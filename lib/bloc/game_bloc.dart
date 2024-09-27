// BLOC Class
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_game/bloc/game_event.dart';
import 'package:space_game/bloc/game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameState()) {
    on<ScoreUpdateEvent>(_onScoreUpdateEvent);
    on<GamePausedEvent>(_onGamePausedEvent);
    on<GameResumedEvent>(_onGameResumedEvent);
  }

  void _onScoreUpdateEvent(ScoreUpdateEvent event, Emitter<GameState> emit) {
    if (event.score != state.score) {
      emit(GameState(score: event.score, isPaused: state.isPaused));
    }
  }

  void _onGamePausedEvent(GamePausedEvent event, Emitter<GameState> emit) {
    emit(GameState(score: state.score, isPaused: true));
  }

  void _onGameResumedEvent(GameResumedEvent event, Emitter<GameState> emit) {
    emit(GameState(score: state.score, isPaused: false));
  }
}