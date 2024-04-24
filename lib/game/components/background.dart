import 'package:flame/components.dart';//SpriteComponent,HasGameRef

import 'my_component.dart';//MyComponent

class BackGround extends MyComponent with HasGameRef{

  //worldはcomponentにカメラの影響を与えるために必要
  BackGround({required game, required World world})
      :super(game: game, world: world, position3D: Vector3.zero(), anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async{
    super.sprite = await gameRef.loadSprite("bg_heaven_tengoku.jpg");


    /*
     * 画面の大きさ調整
     * 画像の縦を画面の縦に合わせる
     *
     * 比率を計算して調整
     * Vector2 operator *(double scale) => clone()..scale(scale);
     */
    Vector2 bgImageSize = super.sprite!.originalSize;
    double ratio = gameRef.size.y/bgImageSize.y;
    super.size = bgImageSize * ratio;
  }
}