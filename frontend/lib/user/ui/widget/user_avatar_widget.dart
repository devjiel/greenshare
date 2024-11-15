import 'package:flutter/material.dart';
import 'package:greenshare/theme.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 20,
      backgroundColor: kLightGreen,
      child: Icon(
        Icons.person,
        color: kDarkGreen,
        size: 32,
      ),
    );
  }
}
