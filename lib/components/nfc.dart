import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NFCObject {
  String name;
  String description;
  String password;

  NFCObject(
      {Key? key,
      required this.name,
      required this.description,
      required this.password});

  factory NFCObject.fromJson(Map<dynamic, dynamic> json) {
    return NFCObject(
      name: json['name'],
      description: json['informations'],
      password: json['password'],
    );
  }
}

class NFCManager {
  void detectTag() async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (!checkAvailability(isAvailable)) {
      return;
    }

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        Ndef? ndef = Ndef.from(tag);

        if (!checkNdef(ndef)) {
          return;
        }

        print("tag compatible");

        // NfcManager.instance.stopSession();
      },
    );
  }

  void write(NFCObject object, VoidCallback callback) async {
    print("write");

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

        Uint8List bytesData = Uint8List.fromList(utf8.encode('{"name":"' +
            object.name +
            '", "informations":"' +
            object.description +
            '", "password":"' +
            object.password +
            '"}'));

        if (ndef.isWritable) {
          ndef.write(
              new NdefMessage([NdefRecord.createMime("text/json", bytesData)]));

          print("done");

          callback();
        } else {
          print("cant write on tag");
        }
      },
    );
  }

  void read(Function(NFCObject) callback) async {
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

        final canMakeReadOnly = ndef.additionalData['canMakeReadOnly'] as bool?;

        NdefMessage readData = await ndef.read();

        // print("can make read only: " + canMakeReadOnly.toString());
        // print("is writable: " + ndef.isWritable.toString());

        var datas = getNfcDatas(readData.records[0]);

        if (datas != null) {
          var decodeResponse = jsonDecode(datas);
          //return decodeResponse[0]["name"];
          var obj = NFCObject.fromJson(decodeResponse);
          callback(obj);
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
