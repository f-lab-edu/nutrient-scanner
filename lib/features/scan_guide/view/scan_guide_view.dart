part of '../viewmodel/scan_guide_viewmodel.dart';

class _ScanGuideView extends StatefulWidget {
  final int currentPage;
  final bool isLastPage;
  final PageController pageController;
  final List<Map<String, String>> pages;
  final Function(int) updateCurrentPage;
  const _ScanGuideView({
    required this.currentPage,
    required this.isLastPage,
    required this.pageController,
    required this.pages,
    required this.updateCurrentPage,
  });

  @override
  State<_ScanGuideView> createState() => _ScanGuideViewState();
}

class _ScanGuideViewState extends State<_ScanGuideView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: widget.pageController,
            onPageChanged: (index) {
              setState(() {
                widget.updateCurrentPage(index);
              });
            },
            children: widget.pages.map((page) {
              return _buildPage(
                description: page['description']!,
                imagePath: page['imagePath']!,
              );
            }).toList(),
          ),
        ),
        _buildPageIndicator(),
        const SizedBox(height: 92),
      ],
    );
  }

  Widget _buildPage({
    required String description,
    required String imagePath,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 48),
            child: Text(
              description,
              style: const TextStyle(
                  fontSize: 22,
                  color: Color(0xFF1A1A1A),
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          Image.asset(imagePath, height: 260, width: 260),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: widget.currentPage == index ? 12 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: widget.currentPage == index ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
