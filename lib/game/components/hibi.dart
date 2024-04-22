import 'package:flame/components.dart';//SpriteComponent,HasGameRef
import 'my_component.dart';//MyComponent

import 'dart:math' as Math;

class Hibi extends MyComponent with HasGameRef {

  Hibi({required game,required World world, required Vector3 position3D})
      : super(game: game, world: world, position3D: position3D, anchor: Anchor.center){
    super.size = Vector2.all(300);
  }

  @override
  Future<void> onLoad() async{
    super.sprite = await gameRef.loadSprite("1976742.png");


    /*
     * 画面の大きさ調整
     * 画像にすっぽり収まるサイズで
     *
     * 比率を計算して調整
     * Vector2 operator *(double scale) => clone()..scale(scale);
     */
    Vector2 bgImageSize = super.sprite!.originalSize;
    double ratio = gameRef.size.y/bgImageSize.y;
    super.size = bgImageSize * ratio;
  }

  void update(double dt){
    super.update(dt);

    if(super.time >= 3){
      super.world.remove(this);
    }
  }
}