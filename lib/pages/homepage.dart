import 'package:flutter/material.dart';
import 'package:flutter_nfc/components/components.dart';
import 'package:flutter_nfc/pages/add_object.dart';
import 'package:flutter_nfc/pages/save_in_nfc.dart';
import 'package:flutter_nfc/pages/scan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    print("initstate homepage");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTitle(
              text: "MyApp",
            ),
            CustomButton(
                text: "Scanner un objet",
                background: Colors.black87,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReadNFC()),
                  );
                })
          ],
        ),
      ),
      body: CustomPagePadding(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: H3(text: "Mes objets"),
            ),
            FutureBuilder<List<String>>(
              future: _getSavedObjects(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(
                        child: Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    ));
                  default:
                    if (snapshot.hasError && snapshot.data != null) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      print(snapshot.data);
                      if (snapshot.data!.isEmpty) {
                        return Center(
                          child: Description(
                            text: "Aucuns objet enregistré",
                          ),
                        );
                      } else {
                        return builderObjects(snapshot);
                      }
                      //return builderTopics(snapshot);
                    }
                }
              },
            )
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: CustomButton(
            text: "Ajouter un objet",
            background: Colors.black87,
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddObject()),
              );
            }),
      ),
    );
  }

  Future<List<String>> _getSavedObjects() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList('listObject') ?? []);

    //await prefs.setStringList('listObject', listObject);
  }

  Widget builderObjects(AsyncSnapshot<List<String>> snapshot) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.count(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1,
          //childAspectRatio: (.7 / 1),
          crossAxisSpacing: 10,
          children: List.generate(snapshot.data!.length, (index) {
            return objectCard(snapshot.data![index]);
          }),
        ),
      ],
    );
  }

  Widget objectCard(String id) {
    return Container(
      decoration: BoxDecoration(color: Colors.red),
      child: Description(
        text: id,
      ),
    );
  }
}
