import 'package:aceit/models/quiz_result.dart';
import 'package:aceit/state/firestore.dart';
import 'package:aceit/utils/extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final quizResultsProvider =
    StateNotifierProvider<QuizResultsNotifier, List<QuizResult>>((ref) {
  return QuizResultsNotifier(ref);
});

final quizResultProvider = Provider.family<QuizResult?, String>((ref, quizId) {
  final results = ref.watch(quizResultsProvider);

  return results.firstWhereOrNull((result) => result.quizId == quizId);
});

class QuizResultsNotifier extends StateNotifier<List<QuizResult>> {
  final Ref _ref;

  QuizResultsNotifier(this._ref) : super([]) {
    _loadQuizResults();
  }

  Future<void> _loadQuizResults() async {
    final firestore = _ref.read(firestoreProvider);
    final snapshot = await firestore.collection('results').get();
    state = snapshot.docs
        .map((doc) => QuizResult.fromMap({'id': doc.id, ...doc.data()}))
        .toList();
  }

  Future<void> saveQuizResult(QuizResult result) async {
    final firestore = _ref.read(firestoreProvider);
    final data = result.toMap();
    data.remove('id');

    if (result.id.isEmpty) {
      final docRef = await firestore.collection('results').add(data);
      final newResult = result.copyWith(id: docRef.id);
      state = [...state, newResult];
    } else {
      await firestore.collection('results').doc(result.id).update(data);
      state = [
        for (final existingResult in state)
          if (existingResult.id == result.id) result else existingResult
      ];
    }
  }
}
