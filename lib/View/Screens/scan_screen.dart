import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plasma_qr_reader/Constants/app_constants.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    if (Platform.isAndroid) {
      _controller!.pauseCamera();
    } else if (Platform.isIOS) {
      _controller!.resumeCamera();
    }
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    final double top = MediaQuery.of(context).size.height * 0.25;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.topCenter,
        children: [
          QRView(
            key: _qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              overlayColor: Colors.black87,
              borderWidth: 6,
              borderColor: primaryColor,
              borderRadius: 14,
            ),
          ),
          Positioned(
            top: top,
            child: const Text(
              'Place the code inside to scan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    _controller = controller;
    _controller!.scannedDataStream.listen(_listener);
  }

  void _listener(Barcode data) {
    if (!mounted) return;
    if (!data.code!.startsWith(qrSignature)){
      HapticFeedback.vibrate();
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Code format is incorrect');
      return;
    }
    HapticFeedback.vibrate();
    Fluttertoast.cancel();
    Fluttertoast.showToast(msg: data.code!);
    // Navigator.of(context).pushReplacement(
    //   RightSlideTransition(
    //     page:
    //     ScanResultPage(data: _result!,),
    //   ),
    // );
  }
}
