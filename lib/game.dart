import 'package:audioplayers/audioplayers.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:space_game/bloc/game_bloc.dart';
import 'package:space_game/bloc/game_event.dart';
import 'package:space_game/obstacle.dart';
import 'package:flutter/material.dart';
import 'package:space_game/player.dart';


class SpaceShooterGame extends FlameGame with PanDetector {
  late Player player;
  late ObstacleManager obstacleManager;
  late AudioPlayer backgroundMusicPlayer;
  late AudioPlayer collisionSoundPlayer;
  late GameBloc gameBloc;
  bool gamePaused = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    gameBloc = GameBloc();
    player = Player();
    obstacleManager = ObstacleManager();

    add(player);
    add(obstacleManager);

    // Preload and set audio
    backgroundMusicPlayer = AudioPlayer();
    collisionSoundPlayer = AudioPlayer();
    await preloadAudio();
  }

  Future<void> preloadAudio() async {
    await backgroundMusicPlayer.setSource(AssetSource('background_music.mp3'));
    backgroundMusicPlayer.setVolume(0.5);
    backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
    await backgroundMusicPlayer.resume();

    await collisionSoundPlayer.setSource(AssetSource('collision_sound.mp3'));
  }

  @override
  void update(double dt) {
    if (!gamePaused) {
      super.update(dt);

      // Optimized broad phase collision detection (reduce checks)
      for (final obstacle in children.whereType<Obstacle>()) {
        if ((player.position.x - obstacle.position.x).abs() < 200) { // Distance threshold
          if (player.toRect().overlaps(obstacle.toRect())) {
            collisionSoundPlayer.play(AssetSource('collision_sound.mp3'));
            gameBloc.add(ScoreUpdateEvent(gameBloc.state.score + 1));
            remove(obstacle);
          }
        }
      }
    }
  }

  void pauseGame() {
    backgroundMusicPlayer.pause();
    gamePaused = true;
    gameBloc.add(GamePausedEvent());
  }

  void resumeGame() {
    gamePaused = false;
    backgroundMusicPlayer.resume();
    gameBloc.add(GameResumedEvent());
  }

  void movePlayerUp(double dt) {
    player.moveUp(dt);
  }

  void movePlayerDown(double dt) {
    player.moveDown(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _drawScore(canvas);
    if (gameBloc.state.isPaused) {
      _drawPausedText(canvas);
    }
  }

  void _drawPausedText(Canvas canvas) {
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Paused',
        style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.x / 2 - textPainter.width / 2, size.y / 2 - textPainter.height / 2));
  }

  void _drawScore(Canvas canvas) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Score: ${gameBloc.state.score}',
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(13, 20));
  }

  @override
  void onRemove() {
    backgroundMusicPlayer.dispose();
    collisionSoundPlayer.dispose();
    super.onRemove();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.position.y += info.delta.global.y;
    player.position.y = player.position.y.clamp(0, size.y - player.height);
  }
}

