import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plasma_qr_reader/Constants/app_constants.dart';
import 'package:plasma_qr_reader/View/Screens/scan_result_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;
  String? code;
  bool? isFlashOn = false;

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

  Future<void> checkPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (status == PermissionStatus.granted)
      return;
    else {
      status = await Permission.camera.request();
      if (status == PermissionStatus.granted) return;
    }
    if (status != PermissionStatus.granted) showPermissionError();
  }

  void showPermissionError() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Permission Error'),
        content: const Text(
            "Cannot access the camera services please check your device's permissions"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              SystemNavigator.pop();
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final Orientation orientation = mediaQuery.orientation;
    final double top = orientation == Orientation.portrait
        ? mediaQuery.size.height * 0.25
        : mediaQuery.size.height * 0.9;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.topCenter,
        children: [
          QRView(
            key: _qrKey,
            onQRViewCreated: _onQRViewCreated,
            formatsAllowed: [BarcodeFormat.qrcode],
            onPermissionSet: (_controller, isSet) {
              if (!isSet) showPermissionError();
            },
            overlay: QrScannerOverlayShape(
              overlayColor: primaryColor.withOpacity(0.5),
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
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              color: Colors.transparent,
              clipBehavior: Clip.none,
              child: Container(
                height: mediaQuery.size.height,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () async {
                          await _controller?.flipCamera();
                        },
                        icon: Icon(
                          Icons.adaptive.flip_camera,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () async {
                          await _controller?.toggleFlash();
                          isFlashOn = await _controller?.getFlashStatus();
                          setState(() {});
                        },
                        icon: Icon(
                          !isFlashOn!
                              ? Icons.flash_on_rounded
                              : Icons.flash_off_rounded,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    //await checkPermission();
    _controller = controller;
    isFlashOn = await _controller?.getFlashStatus();
    _controller!.scannedDataStream.listen(_listener);
  }

  void _listener(Barcode? data) async {
    print(data);
    if (!mounted) return;
    //if (data == null) return;
    if (code == data!.code) return;
    code = data.code;
    HapticFeedback.vibrate();
    if (!code!.startsWith(qrSignature)) {
      //HapticFeedback.vibrate();
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'Code format is incorrect');
      await Future.delayed(const Duration(seconds: 3), () {
        code = null;
      });
      return;
    }
    // Fluttertoast.cancel();
    // Fluttertoast.showToast(msg: code!);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => ScanResultScreen(data: code!,)),
    );
    await Future.delayed(const Duration(seconds: 3), () {
      code = null;
    });
    // Navigator.of(context).pushReplacement(
    //   RightSlideTransition(
    //     page:
    //     ScanResultPage(data: _result!,),
    //   ),
    // );
  }
}
