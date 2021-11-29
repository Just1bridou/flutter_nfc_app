import 'dart:convert';
import 'dart:js_util';
import 'package:flutter_nfc/components/nfc.dart';
import 'package:http/http.dart' as http;

class ServerManager {
  final String baseURL = "http://localhost:1337/";

  Future<int> createObject(NFCObject object) async {
    final response = await http.post(Uri.parse(baseURL + "nfc-objects"), body: {
      "name": object.name,
      "description": object.description,
      "password": object.password
    });

    var decodeResponse = jsonDecode(response.body);

    return decodeResponse["code"];
  }

  Future<NFCObject> findOneObject(String id) async {
    final response = await http.post(Uri.parse(baseURL + "nfc-objects/" + id));

    var decodeResponse = jsonDecode(response.body);

    return NFCObject.fromJson(decodeResponse);
  }

  Future<List<NFCObject>> findAllObjects() async {
    final response = await http.post(Uri.parse(baseURL + "nfc-objects"));

    var decodeResponse = jsonDecode(response.body);

    return List<NFCObject>.from(
        decodeResponse.map((i) => NFCObject.fromJson(i)));
  }
}
