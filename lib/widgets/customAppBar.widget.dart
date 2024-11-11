import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:syncspace/constants.dart';
import 'package:syncspace/models/api.response.model.dart';
import 'package:syncspace/provider/user.provider.dart';
import 'package:syncspace/widgets/userAvatar.widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.label,
    this.notIncludeUserAvatar,
  });

  final String? label;
  final bool? notIncludeUserAvatar;

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final bool isLoggedIn = userProvider.isLoggedIn;
    AuthAPIResponse userData = AuthAPIResponse();

    if (isLoggedIn) {
      userData = userProvider.userData!;
    }

    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          if (label == null)
            Row(
              children: [
                Image.asset(
                  'assets/img-syncspace-logo.png',
                  height: 32.0,
                  width: 32.0,
                ),
                const SizedBox(width: 4.0),
              ],
            ),
          Text(
            label != null ? label! : 'SyncSpace',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: IconButton(
            onPressed: () {
              if (isLoggedIn) {
                Scaffold.of(context).openEndDrawer();
              } else {
                if (!GoRouterState.of(context)
                    .uri
                    .toString()
                    .startsWith('/authentication')) {
                  GoRouter.of(context)
                      .pushNamed(AppRouteConstants.authentication);
                }
              }
            },
            icon: notIncludeUserAvatar == null
                ? UserAvatar(isLoggedIn: isLoggedIn, avatar: userData.avatar)
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
