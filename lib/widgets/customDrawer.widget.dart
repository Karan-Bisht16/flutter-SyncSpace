import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:syncspace/constants.dart';
import 'package:syncspace/models/api.response.model.dart';
import 'package:syncspace/provider/theme.provider.dart';
import 'package:syncspace/provider/user.provider.dart';
import 'package:syncspace/widgets/changeThemeButton.widget.dart';
import 'package:syncspace/widgets/userAvatar.widget.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  void navigateToProfile(AuthAPIResponse userData) {
    if (!GoRouterState.of(context).uri.toString().startsWith('/profile')) {
      Navigator.pop(context);
      GoRouter.of(context).pushNamed(
        AppRouteConstants.profile,
        pathParameters: {
          'userName': userData.userName!,
        },
      );
    }
  }

  void navigateToSettings(AuthAPIResponse userData) {
    if (!GoRouterState.of(context).uri.toString().startsWith('/settings')) {
      Navigator.pop(context);
      GoRouter.of(context).pushNamed(
        AppRouteConstants.settings,
        pathParameters: {
          'userId': userData.id!,
        },
      );
    }
  }

  void openAlert(Function successFunction) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(
      context,
      listen: false,
    );

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        title: const Text('Logout'),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        content: const Text('You will be logged out of your account.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          MaterialButton(
            onPressed: () {
              successFunction();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            color: Theme.of(context).colorScheme.primary,
            child: Text(
              'Ok',
              style: TextStyle(
                color: themeProvider.theme == 3 ? Colors.black : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void logout() {
    final UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    userProvider.logout();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    AuthAPIResponse userData = AuthAPIResponse();
    final bool isLoggedIn = userProvider.isLoggedIn;

    if (isLoggedIn) {
      userData = userProvider.userData!;
    }

    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 200,
                  child: customDrawerHeader(isLoggedIn, userData, context),
                ),
                ListTile(
                  title: Text('Profile', style: listTileTextStyle()),
                  leading: const Icon(Icons.person_rounded, size: 32.0),
                  onTap: () {
                    navigateToProfile(userData);
                  },
                ),
                ListTile(
                  title: Text('Settings', style: listTileTextStyle()),
                  leading: const Icon(Icons.settings, size: 32.0),
                  onTap: () {
                    navigateToSettings(userData);
                  },
                ),
                ListTile(
                  title: Text('Logout', style: listTileTextStyle()),
                  leading: const Icon(Icons.logout_rounded, size: 32.0),
                  onTap: () {
                    openAlert(logout);
                  },
                ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.bottomRight,
            child: ChangeThemeButton(),
          )
        ],
      ),
    );
  }

  DrawerHeader customDrawerHeader(
    bool isLoggedIn,
    AuthAPIResponse userData,
    BuildContext context,
  ) {
    return DrawerHeader(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserAvatar(isLoggedIn: isLoggedIn, avatar: userData.avatar!),
            const SizedBox(width: 12.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData.name != null ? userData.name! : '',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    height: 0,
                  ),
                ),
                Text(
                  'e/${userData.userName}',
                  style: TextStyle(
                    height: 0,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextStyle listTileTextStyle() {
    return const TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    );
  }
}
