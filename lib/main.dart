import 'dart:ui' as ui;

import 'package:flame/assets.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
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
        //showPerformanceOverlay: true,
        title: 'Example',
        home: Scaffold(
            body: Material(
                child: Center(child: GameWidget(game: ExampleGame())))));
  }
}

class ExampleGame extends BaseGame {

  late ui.Image atlasImage;
  late SpriteComponent sc;

  double speed = 50.0;
  double direction = 50.0;

  @override
  Future<void> onLoad() async {
    print('onLoad');

    camera.zoom = 0.075;

    final Images imagesLoader = Images();
    atlasImage = await imagesLoader.load('image.png');

    Vector2 imageSize = Vector2(atlasImage.width.toDouble(), atlasImage.height.toDouble());

    GroupComponent groupComponent = GroupComponent(atlasImage);
    add(groupComponent);

    Sprite sprite = Sprite(atlasImage, srcPosition: Vector2(0, 0),
        srcSize: imageSize);
    sc = SpriteComponent(sprite: sprite);
    sc.size = imageSize;
    sc.position = Vector2(5500,8000);
    add(sc);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (sc.position.x > 18000) {
      direction = -speed;
    } else if (sc.position.x < 4000) {
      direction = speed;
    }
    sc.position += Vector2(direction, 0);
  }
}

class GroupComponent extends Component {
  final Color colour = const Color(0x00000000);
  final ui.Image atlasImage;
  final List<RSTransform> _transforms = [];
  final List<Rect> _rects = [];
  final List<Color> _colours = [];
  final BlendMode _blendMode = BlendMode.srcOver;
  final Paint _paint = Paint();

  Rect? _cullRect;
  bool _loaded = false;

  GroupComponent(this.atlasImage);

  @override
  Future<void>? onLoad() {
    _load();
    return super.onLoad();
  }

  Future<void> _load() async {

    // Add 16,384 Rects
    for (int x = 0; x < 128; x++) {
      for (int y = 0; y < 128; y++) {
        
        // Add Transform for x,y
        double screenX = 11000 + (x - y) * (60);
        double screenY = (x + y) * (30);
        Vector2 offset = Vector2(screenX, screenY);
        RSTransform rsTransform = RSTransform.fromComponents(
            scale: 1.0,
            anchorX: 1.0,
            anchorY: 1.0,
            rotation: 0.0,
            translateX: offset.x,
            translateY: offset.y);
        _transforms.add(rsTransform);

        // Add Rect for x,y
        Rect rect = Rect.fromLTRB(0, 0, 128, 192);
        _rects.add(rect);

        // Add Colour for x,y
        _colours.add(colour);
      }
    }

    _loaded = true;
    print('loaded=$_loaded');
  }

  @override
  void render(ui.Canvas c) {
    super.render(c);

    if (_loaded == false) return;

    c.drawAtlas(
        atlasImage, _transforms, _rects, _colours, _blendMode, _cullRect, _paint);
  }
}