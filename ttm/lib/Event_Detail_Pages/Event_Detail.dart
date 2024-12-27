import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import '../Comman_pages/Constant.dart';
import '../main.dart';
import 'pdf.dart';

class EventDetailPage extends StatefulWidget {
  final String title;
  final String description;
  final String priority;
  final String status;
  final String date;
  final String location;
  final List<String>? pdfUrls;
  final String Event;
  final String Assignedby;
  final List<String>? Attachmentpdfurl;
  final String fromDate;
  final String toDate;
  final String fromTime;
  final String toTime;




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
    this.Attachmentpdfurl,
    required this.fromDate,
    required this.toDate,
    required this.fromTime,
    required this.toTime,
  });

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  List<String> selectedPdfFiles = [];


  bool _notificationsEnabled = false; // Track notification permission status

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission(); // Request permission when the page is initialized
  }

  Future<void> _requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
      await androidImplementation?.requestNotificationsPermission();
      setState(() {
        _notificationsEnabled = grantedNotificationPermission ?? false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
        child: Stack(
          children: [
            ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title Text
                    Text(
                      widget.title,
                      style: GoogleFonts.montserrat(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    // Spacer to push the button to the right
                    Spacer(),
                    // Conditional Button
                    if (widget.status == 'Overdue' && widget.Assignedby == 'Own')
                      ElevatedButton(
                        onPressed: () {
                          // Your button action here
                          print('Button pressed');
                        },
                        child: Text('Action'),
                      ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  widget.description,
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
                Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: List.generate(widget.pdfUrls?.length ?? 0, (index) {
                    String pdfName = widget.pdfUrls![index].split('/').last;
                    return GestureDetector(
                      onTap: () => _openPdfViewer(context, widget.pdfUrls![index]),
                      child: Container(
                        width: screenWidth * 0.4, // Responsive width
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.concolor),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'Assets/Images/pdf.png',
                                  width: 24,
                                  height: 24,
                                ),
                                SizedBox(width: 5),
                                Container(
                                  width: screenWidth * 0.15,
                                  child: Text(
                                    pdfName,
                                    style: GoogleFonts.montserrat(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            PopupMenuButton(
                              icon: Icon(Icons.more_vert, color: Colors.black),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'download',
                                  child: Text('Download'),
                                ),
                              ],
                              onSelected: (value) {
                                if (value == 'download') {
                                  _downloadPdf(widget.pdfUrls![index]);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
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
                      _buildDetailRow(context, Icons.adjust, 'Status:', widget.status),

                      // Check if the event is a meeting
                      if (widget.Event.toLowerCase() == "meeting".toLowerCase()) ...[
                        _buildDetailRow(
                          context,
                          Icons.calendar_today_rounded,
                          'From Date:',
                          formatDate(widget.fromDate),
                        ),
                        _buildDetailRow(
                          context,
                          Icons.access_time, // You can use a clock icon for time
                          'From Time:',
                          widget.fromTime, // Extract time part
                        ),
                        _buildDetailRow(
                          context,
                          Icons.calendar_today_rounded,
                          'To Date:',
                          formatDate(widget.toDate),
                        ),
                        _buildDetailRow(
                          context,
                          Icons.access_time, // You can use a clock icon for time
                          'To Time:',
                          widget.toTime, // Extract time part
                        ),
                      ] else ...[
                        _buildDetailRow(
                          context,
                          Icons.calendar_today_rounded,
                          'Due Date:',
                          formatDate(widget.date),
                        ),
                      ],

                      _buildDetailRow(context, Icons.sell_outlined, 'Priority:', widget.priority),
                      _buildDetailRow(context, Icons.task_outlined, 'Event:', widget.Event),
                      _buildDetailRow(context, Icons.person_2_outlined, 'Assigned By:', widget.Assignedby),
                      _buildDetailRow(context, Icons.location_on, 'Location:', widget.location),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Check if the status is "Not Started" or "In Progress"
                if (widget.status != "Not Started") ...[
                  // New Notes Section
                  Text(
                    'Notes:',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE5E5E5)),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your notes here...',
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  if (widget.status != "Completed") ...[
                    const SizedBox(height: 16),
                    Text(
                      'Task File',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    DottedBorder(
                      color: AppColors.concolor,
                      strokeWidth: 1,
                      dashPattern: [6, 3],
                      borderType: BorderType.RRect,
                      radius: Radius.circular(8),
                      child: InkWell(
                        onTap: _pickFile,
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: _pickFile,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.backwhite,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColors.backwhite,
                                    child: Icon(
                                      Icons.upload_file_rounded,
                                      size: 24,
                                      color: AppColors.concolor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Drag and Drop files here or choose file',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Display selected PDF files in a dotted box
                  if (widget.status == "Completed") ...[
                    Text(
                      'Attachments (${widget.Attachmentpdfurl?.length ?? 0})',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: List.generate(widget.Attachmentpdfurl?.length ?? 0, (index) {
                        String pdfName = widget.Attachmentpdfurl![index].split('/').last;
                        return GestureDetector(
                          onTap: () => _openPdfViewer(context, widget.Attachmentpdfurl![index]),
                          child: Container(
                            width: screenWidth * 0.4,
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.concolor),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'Assets/Images/pdf.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                      width: screenWidth * 0.15,
                                      child: Text(
                                        pdfName,
                                        style: GoogleFonts.montserrat(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.close_rounded,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    // If you want to remove the attachment from the list,
                                    // you need to handle it here. But since this is a widget property,
                                    // you might want to consider a different approach.
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                  // Show Submit button if status is "In Progress"
                  if (widget.status == "In-Progress") ...[
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: AppColors.concolor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                          ),
                          onPressed: () {
                            // Add your submit action here
                          },
                          child: Text(
                            'Submit',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],

                ] else ...[
                  // If status is "Not Started", show the Start button
                  Center(
                    child: Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.concolor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        onPressed: () {
                          // Add your start action here
                        },
                        child: Text(
                          'Start',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String value) {
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
                        padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: getStatusColor(value),
                          borderRadius:
                          BorderRadius.circular(4), // Rounded corners
                        ),
                        child: Text(
                          value,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors
                                .white, // Change text color for visibility
                          ),
                        ),
                      ),
                      SizedBox(width: 8), // Space between status and rectangles
                    ],
                  ),
                if (label ==
                    'Priority:') // For Priority label, add color box and value
                  Row(
                    children: [
                      // Priority Color Box
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: getPriorityColor(
                              value), // Get color based on priority
                          borderRadius:
                          BorderRadius.circular(2), // Rounded corners
                        ),
                      ),
                      SizedBox(width: 8), // Space between color box and value
                      // Display Priority Value
                      Text(
                        value,
                        style: GoogleFonts.montserrat(fontSize: 12),
                      ),
                    ],
                  ),
                if (label != 'Status:' &&
                    label !=
                        'Priority:') // For other labels, just show the value
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
    // Request notification permission
    var notificationStatus = await Permission.notification.request();

    if (notificationStatus.isGranted) {
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

        // Prepare and show notification
        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'com.ttm.ttm',
          'TTM',
          channelDescription: 'TTM description',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        );
        var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
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
    } else if (notificationStatus.isDenied) {
      // If permission is denied, show a message to the user
      print('Notification permission denied. Please enable it in settings.');
      // Optionally, you could show a dialog to inform the user to enable notifications
    } else if (notificationStatus.isPermanentlyDenied) {
      // If permission is permanently denied, prompt the user to go to settings
      print('Notification permission permanently denied. Please enable it in app settings.');
      // Optionally, you could open the app settings
      openAppSettings();
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

  void _pickFile() async {

    var status = await Permission.storage.request();
    if (status.isGranted) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'], // Only allow PDF files
      );
      if (result != null) {
        setState(() {
          selectedPdfFiles.addAll(
              result.paths.where((path) => path != null).map((path) => path!));
        });
      }
    } else {
      print("Storage permission denied");
    }
  }
}
