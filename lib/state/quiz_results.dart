import 'package:aceit/models/quiz_result.dart';
import 'package:aceit/state/auth.dart';
import 'package:aceit/state/courses.dart';
import 'package:aceit/state/firestore.dart';
import 'package:aceit/utils/extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final quizResultsStreamProvider = StreamProvider<List<QuizResult>>((ref) {
  final userId = ref.watch(userIdProvider);
  final firestore = ref.watch(firestoreProvider);
  return firestore
      .collection('results')
      .where('user_id', isEqualTo: userId)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => QuizResult.fromMap({'id': doc.id, ...doc.data()}))
          .toList());
});

final quizResultProvider = Provider.family<QuizResult?, String>((ref, quizId) {
  final resultsAsyncValue = ref.watch(quizResultsStreamProvider);
  final userId = ref.watch(userIdProvider);
  return resultsAsyncValue
      .whenData((results) => results.firstWhereOrNull(
            (result) =>
                result.quizId == quizId &&
                result.userId == userId &&
                result.inProgress,
          ))
      .value;
});

/// Provider that returns the list of quiz results that are in progress
/// for the current user, it returns the course information as well.
final inProgressQuizProvider = StreamProvider<List<QuizResult>>((ref) {
  final userId = ref.watch(userIdProvider);
  final firestore = ref.watch(firestoreProvider);

  return firestore
      .collection('results')
      .where('user_id', isEqualTo: userId)
      .where('in_progress', isEqualTo: true)
      .snapshots()
      .asyncMap((snapshot) async {
    final results = snapshot.docs
        .map((doc) => QuizResult.fromMap({'id': doc.id, ...doc.data()}))
        .toList();

    for (var result in results) {
      final course =
          await ref.read(courseDetailsByQuizIdProvider(result.quizId).future);
      result.course = course;
    }

    return results;
  });
});

/// Returns current quiz progress with result id if any or null otherwise
final currentQuizProgressProvider =
    Provider.family<QuizResult?, String>((ref, resultId) {
  final userId = ref.watch(userIdProvider);
  final resultsAsyncValue = ref.watch(quizResultsStreamProvider);
  return resultsAsyncValue
      .whenData((results) => results.firstWhereOrNull(
            (r) => r.userId == userId && r.id == resultId,
          ))
      .value;
});

/// Provider to load a quiz result by its ID
final quizResultByIdProvider = FutureProvider.family<QuizResult?, String>(
  (ref, resultId) async {
    if (resultId.isEmpty) return null;
    final firestore = ref.watch(firestoreProvider);
    final doc = await firestore.collection('results').doc(resultId).get();
    if (!doc.exists) return null;
    return QuizResult.fromMap({'id': doc.id, ...doc.data()!});
  },
);

final saveQuizResultProvider =
    FutureProvider.autoDispose.family<QuizResult, QuizResult>(
  (ref, result) async {
    final firestore = ref.watch(firestoreProvider);
    final data = result.toMap();

    if (result.id.isEmpty) {
      data.remove('id');
      final docRef = await firestore.collection('results').add(data);
      return QuizResult.fromMap({'id': docRef.id, ...data});
    } else {
      data.remove('date'); // don't update the date
      await firestore.collection('results').doc(result.id).update(data);
      return result;
    }
  },
);
