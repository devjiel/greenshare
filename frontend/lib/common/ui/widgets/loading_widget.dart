import 'package:flutter/material.dart';
import 'package:greenshare/theme.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kDefaultPadding,
      height: kDefaultPadding,
      child: CircularProgressIndicator(
        color: color,
      ),
    );
  }
}
