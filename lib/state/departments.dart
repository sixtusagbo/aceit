import 'package:aceit/models/department.dart';
import 'package:aceit/state/firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final departmentsProvider =
    StreamProvider.family<List<Department>, String?>((ref, facultyId) {
  final firestore = ref.watch(firestoreProvider);
  if (facultyId == null) return Stream.value([]);
  return firestore
      .collection('departments')
      .where('faculty_id', isEqualTo: facultyId)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => Department.fromMap({'id': doc.id, ...doc.data()}),
            )
            .toList(),
      );
});

final selectedDepartmentProvider = StateProvider<String?>((ref) => null);
