import 'dart:core';

import 'package:flutter/material.dart';
import 'package:nutrient_scanner/features/nutrient_intake_guide/model/analysis_result.dart';
import 'package:nutrient_scanner/features/nutrient_intake_guide/service/openai_service.dart';
import 'package:nutrient_scanner/features/nutrient_scan/model/recognized_text_model.dart';
import 'package:nutrient_scanner/util/error_util.dart';

part '../view/guide_view.dart';

class NutrientIntakeGuideViewModel extends StatefulWidget {
  final NutrientRecognizedText? recognizedText;
  const NutrientIntakeGuideViewModel({super.key, required this.recognizedText});

  @override
  State<NutrientIntakeGuideViewModel> createState() =>
      _NutrientIntakeGuideViewModelState();
}

class _NutrientIntakeGuideViewModelState
    extends State<NutrientIntakeGuideViewModel> {
  final OpenAIService _openAIService = OpenAIService();

  bool isLoading = false;
  bool isHalal = false;
  bool? isNotPork;
  bool? isNotAlcohol;
  bool? isNotOtherMeat;
  bool? isNotProducedWithPork;
  String answer = '';

  @override
  void initState() {
    super.initState();
    analyzeNutrientLabel();
  }

  @override
  Widget build(BuildContext context) {
    return _NutrientIntakeGuideView(
      recognizedText: widget.recognizedText?.text ?? '',
      answer: answer,
      isLoading: isLoading,
      isHalal: isHalal,
      isNotPork: isNotPork,
      isNotAlcohol: isNotAlcohol,
      isNotOtherMeat: isNotOtherMeat,
      isNotProducedWithPork: isNotProducedWithPork,
      analyzeNutrientLabel: analyzeNutrientLabel,
      showRecognizedText: () => showRecognizedText(context),
    );
  }

  void analyzeNutrientLabel() async {
    _setLoading(true);
    try {
      final result = await _fetchAnalysisResult();
      _updateAnswer(result);
    } catch (e) {
      _showError(e);
    } finally {
      _setLoading(false);
    }
  }

  void _updateAnswer(String result) {
    setState(() {
      final analysisResult = AnalysisResult.fromApiResponse(result);
      answer = analysisResult.answer;

      final parsedAnswer = _parseAnswer(answer);

      isHalal = parsedAnswer['Halal']?['value'] == false;
      isNotPork = parsedAnswer['Pork']?['value'] == false;
      isNotAlcohol = parsedAnswer['Alcohol']?['value'] == false;
      isNotOtherMeat = parsedAnswer['Other Meat']?['value'] == false;
      isNotProducedWithPork =
          parsedAnswer['Produced with Pork in the Same Facility']?['value'] ==
              false;
    });
  }

  Map<String, dynamic> _parseAnswer(String answer) {
    final Map<String, dynamic> parsedResult = {};
    final lines = answer.split('\n');
    for (final line in lines) {
      if (line.contains(':')) {
        final parts = line.split(':');
        if (parts.length < 2) continue;

        final key = parts[0].trim();
        final valueParts = parts[1].split('. 이유'); // ". 이유"로 나누도록 수정
        final valueString = valueParts[0].trim();

        // 디버깅: valueString 출력
        debugPrint('Key: $key, ValueString: $valueString');

        // true/false가 아닌 경우 null로 설정
        final boolValue = valueString == 'true'
            ? true
            : valueString == 'false'
                ? false
                : null;

        // "정보 부족"인 경우 null로 설정
        if (valueString == '정보 부족') {
          parsedResult[key] = {'value': null, 'reason': '정보 부족'};
          continue;
        }

        final reason = valueParts.length > 1 ? valueParts[1].trim() : '정보 부족';
        parsedResult[key] = {'value': boolValue, 'reason': reason};
      }
    }

    // 디버깅: 최종 파싱 결과 출력
    debugPrint('Parsed Result: $parsedResult');
    return parsedResult;
  }

  void _showError(Object error) {
    final errorMessage = ErrorUtil.formatErrorMessage(error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }

  void _setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<String> _fetchAnalysisResult() async {
    return await _openAIService.analyzeNutrientLabel(
      recognizedText: widget.recognizedText?.text ?? '',
    );
  }

  void showRecognizedText(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('OCR 데이터'),
          content: SingleChildScrollView(
            child: Text(widget.recognizedText?.text ?? ''),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}
