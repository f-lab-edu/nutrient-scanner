part of '../viewmodel/guide_viewmodel.dart';

class _NutrientIntakeGuideView extends StatelessWidget {
  final String recognizedText;
  final bool isLoading;
  final String answer;
  final TextEditingController systemTextController;
  final TextEditingController userTextController;
  final Function() analyzeNutrientLabel;
  final Function() showRecognizedText;
  const _NutrientIntakeGuideView({
    required this.recognizedText,
    required this.answer,
    required this.isLoading,
    required this.systemTextController,
    required this.userTextController,
    required this.analyzeNutrientLabel,
    required this.showRecognizedText,
  });

  ///TODO:: 프롬프트 입력 받는 부분은 추후에 제거하고, 고정된 프롬프트로 변경할 예정
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: showRecognizedText,
                  child: const Text('OCR 데이터 확인하기'),
                ),
                TextField(
                  controller: systemTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'GPT 역할 입력...',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: userTextController,
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
    );
  }
}
