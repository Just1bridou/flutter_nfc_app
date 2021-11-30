import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTitle extends StatelessWidget {
  final String text;
  const CustomTitle({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          text,
          style: GoogleFonts.varelaRound(
              textStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 40,
                  fontWeight: FontWeight.w600)),
        ));
  }
}

class H2 extends StatelessWidget {
  final String text;
  const H2({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          text,
          style: GoogleFonts.varelaRound(
              textStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 30,
                  fontWeight: FontWeight.w600)),
        ));
  }
}

class H3 extends StatelessWidget {
  final String text;
  const H3({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          text,
          style: GoogleFonts.varelaRound(
              textStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 25,
                  fontWeight: FontWeight.w600)),
        ));
  }
}

class H4 extends StatelessWidget {
  final String text;
  H4({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          text,
          style: GoogleFonts.varelaRound(
              textStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
        ));
  }
}

class Description extends StatelessWidget {
  final String text;
  TextAlign? align;
  Description({Key? key, required this.text, this.align = TextAlign.left})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: GoogleFonts.varelaRound(
          textStyle: TextStyle(color: Colors.black87, fontSize: 15)),
    );
  }
}

class CustomPagePadding extends StatelessWidget {
  final Widget child;
  const CustomPagePadding({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: EdgeInsets.only(right: 20, left: 20, bottom: 10, top: 10),
          child: child),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final Color background;
  final Function() onPress;
  final Color? border;

  const CustomButton(
      {Key? key,
      required this.text,
      required this.background,
      required this.onPress,
      this.border})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: background,
      onPressed: onPress,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Text(text,
              style: GoogleFonts.varelaRound(
                  textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              )))),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
              color: border != null ? border! : background, width: 2)),
    );
  }
}

class AppBarText extends StatelessWidget {
  final String text;
  const AppBarText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: Colors.black87),
    );
  }
}

class TextInput extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  TextInput({Key? key, required this.hint, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
          hintText: hint,
          suffixStyle: const TextStyle(color: Colors.green)),
    );
  }
}

class TextArea extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  TextArea({Key? key, required this.hint, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      minLines: 2,
      maxLines: 10,
      decoration: InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
          hintText: hint,
          suffixStyle: const TextStyle(color: Colors.green)),
    );
  }
}

class Footer extends StatelessWidget {
  final List<Widget> children;
  const Footer({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 40, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}

class StepManager {
  final List<Widget> children;
  StepManager({required this.children});

  int step = 0;

  void next({VoidCallback? callback}) {
    if ((children.length - 1) > step) {
      step++;
    } else {
      if (callback != null) {
        callback();
      }
    }
  }

  void previous() {
    if (step > 0) {
      step--;
    }
  }

  int getStep() {
    return step;
  }

  Widget getActual() {
    return children[step];
  }
}
