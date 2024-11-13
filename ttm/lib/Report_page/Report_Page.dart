import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Comman_pages/Constant.dart';
import '../Comman_pages/Navigation_page.dart';
import 'model.dart'; // Import your model here

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  // Sample report data for different time frames
  final Map<String, ReportData> _reportData = {
    'Last 6 months': ReportData(
      [
        MonthlyTaskData('Jan', 10, 20, 22,100),
        MonthlyTaskData('Feb', 30, 23, 11,3),
        MonthlyTaskData('Mar', 15, 25, 10,33),
        MonthlyTaskData('Apr', 20, 15, 5,23),
        MonthlyTaskData('May', 25, 30, 12,44),
        MonthlyTaskData('Jun', 5, 10, 8,44),
      ],
      {
        'Not Started': 5,
        'In Progress': 3,
        'Completed': 10,
        'Overdue': 6,
      },
    ),
    'Last 3 months': ReportData(
      [
        MonthlyTaskData('Jul', 12, 20, 18,6),
        MonthlyTaskData('Aug', 18, 25, 15,9),
        MonthlyTaskData('Sep', 20, 30, 12,8),
      ],
      {
        'Not Started': 7,
        'In Progress': 5,
        'Completed': 15,
        'Overdue': 8,
      },
    ),
  };

  String _selectedTimeFrame = 'Last 6 months';
  late ReportData _currentReportData;

  // Declare _selectedIndex here
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _currentReportData = _reportData[_selectedTimeFrame]!;
  }

  void _updateReportData(String newTimeFrame) {
    setState(() {
      _selectedTimeFrame = newTimeFrame;
      _currentReportData = _reportData[_selectedTimeFrame]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.concolor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.backwhite),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Navigation()),
            );
          },
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                'Report',
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.backwhite,
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Overview',
                  style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: _selectedTimeFrame,
                  items: <String>[
                    'Last 6 months',
                    'Last 3 months'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _updateReportData(newValue);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20), // Spacing between header and task boxes

            // Task Boxes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: buildTaskBox('Not Started', Colors.grey, double.infinity, 90, _currentReportData.taskStatuses['Not Started'] ?? 0, Icons.pending),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: buildTaskBox('In Progress', Colors.orange, double.infinity, 90, _currentReportData.taskStatuses['In Progress'] ?? 0, Icons.rotate_left),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: buildTaskBox('Completed', Colors.green, double.infinity, 90, _currentReportData.taskStatuses['Completed'] ?? 0, Icons.check_circle),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: buildTaskBox('Overdue', Color(0xFFC52D28), double.infinity, 90, _currentReportData.taskStatuses['Overdue'] ?? 0, Icons.timer),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Spacing before the Event Overview text
            Text(
              'Event Overview',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Change color as needed
              ),
            ),
            SizedBox(height: 10), // Spacing before the task status summary

            // Call the task status summary builder here
            _buildTaskStatusSummary(),
            SizedBox(height: 20), // Spacing between header and task boxes

            // Chart
            _buildChart(),
            SizedBox(height: 20), // Spacing before the attendance section

            // Attendance Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Attendance',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Change color as needed
                  ),
                ),
              ],
            ),

            // Pie Chart
            _buildAttendanceChart(),
          ],
        ),
      ),
    );
  }

  Widget buildTaskBox(String title, Color color, double width, double height, int taskCount, IconData iconData) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.only(left: 0.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$taskCount',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              iconData,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskStatusSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Align to start
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _currentReportData.taskStatuses.keys.map((status) {
            Color dotColor;
            Color backgroundColor; // Variable for background color
            switch (status) {
              case 'Not Started':
                dotColor = Colors.grey;
                backgroundColor = Colors.grey[200 ]!; // Light grey background for Not Started
                break;
              case 'In Progress':
                dotColor = Colors.orange;
                backgroundColor = Colors.grey[200]!; // Light orange background for In Progress
                break;
              case 'Completed':
                dotColor = Colors.green;
                backgroundColor = Colors.grey[200]!; // Light green background for Completed
                break;
              default:
                dotColor = Colors.red;
                backgroundColor = Colors.grey[200]!; // Light red background for default
            }

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 1.0, vertical: 4.0), // Add padding for better spacing
              margin: EdgeInsets.symmetric(horizontal: 1.0), // Add margin between items
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, // Center the dot and text vertically
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4), // Add space between the dot and the text
                  Text(
                    status, // Display just the status name
                    style: GoogleFonts.montserrat(fontSize: 12),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }



  Widget _buildChart() {
    // Calculate the maximum value based on the data
    double maxYValue = 0;

    for (var data in _currentReportData.monthlyData) {
      // Calculate the total for the current data instance
      double totalTasks = data.notStarted.toDouble() +
          data.completed.toDouble() +
          data.inProgress.toDouble() +
          data.overdue.toDouble();

      // Update maxYValue if totalTasks is greater
      maxYValue = max(maxYValue, totalTasks);
    }

    // Ensure the maximum value is rounded up to the nearest 10 for better visualization
    maxYValue = (maxYValue / 10).ceil() * 10;

    return SfCartesianChart(
      title: ChartTitle(text: 'Monthly Task Overview'),
      legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: CategoryAxis(
        title: AxisTitle(text: 'Months'),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Task Count'),
        minimum: 0,
        maximum: maxYValue,
        interval: 10, // You can adjust this interval as needed
        labelFormat: '{value}',
      ),
      series: <CartesianSeries>[
        StackedColumnSeries<MonthlyTaskData, String>(
          dataSource: _currentReportData.monthlyData,
          xValueMapper: (MonthlyTaskData data, _) => data.month,
          yValueMapper: (MonthlyTaskData data, _) => data.notStarted,
          name: 'Not Started',
          color: Colors.grey,
        ),
        StackedColumnSeries<MonthlyTaskData, String>(
          dataSource: _currentReportData.monthlyData,
          xValueMapper: (MonthlyTaskData data, _) => data.month,
          yValueMapper: (MonthlyTaskData data, _) => data.inProgress,
          name: 'In Progress',
          color: Colors.orange,
        ),
        StackedColumnSeries<MonthlyTaskData, String>(
          dataSource: _currentReportData.monthlyData,
          xValueMapper: (MonthlyTaskData data, _) => data.month,
          yValueMapper: (MonthlyTaskData data, _) => data.completed,
          name: 'Completed',
          color: Colors.green,
        ),
        StackedColumnSeries<MonthlyTaskData, String>(
          dataSource: _currentReportData.monthlyData,
          xValueMapper: (MonthlyTaskData data, _) => data.month,
          yValueMapper: (MonthlyTaskData data, _) => data.overdue,
          name: 'Overdue',
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildAttendanceChart() {
    // Sample attendance data
    final List<AttendanceData> _attendanceData = [
      AttendanceData('Present', 20, color: Colors.green),
      AttendanceData('Absent', 100, color: Colors.red),
    ];

    // Calculate total attendance
    double totalAttendance = _attendanceData.fold(0, (sum, item) => sum + item.value);

    // Initialize attendance percentage text
    String attendancePercentageText = '';

    // Display percentage if a segment is selected
    if (_selectedIndex != -1) {
      AttendanceData selectedData = _attendanceData[_selectedIndex];
      double selectedCount = selectedData.value;
      double attendancePercentage = (selectedCount / totalAttendance) * 100;
      attendancePercentageText = '${attendancePercentage.toStringAsFixed(1)}%';
    }

    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 40,),
            Stack(
              alignment: Alignment.center,
              children: [
                SfCircularChart(
                  palette: [
                    Colors.green, // Color for 'Present'
                    Colors.red,   // Color for 'Absent'
                  ],
                  series: <CircularSeries>[
                    DoughnutSeries<AttendanceData, String>(
                      dataSource: _attendanceData,
                      xValueMapper: (AttendanceData data, _) => data.category,
                      yValueMapper: (AttendanceData data, _) => data.value,
                      innerRadius: '80%',
                      explode: true,
                      explodeIndex: _selectedIndex,
                      onPointTap: (ChartPointDetails details) {
                        setState(() {
                          if (_selectedIndex == details.pointIndex) {
                            _selectedIndex = -1; // Deselect if the same segment is tapped again
                          } else {
                            _selectedIndex = -1; // Reset selection
                            Future.delayed(Duration(milliseconds: 10), () {
                              setState(() {
                                _selectedIndex = details.pointIndex!; // Set new selection
                              });
                            });
                          }
                        });
                      },
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                      explodeOffset: '10%',
                    ),
                  ],
                  tooltipBehavior: TooltipBehavior(enable: true),
                ),
                // Display selected segment's percentage in the center
                if (attendancePercentageText.isNotEmpty)
                  Text(
                    attendancePercentageText,
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
          ],
        ),
        // Custom legend at the top left side of the chart
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: List.generate(_attendanceData.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (_selectedIndex == index) {
                      _selectedIndex = -1; // Deselect if the same legend item is tapped again
                    } else {
                      _selectedIndex = -1; // Reset selection
                      Future.delayed(Duration(milliseconds: 10), () {
                        setState(() {
                          _selectedIndex = index; // Set new selection
                        });
                      });
                    }
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _selectedIndex == index ? _getColorForIndex(index).withOpacity(0.7) : _getColorForIndex(index),
                        border: _selectedIndex == index ? Border.all(color: Colors.black, width: 1) : null,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      _attendanceData[index].category,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // Helper function to return color based on index
  Color _getColorForIndex(int index) {
    switch (index) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}