part of 'nutrient_label_scanner_page.dart';

class _NutrientLabelScannerView extends StatelessWidget {
  final NutrientRecognizedText? recognizedText;
  final bool isLoading;
  final Function(ImageSource imageSource) getImage;
  const _NutrientLabelScannerView({
    required this.recognizedText,
    required this.isLoading,
    required this.getImage,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () => getImage(ImageSource.camera),
                        child: Text('Camera',
                            style: Theme.of(context).textTheme.headlineMedium)),
                    ElevatedButton(
                        onPressed: () => getImage(ImageSource.gallery),
                        child: Text('Gallery',
                            style: Theme.of(context).textTheme.headlineMedium)),
                  ],
                ),
                recognizedText?.text != '' && recognizedText?.text != null
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NutrientIntakeGuidePage(
                                  recognizedText: recognizedText),
                            ),
                          );
                        },
                        child: Text('GPT한테 물어보러 가기',
                            style: Theme.of(context).textTheme.headlineMedium),
                      )
                    : const SizedBox(),
                Text(
                  'OCR 결과:\n${recognizedText?.text ?? '인식된 텍스트가 없습니다.'}',
                ),
              ],
            ),
          );
  }
}
