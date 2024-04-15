import 'package:flame/flame.dart';

import 'my_component.dart';
import 'package:flame/game.dart';//FlameGame
import 'package:flame/components.dart';
import 'package:flame/events.dart';//onTapDownEvent
import 'bullet.dart';//Bullet

//画像じゃないしのでPositionComponentを使った(anchorはポジション必要)
class Player extends FlameGame with HasGameRef, TapCallbacks{

  //親にFlameGame持つのでworld変数に注意
  World _world;

  Player({required World world, required Vector3 position3D}):
        this._world = world;

  @override
  void onLoad(){
  }

  @override//from TapCallbacks
  Future<void> onTapDown(TapDownEvent event) async {
    super.onTapDown(event);

    Vector2 addPos = event.localPosition;// - gameRef.size/2;

    await _world.add(
      Bullet(
        world: _world,
        position3D: Vector3(addPos.x, addPos.y, 200),
        velocity: Vector3(0, 0, -100),
      ),
    );
  }
}