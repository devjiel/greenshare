import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenshare/common/ui/widgets/loading_widget.dart';
import 'package:greenshare/ecological_data/ui/blocs/carbon_reduction_bloc.dart';
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
              child: BlocBuilder<CarbonReductionBloc, CarbonReductionState>(builder: (context, state) {
                return Column( // TODO if height is not enough, switch to a row
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (state is CarbonReductionStateLoaded) ...[
                      Row(
                        children: [
                          Text(
                            state.carbonReduction.value.toString(),
                            style: context.titleLarge?.copyWith(
                              color: kBlack,
                              fontSize: 56.0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              state.carbonReduction.unit,
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
                    ] else if (state is CarbonReductionStateLoading) ...[
                      const LoadingWidget(color: kBlack),
                    ] else if (state is CarbonReductionStateError) ...[
                      Text(
                        'Error: ${state.message}',
                        style: context.bodySmall?.copyWith(color: kRed),
                      ),
                    ],
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
