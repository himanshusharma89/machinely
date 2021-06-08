import 'package:flutter/material.dart';

/// Decorated container to display passed widget
class CardView extends StatelessWidget {
  /// CardView constructor to recieve the widget
  const CardView({required this.child, Key? key}) : super(key: key);
  /// Child Widget
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.5),
            borderRadius: BorderRadius.circular(22)),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
