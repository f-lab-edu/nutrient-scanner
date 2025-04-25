import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutrient_scanner/features/nutrient_intake_guide/model/analysis_result.dart';
import 'package:nutrient_scanner/features/nutrient_intake_guide/viewmodel/analysis_result_view_model.dart';

void main() {
  group('AnalysisResultViewModel', () {
    late AnalysisResultViewModel viewModel;

    setUp(() {
      SharedPreferences.setMockInitialValues({}); // 초기화
      viewModel = AnalysisResultViewModel();
    });

    test('캐싱된 데이터를 저장하고 불러올 수 있다.', () async {
      final result = AnalysisResult('Test Answer');

      // 캐싱 저장
      await viewModel.saveToCache(result);

      // 캐싱 불러오기
      final cachedResult = await viewModel.loadFromCache();

      expect(cachedResult, isNotNull);
      expect(cachedResult!.answer, equals('Test Answer'));
    });

    test('캐싱된 데이터가 만료되면 null을 반환한다.', () async {
      final result = AnalysisResult('Expired Answer');

      // 캐싱 저장
      await viewModel.saveToCache(result);

      // 만료 날짜를 강제로 과거로 설정
      final prefs = await SharedPreferences.getInstance();
      final expiredDate = DateTime.now().subtract(const Duration(days: 1)).toIso8601String();
      await prefs.setString('analysis_result_answer_expiry', expiredDate);

      // 캐싱 불러오기
      final cachedResult = await viewModel.loadFromCache();

      expect(cachedResult, isNull);
    });
  });
}