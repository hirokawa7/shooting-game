import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';//SpriteComponent

class MyComponent extends SpriteComponent{

  //componentにカメラの影響を与えるために必要
  final World _world;

  //カメラのz座標 手前側が正
  final double _eye_z = 300;

  //このcomponentが生まれてからの時間
  double _time = 0;

  //このcomponentが生まれてからのフレーム数
  int _frameCount = 0;

  double _frameRate = 0;

  //3次元表現するためのz座標
  double _z = 0;

  //移動速度
  Vector3 _velocity = Vector3.zero();

  //anchorをCenterにすることで画像の基準が真ん中になる
  MyComponent({required World world, Vector3? position3D, Vector3? velocity, Anchor? anchor})
      : this._world = world,
        super(anchor: anchor){

    if(position3D != null){
      this._z = position3D.z;
      super.position = position3D.xy;
    } else {
      this._z = 0;
      super.position = Vector2.zero();
    }

    if(velocity != null){
      this._velocity = velocity;
    }
  }

  //worldのgetter
  World get world => _world;

  //生まれてからの時間のgetter
  double get time => _time;

  //生まれてからのフレームのgetter
  int get frameCount => _frameCount;

  double get frameRate => _frameRate;

  //外から見て3Dのベクトルを扱っているように見える
  void set position3D(Vector3 position){
    this. _z = position.z;
    super.position = position.xy;
  }
  Vector3 get position3D{
    return Vector3(super.position.x, super.position.y, this._z);
  }
  void set velocity3D(Vector3 velocity) => this._velocity = velocity;
  Vector3 get velocity3D => this._velocity;

  @override
  void onLoad();

  @override
  @mustCallSuper//下位クラスはこれ呼ばないとダメってかんじな設定できる
  void update(double dt){
    _time += dt;
    _frameCount++;
    _frameRate = 1/dt;
    position3D += velocity3D * dt;

    //Z座標変わった時だけ
    if(velocity3D.z != 0){
      super.size *= (_eye_z -_z)/(_eye_z - (_z+velocity3D.z * dt));
    }
  }
}