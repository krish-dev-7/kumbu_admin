import 'package:flutter/material.dart';
import 'package:kumbu_admin/Common/ThemeData.dart';
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

  @override
  void initState() {
    super.initState();
    _futureAttendance =
        _attendanceService.getAttendanceByMember(widget.memberId);
  }

  DataRow _createDataRow(Attendance attendance) {
    return DataRow(cells: [
      DataCell(Text(attendance.entry.toString().split(' ')[0])), // Date
      DataCell(Text(attendance.entry
          .toString()
          .split(' ')[1]
          .substring(0, 5))), // Entry Time
      DataCell(Text(attendance.exit != null
          ? attendance.exit!.toString().split(' ')[1].substring(0, 5)
          : 'N/A')), // Exit Time
    ]);
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
          print("snap ${snapshot.data}");
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
