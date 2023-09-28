import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_supply_chain_management_fyp/models/medical_item.dart';

class MedicalItemService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final collectionName='medicalItems';

  Future<void> addMedicalItem(MedicalItem medicalItem) async {
    final String docId = _firestore.collection(collectionName).doc().id;
    medicalItem.id = docId;
    await _firestore.collection(collectionName).doc(docId).set(medicalItem.toMap());
  }

  Future<void> updateMedicalItem(String itemId,  int quantity) async {
      DocumentReference docRef = _firestore.collection(collectionName).doc(itemId);
      Map<String, dynamic> updateData = {'quantityInStock': quantity};
      await docRef.update(updateData);

  }

  Future<List<MedicalItem>> getMedicalItemsForHospital(String hospitalId) async {
    final QuerySnapshot querySnapshot =
    await _firestore.collection(collectionName).where('hospitalId', isEqualTo: hospitalId).get();

    return querySnapshot.docs.map((doc) => MedicalItem.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

}
