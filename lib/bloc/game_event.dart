// BLOC Events
abstract class GameEvent {}

class ScoreUpdateEvent extends GameEvent {
  final int score;
  ScoreUpdateEvent(this.score);
}

class GamePausedEvent extends GameEvent {}

class GameResumedEvent extends GameEvent {}