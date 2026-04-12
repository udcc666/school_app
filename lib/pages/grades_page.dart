import 'dart:async';

import 'package:flutter/material.dart';
import 'package:school_app/functions/grades_class.dart';
import 'package:school_app/themes/app/app_theme.dart';
import 'package:school_app/widgets/average_grade.dart';
import 'package:school_app/widgets/column_container.dart';

import 'package:school_app/widgets/load_indicator.dart';

import 'package:school_app/Global.dart' as global;

class GradesPage extends StatefulWidget {
  const GradesPage({super.key});

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {

  Timer? _timer;

  Grades get grades => global.user!.grades;
  List<GradesClass> get classes => grades.classes;

  int selectedClassId = -1;

  @override
  void initState() {
    super.initState();
    startLoadingTimer();
  }

  void startLoadingTimer() {
    if (grades.fromEPV) {
      return;
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {});
      if (grades.fromEPV) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final colors = theme.colorScheme;
    if (!grades.loaded) {
      return Center(child: CircularProgressIndicator());
    }
    if (selectedClassId != -1){
      return buildModulesPage();
    }
    return buildMainContainer();
  }

  Widget buildMainContainer(){
    // final theme = Theme.of(context);
    // final colors = theme.colorScheme;

    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        spacing: 10,
        children: [
          AverageGradeWidget(),
          buildClasses(),
        ]
      ),
    );
  }

  Widget buildTopItems(){
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: AppTheme.containerRadius,
        boxShadow: AppTheme.defaultShadow
      ),
      height: 100,
      width: double.infinity,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              spacing: 15,
              children: [
                Container( // Icon
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: colors.surfaceContainerHigh,
                  ),
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.trending_up,
                    size: 30,
                    color: colors.primary,
                  )
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Média Geral',
                      style: TextStyle(
                        fontSize: 20,
                        color: colors.onSurface
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${(grades.getAverage()*10).round()/10}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: colors.onSurface
                          ),
                        ),
                        Text(
                          ' / 20.0',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                            color: colors.onSurface
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          LoadIndicatorWidget(
            top: 5,
            colorId: grades.isLoading 
              ? 1 
              : grades.fromEPV ? 2 : 0,
          ),
        ],
      ),
    );
  }

  Widget buildClasses(){
    // final theme = Theme.of(context);
    // final colors = theme.colorScheme;
    
    return Flexible(
      child: ColumnContainerWidget(
        text: 'Por disciplina',
        children: [
          for (int i = 0; i < classes.length; i++)...[
            buildClassButton(i),
            if (i < classes.length-1)
              Divider(),
          ]
        ],
      ),
    );
  }

  Widget buildClassButton(int id){
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final grade = classes[id];

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.surfaceContainer,
        foregroundColor: colors.onSurface,
        shape: RoundedRectangleBorder(
          // borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      onPressed: () {
        setState(() {
          selectedClassId = id;
        });
      },
      child: SizedBox(
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    grade.name,
                    style: TextStyle(
                      fontSize: 16,
                      color: colors.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${grade.modulesCompleted}/${grade.modules.length} módulos concluidos',
                    style: TextStyle(
                      fontSize: 16,
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              spacing: 10,
              children: [
                Text(
                  '${(grade.average*10).round()/10.0}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }

  Widget buildModulesPage(){
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final classe = classes[selectedClassId];

    return Container(
      constraints: BoxConstraints(
        maxWidth: 500
      ),
      padding: EdgeInsets.all(20.0),
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedClassId = -1;
                  });
                }, 
                icon: Icon(
                  Icons.arrow_back,
                  color: colors.onSurface,
                ),
              ),
              Expanded(
                child: Text(
                  '${classe.name}',
                  style: TextStyle(
                    fontSize: 24,
                    color: colors.onSurface,
                  ),
                  maxLines: 2,
                ),
              )
            ],
          ),
          AverageGradeWidget(classID: selectedClassId),
          Flexible(
            child: ColumnContainerWidget(
              text: 'Módulos', 
              children: classe.modules.isNotEmpty 
                ?[
                  for (int i = 0; i < classe.modules.length; i++) ...[
                    buildModule(selectedClassId, i),
                    if (i < classe.modules.length-1)
                      Divider(),
                  ],
                ]
                :[
                  const SizedBox(height: 20),
                  Text(
                    "Nenhum módulo",
                    style: TextStyle(
                      fontSize: 16,
                      color: colors.onSurfaceVariant
                    ),
                  ),
                ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildModule(int classId, int moduleId){
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final GradesModule module = classes[classId].modules[moduleId];

    return Container(
      constraints: BoxConstraints(
        minHeight: 75,
      ),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 20,
        children: [
          Text(
            '${moduleId+1}',
            style: TextStyle(
              fontSize: 16,
              color: colors.onSurfaceVariant
            ),
          ),
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module.name,
                    style: TextStyle(
                      fontSize: 16,
                      color: colors.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${module.year}º ano',
                    style: TextStyle(
                      fontSize: 16,
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
          ),
          Row(
            spacing: 10,
            children: [
              Text(
                '${
                  module.grade >= 0
                    ? (module.grade*10).round()/10.0
                    : 'none'
                }',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700
                ),
              ),
            ],
          ),
          
        ],
      ),
    );
  }

}
