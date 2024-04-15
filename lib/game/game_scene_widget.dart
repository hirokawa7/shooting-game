import 'package:flame/game.dart';//GameWidget
import 'package:flutter/material.dart';//Widget
import 'dart:io';//File
import 'game.dart';//MyGame

class GameScene extends StatelessWidget{

  //前シーンからのファイル
  File? beforeSceneFile;
  //GameScene({File? file}):this.beforeSceneFile = file;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:Align(
        alignment: Alignment.topLeft,

        child: GameWidget(
          /*
           * enemyImg変数キモイ(むしろglobalのほうがきれい？)
           * もっときれいな実装はないだろうか？
           *
           * SceneごとにSingleton化？
           * →ただのグローバル変数と変わらん...
           */
          game: MyGame(),
        ),
      ),
    );
  }
}