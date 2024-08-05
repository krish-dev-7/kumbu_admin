import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Common/ThemeData.dart';
import '../Models/Attendance.dart';
import '../service/AttendanceService.dart';

class MemberAttendancePage extends StatefulWidget {
  final String memberId;

  const MemberAttendancePage({super.key, required this.memberId});

  @override
  _MemberAttendancePageState createState() => _MemberAttendancePageState();
}

class _MemberAttendancePageState extends State<MemberAttendancePage> {
  late Future<List<Attendance>> _futureAttendance;
  final AttendanceService _attendanceService = AttendanceService();
  Map<DateTime, List<Attendance>> _groupedAttendance = {};
  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final List<Attendance> _selectedAttendance = [];
  double currentMonthAverage = 0;
  double previousMonthAverage = 0;
  double improvementPercentage = 0;

  @override
  void initState() {
    super.initState();
    _futureAttendance =
        _attendanceService.getAttendanceByMember(widget.memberId);
    _futureAttendance.then((attendances) {
      setState(() {
        _groupedAttendance = _groupAttendanceByDate(attendances);
        _calculateAverages(attendances);
      });
    });
  }

  void _calculateAverages(List<Attendance> attendances) {
    Duration totalDuration = const Duration();
    List<Attendance> currentMonthAttendances = [];
    DateTime now = DateTime.now();
    DateTime firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);

    for (var attendance in attendances) {
      if (attendance.exit != null) {
        totalDuration += attendance.exit!.difference(attendance.entry);
      }
      if (attendance.entry.isAfter(firstDayOfCurrentMonth)) {
        currentMonthAttendances.add(attendance);
      }
    }

    currentMonthAverage = currentMonthAttendances.isNotEmpty
        ? totalDuration.inMinutes / currentMonthAttendances.length
        : 0;

    previousMonthAverage = 5;
    improvementPercentage = previousMonthAverage != 0
        ? ((currentMonthAverage - previousMonthAverage) /
                previousMonthAverage) *
            100
        : 0;
  }

  Map<DateTime, List<Attendance>> _groupAttendanceByDate(
      List<Attendance> attendances) {
    Map<DateTime, List<Attendance>> data = {};
    for (var attendance in attendances) {
      DateTime date = DateTime(
          attendance.entry.year, attendance.entry.month, attendance.entry.day);
      if (data[date] == null) data[date] = [];
      data[date]!.add(attendance);
    }
    return data;
  }

  List<Attendance> _getAttendancesForDay(DateTime day) {
    DateTime formattedDay = DateTime(day.year, day.month, day.day);
    return _groupedAttendance[formattedDay] ?? [];
  }

  Widget _buildAttendanceList(List<Attendance> attendances) {
    return ListView.builder(
      itemCount: attendances.length,
      itemBuilder: (context, index) {
        Attendance attendance = attendances[index];
        return Container(
          decoration: BoxDecoration(
              border: Border.all(color: appLightGreen),
              borderRadius: BorderRadius.circular(14)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: ListTile(
                  title: Row(
                    children: [
                      const Text("Entry: "),
                      const Icon(Icons.arrow_right_alt),
                      Text(attendances[index]
                          .entry
                          .toString()
                          .split(" ")[1]
                          .substring(0, 5)),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      const Text("Exit: "),
                      const Icon(Icons.arrow_right_alt),
                      Text(attendances[index]
                              .exit
                              ?.toString()
                              .split(" ")[1]
                              .substring(0, 5) ??
                          'N/A'),
                    ],
                  ),
                ),
              ),
              Text(
                "${(attendance.exit != null) ? attendance.exit!.difference(attendance.entry).inMinutes : 0} Mins ",
                style: const TextStyle(fontSize: 25, color: Colors.white70),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatistics() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: improvementPercentage.isFinite
                    ? improvementPercentage / 100
                    : 0,
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(appLightGreen),
                strokeWidth: 8.0,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${improvementPercentage.isFinite ? improvementPercentage > 300 ? '>300' : improvementPercentage.toStringAsFixed(2) : 'N/A'}%",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "improved from prev. month",
                        style: TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: appLightGreen),
                borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Average Gym Time",
                    style: TextStyle(color: appLightGreen),
                  ),
                  Text(
                    "Current month: ${currentMonthAverage.toStringAsFixed(2)} minutes",
                  ),
                  Text(
                    "Previous month: ${previousMonthAverage.toStringAsFixed(2)} minutes",
                  ),
                  Text(
                    "${Duration(minutes: currentMonthAverage.toInt() * _groupedAttendance.length).inHours}hrs ${Duration(minutes: currentMonthAverage.toInt() * _groupedAttendance.length).inMinutes % 60} mins fired this month",
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _calculatePreviousMonthAverage() {
    DateTime now = DateTime.now();
    DateTime firstDayOfCurrentMonth = DateTime(now.year, now.month, 1);
    DateTime firstDayOfPreviousMonth = DateTime(now.year, now.month - 1, 1);
    DateTime lastDayOfPreviousMonth = DateTime(now.year, now.month, 0);

    List<Attendance> previousMonthAttendances = _groupedAttendance.entries
        .where((entry) =>
            entry.key.isAfter(firstDayOfPreviousMonth) &&
            entry.key.isBefore(firstDayOfCurrentMonth))
        .expand((entry) => entry.value)
        .toList();

    if (previousMonthAttendances.isEmpty) return 0;

    Duration totalDuration = const Duration();
    for (var attendance in previousMonthAttendances) {
      if (attendance.exit != null) {
        totalDuration += attendance.exit!.difference(attendance.entry);
      }
    }

    return totalDuration.inMinutes / previousMonthAttendances.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Records'),
      ),
      body: FutureBuilder<List<Attendance>>(
        future: _futureAttendance,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(child: Text('No attendance records found :('));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text('No attendance records found'));
          } else if (snapshot.hasData) {
            List<Attendance> attendanceRecords = snapshot.data!;
            return Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Center(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Entry Time')),
                      DataColumn(label: Text('Exit Time')),
                    ],
                    rows: attendanceRecords
                        .map((attendance) => _createDataRow(attendance))
                        .toList(),
                    decoration: BoxDecoration(
                      border: Border.all(color: appLightGreen),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
