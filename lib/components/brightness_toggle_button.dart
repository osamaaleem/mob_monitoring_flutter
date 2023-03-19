import 'package:flutter/material.dart';

class ThemeToggleButton extends StatefulWidget {
  const ThemeToggleButton({Key? key}) : super(key: key);

  @override
  _ThemeToggleButtonState createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<ThemeToggleButton> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    final theme = isDarkMode ? ThemeData.dark() : ThemeData.light();
    applyTheme(theme);
  }

  void applyTheme(ThemeData theme) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(const SnackBar(content: Text('Changing theme...')));
    // Wait for the SnackBar to finish animating before updating the theme
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        // Update the ThemeData object with the new brightness
        Theme.of(context).copyWith(
          brightness: theme.brightness,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
      onPressed: toggleTheme,
    );
  }
}
