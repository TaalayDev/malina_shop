import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../widgets.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  bool _isScanning = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: MobileScanner(
                onDetect: (value) {
                  if (value.barcodes.isEmpty) return;
                  if (!_isScanning) return;
                  _isScanning = false;

                  final barcode = value.barcodes.first;

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                        SnackBar(
                          content: Text('QR-код: ${barcode.rawValue}'),
                          action: SnackBarAction(
                            label: 'Скопировать',
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              Clipboard.setData(ClipboardData(
                                text: barcode.rawValue ?? '',
                              ));
                            },
                          ),
                        ),
                      )
                      .closed
                      .then((reason) {
                    _isScanning = true;
                  });
                },
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Поместите QR-код в рамку',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Builder(builder: (context) {
                    return CustomPaint(
                      painter: CornersPainter(
                        color: CornerColor.all(Colors.white),
                        width: 2,
                        lineLength: const CornerLineLength.all(35),
                      ),
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: SafeArea(
                child: Center(
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: 24,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
