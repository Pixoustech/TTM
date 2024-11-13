// pdf_viewer.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:ttm/Comman_pages/Constant.dart';

class PDFViewer extends StatefulWidget {
  final String url;

  PDFViewer({required this.url});

  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  String pdfPath = "";
  int currentPage = 0;
  int totalPages = 0;

  @override
  void initState() {
    super.initState();
    openPDF();
  }

  Future<void> openPDF() async {
    try {
      final response = await http.get(Uri.parse(widget.url));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final file = File("${dir.path}/sample.pdf");

        await file.writeAsBytes(bytes, flush: true);
        setState(() {
          pdfPath = file.path;
        });
      } else {
        // Handle the case when the server returns an error
        throw Exception('Failed to download PDF: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the download
      print('Error downloading PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('PDF Viewer',
        style: GoogleFonts.montserrat(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),backgroundColor: AppColors.concolor,iconTheme: IconThemeData(color: Colors.white),),
      body: pdfPath.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                PDFView(
                  filePath: pdfPath,
                  onPageChanged: (page, total) {
                    setState(() {
                      currentPage = page!;
                      totalPages = total!;
                    });
                  },
                ),
                // Scrollbar
                Align(
                  alignment: Alignment.centerRight,
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Container(
                        width: 20,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Page count display
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Page ${currentPage + 1} of $totalPages',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}