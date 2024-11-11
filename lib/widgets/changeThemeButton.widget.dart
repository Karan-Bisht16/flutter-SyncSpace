import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncspace/provider/theme.provider.dart';

class ChangeThemeButton extends StatelessWidget {
  const ChangeThemeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
        showModalBottomSheet(
          context: context,
          showDragHandle: true,
          builder: (context) => SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.25,
            child: Consumer<ThemeProvider>(builder: (
              context,
              themeProvider,
              child,
            ) {
              return Column(
                children: [
                  themeModeRadioButton(themeProvider, 'Light mode', 1),
                  themeModeRadioButton(themeProvider, 'Dark mode', 2),
                  const Divider(),
                  themeModeRadioButton(themeProvider, 'High contrast mode', 3),
                ],
              );
            }),
          ),
        );
      },
      icon: Padding(
        padding: const EdgeInsets.only(right: 12.0, bottom: 12.0),
        child: Consumer<ThemeProvider>(builder: (
          context,
          themeProvider,
          child,
        ) {
          return Icon(
              themeProvider.theme == 1 ? Icons.dark_mode : Icons.light_mode
              // Theme.of(context).brightness == Brightness.light
              //     ? Icons.dark_mode
              //     : Icons.light_mode,
              );
        }),
      ),
    );
  }

  ListTile themeModeRadioButton(
    ThemeProvider themeProvider,
    String label,
    int value,
  ) {
    return ListTile(
      title: Text(label),
      trailing: Radio(
        value: value,
        groupValue: themeProvider.theme,
        onChanged: (value) => themeProvider.setTheme(value!),
      ),
    );
  }
}
