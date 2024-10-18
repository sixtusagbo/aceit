import 'package:aceit/models/school.dart';
import 'package:aceit/state/firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final schoolsProvider = StreamProvider<List<School>>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return firestore.collection('schools').snapshots().map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => School.fromMap({'id': doc.id, ...doc.data()}),
            )
            .toList(),
      );
});

final selectedSchoolProvider = StateProvider<String?>((ref) => null);
