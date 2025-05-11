part of '../viewmodel/guide_viewmodel.dart';

class _NutrientIntakeGuideView extends StatelessWidget {
  final String recognizedText;
  final bool isLoading;
  final bool isHalal;
  final bool? isNotPork;
  final bool? isNotAlcohol;
  final bool? isNotOtherMeat;
  final bool? isNotProducedWithPork;
  final String answer;
  final Function() analyzeNutrientLabel;
  const _NutrientIntakeGuideView({
    required this.recognizedText,
    required this.answer,
    required this.isLoading,
    required this.isHalal,
    this.isNotPork,
    this.isNotAlcohol,
    this.isNotOtherMeat,
    this.isNotProducedWithPork,
    required this.analyzeNutrientLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Analyze',
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
      backgroundColor:
          isHalal ? const Color(0xFFEDFAF7) : const Color(0xFFFFF4F4),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                _buildSimpleGuide(context, isHalal),
                _buildDetailGuide(context, isHalal),
                Container(
                  width: double.infinity,
                  height: 6,
                  color: const Color(0xFFF1F1F1),
                ),
                _buildIngredients(context),
              ],
            ),
    );
  }

  Widget _buildSimpleGuide(BuildContext context, bool isHalal) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 186,
          width: double.infinity,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  isHalal
                      ? 'assets/images/check.png'
                      : 'assets/images/caution.png',
                  width: 54,
                  height: 54,
                ),
                const SizedBox(height: 7),
                Text(
                  isHalal
                      ? 'Haram Ingredients not in lncluded'
                      : 'Haram Ingredients included',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isHalal
                          ? const Color(0xFF219981)
                          : const Color(0xFFE44C4C)),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDetailGuide(BuildContext context, bool isHalal) {
    return Container(
      width: double.infinity,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, -4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              width: double.infinity,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                shadows: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 8,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildSummary(context)],
              ),
            ),
            const SizedBox(height: 48),
            Container(
              height: 50,
              width: double.infinity,
              color: Colors.blue,
              child: const Center(
                child: Text('banner'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    final safeItems = [
      if (isNotPork == true)
        {'icon': 'assets/icons/caution_fill.png', 'label': 'No Pork'},
      if (isNotAlcohol == true)
        {'icon': 'assets/icons/drink.png', 'label': 'No Alcohol'},
      if (isNotOtherMeat == true)
        {
          'icon': 'assets/icons/food.png',
          'label': 'No Other meat (Beef or Chicken)'
        },
      if (isNotProducedWithPork == true)
        {
          'icon': 'assets/icons/factory.png',
          'label': 'Not produced with Pork in the same facility'
        },
    ];

    final cautionItems = [
      if (isNotPork == false)
        {'icon': 'assets/icons/caution_fill.png', 'label': 'Pork in it'},
      if (isNotAlcohol == false)
        {'icon': 'assets/icons/drink.png', 'label': 'Alcohol in it'},
      if (isNotOtherMeat == false)
        {
          'icon': 'assets/icons/food.png',
          'label': 'Other meat (Beef or Chicken) in it'
        },
      if (isNotProducedWithPork == false)
        {
          'icon': 'assets/icons/factory.png',
          'label': 'Produced with Pork in the same facility'
        },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (safeItems.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEDFAF7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Safe',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1AC2A0)),
            ),
          ),
          const SizedBox(height: 16),
          ...safeItems.map((item) => _buildSummaryItem(
                context,
                icon: item['icon'] as String,
                label: item['label'] as String,
              )),
        ],
        if (safeItems.isNotEmpty && cautionItems.isNotEmpty) ...[
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            width: double.infinity,
            height: 1,
            color: const Color(0xFFF1F1F1),
          ),
        ],
        if (cautionItems.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4F4),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Caution',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFE44C4C)),
            ),
          ),
          const SizedBox(height: 16),
          ...cautionItems.map((item) => _buildSummaryItem(
                context,
                icon: item['icon'] as String,
                label: item['label'] as String,
              )),
        ],
      ],
    );
  }

  Widget _buildSummaryItem(
    BuildContext context, {
    required String icon,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(icon, width: 24, height: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF505050),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredients(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Analyzed Ingredients',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A)),
          ),
          const SizedBox(height: 16),
          Text(recognizedText,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF505050))),
          const SizedBox(height: 32),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              width: double.infinity,
              decoration: ShapeDecoration(
                color: const Color(0xFFF5F5F5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/icons/caution.png',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('∙ ',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF8D8D8D))),
                            Expanded(
                              child: Text(
                                  'This result is based on AI analysis.',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF8D8D8D))),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('∙ ',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF8D8D8D))),
                            Expanded(
                              child: Text(
                                  'Consumption of this product is at your own discretion.',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF8D8D8D))),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
