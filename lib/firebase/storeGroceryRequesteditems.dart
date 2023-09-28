import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_supply_chain_management_fyp/models/user.dart';

import '../models/requestedGroceryItem.dart';
import '../models/requestedMedicalItem.dart';

class RequestedGroceryItemService {
  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection('requested_grocery_items');

  Future<void> createRequestedGroceryItem(RequestedGroceryItem item) async {
    final String docId =_collectionReference.doc().id;
    item.id=docId;
    await _collectionReference.doc(docId).set(item.toMap());
  }

  Future<void> updateRequestedGroceryItemAssignedReliefWorker(
      String id, UserModel assignedReliefWorker) async {

    await _collectionReference.doc(id).update({'assignedReliefWorker': assignedReliefWorker.toMap(),'status':'approved'});
  }



  Future<void> updateRequestedGroceryItemRemarks(
      String id, String remarks) async {

    await _collectionReference.doc(id).update({'remarks':remarks });
  }


  Future<void> deleteRequestedGroceryItem(String id) async {
    await _collectionReference.doc(id).delete();
  }

  Future<List<RequestedGroceryItem>> getAllRequestedGroceryItems() async {
    final QuerySnapshot querySnapshot = await _collectionReference.get();

    List<RequestedGroceryItem> requestedItems = [];

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      RequestedGroceryItem requestedItem =
      RequestedGroceryItem.fromMap(docSnapshot.data() as Map<String, dynamic>);
      requestedItems.add(requestedItem);
    }

    return requestedItems;
  }


  Future<List<RequestedGroceryItem>> getAllRequestedGroceryItemsOfUser(String userId) async {
    final QuerySnapshot querySnapshot = await _collectionReference.get();

    List<RequestedGroceryItem> requestedItems = [];

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      RequestedGroceryItem requestedItem =
      RequestedGroceryItem.fromMap(docSnapshot.data() as Map<String, dynamic>);

      requestedItems.add(requestedItem);
    }
    List<RequestedGroceryItem> filteredItems = requestedItems
        .where((item) => item.resident?.id == userId)
        .toList();
    return filteredItems;

  }
}
