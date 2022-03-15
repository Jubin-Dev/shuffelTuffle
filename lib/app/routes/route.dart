import 'package:flutter/material.dart';
import 'package:shuffle_tuffle/app/views/home.dart';
import 'package:shuffle_tuffle/app/views/puzzle_view.dart';

const String homeRoute = "home";
const String puzzleRoute = "puzzle";

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case puzzleRoute:
      return MaterialPageRoute(builder: (_) => const PuzzleView());
    case homeRoute:
    default:
      return MaterialPageRoute(builder: (_) => const Home());
  }
}
