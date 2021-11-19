import 'package:flutter/material.dart';
import 'package:flutter_nfc/components/components.dart';
import 'package:flutter_nfc/components/nfc.dart';
import 'package:flutter_nfc/pages/save_in_nfc.dart';

class AddObject extends StatefulWidget {
  const AddObject({Key? key}) : super(key: key);

  @override
  _AddObjectState createState() => _AddObjectState();
}

class _AddObjectState extends State<AddObject> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  StepManager stepManager = StepManager(children: []);

  @override
  void initState() {
    stepManager.children.add(step1(context));
    stepManager.children.add(step2(context));
    stepManager.children.add(step3(context));
    super.initState();
  }

  Widget step1(BuildContext context) {
    return CustomPagePadding(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        H4(text: "1. Préparer un tag NFC vierge"),
        Center(
            child: SizedBox(
                width: 200,
                height: 150,
                child: Image.asset('assets/images/nfc_illu_2.png'))),
        H4(text: "2. Entrez les données à stocker"),
        Description(
            text:
                "Les informations sur cet écran seront visible par toute personne scannant votre objet. Faites en sorte de ne rien indiquer de trop personnel, mais suffisament pour que la personne qui trouve l'objet puisse vous contacter en cas de perte"),
        Padding(
            padding: EdgeInsets.only(top: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Description(text: "Nom de l'objet"),
                TextInput(
                  hint: "Nom de l'objet",
                  controller: nameController,
                ),
                Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Description(text: "Information en cas de perte")),
                TextArea(
                  hint: "Numéro de téléphone, adresse, ...",
                  controller: descriptionController,
                ),
              ],
            ))
      ],
    ));
  }

  Widget step2(BuildContext context) {
    return CustomPagePadding(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        H4(text: "3. Ajouter des photos de l'objet"),
        Padding(
            padding: EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                    text: "Prendre en photo",
                    background: Colors.black87,
                    onPress: () {
                      print("prendre en photo");
                    })
              ],
            )),
      ],
    ));
  }

  Widget step3(BuildContext context) {
    return CustomPagePadding(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        H4(text: "4. Ajouter un mot de passe"),
        Description(
            text:
                "Le mot de passe sera demandé pour modifier l'objet et donc pouvoir se l'attribuer. Il permet de prouver que c'est votre objet"),
        Padding(
            padding: EdgeInsets.only(top: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Description(text: "Mot de passe"),
                TextInput(
                  hint: "Mot de passe",
                  controller: passwordController,
                ),
              ],
            ))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: AppBarText(text: "Ajouter un objet"),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                if (stepManager.getStep() == 0) {
                  Navigator.pop(context);
                } else {
                  stepManager.previous();
                }
              });
            },
          ),
        ),
        body: stepManager.getActual(),
        floatingActionButton: Footer(children: [
          H4(
              text: "Etape " +
                  (stepManager.step + 1).toString() +
                  "/" +
                  stepManager.children.length.toString()),
          CustomButton(
              text: "Suivant",
              background: Colors.black87,
              onPress: () {
                setState(() {
                  stepManager.next(callback: () {
                    if (_isStr(nameController.text) &&
                        _isStr(descriptionController.text) &&
                        _isStr(passwordController.text)) {
                      NFCObject newObject = NFCObject(
                          name: nameController.text,
                          informations: descriptionController.text,
                          password: passwordController.text);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SaveNFC(
                                  newObject: newObject,
                                )),
                      );
                    }
                  });
                });
              })
        ]));
  }

  bool _isStr(String value) {
    if (value == null || value == "") {
      return false;
    }
    return true;
  }
}
