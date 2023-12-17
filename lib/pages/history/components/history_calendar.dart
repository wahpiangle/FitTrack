import 'package:flutter/material.dart';
import 'package:group_project/constants/themes/app_colours.dart';
import 'package:group_project/models/workout_session.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class HistoryCalendar extends StatefulWidget {
  final List<WorkoutSession> workoutSessions;
  final void Function(WorkoutSession) scrollToItem;
  const HistoryCalendar({
    super.key,
    required this.workoutSessions,
    required this.scrollToItem,
  });

  @override
  State<HistoryCalendar> createState() => _HistoryCalendarState();
}

class _HistoryCalendarState extends State<HistoryCalendar> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<WorkoutSession> selectedWorkoutSessions = [];

  @override
  void initState() {
    super.initState();
    selectedWorkoutSessions = widget.workoutSessions
        .where((element) => isSameDay(element.date, _selectedDay))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.primary,
      appBar: AppBar(
        backgroundColor: AppColours.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  selectedWorkoutSessions = widget.workoutSessions
                      .where((element) => isSameDay(element.date, selectedDay))
                      .toList();
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) {
              return widget.workoutSessions
                  .where((element) => isSameDay(element.date, day))
                  .toList();
            },
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            daysOfWeekHeight: 40,
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.grey),
              weekendStyle: TextStyle(color: Colors.grey),
            ),
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: Colors.white,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: (isSameDay(_selectedDay, DateTime.now()))
                    ? AppColours.secondary
                    : Colors.grey,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(
                color: (isSameDay(_selectedDay, DateTime.now()))
                    ? Colors.black
                    : Colors.white,
                fontWeight: FontWeight.bold,
              ),
              todayDecoration: const BoxDecoration(
                color: AppColours.secondary,
                shape: BoxShape.circle,
              ),
              todayTextStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              defaultTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              weekendTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 16),
              holidayTextStyle: const TextStyle(color: Colors.white),
              outsideTextStyle:
                  const TextStyle(fontSize: 16, color: Colors.grey),
              markerDecoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              markerMargin: const EdgeInsets.symmetric(
                horizontal: 1,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      widget.scrollToItem(selectedWorkoutSessions[index]);
                      Navigator.pop(
                        context,
                      );
                    },
                    child: ListTile(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        side: BorderSide(
                          color: AppColours.secondary,
                          width: 1,
                        ),
                      ),
                      title: Text(
                        selectedWorkoutSessions[index].title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        DateFormat('dd MMMM yyyy kk:mm a').format(
                          selectedWorkoutSessions[index].date,
                        ),
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ),
                  ),
                );
              },
              itemCount: selectedWorkoutSessions.length,
            ),
          )
        ],
      ),
    );
  }
}
