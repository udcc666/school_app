import 'package:flutter/material.dart';
import 'package:school_app/functions/grades_class.dart';
import 'package:school_app/themes/app/app_theme.dart';
import 'package:school_app/widgets/load_indicator.dart';

import 'package:school_app/Global.dart' as global;

class AverageGradeWidget extends StatefulWidget {
  const AverageGradeWidget({super.key, this.classID = -1, this.onYearChanged});

  final int classID;
  final VoidCallback? onYearChanged;

  @override
  State<AverageGradeWidget> createState() => _AverageGradeWidgetState();
}

class _AverageGradeWidgetState extends State<AverageGradeWidget> {
  Grades get grades => global.user!.grades;

  bool get showGlobal => widget.classID == -1;
  int? globalYearSelected;

  @override
  void initState() {
    super.initState();
    globalYearSelected = global.yearSelected;
  }

  @override
  void didUpdateWidget(covariant AverageGradeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
    globalYearSelected = global.yearSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    double avg = 0.0;

    if (showGlobal) {
      avg = grades.getAverage(yearSelected: globalYearSelected);
    } else {
      avg = grades.classes[widget.classID].getAverage(yearSelected: globalYearSelected);
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: AppTheme.containerRadius,
        boxShadow: AppTheme.defaultShadow,
      ),
      height: 160,
      width: double.infinity,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 10,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Anos',
                      style: TextStyle(
                        fontSize: 18,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    _buildYearSelection(),
                  ],
                ),
                const Divider(),
                Row(
                  spacing: 15,
                  children: [
                    Container(
                      // Icon
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
                      ),
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            showGlobal ? 'Média global' : 'Média da disciplina',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: colors.onSurface,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '${(avg * 10.0).round() / 10.0}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: colors.onSurface,
                                ),
                              ),
                              Text(
                                ' / 20.0',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                : grades.fromEPV
                ? 2
                : 0,
          ),
        ],
      ),
    );
  }

  Widget _buildYearSelection() {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButtonFormField(
            initialValue: (globalYearSelected ?? '0').toString(),
            items: const [
              DropdownMenuItem(value: '0', child: Text('Todos')),
              DropdownMenuItem(value: '1', child: Text('1º Ano')),
              DropdownMenuItem(value: '2', child: Text('2º Ano')),
              DropdownMenuItem(value: '3', child: Text('3º Ano')),
            ],
            onChanged: (val) {
              setState(() {
                globalYearSelected = int.tryParse(val!);
                if (globalYearSelected == 0) globalYearSelected = null;

                if (showGlobal) {
                  global.setYearSelected(globalYearSelected);
                }
                if (widget.onYearChanged != null) {
                  widget.onYearChanged!();
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
