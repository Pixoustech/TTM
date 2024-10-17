import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face ID Auth App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FaceAuthCheck(), // Check if user has Face ID enabled on app launch
    );
  }
}

class FaceAuthCheck extends StatelessWidget {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      return await auth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on Exception catch (e) {
      print(e);
      return false; // Authentication failed
    }
  }

  Future<bool> isFaceIdEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('faceIdEnabled') ?? false;
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    return username != null && password != null;
  }

  Future<Map<String, String>?> getLastLoginDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    if (username != null && password != null) {
      return {'username': username, 'password': password};
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLoggedIn(), // Check if user is already logged in
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData && snapshot.data == true) {
          // User is logged in, check for Face ID
          return FutureBuilder<bool>(
            future: isFaceIdEnabled(),
            builder: (context, faceIdSnapshot) {
              if (faceIdSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(body: Center(child: CircularProgressIndicator()));
              } else if (faceIdSnapshot.hasData && faceIdSnapshot.data == true) {
                // If Face ID is enabled, proceed with authentication
                return FutureBuilder<bool>(
                  future: authenticate(),
                  builder: (context, authSnapshot) {
                    if (authSnapshot.connectionState == ConnectionState.waiting) {
                      return Scaffold(body: Center(child: CircularProgressIndicator()));
                    } else if (authSnapshot.hasData && authSnapshot.data == true) {
                      // Authentication succeeds, navigate to HomePage
                      return HomePage();
                    } else {
                      return LoginPage(); // If Face ID authentication fails, show LoginPage
                    }
                  },
                );
              } else {
                return HomePage(); // Face ID is not enabled, go to HomePage directly
              }
            },
          );
        } else {
          return LoginPage(); // User is not logged in, show LoginPage
        }
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  final String? username;
  final String? password;

  LoginPage({this.username, this.password});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool faceIdEnabled = false;

  final Map<String, String> users = {
    'surya': '123',
    'sethu': '123',
  };

  @override
  void initState() {
    super.initState();
    _loadToggleState();
    // Autofill username and password if available
    if (widget.username != null) {
      usernameController.text = widget.username!;
    }
    if (widget.password != null) {
      passwordController.text = widget.password!;
    }
  }

  void _loadToggleState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      faceIdEnabled = prefs.getBool('faceIdEnabled') ?? false;
    });
  }

  void _saveToggleState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('faceIdEnabled', faceIdEnabled);
  }

  Future<void> loginWithFaceID() async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        // If authentication is successful, retrieve last login details
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? username = prefs.getString('username');
        String? password = prefs.getString('password');

        if (username != null && password != null) {
          // Check credentials (assuming they are valid, add your logic here)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        }
      }
    } catch (e) {
      print('Error during Face ID authentication: $e');
    }
  }

  void login() async {
    final username = usernameController.text;
    final password = passwordController.text;

    if (users[username] == password) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Store login details if Face ID is enabled
      if (faceIdEnabled) {
        await prefs.setString('username', username);
        await prefs.setString('password', password);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      print('Invalid username or password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Switch(
                  value: faceIdEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      faceIdEnabled = value;
                      _saveToggleState(); // Save toggle state immediately when changed
                    });
                  },
                ),
                Text('Enable Face ID'),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: loginWithFaceID,
              child: Text('Login with Face ID'),
            ),
          ],
        ),
      ),
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool faceIdEnabled = false;
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadToggleState();
    _loadUsername(); // Load the username when HomePage is initialized
  }

  void _loadToggleState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      faceIdEnabled = prefs.getBool('faceIdEnabled') ?? false;
    });
  }

  void _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Guest'; // Load the saved username or show 'Guest'
    });
  }

  void _saveToggleState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('faceIdEnabled', value);
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (faceIdEnabled) {
      // Keep Face ID enabled and don't remove login details
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => FaceAuthCheck()),
            (Route<dynamic> route) => false, // Remove all previous routes
      );
    } else {
      // Clear login details if Face ID is disabled
      prefs.setBool('faceIdEnabled', false);
      prefs.remove('username');
      prefs.remove('password');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false, // Remove all previous routes
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, $username!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('Face ID is ${faceIdEnabled ? 'enabled' : 'disabled'}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Face ID Enabled'),
                Switch( 
                  value: faceIdEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      faceIdEnabled = value;
                      _saveToggleState(value);
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: logout,
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
