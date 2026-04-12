import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:school_app/widgets/load_indicator.dart';

import 'package:school_app/Global.dart' as global;

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {

  @override
  void initState() {
    super.initState();
    if (!global.user!.isLoadedFromEPV && 
      !global.user!.loadingFromEPV) {
        loadUser();
    }
    startLoadingTimer();
  }

  void loadUser() async {
    await global.user!.loadUser();
    if (!mounted) return;
    setState(() {});
  }

  void startLoadingTimer() {
    if (!global.user!.loadingFromEPV) {
      return;
    }

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {});
      if (!global.user!.loadingFromEPV) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final colors = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    clipBehavior: Clip.antiAlias, 
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Image.memory(
                      global.user!.image ?? Uint8List(0),
                      fit: BoxFit.cover,
                    ),
                  ),
              
                  Text(global.user!.name),
                  Text(global.user!.className),
                ],
              ),
            ),
            LoadIndicatorWidget(
              colorId: global.user!.loadingFromEPV ? 1
                : global.user!.isLoadedFromEPV ? 2
                : 0
            ),
          ],
        ),
      ),
    );
  }
}
