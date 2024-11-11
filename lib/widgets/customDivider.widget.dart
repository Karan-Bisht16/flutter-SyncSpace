import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1.0,
      child: Divider(
        color: Theme.of(context).colorScheme.surfaceBright,
      ),
    );
  }
}
