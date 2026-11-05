import 'package:flutter_test/flutter_test.dart';
import 'package:daily_you/services/pronunciation_assessment_service.dart';

void main() {
  group('PronunciationAssessmentService Tests', () {
    test('Empty recognized text (silence / no speech) returns 0 score', () {
      final result = PronunciationAssessmentService.assess(
        userId: 1,
        targetSentence: 'Hello, nice to meet you!',
        recognizedText: '',
      );

      expect(result.overallScore, 0.0);
      expect(result.mispronouncedWords!.length, 5);
      expect(result.wordScores!.every((w) => w.score == 0.0), isTrue);
      expect(result.feedback!.contains('Chưa phát hiện giọng nói'), isTrue);
    });

    test('Partial speech returns proportional score and marks missing words', () {
      final result = PronunciationAssessmentService.assess(
        userId: 1,
        targetSentence: 'Hello, nice to meet you!',
        recognizedText: 'Hello',
      );

      // 1 out of 5 words matches => 20%
      expect(result.overallScore, 20.0);
      expect(result.wordScores!.first.word, 'hello');
      expect(result.wordScores!.first.score, 100.0);
      expect(result.mispronouncedWords!.length, 4);
    });

    test('Mispronounced words get lower similarity scores', () {
      final result = PronunciationAssessmentService.assess(
        userId: 1,
        targetSentence: 'Good morning',
        recognizedText: 'Gud moring',
      );

      expect(result.overallScore, greaterThan(0.0));
      expect(result.overallScore, lessThan(100.0));
    });

    test('Exact match returns 100 score', () {
      final result = PronunciationAssessmentService.assess(
        userId: 1,
        targetSentence: 'Good morning, how are you today?',
        recognizedText: 'Good morning, how are you today?',
      );

      expect(result.overallScore, 100.0);
      expect(result.mispronouncedWords, isEmpty);
    });
  });
}
