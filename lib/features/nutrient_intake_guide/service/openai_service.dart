import 'package:openai_dart/openai_dart.dart';
import 'package:nutrient_scanner/config/env.dart';

class OpenAIService {
  final OpenAIClient _client;

  final systemPrompt = '''
너는 식품 성분 정보를 분석하는 전문가야. 성분 정보를 바탕으로 특정 기준에 적합한지 판단하고, 명확하고 간결한 답변을 제공해.
결과는 아래의 네 가지 기준에 따라 판단해:
1. 돼지고기가 포함되었는지(Pork)
2. 알코올이 포함되었는지(Alcohol)
3. 기타 고기(소고기, 닭고기 등)가 포함되었는지(Other Meat), 쇠고기나 닭고기 혼입가능 이런 문구는 포함된 것으로 간주함
4. 돼지고기를 사용하는 시설에서 생산되었는지(Produced with Pork in the Same Facility)
5. 위 1~4에 의거한 할랄 여부(Halal)
결과는 항상 아래 형식으로 제공해:
- Pork: [true/false]. 이유: [왜 돼지고기가 포함되었는지 또는 포함되지 않았는지 설명].
- Alcohol: [true/false]. 이유: [왜 알코올이 포함되었는지 또는 포함되지 않았는지 설명].
- Other Meat: [true/false]. 이유: [왜 기타 고기가 포함되었는지 또는 포함되지 않았는지 설명].
- Produced with Pork in the Same Facility: [true/false]. 이유: [왜 돼지고기를 사용하는 시설에서 생산되었는지 또는 생산되지 않았는지 설명].
- Halal: [true/false]. 이유: [왜 할랄인지 또는 아닌지 설명].

만약 필요한 정보가 부족하다면, 해당 항목에 대해 "정보 부족"이라고 명시해.
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
