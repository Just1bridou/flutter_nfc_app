import 'package:flutter/material.dart';
import 'package:flutter_nfc/components/components.dart';
import 'package:flutter_nfc/components/nfc.dart';
import 'package:flutter_nfc/pages/homepage.dart';
import 'package:flutter_nfc/pages/informations.dart';

class ReadNFC extends StatefulWidget {
  const ReadNFC({Key? key}) : super(key: key);

  @override
  _ReadNFCState createState() => _ReadNFCState();
}

class _ReadNFCState extends State<ReadNFC> {
  NFCManager nfcManager = NFCManager();

  @override
  Widget build(BuildContext context) {
    nfcManager.read(context, (object) {
      if (object != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InformationNFC(
                    object: object,
                  )),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: AppBarText(text: "Scanner"),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                ).then((_) {
                  setState(() {});
                });
              });
            },
          )),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
              width: 250,
              //height: 150,
              child: Image.asset('assets/images/nfc_illu_1.png')),
          Padding(
              padding: EdgeInsets.only(top: 20),
              child: Description(
                text: "Approcher un tag NFC pour voir ses informations",
                align: TextAlign.center,
              )),
        ],
      )),
    );
  }
}
