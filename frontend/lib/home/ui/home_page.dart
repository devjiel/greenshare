import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:greenshare/common/config/injectable.dart';
import 'package:greenshare/ecological_data/ui/ecological_data_section.dart';
import 'package:greenshare/files/ui/blocs/available_files/available_files_cubit.dart';
import 'package:greenshare/files/ui/blocs/file_upload/file_upload_bloc.dart';
import 'package:greenshare/files/ui/file_section.dart';
import 'package:greenshare/home/ui/footer.dart';
import 'package:greenshare/home/ui/header.dart';
import 'package:greenshare/share/ui/bloc/share_links_cubit.dart';
import 'package:greenshare/user/ui/blocs/user_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
            return Column(
              children: [
                const Expanded(
                  child: Header(),
                ),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.4,
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider<AvailableFilesCubit>.value(value: getIt<AvailableFilesCubit>()),
                      BlocProvider<FileUploadBloc>.value(value: getIt<FileUploadBloc>()),
                      BlocProvider<ShareLinksCubit>.value(value: getIt<ShareLinksCubit>()),
                    ],
                    child: const FileSection(),
                  ),
                ),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.025),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.3,
                  child: const EcologicalDataSection(),
                ),
                const Expanded(
                  child: Footer(),
                ),
              ],
            );
          },
          ),
        ),
      ),
    );
  }
}
