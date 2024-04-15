import 'package:flame/components.dart';
import 'package:flame/game.dart';//FlameGame
import 'components/background.dart';//BackGround
import 'components/enemy.dart';//Enemy
import 'components/player.dart';//Player

class MyGame extends FlameGame with HasGameRef{

  /*
   * 遅延初期化
   * インスタンスが生成されてsuperが出てきた後に初期化したい
   * 遅延初期化前に変数にアクセスするとLateInitializationErrorがスローされる。
   */
  late final BackGround _backGround;
  late final Enemy _enemy;
  late final Player _player;


  MyGame(){
    _backGround = BackGround(world: super.world);
    _enemy = Enemy(world: super.world, position3D: Vector3.zero());
    _player = Player(world: super.world, position3D: Vector3(0, 0, -300));
  }


  @override
  Future<void> onLoad() async{
    /*
     * world addしたものがカメラの追従を受けることができる
     *
     * world.add
     * FlameGame.add
     * SpriteComponent.add
     * は親をたどるとすべてComponent.addに行く
     *
     */
    await super.world.add(_backGround);
    await super.world.add(_enemy);
    await super.world.add(_player);


    camera.moveTo(gameRef.size/2);
  }
}