import 'package:flutter/material.dart';

/// Widget to display relatime detection stats
class StatsRow extends StatelessWidget {
  /// Constructor
  const StatsRow(this.left, this.right, {Key? key}) : super(key: key);

  /// Definition
  final String left;

  /// Output
  final String right;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(left), Text(right)],
      ),
    );
  }
}
