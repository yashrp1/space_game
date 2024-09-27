import 'dart:math';
import 'package:flame/components.dart';
import 'package:space_game/game.dart';

class ObstacleManager extends TimerComponent with HasGameRef<SpaceShooterGame> {
  static final _random = Random();
  final List<Obstacle> _pool = [];

  ObstacleManager() : super(period: 1, repeat: true);

  @override
  void onTick() {
    super.onTick();
    _spawnObstacle();
  }

  void _spawnObstacle() {
    final obstacle = _getObstacle();
    obstacle.position = Vector2(gameRef.size.x, _random.nextDouble() * gameRef.size.y);
    gameRef.add(obstacle);
  }

  Obstacle _getObstacle() {
    if (_pool.isNotEmpty) {
      return _pool.removeLast();
    } else {
      return Obstacle(); // New obstacle if pool is empty
    }
  }

  void recycleObstacle(Obstacle obstacle) {
    _pool.add(obstacle);
  }
}

class Obstacle extends SpriteComponent with HasGameRef<SpaceShooterGame> {
  static const _speed = 150;
  double obstacleSize = 30;

  Obstacle();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('enemy.png');
    obstacleSize = gameRef.size.x >= 600 ? 70 : 30;
    width = obstacleSize;
    height = obstacleSize;
    anchor = Anchor.center;
    angle = pi / 2; 
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= _speed * dt;

    if (position.x + width < 0) {
      gameRef.remove(this);
      gameRef.obstacleManager.recycleObstacle(this); // Recycle the obstacle
    }
  }
}
