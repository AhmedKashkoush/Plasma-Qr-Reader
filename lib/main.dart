import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plasma_qr_reader/Shared/theme_helper.dart';
import 'package:plasma_qr_reader/View/Screens/scan_screen.dart';
import 'package:plasma_qr_reader/firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      debugShowCheckedModeBanner: false,
      theme: ThemeHelper.lightTheme,
      darkTheme: ThemeHelper.darkTheme,
      themeMode: ThemeHelper.themeMode,
      home: const ScanScreen(),
    );
  }
}
