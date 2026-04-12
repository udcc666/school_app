import 'package:flutter/material.dart';
import 'package:school_app/functions/grades_class.dart';
import 'package:school_app/themes/app/app_theme.dart';

import 'package:school_app/Global.dart' as global;

class ColumnContainerWidget extends StatefulWidget {
  const ColumnContainerWidget({ super.key, required this.text, required this.children });

  final String text;
  final List<Widget> children;

  @override
  State<ColumnContainerWidget> createState() => _ColumnContainerWidgetState();
}

class _ColumnContainerWidgetState extends State<ColumnContainerWidget> {

  Grades get grades => global.user!.grades;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppTheme.containerRadius,
        boxShadow: AppTheme.defaultShadow,
        color: colors.surfaceContainer,
      ),
      clipBehavior: Clip.antiAlias,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height:2),
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                    color: colors.onSurface
              ),
            ),
            const SizedBox(height:5),
            const Divider(thickness: 2.5),
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.children,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
