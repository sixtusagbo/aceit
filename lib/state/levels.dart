import 'package:aceit/models/level.dart';
import 'package:aceit/state/firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final levelsProvider = StreamProvider<List<Level>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore.collection('levels').snapshots().map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => Level.fromMap({'id': doc.id, ...doc.data()}),
            )
            .toList(),
      );
});

final selectedLevelProvider = StateProvider<String?>((ref) => null);
