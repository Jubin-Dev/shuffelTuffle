import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shuffle_tuffle/models/leaderboard_entry.dart';
import 'package:shuffle_tuffle/services/leaderboards_service.dart';
import 'package:shuffle_tuffle/states/puzzle_state.dart';
import 'package:shuffle_tuffle/styles/colors.dart';
import 'package:shuffle_tuffle/utils/format.dart';

class GameCompletionDialog extends StatefulWidget {
  const GameCompletionDialog({Key? key, this.onDismissCallback})
      : super(key: key);
  final Function? onDismissCallback;

  @override
  _GameCompletionDialogState createState() => _GameCompletionDialogState();
}

class _GameCompletionDialogState extends State<GameCompletionDialog> {
  final _textEditingController = TextEditingController();
  final _keyDialogForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = "";
  }

  Future<void> onSubmitDialog() async {
    final state = StoreProvider.of<PuzzleState>(context).state;
    final moves = state.moves;
    final seconds = state.secondsElpased.inSeconds;
    final name = _textEditingController.text;

    await LeaderboardsService.instance.add(LeaderboardEntry(
        name: name, moves: moves, seconds: seconds, timestamp: DateTime.now()));
  }

  void openDialog() {
    final PuzzleState state = StoreProvider.of<PuzzleState>(context).state;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white70,
            elevation: 2,
            title: Form(
              key: _keyDialogForm,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Good Job! ",
                        style: TextStyle(color: ThemeColors.yellow),
                      ),
                      Icon(
                        Icons.celebration_sharp,
                        color: ThemeColors.yellow,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "You have completed the puzzle in ${FormatTime.formatTime(state.secondsElpased)} and ${state.moves} moves!",
                          style: TextStyle(
                              color: ThemeColors.darkBlue, fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Would you like to sign your name in our leaderboards?",
                          style: TextStyle(
                              color: ThemeColors.darkBlue, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                  TextFormField(
                    style: TextStyle(color: ThemeColors.darkBlue),
                    decoration: InputDecoration(
                      fillColor: ThemeColors.red,
                      icon: Icon(
                        Icons.create,
                        color: ThemeColors.darkBlue,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    onChanged: (val) {
                      _textEditingController.text = val;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Your Name';
                      }

                      return null;
                    },
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  onSubmitDialog();
                  Navigator.pop(context);
                },
                child: Text(
                  'Submit',
                  style: TextStyle(
                      color: ThemeColors.darkBlue, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Dismiss',
                    style: TextStyle(
                        color: ThemeColors.darkBlue,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration.zero, openDialog),
      builder: (context, _) => const SizedBox(),
    );
  }
}
