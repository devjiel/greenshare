import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:greenshare/theme.dart';

class FileUploadPage extends StatelessWidget {
  const FileUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: DottedBorder(
              color: kLightGreen,
              dashPattern: const [6, 6],
              borderType: BorderType.RRect,
              radius: const Radius.circular(16),
              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Click me', style: TextStyle(color: Colors.black)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
