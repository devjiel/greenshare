import 'package:flutter/material.dart';
import 'package:greenshare/file_upload/ui/widgets/file_widget.dart';
import 'package:greenshare/l10n/localization.dart';
import 'package:greenshare/theme.dart';
import 'package:greenshare/ui/widgets/card.dart';

class EcologicalDataSection extends StatelessWidget {
  const EcologicalDataSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            height: double.infinity,
            child: const GreenShareCard(
              child: Text("A"),
            ),
          ),
          const SizedBox(width: kMaxPadding),
          const Expanded(
            child: SizedBox(
              height: double.infinity,
              child: GreenShareCard(
                child: Center(child: Text("A")),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
