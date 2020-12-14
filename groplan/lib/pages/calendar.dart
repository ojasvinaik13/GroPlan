import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  Map<DateTime, List> calDays;
  CalendarPage(Map<DateTime, List> calDays) {
    this.calDays = calDays;
  }
  @override
  _CalendarPageState createState() => _CalendarPageState(calDays);
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarController _calendarController;
  Map<DateTime, List> calDays;
  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  _CalendarPageState(Map<DateTime, List> calDays) {
    this.calDays = calDays;
    print(calDays);
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      startDay: DateTime.now(),
      holidays: calDays,
      calendarController: _calendarController,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        outsideHolidayStyle: TextStyle(color: Colors.brown[700]),
        holidayStyle: TextStyle(color: Colors.brown[700]),
        selectedColor: Color(0xFF72C077),
        todayColor: Color(0xFF72C077),
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Color(0xFF72C077),
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Center(
        child: _buildTableCalendar(),
      ),
    );
  }
}
