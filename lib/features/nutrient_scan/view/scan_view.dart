part of '../viewmodel/scan_viewmodel.dart';

class _NutrientLabelScanView extends StatelessWidget {
  final NutrientRecognizedText? recognizedText;
  final bool isLoading;
  final Function() navigateToGuidePage;
  const _NutrientLabelScanView({
    required this.recognizedText,
    required this.isLoading,
    required this.navigateToGuidePage,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/ai.png',
                  width: 54,
                  height: 54,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Not in our list.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                ),
                const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(
                      'Let AI take a look?',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    )),
                const SizedBox(height: 32),
                Image.asset(
                  'assets/images/scan_exam.png',
                  width: 270,
                  height: 270,
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: navigateToGuidePage,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDFAF7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Image.asset(
                                'assets/icons/question.png',
                                width: 20,
                                height: 20,
                              ),
                            ),
                            const Text(
                              'Product Photo Guide',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF8D8D8D)),
                            )
                          ],
                        ),
                        Image.asset(
                          'assets/icons/right_arrow.png',
                          width: 24,
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
