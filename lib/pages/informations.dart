import 'package:flutter/material.dart';
import 'package:flutter_nfc/components/components.dart';
import 'package:flutter_nfc/components/nfc.dart';
import 'package:flutter_nfc/pages/homepage.dart';
import 'package:flutter_nfc/server/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformationNFC extends StatefulWidget {
  final NFCObject object;
  const InformationNFC({Key? key, required this.object}) : super(key: key);

  @override
  _InformationNFCState createState() => _InformationNFCState();
}

class _InformationNFCState extends State<InformationNFC> {
  NFCManager nfcManager = NFCManager();
  ServerManager serverManager = ServerManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: AppBarText(text: widget.object.name),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _deleteObject(widget.object.id.toString());
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: CustomPagePadding(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H4(text: "Description"),
          Description(text: "ID : " + widget.object.id.toString()),
          //H4(text: widget.object.name),
          Description(text: widget.object.description),
          H4(text: "Photos"),
        ],
      )),
    );
  }

  _deleteObject(String id) async {
    serverManager.deleteObject(id);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listObjects = (prefs.getStringList('listObject') ?? []);

    listObjects.removeWhere((item) => item == id);

    await prefs.setStringList('listObject', listObjects);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
