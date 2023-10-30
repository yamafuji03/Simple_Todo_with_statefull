// files
import 'package:todo2/model/variable_function.dart';
import 'package:todo2/view_model/admob.dart';
import 'package:todo2/view_model/custom_text_field.dart';
import 'package:todo2/view_model/registration_view_model.dart';
// packages
import 'package:flutter/material.dart';

class Registration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Acount Screen"),
      ),
      body: Column(
        children: [
          CustomTextField(
              label: "Mail address",
              onChangedFunc: (newtext) {
                RegistrationModel.instance.mailAddressRegistration = newtext;
              },
              isPassword: false),
          CustomTextField(
              label: "Password",
              onChangedFunc: (newtext) {
                RegistrationModel.instance.passwordRegistration = newtext;
              },
              isPassword: true),
          CustomTextField(
              label: "Comfirm password",
              onChangedFunc: (newtext) {
                RegistrationModel.instance.passwordCheckRegistration = newtext;
              },
              isPassword: true),
          ElevatedButton(
            child: Container(
              width: 200,
              height: 50,
              alignment: Alignment.center,
              child: Text(
                'Create!',
                textAlign: TextAlign.center,
              ),
            ),
            onPressed: () async {
              await registrationButton(context);
            },
          ),
        ],
      ),
      // bottomNavigationBar: AdMob(),
    );
  }
}
