import 'package:flutter/material.dart';

import '../providers/user.dart';
import 'add_medical_stock.dart';

class MedicalStock extends StatelessWidget {
  const MedicalStock({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
        floatingActionButton:UserProvider.userModel!.userRole=='Medical Facility Manager'?FloatingActionButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddMedicalStock(),));
        } ,child: Icon(Icons.add)) :       null
    );
  }
}
