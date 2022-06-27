import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_qr_reader/Constants/app_constants.dart';

class ScanResultScreen extends StatelessWidget {
  const ScanResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: isDark?primaryDarkColor:primaryColor,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: iconDarkColor,
                    child: Icon(
                      Icons.person,
                      size: 64,
                      color: primaryColor,
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text(
                        'Username',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
                      ),
                      subtitle: const Text('email',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
              )),
        ],
      ),
    );
  }
}
