import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

bool _locked = false;
void main() => runApp(FirstAndThen());

class FirstAndThen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'First And Then',
      debugShowCheckedModeBanner:false,
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
    );
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
  Icon _lockIcon = Icon(Icons.lock_open);

  void _lockscreen() {
    setState(() {
      if(_locked){
        _locked = false;
        _lockIcon = Icon(Icons.lock_open);
      }else{
        _locked = true;
        _lockIcon = Icon(Icons.lock);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return GridView.count(
              padding: const EdgeInsets.all(20.0),
              // Create a grid with 1 columns in portrait mode, or 2 columns in
              // landscape mode.
              crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
              children: <Widget>[
                ImageCard(title: "First"),
                ImageCard(title: "Then")
              ],
            );
        }),
      floatingActionButton: FloatingActionButton(
        onPressed: _lockscreen,
        tooltip: 'Lock',
        child: _lockIcon,
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }
}

class ImageCard extends StatefulWidget{
  ImageCard({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _ImageCard createState() => _ImageCard();
}

class _ImageCard extends State<ImageCard> {
  File image;
  getCamera() async {
    image = await ImagePicker.pickImage(
        source: ImageSource.camera // maxHeight: 50.0, // maxWidth: 50.0,
    );
    setState(() {});
  }
  getGallery() async {
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }
  //save the result of gallery file
  void _addImageDialog() {
    if(!_locked){
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text('Select and Image'),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(onPressed: () {
                      getGallery();
                      Navigator.pop(context);
                      }, icon: Icon(Icons.add_photo_alternate)),
                    IconButton(onPressed: (){
                      getCamera();
                      Navigator.pop(context);
                    }, icon: Icon(Icons.add_a_photo))
                  ]
                ),
              ],
            );
          });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(widget.title, style: Theme.of(context).textTheme.title),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            image == null
            ? new IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: _addImageDialog
            )
            : new Container(
              child: GestureDetector(
                child: Hero(
                  tag: "",
                  child:Image.file(image, width: 300, height: 300, fit: BoxFit.cover),
                ),
                onTap: _addImageDialog,
              )
            )
          ]
        ),
      ],
    );
  }
}

