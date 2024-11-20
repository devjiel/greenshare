import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:greenshare/common/ui/widgets/loading_widget.dart';
import 'package:greenshare/files/ui/blocs/available_files/available_files_cubit.dart';
import 'package:greenshare/share/ui/bloc/share_links/share_links_bloc.dart';
import 'package:greenshare/user/ui/blocs/user_bloc.dart';

class SharePage extends StatelessWidget {
  const SharePage({super.key, required this.shareLinkUid});

  final String shareLinkUid;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShareLinksBloc, ShareLinksState>(
      listener: (context, state) {
        if (state is ShareLinkLoaded) {
          final userBloc = context.read<UserBloc>();
          if (userBloc.state is UserStateLoaded) {
            userBloc.add(AddAvailableFile(fileUidList: state.fileUidList));

            for (final fileUid in state.fileUidList) {
              context.read<AvailableFilesCubit>().addSharedWithUser(fileUid, (userBloc.state as UserStateLoaded).user.uid);
            }
          }
          context.pushReplacement('/home');
        }
      },
      child: const Scaffold(
        body: Center(
          child: LoadingWidget(),
        ),
      ),
    );
  }
}
