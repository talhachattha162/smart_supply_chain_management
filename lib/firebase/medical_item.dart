import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_supply_chain_management_fyp/models/medical_item.dart';

class MedicalItemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMedicalItem(MedicalItem medicalItem) async {

    await _firestore.collection('medicalItems').add(medicalItem.toMap());
  }

  Future<List<Map<String, dynamic>>> getMedicalItemsForHospital(String hospitalId) async {
    final QuerySnapshot querySnapshot =
    await _firestore.collection('medicalItems').where('hospitalId', isEqualTo: hospitalId).get();

    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}
