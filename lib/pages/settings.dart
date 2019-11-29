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
                  _timerSettingsCard(model),
                ],
              ),
            ),
          );
        });
  }

  Widget _timerSettingsCard(model){
    final _timeDurationForm = GlobalKey<FormState>();
    TextEditingController minutesController = TextEditingController();
    TextEditingController secondsController = TextEditingController();
    minutesController.text = model.durationMin.toString();
    secondsController.text = model.durationSec.toString();
    return Form(
      key: _timeDurationForm,
      child: Card(
        child:Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Timer Settings',
                        textAlign: TextAlign.center
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child:ListTile(
                      title: Text('Toggle Timer'),
                      subtitle: Text('This will show a timer above the first item'),
                      trailing: Switch(
                        onChanged: model.toggleTimer,
                        value: model.timer,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                          'Set Timer Duration (Timer Counts Down for the set duration)',
                          textAlign: TextAlign.left
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child:Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: minutesController,
                        decoration: InputDecoration(labelText: "Minutes"),
                        keyboardType: TextInputType.number,
                        onChanged: (m) => minutesController.text = m,
                      ),
                    ),
                  ),
                  Expanded(
                    child:Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: secondsController,
                        decoration: InputDecoration(labelText: "Seconds"),
                        keyboardType: TextInputType.number,
                        onChanged: (s) => secondsController.text = s,
                      ),
                    ),
                  ),
                  Expanded(
                    child:Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RaisedButton(
                        color: Colors.pinkAccent,
                        onPressed: () {
                            model.updateTimerDuration(minutesController.text, secondsController.text);
                        },
                        child: Text('Set Timer'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}