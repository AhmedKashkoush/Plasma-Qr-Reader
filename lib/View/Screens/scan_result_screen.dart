import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plasma_qr_reader/Constants/app_constants.dart';
import 'package:plasma_qr_reader/View/Screens/scan_screen.dart';

class ScanResultScreen extends StatelessWidget {
  final String data;

  const ScanResultScreen({Key? key, required this.data}) : super(key: key);

  Future<Map<String, dynamic>> getUserData() async {
    String decodedData = data.replaceAll(qrSignature, '').split(';')[1];
    final FirebaseFirestore _store = FirebaseFirestore.instance;
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _store.collection('users').get();
    List<Map<String, dynamic>> userList =
        querySnapshot.docs.map((doc) => doc.data()).toList();
    List<Map<String, dynamic>> userData =
        userList.where((doc) => doc['national_id'] == decodedData).toList();
    return userData.first;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ScanScreen(),
          ),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ScanScreen(),
              ),
            ),
          ),
        ),
        backgroundColor: isDark ? primaryDarkColor : primaryColor,
        extendBodyBehindAppBar: true,
        body: FutureBuilder<Map<String, dynamic>>(
          future: getUserData(),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            Map<String, dynamic>? data = snapshot.data;
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    right: 8,
                    left: 8,
                    bottom: 8,
                    top: 30,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : snapshot.hasError
                          ? const Center(
                              child: Icon(Icons.warning_amber_rounded),
                            )
                          : !snapshot.hasData
                              ? const Center()
                              : Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundColor: isDark
                                          ? primaryDarkColor
                                          : primaryColor,
                                      foregroundImage: data!['image'] == ""
                                          ? null
                                          : CachedNetworkImageProvider(
                                              data['image'],
                                              cacheKey: data['image']),
                                      child: Icon(
                                        Icons.person,
                                        size: 64,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: Text(
                                          '${data['first_name']} ${data['last_name']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '${data['email']}',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: snapshot.connectionState == ConnectionState.waiting
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : snapshot.hasError
                            ? const Center(
                                child: Text(
                                  'Something went wrong',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            : !snapshot.hasData
                                ? const Center(
                                    child: Text(
                                      'Nothing to show',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  )
                                : ListView(
                                    padding: const EdgeInsets.all(18),
                                    children: [
                                      ListTile(
                                        title: Text('Phone'),
                                        subtitle: Text('${data!['phone']}'),
                                        leading: Icon(Icons.phone),
                                      ),
                                      ListTile(
                                        title: Text('National ID'),
                                        subtitle:
                                            Text('${data['national_id']}'),
                                        leading:
                                            Icon(Icons.perm_identity_rounded),
                                      ),
                                      ListTile(
                                        title: Text('Gender'),
                                        leading: Icon(Icons.male),
                                        //leading: Icon(Icons.gen),
                                      ),
                                      if (data['blood_type'] != "")
                                        ListTile(
                                          title: Text('Blood Type'),
                                          subtitle: Text('O+'),
                                          leading: Icon(Icons.bloodtype),
                                        ),
                                    ],
                                  ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
