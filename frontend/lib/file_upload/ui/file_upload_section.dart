import 'package:flutter/material.dart';
import 'package:greenshare/ui/widgets/card.dart';

class FileUploadSection extends StatelessWidget {
  const FileUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GreenShareCard(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Click me', style: TextStyle(color: Colors.black)),
              ),
            ),
          ),
        ),
        Expanded(
          child: GreenShareCard(
            dottedBorder: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Click me', style: TextStyle(color: Colors.black)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
