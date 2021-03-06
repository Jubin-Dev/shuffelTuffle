import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shuffle_tuffle/interfaces/tile.dart';
import 'package:shuffle_tuffle/reducers/puzzle_reducer.dart';
import 'package:shuffle_tuffle/services/puzzle_service.dart';
import 'package:shuffle_tuffle/states/puzzle_state.dart';
import 'package:shuffle_tuffle/styles/colors.dart';
import 'package:shuffle_tuffle/widgets/rive_animation.dart';

class TileWidget extends StatefulWidget {
  const TileWidget({Key? key, required this.tile}) : super(key: key);
  final Tile tile;
  @override
  _TileWidgetState createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget> {
  late AssetsAudioPlayer moveTileSound;

  double calculateAlignment(int valueOnAxis) {
    final gap = valueOnAxis != 0 ? valueOnAxis / 100 : 0;
    final initialPosition = ((valueOnAxis + 0.5) / 4);
    return initialPosition + gap;
  }

  @override
  void initState() {
    moveTileSound = AssetsAudioPlayer.withId("slide-sound-effect");
    moveTileSound.open(Audio.file("assets/sounds/effects/slide.wav"),
        autoStart: false, loopMode: LoopMode.none);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tile = widget.tile;
    final state = StoreProvider.of<PuzzleState>(context).state;
    final tileSize = state.tileSize;
    final gameStatus = state.gameStatus;
    final sound = state.sound;

    return AnimatedAlign(
        duration: const Duration(milliseconds: 300),
        alignment: FractionalOffset(calculateAlignment(tile.currentPosition.x),
            calculateAlignment(tile.currentPosition.y)),
        child: MouseRegion(
          cursor: gameStatus == GameStatus.playing
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: GestureDetector(
              onTap: () {
                if (gameStatus != GameStatus.playing) {
                  return;
                }

                if (sound) {
                  moveTileSound.play();
                }

                StoreProvider.of<PuzzleState>(context).dispatch(
                    PuzzleAction(type: PuzzleActions.moveTile, payload: tile));
              },
              child: Container(
                  key: Key("tile-animated-container-${tile.number}"),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: ThemeColors.darkBlue.withOpacity(0.6),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 2),
                        )
                      ]),
                  width: tileSize,
                  height: tileSize,
                  child: RiveAnimationWidget(
                    key: Key("tile-rive-animation-${tile.number}"),
                    tile: tile,
                  ))),
        ));
  }
}
