import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NFCObject {
  String name;
  String informations;
  // List<Photos>
  String password;

  NFCObject(
      {Key? key,
      required this.name,
      required this.informations,
      required this.password});
}

class NFCManager {
  void detectTag() async {
    print("on detect");
    // Check availability
    bool isAvailable = await NfcManager.instance.isAvailable();
    print(isAvailable);

    // Start Session
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        print("detected");
        Ndef? ndef = Ndef.from(tag);

        if (ndef == null) {
          print('Tag is not compatible with NDEF');
          return;
        }

        print("tag compatible");
      },
    );

    // Stop Session
    //NfcManager.instance.stopSession();
  }
}
