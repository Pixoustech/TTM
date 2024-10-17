import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_face_api_beta/flutter_face_api.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var faceSdk = FaceSDK.instance;

  String _status = "nil";
  String _similarityStatus = "nil";
  String _livenessStatus = "nil";
  Image _uiImage1 = Image.network('https://8034-2405-201-e02b-505c-bc2d-30c1-4e58-c5d2.ngrok-free.app/api/images/surya.jpg');
  Image _uiImage2 = Image.network('https://8034-2405-201-e02b-505c-bc2d-30c1-4e58-c5d2.ngrok-free.app/api/images/surya.jpg');
/*  var _uiImage1 = Image.network('https://8034-2405-201-e02b-505c-bc2d-30c1-4e58-c5d2.ngrok-free.app/api/images/surya.jpg');
  var _uiImage2 = Image.network('https://8034-2405-201-e02b-505c-bc2d-30c1-4e58-c5d2.ngrok-free.app/api/images/surya.jpg');*/

  MatchFacesImage? mfImage1;
  MatchFacesImage? mfImage2;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (!await initialize()) return;
    setState(() {
      _status = "Ready";
    });
  }

  Future<bool> initialize() async {
    setState(() {
      _status = "Initializing...";
    });
    var license = await loadAssetIfExists("assets/regula.license");
    InitConfig? config;
    if (license != null) config = InitConfig(license);
    var (success, error) = await faceSdk.initialize(config: config);
    if (!success) {
      setState(() {
        _status = error!.message;
      });
      print("${error?.code}: ${error?.message}");
    }
    return success;
  }

  Future<ByteData?> loadAssetIfExists(String path) async {
    try {
      return await rootBundle.load(path);
    } catch (_) {
      return null;
    }
  }

  void setImage(Uint8List bytes, ImageType type, int number) {
    setState(() {
      var mfImage = MatchFacesImage(bytes, type);
      if (number == 1) {
        mfImage1 = mfImage;
        _uiImage1 = Image.memory(bytes);
        _livenessStatus = "nil"; // Reset liveness status when setting a new image
      } else if (number == 2) {
        mfImage2 = mfImage;
        _uiImage2 = Image.memory(bytes);
      }
      // Debug prints
      print("mfImage1 is set: ${mfImage1 != null}");
      print("mfImage2 is set: ${mfImage2 != null}");
    });
  }

  void clearResults() {
    setState(() {
      _status = "Ready";
      _similarityStatus = "nil";
      _livenessStatus = "nil";
      _uiImage1 = Image.asset('assets/images/portrait.png');
      _uiImage2 = Image.asset('assets/images/portrait.png');
      mfImage1 = null;
      mfImage2 = null;
    });
  }

  void startLiveness() async {
    var result = await faceSdk.startLiveness(
      config: LivenessConfig(skipStep: [LivenessSkipStep.ONBOARDING_STEP]),
      notificationCompletion: (notification) {
        print(notification.status);
      },
    );
    if (result.image != null) {
      setImage(result.image!, ImageType.LIVE, 1);
      setState(() {
        _livenessStatus = result.liveness.name.toLowerCase();
      });
    }
  }

  void matchFaces() async {
    if (mfImage1 == null || mfImage2 == null) {
      setState(() {
        _status = "Both images required!";
      });
      return;
    }
    setState(() {
      _status = "Processing...";
    });
    var request = MatchFacesRequest([mfImage1!, mfImage2!]);
    var response = await faceSdk.matchFaces(request);
    var split = await faceSdk.splitComparedFaces(response.results, 0.75);
    var match = split.matchedFaces;
    setState(() {
      _similarityStatus = "failed";
      if (match.isNotEmpty) {
        _similarityStatus = (match[0].similarity * 100).toStringAsFixed(2) + "%";
      }
      _status = "Ready";
    });
  }

  Widget useGallery(int number) {
    return TextButton(
      child: Text("Use gallery"),
      onPressed: () async {
        Navigator.pop(context);
        var image = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image != null) {
          final bytes = await File(image.path).readAsBytes();
          setImage(bytes, ImageType.PRINTED, number);
        }
      },
    );
  }

  Widget useCamera(int number) {
    return TextButton(
      child: Text("Use camera"),
      onPressed: () async {
        Navigator.pop(context);
        var response = await faceSdk.startFaceCapture();
        var image = response.image;
        if (image != null) {
          setImage(image.image, image.imageType, number);
        }
      },
    );
  }

  Widget image(Image image, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Image(height: 150, width: 150, image: image.image),
    );
  }

  Widget button(String text, Function() onPressed) {
    return Container(
      child: TextButton(
        child: Text(text),
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
        ),
      ),
      width: 250,
    );
  }

  void setImageDialog(BuildContext context, int number) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Select option"),
        actions: [useGallery(number), useCamera(number)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(_status))),
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height / 8),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            image(_uiImage1, () => setImageDialog(context, 1)),
            image(_uiImage2, () => setImageDialog(context, 2)),
            Container(margin: EdgeInsets.fromLTRB(0, 0, 0, 15)),
            button("Match", () => matchFaces()),
            button("Liveness", () => startLiveness()),
            button("Clear", () => clearResults()),
            Container(margin: EdgeInsets.fromLTRB(0, 15, 0, 0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Similarity: " + _similarityStatus),
                Container(margin: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                Text("Liveness: " + _livenessStatus)
              ],
            )
          ],
        ),
      ),
    );
  }
}
