import 'package:flutter/material.dart';
import 'package:nutrient_scanner/config/env.dart';
import 'package:nutrient_scanner/features/nutrient_scanner/models/recognized_text_model.dart';
import 'package:openai_dart/openai_dart.dart';

part '../views/nutrient_intake_guide_page.view.dart';

class NutrientIntakeGuidePage extends StatefulWidget {
  final NutrientRecognizedText? recognizedText;
  const NutrientIntakeGuidePage({super.key, required this.recognizedText});

  @override
  State<NutrientIntakeGuidePage> createState() =>
      _NutrientIntakeGuidePageState();
}

class _NutrientIntakeGuidePageState extends State<NutrientIntakeGuidePage> {
  final TextEditingController _systemTextController = TextEditingController();
  final TextEditingController _userTextController = TextEditingController();

  bool isLoading = false;
  String answer = '';
  // String systemPrompt =
  //     '당신은 영양사입니다. 사용자가 입력한 영양성분을 바탕으로 영양소를 분석하고, 사용자가 입력한 질문에 대한 답변을 제공합니다. 사용자가 입력한 질문은 영양소와 관련된 질문입니다. 사용자가 입력한 질문에 대한 답변을 제공하세요.';

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
    final openaiApiKey = Env.apiKey;
    final client = OpenAIClient(apiKey: openaiApiKey);
    setState(() {
      isLoading = true;
    });
    try {
      final res = await client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: const ChatCompletionModel.modelId('gpt-4o'),
          messages: [
            ChatCompletionMessage.system(
              content: _systemTextController.text,
            ),
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.string(
                  '${_userTextController.text}\n성분: ${widget.recognizedText?.text}'),
            ),
          ],
          temperature: 0,
        ),
      );
      setState(() {
        answer = res.choices.first.message.content.toString();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('에러 발생: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
