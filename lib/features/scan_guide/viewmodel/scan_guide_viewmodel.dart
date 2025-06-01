import 'package:flutter/material.dart';

part '../view/scan_guide_view.dart';

class ScanGuideViewModel extends StatefulWidget {
  const ScanGuideViewModel({super.key});
  @override
  State<ScanGuideViewModel> createState() => _ScanGuideViewModelState();
}

class _ScanGuideViewModelState extends State<ScanGuideViewModel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool get _isLastPage => _currentPage == _pages.length - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      floatingActionButton: _floatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: _ScanGuideView(
        currentPage: _currentPage,
        isLastPage: _isLastPage,
        pageController: _pageController,
        pages: _pages,
        updateCurrentPage: (index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }

  final List<Map<String, String>> _pages = [
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
    _currentPage = index;
  }

  void goToNextPage() {
    if (!_isLastPage) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: const Text(
        'Guide',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A1A)),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _floatingActionButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: FloatingActionButton.extended(
        onPressed: () {
          if (_isLastPage) {
            Navigator.of(context).pop();
          } else {
            goToNextPage();
          }
        },
        label: Text(
          _isLastPage ? 'Confirm' : 'Next',
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1AC2A0),
      ),
    );
  }
}
