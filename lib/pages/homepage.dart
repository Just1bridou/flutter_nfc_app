import 'package:flutter/material.dart';
import 'package:flutter_nfc/components/components.dart';
import 'package:flutter_nfc/pages/add_object.dart';
import 'package:flutter_nfc/pages/save_in_nfc.dart';
import 'package:flutter_nfc/pages/scan.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTitle(
              text: "MyApp",
            ),
            CustomButton(
                text: "Scanner un objet",
                background: Colors.black87,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReadNFC()),
                  );
                })
          ],
        ),
      ),
      body: CustomPagePadding(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: H3(text: "Mes objets"),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: CustomButton(
            text: "Ajouter un objet",
            background: Colors.black87,
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddObject()),
              );
            }),
      ),
    );
  }
}
