import 'package:flutter/material.dart';
import 'package:school_app/functions/grades_class.dart';
import 'package:school_app/themes/app/app_theme.dart';
import 'package:school_app/widgets/load_indicator.dart';

import 'package:school_app/Global.dart' as global;

class AverageGradeWidget extends StatefulWidget {
  const AverageGradeWidget({super.key, this.classID = -1});

  final int classID;

  @override
  State<AverageGradeWidget> createState() => _AverageGradeWidgetState();
}

class _AverageGradeWidgetState extends State<AverageGradeWidget> {

  Grades get grades => global.user!.grades;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final bool showGlobal = widget.classID == -1;

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
                      showGlobal ? 'Média Geral' : 'Média da disciplina',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${
                            showGlobal 
                              ? (grades.getAverage()*10).round()/10
                              : (grades.classes[widget.classID].average*10).round()/10
                          }',
                          style: TextStyle(
                            fontSize: 24,
                            color: colors.onSurface
                          ),
                        ),
                        Text(
                          ' / 20.0',
                          style: TextStyle(
                            fontSize: 24,
                            color: colors.onSurfaceVariant
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
}
