import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Comman_pages/Constant.dart';
import '../Comman_pages/Navigation_page.dart';
import '../Home_Page/Home_page_Widgets.dart';
import '../Report_Taskbox_page.dart';
import 'model.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  // Use the sample report data for different time frames
  final Report _reportData = sampleReportData;

  String _selectedTimeFrame = 'Last 6 months';
  late OverallCounts _currentOverallCounts;
  late Map<String, MonthlyTaskCounts> _currentMonthlyTaskCounts;
  late Attendance _currentAttendance;


  // Declare _selectedIndex here
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _updateCurrentReportData();
  }

  void _updateCurrentReportData() {
    if (_selectedTimeFrame == 'Last 6 months') {
      _currentOverallCounts = _reportData.last6Months.overallCounts;
      _currentMonthlyTaskCounts = _reportData.last6Months.monthlyTaskCounts;
      _currentAttendance = _reportData.last6Months.attendance;
    } else {
      _currentOverallCounts = _reportData.last3Months.overallCounts;
      _currentMonthlyTaskCounts = _reportData.last3Months.monthlyTaskCounts;
      _currentAttendance = _reportData.last3Months.attendance;
    }
  }

  void _updateReportData(String newTimeFrame) {
    setState(() {
      _selectedTimeFrame = newTimeFrame;
      _updateCurrentReportData();
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
                    child: _buildTaskBox(context, 'Not Started', Colors.grey, double.infinity, 90, _currentOverallCounts.notStarted, Icons.pending),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: _buildTaskBox(context, 'In-Progress', Colors.orange, double.infinity, 90, _currentOverallCounts.inProgress, Icons.rotate_left),
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
                    child: _buildTaskBox(context, 'Completed', Colors.green, double.infinity, 90 , _currentOverallCounts.completed, Icons.check_circle),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: _buildTaskBox(context, 'Overdue', Color(0xFFC52D28), double.infinity, 90, _currentOverallCounts.overdue, Icons.timer),
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

  Widget _buildChart() {
    // Prepare monthly task data for the chart
    List<MonthlyTaskData> monthlyData = _currentMonthlyTaskCounts.entries.map((entry) {
      // Capitalize the month name if necessary
      String month = entry.key[0].toUpperCase() + entry.key.substring(1); // Capitalize first letter
      return MonthlyTaskData(
        month,
        entry.value.notStarted,
        entry.value.inProgress,
        entry.value.completed,
        entry.value.overdue,
      );
    }).toList();

    // Calculate the maximum value based on the data
    double maxYValue = 0;

    for (var data in monthlyData) {
      double totalTasks = data.notStarted.toDouble() +
          data.completed.toDouble() +
          data.inProgress.toDouble() +
          data.overdue.toDouble();

      maxYValue = max(maxYValue, totalTasks);
    }

    maxYValue = (maxYValue / 10).ceil() * 10;

    return SfCartesianChart(
      legend: const Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.scroll,
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: CategoryAxis(
        title: AxisTitle(text: 'Months'),
      ),
      primaryYAxis: NumericAxis(
        title: const AxisTitle(text: 'Task Count'),
        minimum: 0,
        maximum: maxYValue,
        interval: 10,
        labelFormat: '{value}',
      ),
      series: <CartesianSeries>[
        StackedColumnSeries<MonthlyTaskData, String>(
          dataSource: monthlyData,
          xValueMapper: (MonthlyTaskData data, _) => data.month,
          yValueMapper: (MonthlyTaskData data, _) => data.notStarted,
          name: 'Not Started',
          color: Colors.grey,
        ),
        StackedColumnSeries<MonthlyTaskData, String>(
          dataSource: monthlyData,
          xValueMapper: (MonthlyTaskData data, _) => data.month,
          yValueMapper: (MonthlyTaskData data, _) => data.inProgress,
          name: 'In-Progress',
          color: Colors.orange,
        ),
        StackedColumnSeries<MonthlyTaskData, String>(
          dataSource: monthlyData,
          xValueMapper: (MonthlyTaskData data, _) => data.month,
          yValueMapper: (MonthlyTaskData data, _) => data.completed,
          name: 'Completed',
          color: Colors.green,
        ),
        StackedColumnSeries<MonthlyTaskData, String>(
          dataSource: monthlyData,
          xValueMapper: (MonthlyTaskData data, _) => data.month,
          yValueMapper: (MonthlyTaskData data, _) => data.overdue,
          name: 'Overdue',
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildAttendanceChart() {
    // Create a list of attendance data using the model data
    final List<AttendanceData> _attendanceData = [
      AttendanceData('Present', _currentAttendance.presentCount, color: Colors.green),
      AttendanceData('Absent', _currentAttendance.absentCount, color: Colors.red),
    ];

    // Calculate total attendance
    double totalAttendance = _attendanceData.fold(0, (sum, item) => sum + item.value);
    String attendancePercentageText = '';

    // Determine the attendance percentage for the selected segment
    if (_selectedIndex != -1) {
      AttendanceData selectedData = _attendanceData[_selectedIndex];
      double selectedCount = selectedData.value.toDouble();
      double attendancePercentage = (selectedCount / totalAttendance) * 100;
      attendancePercentageText = '${attendancePercentage.toStringAsFixed(1)}%';
    }

    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 40),
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


  Widget _buildTaskBox(BuildContext context, String title, Color color, double width, double height, int count, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskBoxPage(
              taskStatus: title,
              selectedTimeFrame: _selectedTimeFrame, // Pass the selected timeframe
            ),
          ),
        );
      },
      child: Container(
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
                      '$count',
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
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
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

