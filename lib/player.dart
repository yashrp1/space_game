import 'dart:math';

import 'package:flame/components.dart';
import 'package:space_game/game.dart';
// import 'package:flame/img.dart';
class Player extends SpriteComponent with HasGameRef<SpaceShooterGame> {
  static const double _speed = 300;
  double playerSize = 50;

  Player();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('player.png');

    final size = gameRef.size;
    position = Vector2(size.x / 8, size.y / 2);
    playerSize = size.x >= 600 ? 70 : 50;
    width = playerSize;
    height = playerSize;
    anchor = Anchor.center;
    angle = pi / 2; 
  }

  void moveUp(double dt) {
    position.y -= _speed * 3 * dt;
    position.y = position.y.clamp(0, gameRef.size.y - height);
  }

  void moveDown(double dt) {
    position.y += _speed * 3 * dt;
    position.y = position.y.clamp(0, gameRef.size.y - height);
  }
}
