import 'package:flutter/material.dart';
import 'package:syncspace/widgets/customAppBar.widget.dart';

class Settings extends StatelessWidget {
  const Settings({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        label: 'Settings',
        notIncludeUserAvatar: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text('Settings Page'),
            // change password
            // delete account
          ],
        ),
      ),
    );
  }
}
