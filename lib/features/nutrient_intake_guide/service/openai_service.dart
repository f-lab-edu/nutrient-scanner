import 'package:openai_dart/openai_dart.dart';
import 'package:nutrient_scanner/config/env.dart';

class OpenAIService {
  final OpenAIClient _client;

  OpenAIService() : _client = OpenAIClient(apiKey: Env.apiKey);

  Future<String> analyzeNutrientLabel({
    required String systemPrompt,
    required String userPrompt,
    required String recognizedText,
  }) async {
    try {
      final res = await _client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: const ChatCompletionModel.modelId('gpt-4o'),
          messages: [
            ChatCompletionMessage.system(content: systemPrompt),
            ChatCompletionMessage.user(
              content: ChatCompletionUserMessageContent.string(
                  '$userPrompt\n성분: $recognizedText'),
            ),
          ],
          temperature: 0,
        ),
      );
      return res.choices.first.message.content.toString();
    } catch (e) {
      throw Exception('OpenAI API 호출 중 에러 발생: $e');
    }
  }
}