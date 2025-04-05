import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nutrient_scanner/env.dart';
import 'package:openai_dart/openai_dart.dart';

class NutrientIntakeGuidePage extends StatefulWidget {
  final String recognizedText;
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

  ///TODO:: 프롬프트 입력 받는 부분은 추후에 제거하고, 고정된 프롬프트로 변경할 예정
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrient Intake Guide'),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => showRecognizedText(context),
                    child: const Text('OCR 데이터 확인하기'),
                  ),
                  TextField(
                    controller: _systemTextController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'GPT 역할 입력...',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _userTextController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'GPT에게 어떻게 물어볼지 입력...',
                    ),
                  ),
                  ElevatedButton(
                      onPressed: analyzeNutrientLabel,
                      child: const Text('OCR데이터와 함께 GPT에게 물어보기')),
                  answer != ''
                      ? Container(
                          padding: const EdgeInsets.all(16.0),
                          margin: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          height: 450,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: SingleChildScrollView(
                            child: Text(
                              'GPT의 답변:\n$answer',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
      ),
    );
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
                  '$_userTextController.text + 성분: ${widget.recognizedText}'),
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
            child: Text(widget.recognizedText),
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
