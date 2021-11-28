import 'package:flutter/material.dart';
import 'package:flutter_nfc/components/components.dart';
import 'package:flutter_nfc/components/nfc.dart';
import 'package:flutter_nfc/pages/homepage.dart';

class InformationNFC extends StatefulWidget {
  final NFCObject object;
  const InformationNFC({Key? key, required this.object}) : super(key: key);

  @override
  _InformationNFCState createState() => _InformationNFCState();
}

class _InformationNFCState extends State<InformationNFC> {
  NFCManager nfcManager = NFCManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: AppBarText(text: "Informations"),
        centerTitle: true,
        elevation: 0,
      ),
      body: CustomPagePadding(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H4(text: widget.object.name),
          Description(text: widget.object.informations),
          H4(text: "Photos"),
        ],
      )),
    );
  }
}
