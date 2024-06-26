import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// image_gallery_saver
import 'package:image_gallery_saver/image_gallery_saver.dart';
// To handle Uint8List
import 'dart:typed_data';

import 'game/game_scene_widget.dart';//Gameシーン

//global変数で対処
//Uint8List? global_image;

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Camera Example',
      home: TakePicturePage(),
    );
  }
}

class TakePicturePage extends StatefulWidget {
  const TakePicturePage({
    Key? key,
  }) : super(key: key);

  @override
  TakePicturePageState createState() => TakePicturePageState();
}

class TakePicturePageState extends State<TakePicturePage> {
  late CameraController _controller;
  final _cameraLoaded = Completer<bool>();
  var _isZooming = false;
  var _isTakingPicture = false;

  File? _imageFile;

  @override
  void initState() {
    super.initState();

    availableCameras().then((cameras) {
      _controller = CameraController(cameras.first, ResolutionPreset.medium)
        ..initialize().then((_) {
          setState(() {
            _cameraLoaded.complete(true);
          });
        }).onError((CameraException error, stackTrace) {
          if (error.code == 'CameraAccessDenied') {
            showDialog(
              context: context,
              builder: (context) => const SimpleDialog(
                children: [Text('カメラに撮影許可を出してください')],
              ),
            );
          }
        });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                FutureBuilder<bool>(
                  future: _cameraLoaded.future,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error!}');
                    } else if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    return CameraPreview(_controller);
                  },
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey,
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            const Text('2倍ズーム'),
                            Switch(
                              value: _isZooming,
                              onChanged: zoomingChanged,
                            ),
                          ],
                        ),
                        Center(
                          child: FilledButton(
                            onPressed:
                            _cameraLoaded.isCompleted && !_isTakingPicture
                                ? () {
                              setState(() {
                                _isTakingPicture = true;
                              });
                              onTakePicture(context).then((_) {//!!!
                                setState(() {
                                  _isTakingPicture = false;
                                });

                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context){
                                        //転移先(俺作ったやつにGO！いぇい！)
                                        return GameScene();
                                      }
                                  ),
                                );
                              });
                            }
                                : null,
                            child: const Text('撮影'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_imageFile != null)
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Image.file(_imageFile!),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> onTakePicture(BuildContext context) async {///!!!
    final XFile image = await _controller.takePicture();

    final Uint8List buffer = await image.readAsBytes();

    //Uint8List型を渡したい
    //global_image = buffer;

    // Save to camera roll
    await ImageGallerySaver.saveImage(buffer, name: image.name);

    File future = File(image.path);

    setState(() {
      _imageFile = future;
    });
    await Future.delayed(const Duration(seconds: 1)).then((_) {

      /*setState(() {
        _imageFile = null;
      });*/
    });
  }

  void zoomingChanged(bool? value) {
    if (value == null) {
      return;
    }
    setState(() {
      _isZooming = value;
    });
    _controller.setZoomLevel(_isZooming ? 2.0 : 1.0);
  }
}