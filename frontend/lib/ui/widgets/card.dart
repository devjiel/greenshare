import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:greenshare/theme.dart';

class GreenShareCard extends StatelessWidget {
  const GreenShareCard({super.key, required this.child, this.dottedBorder = false});

  final bool dottedBorder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return dottedBorder ? _buildDottedBorder() : _buildCard();
  }

  _buildDottedBorder() {
    return DottedBorder(
        color: kLightGreen,
        padding: const EdgeInsets.all(kSmallPadding - 1.0), // -1.0 to make the border fit the default Material Card
        dashPattern: const [6, 6],
        borderType: BorderType.RRect,
        radius: const Radius.circular(16),
    child: child,
    );
  }

  // Try to rely a maximum on the Material library
  _buildCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kSmallPadding),
        child: child,
      ),
    );
  }
}
