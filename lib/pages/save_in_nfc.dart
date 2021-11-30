import 'package:flutter/material.dart';
import 'package:flutter_nfc/components/components.dart';
import 'package:flutter_nfc/components/nfc.dart';
import 'package:flutter_nfc/pages/homepage.dart';
import 'package:flutter_nfc/server/server.dart';
import 'package:uuid/uuid.dart';

class SaveNFC extends StatefulWidget {
  final PayloadNFCObject newObject;
  const SaveNFC({Key? key, required this.newObject}) : super(key: key);

  @override
  _SaveNFCState createState() => _SaveNFCState();
}

class _SaveNFCState extends State<SaveNFC> {
  StepManager stepManager = StepManager(children: []);
  NFCManager nfcManager = NFCManager();
  ServerManager serverManager = ServerManager();

  @override
  void initState() {
    stepManager.children.add(step1(context));
    stepManager.children.add(step2(context));
    stepManager.children.add(step3(context));
    super.initState();
  }

  Widget step1(BuildContext context) {
    // nfcManager.read();

    nfcManager.write(widget.newObject, () {
      setState(() {
        stepManager.next();
      });
    });

    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
            width: 250,
            //height: 150,
            child: Image.asset('assets/images/nfc_illu_1.png')),
        Padding(
            padding: EdgeInsets.only(top: 20),
            child: Description(
              text: "Approcher un tag NFC vierge pour sauvegarder les données",
              align: TextAlign.center,
            )),
        // CustomButton(
        //     text: "next",
        //     background: Colors.black87,
        //     onPress: () {
        //       setState(() {
        //         stepManager.next();
        //       });
        //     })
      ],
    ));
  }

  Widget step2(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        H4(text: "C'est bientôt fini !"),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Container(
              height: 20,
              width: 180,
              decoration: BoxDecoration(
                  color: Colors.grey.shade500,
                  borderRadius: BorderRadius.circular(5)),
            )),
        Description(
          text: "Envoie des images sur le serveur...",
          align: TextAlign.center,
        ),
        CustomButton(
            text: "next",
            background: Colors.black87,
            onPress: () {
              setState(() {
                stepManager.next(callback: () {
                  print("end");
                });
              });
            })
      ],
    ));
  }

  Widget step3(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        H4(text: "Bravo !"),
        Description(
          text: "[ITEM NAME] est maintenant enregistré",
          align: TextAlign.center,
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Container(
              height: 20,
              width: 180,
              decoration: BoxDecoration(
                  color: Colors.lightBlue.shade400,
                  borderRadius: BorderRadius.circular(5)),
            )),
        Description(
          text:
              "Tout es ok, collez votre tag sur un objet et le tour est joué !",
          align: TextAlign.center,
        ),
        CustomButton(
            text: "Voir mes objets",
            background: Colors.black87,
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              ).then((_) {
                setState(() {});
              });
            })
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: AppBarText(text: "Sauvegarder"),
        centerTitle: true,
        elevation: 0,
      ),
      body: stepManager.getActual(),
    );
  }
}
