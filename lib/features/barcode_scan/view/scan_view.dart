part of '../viewmodel/scan_viewmodel.dart';

class _BarcodeScanView extends StatelessWidget {
  final Function() onScanButtonPressed;
  const _BarcodeScanView({
    required this.onScanButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: onScanButtonPressed,
                child: Text('바코드 스캔',
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
