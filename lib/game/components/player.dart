import 'package:flame/flame.dart';

import 'my_component.dart';
import 'package:flame/game.dart';//FlameGame
import 'package:flame/components.dart';
import 'package:flame/events.dart';//onTapDownEvent
import 'enemy_bullet.dart';
import 'player_bullet.dart';//Bullet

//画像じゃないしのでPositionComponentを使った(anchorはポジション必要)
class Player extends FlameGame with HasGameRef, TapCallbacks{

  final double BALLSPD = 100;

  //親にFlameGame持つのでworld変数に注意
  World _world;
  FlameGame _game;

  Player({required game, required World world, required Vector3 position3D}):
        this._game = game, this._world = world;

  @override
  void onLoad(){
  }

  @override//from TapCallbacks
  Future<void> onTapDown(TapDownEvent event) async {
    super.onTapDown(event);

    Vector2 addPos = event.localPosition;// - gameRef.size/2;

    await _world.add(
      PlayerBullet(
        game: game,
        world: _world,
        position3D: Vector3(addPos.x, addPos.y, 200),
        velocity: Vector3(0, 0, -BALLSPD),
      ),
    );
  }
}