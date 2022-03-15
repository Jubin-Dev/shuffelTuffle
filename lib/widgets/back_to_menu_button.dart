import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shuffle_tuffle/reducers/puzzle_reducer.dart';
import 'package:shuffle_tuffle/services/puzzle_service.dart';
import 'package:shuffle_tuffle/states/puzzle_state.dart';
import 'package:shuffle_tuffle/widgets/menu_button.dart';

class BackToMenuButton extends StatelessWidget {
  const BackToMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuButton(
        text: "Menu",
        onTap: () {
          Navigator.pop(context);
          StoreProvider.of<PuzzleState>(context).dispatch(PuzzleAction(
              type: PuzzleActions.setGameStatus,
              payload: GameStatus.notPlaying));
        });
  }
}
