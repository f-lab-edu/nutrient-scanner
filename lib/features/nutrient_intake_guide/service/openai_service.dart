import 'package:openai_dart/openai_dart.dart';
import 'package:nutrient_scanner/config/env.dart';

class OpenAIService {
  final OpenAIClient _client;

  final systemPrompt = '''
너는 식품 성분 정보를 분석하는 전문가야. 성분 정보를 바탕으로 특정 기준에 적합한지 판단하고, 명확하고 간결한 답변을 제공해.
결과는 항상 아래 내용을 포함한 JSON으로 제공해:
- <Object>No Pork</Object>: <value>[true/false]</value> <description>[왜 돼지고기가 포함되었는지 또는 포함되지 않았는지 설명]</description>
나머지 내용도 이와 동일한 포맷으로 처리해 
- No Alcohol: [true/false]. 이유: [왜 알코올이 포함되었는지 또는 포함되지 않았는지 설명].
- No Other Meat: [true/false]. 이유: [왜 기타 고기가 포함되었는지 또는 포함되지 않았는지 설명].
- No Produced with Pork in the Same Facility: [true/false]. 이유: [왜 돼지고기를 사용하는 시설에서 생산되었는지 또는 생산되지 않았는지 설명].
- Halal: [true/false]. 이유: [왜 할랄인지 또는 아닌지 설명].

만약 필요한 정보가 부족한 항목이 있다면, 그 항목은답변에서 제외해.
''';

  final userPrompt = '''
제품 라벨의 텍스트야. 분석해서 제품이 기준에 적합한지 판단해.
''';

  OpenAIService() : _client = OpenAIClient(apiKey: Env.apiKey);

  Future<String> analyzeNutrientLabel({
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
