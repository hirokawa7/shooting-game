import 'package:cameratest1/main.dart';
import 'package:flame/components.dart';//SpriteComponent,HasGameRef
import 'package:flutter/cupertino.dart';

import 'my_component.dart';//MyComponent

//sin
import 'dart:math';

//bullet
import 'enemy_bullet.dart';

import 'package:perlin/perlin.dart';//Parin noise

import 'dart:ui' as ui;
import 'dart:io';

import 'dart:typed_data';//Uint8List
import 'dart:async';//Completer

class Enemy extends MyComponent with HasGameRef {


  bool _isDamaged = false;//ダメージフラグ;

  void set isDamaged(bool flag) => _isDamaged = flag;

  Enemy({required game, required World world, required Vector3 position3D}):
        super(game: game, world: world, position3D: position3D, anchor: Anchor.center) {
    super.size = Vector2.all(200);
    //_image = imageFile;
  }

  /*
  Uint8Listから画像への変換をやってみたがうまくいかず

  Future<ui.Image> _convertFrameToImage(Uint8List pixels) {
    final c = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      pixels,
      2,
      12073,
      ui.PixelFormat.rgba8888,
      c.complete,
    );

    return c.future;
  }*/

  @override
  Future<void> onLoad() async {

    /*
    Uint8Listから画像への変換の爪痕
    ui.Image img = await _convertFrameToImage(global_image!);
    super.sprite = SpriteComponent.fromImage(img) as Sprite?;*/

    super.sprite = await gameRef.loadSprite("youngman_23.png");
  }


  /*
   * 一次元パーリンノイズ列を2つとってくる(-0.5,0.5)
   */
  final List<double> noiseX = perlin2d(width: 1, height: 50, frequency: 71)[1];
  final List<double> noiseY = perlin2d(width: 1, height: 50, frequency: 52)[1];
  //final List<double> noiseZ = perlin2d(width: 1, height: 50, frequency: 35)[1];

  @override
  void update(double dt) async {
    super.update(dt);//時間の更新、一の更新など

    //print(noiseX[super.frameCount%noiseX.length]);

    super.position3D = Vector3(
      (noiseX[super.frameCount%noiseX.length]+0.5) * gameRef.size.x,
      (noiseY[super.frameCount%noiseY.length]+0.5) * gameRef.size.y,
      0//(noiseZ[super.frameCount%noiseY.length]+0.5) * 250,
    );

    if(super.time.floor()%6 == 3 && (super.time-dt).floor()%6 != 3){
      await super.world.add(
        EnemyBullet(
          game: game,
          world: super.world,
          position3D: super.position3D,
          velocity: Vector3(0,0,150),
        )
      );
    }

    if(false && (super.time*20).floor() != ((super.time-dt)*20).floor()){
      super.world.add(
          EnemyBullet(
            game: game,
            world: world,
            position3D: Vector3(super.position.x, super.position.y, 0),
            velocity: Vector3(super.position.x, super.position.y, 0)/20,
          )
      );
    }
  }
}