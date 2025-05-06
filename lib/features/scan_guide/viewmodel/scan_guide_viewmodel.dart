import 'package:flutter/material.dart';

part '../view/scan_guide_view.dart';

class ScanGuideViewModel extends StatelessWidget {
  final PageController pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return const _ScanGuideView();
  }

  final List<Map<String, String>> pages = [
    {
      'description':
          'For pouch items, please flatten and show the text on the back',
      'imagePath': 'assets/images/tutorial_1.png',
    },
    {
      'description':
          'For cylinder items, please take a photo showing the text clearly.',
      'imagePath': 'assets/images/tutorial_2.png',
    },
    {
      'description':
          'For bottled(can) items, please take a photo of the side of the bottle.',
      'imagePath': 'assets/images/tutorial_3.png',
    },
  ];

  void updateCurrentPage(int index) {
    currentPage = index;
  }

  bool get isLastPage => currentPage == pages.length - 1;

  void goToNextPage() {
    if (!isLastPage) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
