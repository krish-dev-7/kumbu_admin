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
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Attendance> _selectedAttendance = [];
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
        title: const Text('Dashboard'),
      ),
      body: FutureBuilder<List<Attendance>>(
        future: _futureAttendance,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text('No attendance records found'));
          } else if (snapshot.hasData) {
            List<Attendance> attendances = snapshot.data!;
            _groupedAttendance = _groupAttendanceByDate(attendances);

            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 1000) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TableCalendar(
                            firstDay: DateTime.utc(2021, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            focusedDay: _focusedDay,
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                                _selectedAttendance =
                                    _getAttendancesForDay(selectedDay);
                              });
                            },
                            eventLoader: (day) {
                              return _groupedAttendance[
                                      DateTime(day.year, day.month, day.day)] ??
                                  [];
                            },
                            calendarBuilders: CalendarBuilders(
                              markerBuilder: (context, date, events) {
                                if (events.isNotEmpty) {
                                  return Positioned(
                                    right: 1,
                                    bottom: 1,
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: appLightGreen,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  );
                                }
                                return null;
                              },
                              todayBuilder: (context, date, _) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: appDarkGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  margin: const EdgeInsets.all(4.0),
                                  width: 100,
                                  height: 100,
                                  child: Center(
                                    child: Text(
                                      '${date.day}',
                                      style: const TextStyle().copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (_selectedAttendance.isNotEmpty)
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _buildAttendanceList(
                                        _selectedAttendance),
                                  ),
                                )
                              else
                                const Expanded(
                                  child: Center(
                                      child: Text(
                                          'Select a date to view attendance')),
                                ),
                              _buildStatistics(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          TableCalendar(
                            firstDay: DateTime.utc(2021, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            focusedDay: _focusedDay,
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                                _selectedAttendance =
                                    _getAttendancesForDay(selectedDay);
                              });
                            },
                            eventLoader: (day) {
                              return _groupedAttendance[
                                      DateTime(day.year, day.month, day.day)] ??
                                  [];
                            },
                            calendarBuilders: CalendarBuilders(
                              markerBuilder: (context, date, events) {
                                if (events.isNotEmpty) {
                                  return Positioned(
                                    right: 1,
                                    bottom: 1,
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: appLightGreen,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  );
                                }
                                return null;
                              },
                              todayBuilder: (context, date, _) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: appDarkGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  margin: const EdgeInsets.all(4.0),
                                  width: 100,
                                  height: 100,
                                  child: Center(
                                    child: Text(
                                      '${date.day}',
                                      style: const TextStyle().copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          if (_selectedAttendance.isNotEmpty) ...[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    _buildAttendanceList(_selectedAttendance),
                              ),
                            ),
                            _buildStatistics(),
                          ] else
                            const Expanded(
                              child: Center(
                                  child:
                                      Text('Select a date to view attendance')),
                            ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
