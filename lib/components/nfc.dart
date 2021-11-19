import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
