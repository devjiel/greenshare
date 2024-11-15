import 'package:flutter/material.dart';
import 'package:greenshare/authentication/ui/blocs/authentication_bloc.dart';
import 'package:greenshare/common/config/injectable.dart';
import 'package:greenshare/l10n/localization.dart';
import 'package:greenshare/theme.dart';
import 'package:greenshare/user/ui/widget/user_avatar_widget.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            PopupMenuButton<String>(
              offset: const Offset(0, kSmallPadding),
              onSelected: (String result) {
                if (result == 'logout') {
                  getIt<AuthenticationBloc>().add(const AuthenticationLogoutRequested());
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text(
                    context.localization.logout,
                    style: context.bodyLarge,
                  ),
                ),
              ],
              icon: const UserAvatar(),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
