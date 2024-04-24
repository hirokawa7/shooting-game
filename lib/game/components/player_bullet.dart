import 'package:cameratest1/game/game.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'enemy.dart';
import 'my_component.dart';

class PlayerBullet extends MyComponent with HasGameRef{
  PlayerBullet({required game, required World world, required Vector3 position3D, Vector3? velocity})
      :  super(game: game, world: world, position3D: position3D, velocity: velocity, anchor: Anchor.center) {

    super.size = Vector2.all(50);
  }

  @override
  Future<void> onLoad() async{
    super.sprite = await gameRef.loadSprite("baseball_ball.png");
  }

  @override
  void update(double dt) async{
    super.update(dt);

    //print(size);
    if(super.position3D.z <= -10){
      world.remove(this);
    }
  }
}
