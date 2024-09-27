import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:show_fps/show_fps.dart';
import 'package:space_game/bloc/game_bloc.dart';
import 'package:space_game/control_buttons.dart';
import 'package:space_game/game.dart';


void main() {
  runApp(
    BlocProvider(
      create: (_) => GameBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SafeArea(
            child: ShowFPS(
              alignment: Alignment.topRight,
              visible: true,
              showChart: false,
              borderRadius: const BorderRadius.all(Radius.circular(11)),
              child: GameWidget(
                game: SpaceShooterGame(),
                overlayBuilderMap: {
                  'ControlButtons': (context, game) {
                    return ControlButtons(game: game as SpaceShooterGame);
                  },
                },
                initialActiveOverlays: const ['ControlButtons'],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

