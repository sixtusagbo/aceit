import 'package:aceit/models/course.dart';
import 'package:aceit/state/firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final coursesProvider = StreamProvider.family<
    List<Course>,
    ({
      String? departmentId,
      String? levelId,
      String? semesterId
    })>((ref, params) {
  final firestore = ref.watch(firestoreProvider);
  if (params.departmentId == null || params.levelId == null) {
    return Stream.value([]);
  }
  var query = firestore
      .collection('courses')
      .where('department_id', isEqualTo: params.departmentId)
      .where('level_id', isEqualTo: params.levelId);
  if (params.semesterId != null) {
    query = query.where('semester_id', isEqualTo: params.semesterId);
  }
  return query.snapshots().map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => Course.fromMap({'id': doc.id, ...doc.data()}),
            )
            .toList(),
      );
});

final selectedCourseProvider = StateProvider<String?>((ref) => null);
