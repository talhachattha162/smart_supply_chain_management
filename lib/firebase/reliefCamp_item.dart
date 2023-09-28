import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_supply_chain_management_fyp/models/medical_item.dart';

import '../models/grocery_item.dart';
import '../models/relief_camp_item.dart';

class ReliefCampItemService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final collectionName='reliefCampItems';

  Future<void> addReliefCampItem(ReliefCampItem reliefCampItem) async {
    final String docId = _firestore.collection(collectionName).doc().id;
    reliefCampItem.id = docId;
    await _firestore.collection(collectionName).doc(docId).set(reliefCampItem.toMap());
  }

  Future<void> updateReliefCampItem(String itemId,  int quantity) async {
    DocumentReference docRef = _firestore.collection(collectionName).doc(itemId);
    Map<String, dynamic> updateData = {'quantityInStock': quantity};
    await docRef.update(updateData);

  }

  Future<List<ReliefCampItem>> getReliefCampItemsForCamp(String shopId) async {
    final QuerySnapshot querySnapshot =
    await _firestore.collection(collectionName).where('campId', isEqualTo: shopId).get();

    return querySnapshot.docs.map((doc) => ReliefCampItem.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

}
