import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shuffle_tuffle/reducers/puzzle_reducer.dart';
import 'package:shuffle_tuffle/services/puzzle_service.dart';
import 'package:shuffle_tuffle/states/puzzle_state.dart';
import 'package:shuffle_tuffle/styles/menu_text.dart';
import 'package:shuffle_tuffle/utils/format.dart';

class SessionTimer extends StatefulWidget {
  const SessionTimer(
      {Key? key, required this.secondsElpased, required this.gameStatus})
      : super(key: key);

  final Duration secondsElpased;
  final GameStatus gameStatus;

  @override
  _SessionTimerState createState() => _SessionTimerState();
}

class _SessionTimerState extends State<SessionTimer> {
  Timer? timer;
  bool isActive = false;

  void tick(timer) {
    StoreProvider.of<PuzzleState>(context).dispatch(PuzzleAction(
        type: PuzzleActions.setSecondsElpased,
        payload: Duration(seconds: widget.secondsElpased.inSeconds + 1)));
  }

  void initTicker() {
    setState(() {
      isActive = true;

      timer = Timer.periodic(const Duration(seconds: 1), tick);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SessionTimer oldWidget) {
    final gameStatus = widget.gameStatus;
    if (gameStatus == GameStatus.playing && !isActive) {
      initTicker();
    } else if (gameStatus == GameStatus.done) {
      timer?.cancel();
      setState(() {
        isActive = false;
      });
    } else if (gameStatus != GameStatus.playing) {
      timer?.cancel();
      setState(() {
        isActive = false;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          width: 120,
          margin: const EdgeInsets.only(right: 2),
          child: Text(FormatTime.formatTime(widget.secondsElpased),
              style: const MenuTextStyle()),
        ),
        const Icon(
          Icons.timer,
          color: Colors.white,
        )
      ],
    );
  }
}
