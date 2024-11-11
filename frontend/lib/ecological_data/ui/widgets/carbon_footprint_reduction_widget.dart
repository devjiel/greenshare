import 'package:flutter/material.dart';
import 'package:greenshare/l10n/localization.dart';
import 'package:greenshare/theme.dart';

class CarbonFootprintReductionWidget extends StatelessWidget {
  const CarbonFootprintReductionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kLightGreen,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    context.localization.carbonFootprintReduction,
                    style: context.titleLarge?.copyWith(
                      color: kBlack,
                    ),
                  ),
                ),
                const Icon(
                  Icons.info_outline_rounded,
                  size: 24.0,
                  color: kBlack,
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        "0.7",
                        style: context.titleLarge?.copyWith(
                          color: kBlack,
                          fontSize: 64.0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "tons",
                          style: context.bodySmall,
                        ),
                      ),
                      const Icon(
                        Icons.share_rounded,
                        size: 24.0,
                        color: kBlack,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
