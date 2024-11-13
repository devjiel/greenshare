import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenshare/common/config/injectable.dart';
import 'package:greenshare/ecological_data/ui/blocs/carbon_reduction_bloc.dart';
import 'package:greenshare/ecological_data/ui/ecological_data_section.dart';
import 'package:greenshare/file_upload/ui/blocs/available_files/available_files_bloc.dart';
import 'package:greenshare/file_upload/ui/blocs/file_upload/file_upload_bloc.dart';
import 'package:greenshare/file_upload/ui/file_upload_section.dart';
import 'package:greenshare/home/ui/footer.dart';
import 'package:greenshare/home/ui/header.dart';
import 'package:greenshare/user/ui/blocs/user_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CarbonReductionBloc>(
          create: (_) => getIt<CarbonReductionBloc>()..add(LoadCarbonReductionEvent()),
        ),
        BlocProvider<UserBloc>(
          create: (_) => getIt<UserBloc>()..add(const StartListeningUser('d9ae6ea2-98c5-451f-856b-2c09cf2d9c4b')),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
              return Column(
                children: [
                  const Expanded(
                    child: Header(),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: MultiBlocProvider(
                      providers: [
                        BlocProvider<AvailableFilesBloc>.value(value: getIt<AvailableFilesBloc>()),
                        BlocProvider<FileUploadBloc>.value(value: getIt<FileUploadBloc>())
                      ],
                      child: const FileUploadSection(),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: const EcologicalDataSection(),
                  ),
                  const Expanded(
                    child: Footer(),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
