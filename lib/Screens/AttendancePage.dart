import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kumbu_admin/Common/ThemeData.dart';

import '../Models/Attendance.dart';
import '../service/AttendanceService.dart';

class AttendancePage extends StatefulWidget {
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final AttendanceService _attendanceService = AttendanceService();
  List<Attendance> _attendanceList = [];
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  Future<void> _fetchAttendance() async {
    setState(() {
      _isLoading = true;
    });
    try {
      _attendanceList = await _attendanceService.getAttendanceByDate(_selectedDate);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchAttendance();
    }
  }

  @override
  Widget build(BuildContext context) {
    int serialNumber = 1; // Counter for serial numbers
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Records'),
        actions: [IconButton(onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AttendancePage()));}, icon: Icon(Icons.refresh))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${DateFormat('dd-MM-yyyy').format(_selectedDate)}',
                  style: TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today, color: appLightGreen,),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  headingRowHeight: 56.0,
                  dataRowHeight: 56.0,
                  columnSpacing: 20.0,
                  columns: [
                    DataColumn(label: Text('SN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: appLightGreen))),
                    DataColumn(label: Text('ID', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: appLightGreen))),
                    DataColumn(label: Text('Name', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: appLightGreen))),
                    DataColumn(label: Text('Phone', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: appLightGreen))),
                    DataColumn(label: Text('Entry', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: appLightGreen))),
                    DataColumn(label: Text('Exit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: appLightGreen))),
                    DataColumn(label: Text('Membership Due', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: appLightGreen))),
                  ],
                  rows: _attendanceList.map((attendance) {
                    int membershipEndDays = attendance.membershipEndDate.difference(DateTime.now()).inDays;
                    final isMembershipEndingSoon = membershipEndDays < 7;
                    return DataRow(
                      cells: [
                        DataCell(Text(
                          '${serialNumber++}', // Display serial number
                          style: TextStyle(fontSize: 16),
                        )),
                        DataCell(Container(
                          width: 50,
                          child: Text(
                            attendance.gymMemberId.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                        )),
                        DataCell(Container(
                          width: 150,
                          child: Text(
                            attendance.memberName,
                            style: TextStyle(fontSize: 16),
                          ),
                        )),
                        DataCell(Container(
                          width: 120,
                          child: Text(
                            attendance.memberNumber,
                            style: TextStyle(fontSize: 16),
                          ),
                        )),
                        DataCell(Container(
                          width: 120,
                          child: Text(
                            DateFormat('hh:mm a').format(attendance.entry),
                            style: TextStyle(fontSize: 16),
                          ),
                        )),
                        DataCell(Container(
                          width: 120,
                          child: Text(
                            attendance.exit != null ? DateFormat('hh:mm a').format(attendance.exit!) : '-',
                            style: TextStyle(fontSize: 16),
                          ),
                        )),
                        DataCell(Container(
                          width: 120,
                          child: Text(
                            "$membershipEndDays days",
                            style: TextStyle(
                              fontSize: 16,
                              color: isMembershipEndingSoon ? Colors.red : Colors.white,
                              fontWeight: isMembershipEndingSoon ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        )),
                      ],
                    );
                  }).toList(),
                  decoration: BoxDecoration(
                    border: Border.all(color: appLightGreen),
                    borderRadius: BorderRadius.circular(16)
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
