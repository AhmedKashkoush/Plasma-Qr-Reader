import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plasma_qr_reader/Shared/theme_helper.dart';
import 'package:plasma_qr_reader/View/Screens/scan_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(overlayStyle);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plasma QR Reader',
      theme: ThemeHelper.lightTheme,
      darkTheme: ThemeHelper.darkTheme,
      themeMode: ThemeHelper.themeMode,
      home: const ScanScreen(),
    );
  }
}
