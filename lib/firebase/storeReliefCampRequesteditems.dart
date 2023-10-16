import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_supply_chain_management_fyp/models/user.dart';

import '../models/requestedMedicalItem.dart';
import '../models/requestedReliefCampItem.dart';

class RequestedReliefCampItemService {
  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection('requested_reliefCamp_items');

  Future<void> createRequestedReliefCampItem(RequestedReliefCampItem item) async {
    final String docId =_collectionReference.doc().id;
    item.id=docId;
    await _collectionReference.doc(docId).set(item.toMap());
  }

  Future<void> updateRequestedReliefCampItemAssignedReliefWorker(
      String id, UserModel assignedReliefWorker) async {

    await _collectionReference.doc(id).update({'assignedReliefWorker': assignedReliefWorker.toMap(),'status':'approved'});
  }



  Future<void> updateRequestedReliefCampItemRemarks(
      String id, String remarks) async {

    await _collectionReference.doc(id).update({'remarks':remarks });
  }


  Future<void> deleteRequestedReliefCampItem(String id) async {
    await _collectionReference.doc(id).delete();
  }

  Future<List<RequestedReliefCampItem>> getAllRequestedReliefCampItems(String campId) async {
    final QuerySnapshot querySnapshot = await _collectionReference.get();

    List<RequestedReliefCampItem> requestedItems = [];

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      RequestedReliefCampItem requestedItem =
      RequestedReliefCampItem.fromMap(docSnapshot.data() as Map<String, dynamic>);
      requestedItems.add(requestedItem);
    }
    requestedItems=requestedItems.where((element) => element.reliefCampItems[0].campId==campId).toList();
    return requestedItems;
  }


  Future<List<RequestedReliefCampItem>> getAllRequestedReliefCampItemsOfUser(String userId) async {
    final QuerySnapshot querySnapshot = await _collectionReference.get();

    List<RequestedReliefCampItem> requestedItems = [];

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      RequestedReliefCampItem requestedItem =
      RequestedReliefCampItem.fromMap(docSnapshot.data() as Map<String, dynamic>);

      requestedItems.add(requestedItem);
    }
    List<RequestedReliefCampItem> filteredItems = requestedItems
        .where((item) => item.resident?.id == userId)
        .toList();
    return filteredItems;

  }
}
