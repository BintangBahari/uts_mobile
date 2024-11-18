import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'input.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController myTxtctrlEml = TextEditingController();
    TextEditingController myTxtctrlPsw = TextEditingController();
    TextEditingController myTxtctrlCPs = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            makeInput(txtInpctrl: myTxtctrlEml, label: "Email"),
            makeInput(txtInpctrl: myTxtctrlPsw, label: "Password", obsureText: true),
            makeInput(txtInpctrl: myTxtctrlCPs, label: "Confirm Password", obsureText: true),
          ],
        ),
      ),
    );
  }
}
