import 'dart:convert';
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

      isHalal = parsedAnswer['Halal']?['value'] ?? false;
      isNotPork = parsedAnswer['No Pork']?['value'];
      isNotAlcohol = parsedAnswer['No Alcohol']?['value'];
      isNotOtherMeat = parsedAnswer['No Other Meat']?['value'];
      isNotProducedWithPork =
          parsedAnswer['No Produced with Pork in the Same Facility']?['value'];
    });
  }

  Map<String, dynamic> _parseAnswer(String answer) {
    final Map<String, dynamic> parsedResult = {};

    try {
      // 문자열 앞뒤 공백 및 백틱 제거
      final cleanedAnswer =
          answer.trim().replaceAll('```json', '').replaceAll('```', '');

      final Map<String, dynamic> jsonData = jsonDecode(cleanedAnswer);

      jsonData.forEach((key, value) {
        // "정보 부족"인 경우 null로 설정
        final boolValue = value['value'] == true
            ? true
            : value['value'] == false
                ? false
                : value['value'] == '정보 부족'
                    ? null
                    : null;

        final reason = value['description'] ?? '정보 부족';

        parsedResult[key] = {'value': boolValue, 'reason': reason};
      });
    } catch (e) {
      debugPrint('JSON 파싱 에러: $e');
    }

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
    final result = await _openAIService.analyzeNutrientLabel(
      recognizedText: widget.recognizedText?.text ?? '',
    );

    return result;
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
