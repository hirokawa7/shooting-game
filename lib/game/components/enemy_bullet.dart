import 'package:flame/components.dart';//SpriteComponent,HasGameRef
import 'my_component.dart';//MyComponent
import 'hibi.dart';//Hibi

class EnemyBullet extends MyComponent with HasGameRef{

  /*
   * worldはcomponentにカメラの影響を与えるために必要
   *
   * super()はコンストラクタのみ呼び出す
   * super.は自分より上位のクラスすべてから呼べる
   */
  EnemyBullet({required game, required World world, required Vector3 position3D, Vector3? velocity})
      :  super(game: game, world: world, position3D: position3D, velocity: velocity, anchor: Anchor.center) {

    super.size = Vector2.all(50);
  }

  @override
  Future<void> onLoad() async{
    super.sprite = await gameRef.loadSprite("glass_ball4_red.png");
  }

  @override
  void update(double dt) async{
    super.update(dt);

    if(super.position3D.z >= 250){
      //処理重いと若干のラグあるのでawait
      world.add(
        Hibi(game: game, world: world, position3D: Vector3(super.position3D.x, super.position3D.y, 0)),
      );
      world.remove(this);
    }
  }
}