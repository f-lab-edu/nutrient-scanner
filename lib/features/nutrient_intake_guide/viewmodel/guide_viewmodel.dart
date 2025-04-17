import 'package:flutter/material.dart';
import 'package:nutrient_scanner/features/nutrient_intake_guide/model/analysis_result.dart';
import 'package:nutrient_scanner/features/nutrient_intake_guide/service/openai_service.dart';
import 'package:nutrient_scanner/features/nutrient_scanner/model/recognized_text_model.dart';
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
  final TextEditingController _systemTextController = TextEditingController();
  final TextEditingController _userTextController = TextEditingController();
  final OpenAIService _openAIService = OpenAIService();

  bool isLoading = false;
  String answer = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nutrient Intake Guide'),
        ),
        resizeToAvoidBottomInset: true,
        body: _NutrientIntakeGuideView(
          recognizedText: widget.recognizedText?.text ?? '',
          answer: answer,
          isLoading: isLoading,
          systemTextController: _systemTextController,
          userTextController: _userTextController,
          analyzeNutrientLabel: analyzeNutrientLabel,
          showRecognizedText: () => showRecognizedText(context),
        ));
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
    });
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
      systemPrompt: _systemTextController.text,
      userPrompt: _userTextController.text,
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
