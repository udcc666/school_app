import 'dart:async';

import 'package:flutter/material.dart';

import 'package:school_app/Global.dart' as global;
import 'package:school_app/functions/student_class.dart';
import 'package:school_app/themes/app/app_theme.dart';
import 'package:school_app/widgets/average_grade.dart';
import 'package:school_app/widgets/column_container.dart';
import 'package:school_app/widgets/load_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? timer;
  Student? get user => global.user;

  @override
  void initState() {
    super.initState();
    startUiTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void startUiTimer() async {
    timer = Timer.periodic(Duration(seconds: 3), (timer) async {
      if (!mounted) return;

      await user!.updateUserData();

      if (!mounted) return;

      setState(() {});
    });
    await user!.updateUserData();
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 20,
        children: [
          buildHello(context),
          AverageGradeWidget(),
          buildEvents(context),
        ],
      ),
    );
  }

  Widget buildHello(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: AppTheme.containerRadius,
        color: colors.surfaceContainer,
        boxShadow: AppTheme.defaultShadow
      ),
      child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Olá, ${user!.getName()}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user!.className,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                        ),
                      )
                    ],
                  ),
                      
                  if (user!.image != null)
                    CircleAvatar(
                      backgroundImage: MemoryImage(user!.image!),
                      radius: 30,
                      backgroundColor: Colors.transparent,
                    )
                  else
                    Icon(
                      Icons.account_circle_outlined,
                      color: colors.onSurface,
                      size: 60,
                    ),
                ],
              ),
            ),
            LoadIndicatorWidget(
              top: 5,
              colorId: user!.loadingFromEPV ? 1
                : user!.isLoadedFromEPV ? 2
                : 0
            ),
          ],
        ),
    );
  }

  Widget buildEvents(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    DateTime now = DateTime.now();
    now = DateTime(now.year, now.month, now.day);

    final List<dynamic> futureEvents = [];

    futureEvents.addAll(
      user!.schedule.schedule.tests.where(
        (event) => event.startTime.isAfter(now),
      ).toList(),
    );

    futureEvents.addAll(
      user!.schedule.schedule.activities.where(
        (event) => event.endTime.isAfter(now),
      ).toList(),
    );
    if (futureEvents.isNotEmpty){
      futureEvents.sort((a, b) => a.startTime.compareTo(b.startTime));
    }

    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Stack(
        children: [
          ColumnContainerWidget(
            text: 'Eventos futuros', 
            children: [
              if (futureEvents.isEmpty) ...[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Nenhum evento futuro",
                      style: TextStyle(
                        fontSize: 16,
                        color: colors.onSurfaceVariant
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ]else ...[
                for (var item in futureEvents) ...[
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      minHeight: 60,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: AppTheme.containerRadius,
                      color: colors.surfaceContainer,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${item.startTime.day}/${item.startTime.month}/${item.startTime.year}",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ],
            ],
          ),
          LoadIndicatorWidget(
            top: 5,
            colorId: user!.schedule.loadingFromEPV ? 1
              : user!.schedule.fromEPV ? 2
              : 0
          ),
        ],
      ),
    );
  }
}
