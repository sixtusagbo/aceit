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
