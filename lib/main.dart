import 'dart:io';
import 'package:first_then/pages/settings.dart';
import 'package:first_then/scoped_models/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:video_player/video_player.dart';
import 'package:flip_panel/flip_panel.dart';

void main() => runApp(FirstAndThen());

class FirstAndThen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    final SettingsModel _settingModel = SettingsModel();
    return new ScopedModel<SettingsModel>(
      model: _settingModel,
      child: MaterialApp(
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
      ),
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
          body: model.timer == true ? BoardWithTimer(locked: model.locked) : FirstThenBoard(locked: model.locked),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute<Settings>(
                    builder: (BuildContext context) => Settings()),
              );
            },
            tooltip: 'Settings',
            child: Icon(Icons.settings),
            backgroundColor: Colors.pinkAccent,
          ),
      );
    });
  }
}

class BoardWithTimer extends StatelessWidget {
  const BoardWithTimer({Key key, this.locked}) : super(key: key);
  final bool locked;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlipClock.countdown(
                  duration: Duration(minutes: 1),
                  digitColor: Colors.white,
                  backgroundColor: Colors.black,
                  digitSize: 48.0,
                  borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                  onDone: () => print('ih'),
                ),
              ]
            ),
          Expanded(
            child:FirstThenBoard(locked: locked),
          )
        ],
      )

    );
  }
}

class FirstThenBoard extends StatelessWidget {
  const FirstThenBoard({Key key, this.locked}) : super(key: key);
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return GridView.count(
              padding: const EdgeInsets.all(20.0),
              // Create a grid with 1 columns in portrait mode, or 2 columns in
              // landscape mode.
              crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
              children: <Widget>[
                ImageCard(title: "First", locked: locked),
                ImageCard(title: "Then", locked: locked)
              ],
        );
    });
  }
}

class ImageCard extends StatefulWidget{
  ImageCard({Key key, this.title, this.locked}) : super(key: key);
  final String title;
  final bool locked;
  @override
  _ImageCard createState() => _ImageCard();
}

class _ImageCard extends State<ImageCard> {
  File _image;
  dynamic _pickImageError;
  bool isVideo = false;
  VideoPlayerController _controller;
  String _retrieveDataError;

  Future<void> _playVideo(File file) async {
    if (file != null && mounted) {
      await _disposeVideoController();
      _controller = VideoPlayerController.file(file);
      await _controller.setVolume(1.0);
      await _controller.initialize();
      await _controller.setLooping(true);
      await _controller.play();
      setState(() {});
    }
  }

  void _onImageButtonPressed(ImageSource source) async {
    if (_controller != null) {
      await _controller.setVolume(0.0);
    }
    if (isVideo) {
      final File file = await ImagePicker.pickVideo(source: source);
      await _playVideo(file);
    } else {
      try {
        _image = await ImagePicker.pickImage(source: source);
        setState(() {});
      } catch (e) {
        _pickImageError = e;
      }
    }
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller.setVolume(0.0);
      _controller.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {
    if (_controller != null) {
      await _controller.dispose();
      _controller = null;
    }
  }

  Widget _previewVideo() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_controller == null) {
      return const Text(
        'You have not yet picked a video',
        textAlign: TextAlign.center,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AspectRatioVideo(_controller),
    );
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_image != null) {
      return GestureDetector(
        child: Hero(
          tag: "",
          child:Image.file(_image, width: 300, height: 300, fit: BoxFit.cover),
        ),
        onTap: _addImageDialog,
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await ImagePicker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        isVideo = true;
        await _playVideo(response.file);
      } else {
        isVideo = false;
        setState(() {
          _image = response.file;
        });
      }
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  //save the result of gallery file
  void _addImageDialog() {
    if(!widget.locked){
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
                      _onImageButtonPressed(ImageSource.gallery);
                      Navigator.pop(context);
                      }, icon: Icon(Icons.add_photo_alternate)),
                    IconButton(onPressed: (){
                      _onImageButtonPressed(ImageSource.camera);
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
            _image == null
            ? new IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: _addImageDialog
            )
            : new Container(
              child: Platform.isAndroid
                  ? FutureBuilder<void>(
                future: retrieveLostData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Text(
                        'You have not yet picked an image.',
                        textAlign: TextAlign.center,
                      );
                    case ConnectionState.done:
                      return isVideo ? _previewVideo() : _previewImage();
                    default:
                      if (snapshot.hasError) {
                        return Text(
                          'Pick image/video error: ${snapshot.error}}',
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return const Text(
                          'You have not yet picked an image.',
                          textAlign: TextAlign.center,
                        );
                      }
                  }
                },
              )
            : (isVideo ? _previewVideo() : _previewImage()),
            )
          ]
        ),
      ],
    );
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}

class AspectRatioVideo extends StatefulWidget {
  AspectRatioVideo(this.controller);

  final VideoPlayerController controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller.value.initialized) {
      initialized = controller.value.initialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: controller.value?.aspectRatio,
          child: VideoPlayer(controller),
        ),
      );
    } else {
      return Container();
    }
  }
}