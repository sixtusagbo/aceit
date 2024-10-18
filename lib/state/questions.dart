import 'package:aceit/models/course.dart';
import 'package:aceit/models/question.dart';
import 'package:aceit/state/firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final questionsProvider =
    StreamProvider.family<List<Question>, String>((ref, quizId) {
  final firestore = ref.watch(firestoreProvider);
  return firestore
      .collection('quizzes')
      .doc(quizId)
      .collection('questions')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => Question.fromMap({'id': doc.id, ...doc.data()}),
            )
            .toList(),
      );
});

final courseDetailsByQuizIdProvider =
    FutureProvider.family<Course, String>((ref, quizId) async {
  final firestore = ref.watch(firestoreProvider);
  final quizDoc = await firestore.collection('quizzes').doc(quizId).get();
  final courseId = quizDoc.data()!['course_id'] as String;
  final courseDoc = await firestore.collection('courses').doc(courseId).get();
  final course = Course.fromMap({'id': courseDoc.id, ...?courseDoc.data()});

  return course;
});
