import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_supply_chain_management_fyp/firebase/firebase_auth.dart';

import '../utils/theme.dart';

class ForgotPasswordScreen extends StatelessWidget {
   ForgotPasswordScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email='';


  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.sizeOf(context).width;
  final height=MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),      resizeToAvoidBottomInset: false,
        body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            Image.asset(
              width:width,
              'lib/assets/logo.png',
              height: height*0.3,
            ),
            // SizedBox(height: height*0.01),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.emailAddress, // Specify keyboard type
              validator: (value) {
                // Email validation logic
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }

                return null;
              },
              onSaved: (newValue) {
                _email=newValue!;
              },
            ),
            SizedBox(height: height*0.04),
            InkWell(onTap: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                AuthService auth=AuthService();
                try {
                  await auth.resetPassword(_email);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Check your email')));
                }
                catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                }
              }
            },
              child: Container(
                decoration:  BoxDecoration(color:button_color,borderRadius: BorderRadius.all(Radius.circular(40))
                  ,border: Border.all(
                    color: button_color, // Border color
                    width: 2.0, // Border width
                  ),),
                height:height*0.07 ,
                width:width,
                child: const Center(child: Text('Reset Password ',style:TextStyle(color:Colors.white))),
              ),
            ),
          ]),
        ),
      ),),
    );
  }
}
