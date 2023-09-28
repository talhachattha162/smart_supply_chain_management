import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_supply_chain_management_fyp/main.dart';
import 'package:smart_supply_chain_management_fyp/providers/signup.dart';
import 'package:smart_supply_chain_management_fyp/screens/login_screen.dart';

import '../clippers/select_role_clipper.dart';
import '../firebase/firebase_auth.dart';
import '../providers/login.dart';
import '../providers/selectrole.dart';
import '../utils/roles.dart';
import '../utils/theme.dart';




class SignupScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Define variables for form fields
  String _name = '';
  String _email = '';
  String _password = '';
  String _phoneNumber='';


  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.sizeOf(context).width;
    final height=MediaQuery.sizeOf(context).height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(

                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // SizedBox(height: height*0.02),
                          Image.asset(
                            'lib/assets/gifs/signup.gif',
                            width: width,
                            height: height*0.3,
                          ),

                          // SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Name',
                              filled: true,
                                                fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(horizontal:2.0,vertical:height*0.01), //

                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _name = value!;
                            },
                          ),
                          // SizedBox(height: height*0.01),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              filled: true,
                                                fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(horizontal:2.0,vertical:height*0.01), //

                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              String? email = value?.trim();
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b').hasMatch(email!)) {
                                return 'Enter valid email';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _email = value!;
                            },
                          ),
                          // SizedBox(height: height*0.01),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              filled: true,
                                                fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(horizontal:2.0,vertical:height*0.01), //

                            ),
                            keyboardType: TextInputType.phone, // Set keyboard type to phone
                            validator: (value) {
                              String? phoneNumber = value?.trim();
                              if (phoneNumber == null || phoneNumber.isEmpty) {
                                return 'Phone Number is required';
                              }
                              if(phoneNumber!=null){

                                // Use a regular expression to validate the phone number format
                                if (!RegExp(r'^[0-9]{11}$').hasMatch(phoneNumber!)) {
                                  return 'Use this format 03402132101';
                                }
                              }

                              return null;
                            },
                            onSaved: (value) {
                               _phoneNumber = value!;
                            },
                          )
,
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              filled: true,
                                                fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(horizontal:2.0,vertical:height*0.01), //

                            ),
                            validator: (value) {
                              if(value!=null){
                                String password = value!;
                                if (password.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                if (!RegExp(r'[A-Z]').hasMatch(password)) {
                                  return 'Include at least 1 uppercase letter';
                                }
                                if (!RegExp(r'[a-z]').hasMatch(password)) {
                                  return 'Include at least 1 lowercase letter';
                                }
                                if (!RegExp(r'\d').hasMatch(password)) {
                                  return 'Include at least 1 digit';
                                }
                                if (!RegExp(r'\W').hasMatch(password)) {
                                  return 'Include at least 1 special character';
                                }
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _password = value!;
                            },
                          ),
                          SizedBox(height: height*0.03),
                          InkWell(onTap: () async {
                            if (_formKey.currentState!.validate())
                            {
                              Provider.of<SignupProvider>(context,listen: false).isLoading=true;
                              String? selectedrole=Provider.of<SignupRoleProvider>(context,listen: false).selectedRole;
                            _formKey.currentState!.save();
                              AuthService auth=AuthService();
                              try{
                                await auth.registerUser(_name, _email, _password, selectedrole!,_phoneNumber);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account Created')));
                              }
                              catch(e){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                              }
                              Provider.of<SignupProvider>(context,listen: false).isLoading=false;
                            }
                          },
                            child: Container(
                              decoration: const BoxDecoration(color:button_color,borderRadius: BorderRadius.all(Radius.circular(40))),
                              height:height*0.06 ,
                              width:width,
                              child:  Center(child: Selector<SignupProvider,bool>(
                                  selector: (p0, p1) => p1.isLoading,
                                  builder: (_, isLoading, child) {
                                    return
                                    isLoading?
                                   const CircularProgressIndicator(color: Colors.white,)
                                        :
                                   const Text('Signup',style:TextStyle(color:Colors.white));
                                  },
                              )),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: height*0.02,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(child: Text('Already have an account?',style:TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(width: width*0.01,),
                          InkWell(onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                          },
                            child:                         Text('Signin',style:TextStyle(color:button_color,fontWeight: FontWeight.bold)),

                          ),

                        ],),

                    ],
                  ),ClipPath(
                    clipper: WavyBottomClipper(),
                    child: Container(
                      color: Colors.blue,
                      height: height*0.09,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
