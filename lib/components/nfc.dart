import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_nfc/components/components.dart';
import 'package:flutter_nfc/server/server.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class NFCObject {
  int id;
  String name;
  String description;
  String password;
  String photo_url;

  NFCObject(
      {Key? key,
      required this.id,
      required this.name,
      required this.description,
      required this.password,
      required this.photo_url});

  factory NFCObject.fromJson(Map<dynamic, dynamic> json) {
    return NFCObject(
      id: json["id"],
      name: json['name'],
      description: json['description'],
      photo_url: json['photo_url'] ?? "path",
      password: json['password'],
    );
  }
}

class PayloadNFCObject {
  String name;
  String description;
  String password;
  String photo_url;

  PayloadNFCObject(
      {Key? key,
      required this.name,
      required this.description,
      required this.password,
      required this.photo_url});
}

class NFCManager {
  ServerManager serverManager = ServerManager();

  void write(BuildContext context, PayloadNFCObject object,
      VoidCallback callback) async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (!checkAvailability(isAvailable)) {
      return;
    }

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        Ndef? isNdef = Ndef.from(tag);

        if (!checkNdef(isNdef)) {
          return;
        }

        Ndef ndef = isNdef!;

        int createdObjectID = await serverManager.createObject(object);

        Uint8List bytesData =
            Uint8List.fromList(utf8.encode(createdObjectID.toString()));

        if (ndef.isWritable) {
          ndef.write(new NdefMessage(
              [NdefRecord.createMime("text/plain", bytesData)]));

          NfcManager.instance.stopSession();

          SharedPreferences prefs = await SharedPreferences.getInstance();
          List<String> listObjects = (prefs.getStringList('listObject') ?? []);
          listObjects.add(createdObjectID.toString());
          await prefs.setStringList('listObject', listObjects);

          callback();
        } else {
          NfcManager.instance.stopSession();
          print("cant write on tag");
        }
      },
    );
  }

  void read(Function(NFCObject?) callback) async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (!checkAvailability(isAvailable)) {
      return;
    }

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        Ndef? isNdef = Ndef.from(tag);

        if (!checkNdef(isNdef)) {
          return;
        }

        Ndef ndef = isNdef!;

        NdefMessage readData = await ndef.read();

        var uuid = getNfcDatas(readData.records[0]);

        NfcManager.instance.stopSession();

        if (uuid != null) {
          NFCObject? object = await serverManager.findOneObject(uuid);
          callback(object);
          /*if (object != null) {
            callback(object);
          }*/
        } else {
          return;
        }
      },
    );
  }

  String? getNfcDatas(NdefRecord record) {
    if (record.typeNameFormat == NdefTypeNameFormat.empty) {
      return null;
    }

    return utf8.decode(record.payload);
  }

  bool checkAvailability(bool available) {
    if (!available) {
      // OPEN MODAL "PLEASE TURN ON NFC"
      return false;
    }
    return true;
  }

  bool checkNdef(Ndef? ndef) {
    if (ndef == null) {
      // Tag is not compatible with NDEF
      return false;
    }
    return true;
  }
}
