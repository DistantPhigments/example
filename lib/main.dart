import 'dart:ui' as ui;

import 'package:flame/assets.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(Example());
}

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Example',
        home: Scaffold(
            body: Material(
                child: Center(child: GameWidget(game: ExampleGame())))));
  }
}

class ExampleGame extends BaseGame {
  late SpriteComponent sc;

  double direction = 1.0;

  @override
  Future<void> onLoad() async {
    print('onLoad');
    final Images imagesLoader = Images();
    ui.Image atlasImage = await imagesLoader.load('image.png');

    SpriteBatch spriteBatch = SpriteBatch(atlasImage);

    Vector2 imageSize = Vector2(atlasImage.width.toDouble(), atlasImage.height.toDouble());

    for(int n = 0; n < 1000; n++) {
      Rect rect = Rect.fromLTRB(0, 0, imageSize.x, imageSize.y);
      Vector2 offset = Vector2(50,50);
      spriteBatch.add(source: rect, offset: offset);
    }

    add(SpriteBatchComponent.fromSpriteBatch(spriteBatch));

    Sprite sprite = Sprite(atlasImage, srcPosition: Vector2(0, 0),
      srcSize: imageSize);
    sc = SpriteComponent(sprite: sprite);
    sc.size = imageSize;
    sc.position = Vector2(200,200);
    add(sc);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (sc.position.x > 300) {
      direction = -1.0;
    } else if (sc.position.x < 100) {
      direction = 1.0;
    }
    sc.position += Vector2(direction, 0);
  }
}
