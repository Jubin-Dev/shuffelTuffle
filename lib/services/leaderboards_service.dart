import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shuffle_tuffle/models/leaderboard_entry.dart';


class LeaderboardsService {
  static CollectionReference get instance => FirebaseFirestore.instance
      .collection('leaderboards')
      .withConverter<LeaderboardEntry>(
          fromFirestore: (snapshot, _) =>
              LeaderboardEntry.fromJson(snapshot.data()!),
          toFirestore: (entry, _) => entry.toJson());
}
