import 'package:aceit/models/faculty.dart';
import 'package:aceit/state/firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final facultiesProvider =
    StreamProvider.family<List<Faculty>, String?>((ref, schoolId) {
  final firestore = ref.watch(firestoreProvider);
  if (schoolId == null) return Stream.value([]);
  return firestore
      .collection('faculties')
      .where('school_id', isEqualTo: schoolId)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => Faculty.fromMap({'id': doc.id, ...doc.data()}),
            )
            .toList(),
      );
});

final selectedFacultyProvider = StateProvider<String?>((ref) => null);
