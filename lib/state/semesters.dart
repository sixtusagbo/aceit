import 'package:aceit/models/semester.dart';
import 'package:aceit/state/firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final semestersProvider = StreamProvider<List<Semester>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore.collection('semesters').snapshots().map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => Semester.fromMap({'id': doc.id, ...doc.data()}),
            )
            .toList(),
      );
});

final selectedSemesterProvider = StateProvider<String?>((ref) => null);
