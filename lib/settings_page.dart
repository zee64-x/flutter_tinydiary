import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final Function(bool) onToggleTheme;

  SettingsPage({required this.onToggleTheme});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.all(20),
          child: SwitchListTile(
            title: Text("Dark Mode"),
            value: isDark,
            onChanged: (v) {
              setState(() => isDark = v);
              widget.onToggleTheme(v);
            },
          ),
        ),
      ),
    );
  }
}
