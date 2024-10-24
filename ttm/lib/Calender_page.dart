import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CalendarPage Page',
          style: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to the Home Page!',
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20), // Add spacing
            Text(
              'Here is an overview of your activity.',
              style: GoogleFonts.montserrat(fontSize: 18),
            ),
            SizedBox(height: 20), // Add spacing

            // Add a list of recent tasks or any other relevant items
            Expanded(
              child: ListView(
                children: [
                  _buildTaskItem('Task 1', 'This is a description of task 1.'),
                  _buildTaskItem('Task 2', 'This is a description of task 2.'),
                  _buildTaskItem('Task 3', 'This is a description of task 3.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to create a task list item
  Widget _buildTaskItem(String title, String description) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: GoogleFonts.montserrat(fontSize: 16),
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Handle task click (navigate to task details, for example)
        },
      ),
    );
  }
}
