import 'package:flutter/material.dart';

class LoadIndicatorWidget extends StatefulWidget {
  const LoadIndicatorWidget({super.key, this.colorId = 1, this.top = 0});

  final int colorId;
  final double top;

  @override
  State<LoadIndicatorWidget> createState() => _LoadIndicatorWidgetState();
}

class _LoadIndicatorWidgetState extends State<LoadIndicatorWidget> {

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final colors = theme.colorScheme;

    return Positioned(
      top: widget.top,
      left: 0,
      child: SizedBox(
        width: 45,
        child: Center(
          child: Icon(
            size: 25,
            Icons.circle,
            color:const [
              Color(0xFFFF0000),
              Color(0xFFFFFF00),
              Color(0xFF00FF00),
            ][widget.colorId],
          ),
        ),
      ),
    );
  }
}
