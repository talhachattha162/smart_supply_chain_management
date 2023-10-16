import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_supply_chain_management_fyp/models/user.dart';

import '../models/requestedMedicalItem.dart';

class RequestedMedicalItemService {
  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection('requested_medical_items');

  Future<void> createRequestedMedicalItem(RequestedMedicalItem item) async {
    final String docId =_collectionReference.doc().id;
    item.id=docId;
    await _collectionReference.doc(docId).set(item.toMap());
  }

  Future<void> updateRequestedMedicalItemAssignedReliefWorker(
      String id, UserModel assignedReliefWorker) async {

    await _collectionReference.doc(id).update({'assignedReliefWorker': assignedReliefWorker.toMap(),'status':'approved'});
  }



  Future<void> updateRequestedMedicalItemRemarks(
      String id, String remarks) async {

    await _collectionReference.doc(id).update({'remarks':remarks });
  }


  Future<void> deleteRequestedMedicalItem(String id) async {
    await _collectionReference.doc(id).delete();
  }

  Future<List<RequestedMedicalItem>> getAllRequestedMedicalItems(String medicalId) async {
    final QuerySnapshot querySnapshot = await _collectionReference.get();

    List<RequestedMedicalItem> requestedItems = [];

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      RequestedMedicalItem requestedItem =
      RequestedMedicalItem.fromMap(docSnapshot.data() as Map<String, dynamic>);
      requestedItems.add(requestedItem);
    }
    requestedItems=requestedItems.where((element) => element.medicalItems[0].hospitalId==medicalId).toList();

    return requestedItems;
  }


  Future<List<RequestedMedicalItem>> getAllRequestedMedicalItemsOfUser(String userId) async {
    final QuerySnapshot querySnapshot = await _collectionReference.get();

    List<RequestedMedicalItem> requestedItems = [];

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      RequestedMedicalItem requestedItem =
      RequestedMedicalItem.fromMap(docSnapshot.data() as Map<String, dynamic>);

      requestedItems.add(requestedItem);
    }
    List<RequestedMedicalItem> filteredItems = requestedItems
        .where((item) => item.resident?.id == userId)
        .toList();
    return filteredItems;

  }
}
