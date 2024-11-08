import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http; // Import HTTP package for network calls
import '../Constant.dart';
import '../main.dart';
import '../pdf.dart';

class EventDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String priority;
  final String status;
  final DateTime date;
  final String location;
  final List<String>? pdfUrls;
  final String Event;
  final String Assignedby;

  EventDetailPage({
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.date,
    required this.location,
    this.pdfUrls,
    required this.Event,
    required this.Assignedby,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.concolor,
        title: Text(
          'Event Details',
          style: GoogleFonts.montserrat(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.montserrat(
                  fontSize: 24, fontWeight: FontWeight.normal),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: GoogleFonts.montserrat(
                  fontSize: 12, color: Color(0xFF5F6368)),
            ),
            SizedBox(height: 10),
            Text(
              'Task Files',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Flexible(
              child: Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: List.generate(pdfUrls?.length ?? 0, (index) {
                  String pdfName = pdfUrls![index].split('/').last;
                  return GestureDetector(
                    onTap: () => _openPdfViewer(context, pdfUrls![index]),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.concolor),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'Assets/Images/pdf.png',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  pdfName,
                                  style: GoogleFonts.montserrat(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: -13,
                            right: -15,
                            child: PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert, size: 20),
                              onSelected: (value) {
                                if (value == 'download') {
                                  _downloadPdf(pdfUrls![index]);
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'download',
                                  child: Text('Download PDF'),
                                ),
                              ],
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFFE5E5E5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(Icons.adjust, 'Status:', status),
                  _buildDetailRow(Icons.calendar_today_rounded, 'Due Date:', date.toLocal().toString().split(' ')[0]),
                  _buildDetailRow(Icons.sell_outlined, 'Priority:',priority ), // Format date
                  _buildDetailRow(Icons.task_outlined, 'Event:', Event),
                  _buildDetailRow(Icons.person_2_outlined, 'Assigned By:', Assignedby),
                  _buildDetailRow(Icons.location_on, 'Location:', location),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align labels at the top
        children: [
          // Icon
          Icon(
            icon,
            size: 20, // Adjust size as needed
            color: Color(0xFF777777), // You can change the color as needed
          ),
          SizedBox(width: 8), // Space between icon and label
          // Label
          Container(
            width: 100, // Set a fixed width for the label to align all rows
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.normal,
                color: Color(0xFF5F6368),
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(width: 8),
          // Value
          Expanded(
            child: Row(
              children: [
                if (label == 'Status:')
                  Row(
                    children: [
                      // Status Container
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Padding for the status container
                        decoration: BoxDecoration(
                          color: getStatusColor(value), // Get color based on status
                          borderRadius: BorderRadius.circular(4), // Rounded corners
                        ),
                        child: Text(
                          value,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.white, // Change text color for visibility
                          ),
                        ),
                      ),
                      SizedBox(width: 8), // Space between status and rectangles
                      // Row of rectangles
                      Row(
                        children: List.generate(3, (index) {
                          Color rectangleColor;
                          if (value == "In Progress") {
                            rectangleColor = index < 2 ? Colors.orange : Colors.grey;
                          } else if (value == "Overdue") {
                            rectangleColor = index < 2 ? Colors.red : Colors.grey;
                          } else {
                            rectangleColor = index < 3 ? Colors.green : Colors.grey;
                          }

                          return Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Container(
                              width: 20,
                              height: 6,
                              decoration: BoxDecoration(
                                color: rectangleColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                if (label != 'Status:') // For other labels, just show the value
                  Expanded(
                    child: Text(
                      value,
                      style: GoogleFonts.montserrat(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void _openPdfViewer(BuildContext context, String pdfUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewer(url: pdfUrl),
      ),
    );
  }

  void _downloadPdf(String url) async {
    var response = await http.get(Uri.parse(url));
    String pdfNameWithExtension = url.split('/').last;
    String pdfName = pdfNameWithExtension.split('.').first;

    if (response.statusCode == 200) {
      var dir = await getExternalStorageDirectory();
      var downloadDir = Directory("${dir!.path}/Download");

      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      String filePath = "${downloadDir.path}/$pdfName.pdf";
      int counter = 1;

      while (await File(filePath).exists()) {
        filePath = "${downloadDir.path}/$pdfName-$counter.pdf";
        counter++;
      }

      await File(filePath).writeAsBytes(response.bodyBytes);
      await _scanFile(filePath);

      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );
      var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        'Download Complete',
        'Your PDF "$pdfName" has been downloaded to the Downloads folder.',
        platformChannelSpecifics,
        payload: 'item x',
      );
    } else {
      print('Failed to download PDF: ${response.statusCode}');
    }
  }

  Future<void> _scanFile(String path) async {
    final File file = File(path);
    if (await file.exists()) {
      final result = await Process.run('am', [
        'broadcast',
        '-a',
        'android.intent.action.MEDIA_SCANNER_SCAN_FILE',
        '-d',
        'file://$path'
      ]);
      print(result.stdout);
    }
  }
}
