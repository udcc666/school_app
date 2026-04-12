import 'dart:math';

import 'package:flutter/material.dart';
import 'package:school_app/themes/app/app_theme.dart';
import 'package:school_app/widgets/load_indicator.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:school_app/Global.dart' as global;

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final CalendarController _calendarController = CalendarController();

  static const double headerHeight = 70;

  Appointment? selectedAppointment;

  @override
  void initState() {
    super.initState();

    if (global.user == null) {
      print("User not logged in!");
      return;
    }

    _calendarController.displayDate = getCurrentWeek();
    
  }

  DateTime getCurrentDay({bool addDays = true}){
    final now = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      1,
      0,
      0,
    );
    return now.add(Duration(
      days: (addDays ? 2 : 0)
    ));
  }

  DateTime getCurrentWeek({bool addDays = true}) {
    final now = getCurrentDay();
    return now.subtract(Duration(
      days: now.weekday - (addDays ? 2 : 1)
    ));
  }

  void gotoThisWeek() {
    DateTime now = getCurrentWeek();
    setState(() {
      _calendarController.displayDate = now;
    });
  }

  void gotoNextWeek() {
    final DateTime now = _calendarController.displayDate!;
    final DateTime nextWeek = now.add(
      Duration(
        days: 7,
    ));
    setState(() {
      _calendarController.displayDate = nextWeek;
    });
  }

  void gotoPreviousWeek() {
    final DateTime now = _calendarController.displayDate!;
    final DateTime nextWeek = now.subtract(
      Duration(
        days: 7,
    ));
    setState(() {
      _calendarController.displayDate = nextWeek;
    });
  }

  List<Appointment> _getDataSource() {
    if (global.user == null) {
      return [];
    }

    final List<Appointment> meetings = <Appointment>[];

    final classes = global.user!.schedule.schedule.classes;
    final tests = global.user!.schedule.schedule.tests;
    final activities = global.user!.schedule.schedule.activities;

    for (var item in classes) {

      final test = tests.cast<dynamic>().firstWhere(
        (test) => test.startTime.isAtSameMomentAs(item.startTime),
        orElse: () => null,
      );

      Color color = test == null 
        ? Colors.blue 
        : Colors.red;
      
      String timeString = item.startTime.toString().substring(11, 16);
      timeString += " - ${item.endTime.toString().substring(11, 16)}";

      String notes = 
        "${item.subject}\n"
        "Professor: ${item.teacher}\n"
        "Sala ${item.room}\n"
        "$timeString\n";
      
      if (test != null) {
        notes += "${test.title}\n";
      }

      meetings.add(
        Appointment(
          startTime: item.startTime,
          endTime: item.endTime,
          subject: item.label,
          color: color,
          notes: notes,
          location: item.room,
        ),
      );
    }

    for (var item in activities) {
      String notes = "${item.title}\n";

      meetings.add(
        Appointment(
          startTime: item.startTime,
          endTime: item.endTime,
          subject: item.title,
          color: Colors.green,
          notes: notes,
          isAllDay: true,
        ),
      );
    }

    return meetings;
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final colors = theme.colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          Positioned( // Schedule
            top: headerHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: buildSchedule()
          ), 
          Positioned( // Header
            top: 0,
            left: 0,
            right: 0,
            child: buildScheduleHeader(context),
          ),
          buildScheduleDetails(context),
        ],
      ),
    );
  }
  
  Widget buildSchedule() {
    
    return SfCalendar(
      controller: _calendarController,
      view: CalendarView.workWeek,
    
      dataSource: MeetingDataSource(_getDataSource()),
    
      firstDayOfWeek: 1,
    
      headerHeight: 0,
    
      appointmentBuilder: (context, details) {
        final Appointment appointment = details.appointments.first;
        return AppointmentTile(appointment: appointment, details: details);
      },
    
      timeSlotViewSettings: const TimeSlotViewSettings(
        timeInterval: Duration(minutes: 60),
        timeIntervalHeight: 85,
    
        numberOfDaysInView: 5,
    
        nonWorkingDays: <int>[DateTime.saturday, DateTime.sunday],
        startHour: 7,
        endHour: 23
      ),
    
      onTap: (CalendarTapDetails details) {
        if (details.appointments != null && details.appointments!.isNotEmpty) {
          setState(() {
            selectedAppointment = details.appointments!.first;
          });
        }
      },
      
    );
  }

  Widget buildScheduleDetails(BuildContext context){
    if (selectedAppointment == null) {
      return Container();
    }
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          selectedAppointment = null;
        });
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withValues(alpha: 0.5),
        child: GestureDetector(
          onTap: () {},
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: AppTheme.containerRadius,
                color: colors.surface,
              ),
              constraints: BoxConstraints(
                minWidth: min(350, MediaQuery.of(context).size.width * 0.9), 
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        selectedAppointment!.isAllDay ? "Atividade" : "Evento",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                        ),
                      ),
                    ),
                    Divider(
                      indent: 20,
                      endIndent: 20,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      selectedAppointment!.notes ?? "",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        color: colors.onSurface,
                        height: 2,
                      ),
                    ),
                  ],
                ),
              ),
              
            ),
          ),
        ),
      ),
    );
  }

  Widget buildScheduleHeader(BuildContext context) {
    // final theme = Theme.of(context);
    // final colors = theme.colorScheme;

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: headerHeight,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 5,
            children: [
              _buildHeaderButton(
                context, 
                Icons.chevron_left, 
                gotoPreviousWeek
              ),
              _buildHeaderButton(
                context, 
                Icons.today, 
                gotoThisWeek, 
                width: 100
              ),
              _buildHeaderButton(
                context, 
                Icons.chevron_right, 
                gotoNextWeek
              ),
            ],
          ),
        ),
        LoadIndicatorWidget(
          colorId: global.user!.schedule.loadingFromEPV ? 1
            : global.user!.schedule.fromEPV ? 2
            : 0
        ),
      ],
    );
  }

  Widget _buildHeaderButton(BuildContext context, 
    IconData icon, VoidCallback onPressed,
    { double width = 60 }
  ) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.buttonRadius,
          ),
        ),
        child: Icon(icon, color: colors.onPrimary),
      ),
    );
  }
}

class AppointmentTile extends StatelessWidget {
  final Appointment appointment;
  final CalendarAppointmentDetails details;

  const AppointmentTile({
    super.key,
    required this.appointment,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final Map<String, List<Color>> eventColors = {
      "class": [colors.primaryContainer, colors.onPrimaryContainer],
      "test": [Colors.red, Colors.white],
      "activity": [Colors.green, Colors.white],
    };

    final String type = [
      "class",
      "test",
      "activity",
    ][([Colors.blue, Colors.red, Colors.green] as List<Color>).indexOf(appointment.color)];

    if (appointment.isAllDay) {
      return Container(
        constraints: BoxConstraints(
          minHeight: 200,
        ),
        decoration: BoxDecoration(
          color: eventColors[type]!.first,
          borderRadius: AppTheme.buttonRadius,
        ),
        alignment: Alignment.center,
        child: Text(
          "Atividade",
          style: TextStyle(
            color: eventColors[type]!.last,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: eventColors[type]!.first.withValues(alpha: 0.9),
        borderRadius: AppTheme.buttonRadius,
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            appointment.subject,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: eventColors[type]!.last,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: 10,
                color: eventColors[type]!.last.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 2),
              Text(
                appointment.location ?? "??",
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  color: eventColors[type]!.last.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
