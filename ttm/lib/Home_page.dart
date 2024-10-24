import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Make sure to import Google Fonts
import 'package:ttm/Constant.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Initialize the button text
  String buttonText = "Check In";
  String _selectedButton = '';

  // Function to handle button press
  void _toggleCheckInOut() {
    setState(() {
      // Toggle between "Check In" and "Check Out"
      buttonText = (buttonText == "Check In") ? "Check Out" : "Check In";
    });
    print("$buttonText button pressed"); // Optional: Print the current button state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Content with gradient background only at the top
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFBE898A), // Start color for the gradient
                  Color(0xFFFFFFFF), // End color transitioning to white
                ],
                begin: Alignment.topRight, // Gradient starts at the top-right
                end: Alignment.bottomRight, // Ends at the bottom-right
                stops: [0.0, 0.6], // Control how much of the gradient is shown
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0), // Add padding around the content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start (left)
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between logo and profile icon
                    children: [
                      // Logo at the top left
                      Image.asset(
                        'Assets/Images/TTMlogo.png', // Replace with your logo asset path
                        height: 100, // Set height of the logo
                        width: 100, // Set width of the logo
                      ),
                      // Profile icon at the top right
                      IconButton(
                        icon: Icon(Icons.account_circle, size: 40, color: AppColors.concolor), // Profile icon
                        onPressed: () {
                          // Action when profile icon is pressed
                        },
                      ),
                    ],
                  ),
                  // Using Transform to move Hello user text up
                  Transform.translate(
                    offset: const Offset(0, -20), // Move text up by 30 pixels
                    child: Column( // Use a Column to hold both texts
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Good Morning, John Harry M',
                          style: TextStyle(
                            fontSize: 14, // Font size for the text
                            fontWeight: FontWeight.bold, // Bold text
                            color: Color(0xFF505050), // Text color #505050
                          ),
                        ),
                        const SizedBox(height: 4), // Space between the two texts
                        const Text(
                          "Let’s get to work!",
                          style: TextStyle(
                            fontSize: 14, // Font size for the text
                            fontWeight: FontWeight.bold, // Normal text weight
                            color: Colors.black, // Text color
                          ),
                        ),
                        const SizedBox(height: 20), // Space between the two texts
                        // Elevated button to toggle check in/out
                        ElevatedButton(
                          onPressed: _toggleCheckInOut,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.concolor,
                            minimumSize: const Size(double.infinity, 45), // Set the button height to 45
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              buttonText, // Display the dynamic button text
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10), // Add some space between the button and the buttons row

                        // Search box
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0), // No padding to take full width
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 0.0), // Reduce the margin to make the search box wider
                            height: 45, // Set the desired height
                            width: double.infinity, // Set full width
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12), // Rounded corners for the container
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFBE898A), // Start color of the gradient
                                  Color(0xFFFFE8E8), // End color of the gradient (lighter)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [ // Add shadow to the search box
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5), // Shadow color with opacity
                                  spreadRadius: 2, // How much the shadow spreads
                                  blurRadius: 6, // How blurry the shadow looks
                                  offset: const Offset(0, 3), // Position of the shadow (horizontal, vertical)
                                ),
                              ],
                            ),
                            child: Container(
                              height: 45, // Explicitly setting height for inner container
                              width: double.infinity, // Full width for inner container
                              decoration: BoxDecoration(
                                color: Colors.white, // White background for the inner container
                                borderRadius: BorderRadius.circular(12), // Same rounded corners for the inner container
                              ),
                              child: TextField(
                                cursorColor: AppColors.concolor, // Set the custom cursor color
                                style: TextStyle(
                                  color: AppColors.concolor, // Set the text color
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search, color: AppColors.concolor), // Search icon inside the text field
                                  hintText: 'Search', // Placeholder text
                                  hintStyle: TextStyle(color: Colors.grey), // Color for the placeholder text
                                  filled: true, // Fill color behind the text field
                                  fillColor: Colors.white, // Background color of the text field
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12), // Rounded corners
                                    borderSide: BorderSide.none, // No visible border
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: _buildFilterButton('Previous'),
                            ),
                            const SizedBox(width: 10), // Add spacing between the buttons
                            Expanded(
                              child: _buildFilterButton('Today'),
                            ),
                            const SizedBox(width: 10), // Add spacing between the buttons
                            Expanded(
                              child: _buildFilterButton('Upcoming'),
                            ),
                          ],
                        ),

                        AppWidgets.divider(),

                        // Add the task boxes below the divider
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildTaskBox('Not Started', Colors.grey, 123, 90, 5),
                              _buildTaskBox('In Progress', Colors.orange, 160, 90, 10),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              _buildTaskBox('Completed', Colors.green, 160, 90, 10),
                              _buildTaskBox('Overdue', Colors.red, 123, 90, 5),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(), // This will push everything below it to the bottom if needed
        ],
      ),
    );
  }

  // Helper method to build filter buttons
  Widget _buildFilterButton(String text) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedButton = text; // Update the selected button
        });
        print('$text button pressed');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedButton == text
            ? AppColors.concolor // Change color to red if selected
            : Colors.white, // Default color
        elevation: 3, // Button shadow effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6), // Rounded corners
          side: BorderSide(
            color: AppColors.concolor, // Border color
            width: 1, // Border width
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Padding inside the button
      ),
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: _selectedButton == text ? Colors.white : AppColors.concolor, // Text color based on selection
        ),
      ),
    );
  }

// Helper method to build task boxes
  Widget _buildTaskBox(String title, Color color, double width, double height, int count) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between title and icon
        children: [
          // Title and count
          Padding(
            padding: const EdgeInsets.only(left: 16.0), // Add padding to the left
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center items vertically
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start (left)
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4), // Space between title and count
                Text(
                  '$count', // Display the count below the title
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 14, // Adjust font size as needed
                    fontWeight: FontWeight.w600, // Semi-bold text for count
                  ),
                ),
              ],
            ),
          ),
          // Icon on the right
          Padding(
            padding: const EdgeInsets.only(right: 16.0), // Add padding to the right
            child: Icon(
              Icons.check_circle, // Replace with the appropriate icon for your use case
              color: Colors.white, // Icon color
              size: 30, // Adjust size as needed
            ),
          ),
        ],
      ),
    );
  }

}
