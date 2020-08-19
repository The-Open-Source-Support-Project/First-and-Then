import 'package:first_then/pages/settings.dart';
import 'package:first_then/scoped_models/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flip_panel/flip_panel.dart';
import 'widgets/image_card.dart';

void main() => runApp(FirstAndThen());

class FirstAndThen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    final SettingsModel _settingModel = SettingsModel();
    return new ScopedModel<SettingsModel>(
        model: _settingModel,
        child: Shortcuts(
          shortcuts: <LogicalKeySet, Intent>{
            LogicalKeySet(LogicalKeyboardKey.select): ActivateIntent(),
          },
          child: MaterialApp(
            title: 'First And Then',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              brightness: Brightness.dark,
              primaryColor: Colors.blue,
              accentColor: Colors.pinkAccent,
              fontFamily: 'Roboto',
              textTheme: TextTheme(
                body1: TextStyle(fontSize: 18.0),
                title: TextStyle(fontSize: 33.0),
              ),
            ),
            home: MyHomePage(title: 'First And Then'),
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return ScopedModelDescendant<SettingsModel>(
        builder: (BuildContext context, Widget child, SettingsModel model) {
      return Scaffold(
        body: model.timer == true
            ? boardWithTimer(model)
            : firstThenBoard(model.locked),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<Settings>(
                  builder: (BuildContext context) => Settings()),
            );
          },
          tooltip: 'Settings',
          child: Icon(Icons.settings),
          backgroundColor: Colors.pinkAccent,
          focusColor: Colors.pink,
        ),
      );
    });
  }

  Widget boardWithTimer(model) {
    var startTime;
    void _restartTimer() async {
      startTime = DateTime.now();
      setState(() {});
    }

    return Material(
        child: Column(
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FlipClock.countdown(
              startTime: startTime,
              duration: Duration(
                  minutes: model.durationMin, seconds: model.durationSec),
              digitColor: Colors.white,
              backgroundColor: Colors.black,
              digitSize: 48.0,
              borderRadius: const BorderRadius.all(Radius.circular(3.0)),
              onDone: () => print('Done'), //TODO make this show Toast message
            ),
          ),
          IconButton(onPressed: _restartTimer, icon: Icon(Icons.refresh))
        ]),
        Expanded(
          child: firstThenBoard(model.locked),
        )
      ],
    ));
  }

  Widget firstThenBoard(locked) {
    return OrientationBuilder(builder: (context, orientation) {
      return GridView.count(
        padding: const EdgeInsets.all(20.0),
        // Create a grid with 1 columns in portrait mode, or 2 columns in
        // landscape mode.
        crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
        children: <Widget>[
          new ImageCard(title: "First", locked: locked),
          new ImageCard(title: "Then", locked: locked)
        ],
      );
    });
  }
}
