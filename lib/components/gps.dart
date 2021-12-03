import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_nfc/components/components.dart';
import 'package:flutter_nfc/pages/save_in_nfc.dart';
import 'package:flutter_nfc/server/server.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';


class gps {

  Future<Position> getGPS() async {
    bool serviceEnabled;
    LocationPermission permission;

    // On regarde si le service de localisation est activé sur le téléphone.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Le service de localisation est désactiver, on envoit donc une erreur
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Les persmissions n'ont pas été accepté par l'utilisateur, on envoit donc une erreur
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Les permissions ne sont pas demandable a l'utilisateur, on envoit donc une erreur
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // une fois tous les checks réalisé et que nous arrivons ici,
    // nous pouvons envoyer les détails de localisation.
    return await Geolocator.getCurrentPosition();
  }
}