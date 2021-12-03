import 'dart:convert';
import 'package:flutter_nfc/components/nfc.dart';
import 'package:http/http.dart' as http;

class ServerManager {
  final String baseURL = "https://serene-beyond-93784.herokuapp.com/";

  Future<int> createObject(PayloadNFCObject object) async {
    final response = await http.post(Uri.parse(baseURL + "nfc-objects"), body: {
      "name": object.name,
      "description": object.description,
      "password": object.password,
      "photo_url": object.photo_url
    });

    var decodeResponse = jsonDecode(response.body);

    return decodeResponse["id"];
  }

  Future<NFCObject?> findOneObject(String id) async {
    final response = await http.get(Uri.parse(baseURL + "nfc-objects/" + id));
    var decodeResponse = jsonDecode(response.body);
    if (decodeResponse['error'] == null) {
      return NFCObject.fromJson(decodeResponse);
    } else {
      return null;
    }
  }

  Future<List<NFCObject>> findAllObjects() async {
    final response = await http.get(Uri.parse(baseURL + "nfc-objects"));

    var decodeResponse = jsonDecode(response.body);

    return List<NFCObject>.from(
        decodeResponse.map((i) => NFCObject.fromJson(i)));
  }

  Future<List<NFCObject>> getObjectsList(List<String> listId) async {
    List<NFCObject> objectsList = [];

    await Future.wait(listId.map((id) async {
      NFCObject? obj = await findOneObject(id);
      if (obj != null) {
        objectsList.add(obj);
      }
    }));

    return objectsList;
  }
}
