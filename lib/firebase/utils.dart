import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_supply_chain_management_fyp/models/medical_facility.dart';

import '../models/grocery_store.dart';
import '../models/relief_camp.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<List<GroceryStore>> getGroceryStoresByApproveOrDeny(String tableName,String keyword) async {

  final QuerySnapshot querySnapshot = await _firestore
      .collection(tableName)
      .where('approveOrDeny', isEqualTo: keyword)
      .get();

  return querySnapshot.docs.map((doc) {
    return GroceryStore.fromMap(doc.data() as Map<String, dynamic>);
  }).toList();
}
Future<List<MedicalFacility>> getMedicalFacilityByApproveOrDeny(String tableName,String keyword) async {

  final QuerySnapshot querySnapshot = await _firestore
      .collection(tableName)
      .where('approveOrDeny', isEqualTo: keyword)
      .get();

  return querySnapshot.docs.map((doc) {
    return MedicalFacility.fromMap(doc.data() as Map<String, dynamic>);
  }).toList();
}
Future<List<ReliefCamp>> getReliefCampByApproveOrDeny(String tableName,String keyword) async {

  final QuerySnapshot querySnapshot = await _firestore
      .collection(tableName)
      .where('approveOrDeny', isEqualTo: keyword)
      .get();

  return querySnapshot.docs.map((doc) {
    return ReliefCamp.fromMap(doc.data() as Map<String, dynamic>);
  }).toList();
}


updateApproveOrDeny(documentId,updatedApproveOrDeny,tableName)async{
  await FirebaseFirestore.instance.collection(tableName).doc(documentId).update({
    'approveOrDeny': updatedApproveOrDeny,
  });
}