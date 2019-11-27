import 'package:first_then/scoped_models/settings.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:toggle_switch/toggle_switch.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SettingsModel>(
        builder: (BuildContext context, Widget child, SettingsModel model) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
            ),
            body: Center(
              child: ListView(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      title: Text('Screen Lock State:'),
                      trailing: ToggleSwitch(
                          minWidth: 90.0,
                          cornerRadius: 20,
                          initialLabelIndex: model.locked == false ? 0 : 1,
                          activeBgColor: Colors.pinkAccent,
                          activeTextColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveTextColor: Colors.white,
                          labels: ['Unlocked', 'Locked'],
                          icons: [Icons.lock_open, Icons.lock],
                          onToggle: (index) {
                            model.lockScreen(index);
                          }),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text('Toggle Timer'),
                      subtitle: Text('This will show a timer above the first item'),
                      trailing: Switch(
                        onChanged: model.toggleTimer,
                        value: model.timer,
                      ),
                    )
                  ),
                ],
              ),
            ),
          );
        });
  }

}