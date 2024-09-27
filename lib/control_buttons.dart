import 'package:flutter/material.dart';
import 'package:space_game/game.dart';

class ControlButtons extends StatefulWidget {
  final SpaceShooterGame game;

  const ControlButtons({required this.game, super.key});

  @override
  ControlButtonsState createState() => ControlButtonsState();
}

class ControlButtonsState extends State<ControlButtons> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Row(
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () {
                    widget.game.movePlayerUp(1.0 / 60.0);
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: const Icon(Icons.arrow_upward),
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    widget.game.movePlayerDown(1.0 / 60.0);
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: const Icon(Icons.arrow_downward),
                  ),
                ),
              ),
              IconButton(
                icon: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    child: Icon(
                        widget.game.gamePaused ? Icons.play_arrow : Icons.pause)),
                onPressed: () {
                  setState(() {
                    if (widget.game.gamePaused) {
                      widget.game.resumeGame();
                    } else {
                      widget.game.pauseGame();
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
