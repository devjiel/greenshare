import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenshare/common/config/injectable.dart';
import 'package:greenshare/ecological_data/ui/blocs/carbon_reduction_bloc.dart';
import 'package:greenshare/ecological_data/ui/ecological_data_section.dart';
import 'package:greenshare/file_upload/ui/blocs/available_files_bloc.dart';
import 'package:greenshare/file_upload/ui/file_upload_section.dart';
import 'package:greenshare/home/ui/footer.dart';
import 'package:greenshare/home/ui/header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const Expanded(
                child: Header(),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: BlocProvider.value(
                  value: getIt<AvailableFilesBloc>()..add(LoadAvailableFilesEvent()),
                  child: const FileUploadSection(),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: BlocProvider.value(
                  value: getIt<CarbonReductionBloc>()..add(LoadCarbonReductionEvent()),
                  child: const EcologicalDataSection(),
                ),
              ),
              const Expanded(
                child: Footer(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
