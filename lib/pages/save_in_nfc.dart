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

    nfcManager.read(context, (obj) {
      if (obj != null) {
        _showOverrideDialog(obj, (res) {
          if (res) {
            nfcManager.write(context, widget.newObject, () {
              setState(() {
                stepManager.next();
              });
            });
          } else {
            _errorDialog();
          }
        });
      } else {
        nfcManager.write(context, widget.newObject, () {
          setState(() {
            stepManager.next();
          });
        });
      }
    });

    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
            width: 250, child: Image.asset('assets/images/nfc_illu_1.png')),
        Padding(
            padding: EdgeInsets.only(top: 20),
            child: Description(
              text: "Approcher un tag NFC vierge pour sauvegarder les données",
              align: TextAlign.center,
            )),
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
          text: widget.newObject.name + " est maintenant enregistré",
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                if (stepManager.getStep() == 1 || stepManager.getStep() == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  ).then((_) {
                    setState(() {});
                  });
                } else {
                  Navigator.pop(context);
                }
              });
            },
          )),
      body: stepManager.getActual(),
    );
  }

  void _showOverrideDialog(NFCObject object, Function(bool) callback) {
    TextEditingController passwordController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Attention'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Description(
                    text:
                        "Un object est déja affecté à cette carte, veuillez entrer le mot de passe pour réécrire la carte"),
                SizedBox(
                  height: 30,
                ),
                TextInput(hint: "Mot de passe", controller: passwordController)
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    callback(false);
                    _dismissDialog();
                  },
                  child: Text('Annuler')),
              TextButton(
                onPressed: () {
                  _checkPassword(
                      callback, object.password, passwordController.text);
                },
                child: Text('Valider'),
              )
            ],
          );
        });
  }

  void _errorDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Description(text: "Une erreur est survenue"),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _dismissDialog();
                },
                child: Text('Ok'),
              )
            ],
          );
        });
  }

  _dismissDialog() {
    Navigator.pop(context);
  }

  _checkPassword(Function(bool) callback, String objectPWD, String inputPWD) {
    _dismissDialog();
    callback(objectPWD == inputPWD);
  }
}
