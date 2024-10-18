import 'package:aceit/models/quiz.dart';
import 'package:aceit/state/firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final quizProvider = StreamProvider.family<Quiz?, String>((ref, quizId) {
  final firestore = ref.watch(firestoreProvider);
  return firestore.collection('quizzes').doc(quizId).snapshots().map(
        (doc) =>
            doc.exists ? Quiz.fromMap({'id': doc.id, ...doc.data()!}) : null,
      );
});

final quizIdByCourseProvider =
    FutureProvider.family<String?, String>((ref, courseId) async {
  final firestore = ref.watch(firestoreProvider);
  final snapshot = await firestore
      .collection('quizzes')
      .where('course_id', isEqualTo: courseId)
      .get();
  if (snapshot.docs.isEmpty) return null;
  return snapshot.docs.first.id;
});
