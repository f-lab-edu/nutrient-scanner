part of '../viewmodel/scan_guide_viewmodel.dart';

class _ScanGuideView extends StatefulWidget {
  const _ScanGuideView();

  @override
  State<_ScanGuideView> createState() => _ScanGuideViewState();
}

class _ScanGuideViewState extends State<_ScanGuideView> {
  late final ScanGuideViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ScanGuideViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _viewModel.pageController,
              onPageChanged: (index) {
                setState(() {
                  _viewModel.updateCurrentPage(index);
                });
              },
              children: _viewModel.pages.map((page) {
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
      ),
      floatingActionButton: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: FloatingActionButton.extended(
          onPressed: () {
            if (_viewModel.isLastPage) {
              Navigator.of(context).pop();
            } else {
              _viewModel.goToNextPage();
            }
          },
          label: Text(
            _viewModel.isLastPage ? '확인' : '다음',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF1AC2A0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildPage({
    required String description,
    required String imagePath,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
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
        _viewModel.pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _viewModel.currentPage == index ? 12 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _viewModel.currentPage == index ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
