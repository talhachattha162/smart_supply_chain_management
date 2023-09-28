import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_supply_chain_management_fyp/models/user.dart';

import '../models/requestedGroceryItem.dart';
import '../models/requestedMedicalItem.dart';
import '../models/requestedReliefCampItem.dart';

class ReliefWorkerService {
  
  //requested medical
  final CollectionReference requestedMedicalCollectionReference = FirebaseFirestore.instance.collection('requested_medical_items');
  
  Future<void> updateRequestedMedicalItemRecievedby(String id, String Recievedby) async {
    await requestedMedicalCollectionReference.doc(id).update({'Recievedby':Recievedby });
  }

  Future<void> updateRequestedMedicalItemStatus(String id) async {
    await requestedMedicalCollectionReference.doc(id).update({'status':'delivered' });
  }
  
  Future<List<RequestedMedicalItem>> getAllRequestedMedicalItemsForReliefWorker(String userId) async {
    final QuerySnapshot querySnapshot = await requestedMedicalCollectionReference.get();

    List<RequestedMedicalItem> requestedItems = [];

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      RequestedMedicalItem requestedItem =
      RequestedMedicalItem.fromMap(docSnapshot.data() as Map<String, dynamic>);

      requestedItems.add(requestedItem);
    }
    List<RequestedMedicalItem> filteredItems = requestedItems
        .where((item) => item.assignedReliefWorker?.id == userId).where((element) => element.status=='approved')
        .toList();
    return filteredItems;

  }
  
  
  //requested grocery
  final CollectionReference requestedGroceryCollectionReference = FirebaseFirestore.instance.collection('requested_grocery_items');
  
  Future<void> updateRequestedGroceryItemReceivedBy(String id, String Recievedby) async {

    await requestedGroceryCollectionReference.doc(id).update({'Recievedby':Recievedby });
  }

  Future<void> updateRequestedGroceryItemStatus(String id) async {
    await requestedGroceryCollectionReference.doc(id).update({'status':'delivered' });
  }


  Future<List<RequestedGroceryItem>> getAllRequestedGroceryItemsForReliefWorker(String userId) async {
    final QuerySnapshot querySnapshot = await requestedGroceryCollectionReference.get();

    List<RequestedGroceryItem> requestedItems = [];

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      RequestedGroceryItem requestedItem =
      RequestedGroceryItem.fromMap(docSnapshot.data() as Map<String, dynamic>);

      requestedItems.add(requestedItem);
    }
    List<RequestedGroceryItem> filteredItems = requestedItems
        .where((item) => item.assignedReliefWorker?.id == userId).where((element) => element.status=='approved')
        .toList();
    return filteredItems;

  }  
  
  //requested reliefCamp
  final CollectionReference requestedCampCollectionReference =
  FirebaseFirestore.instance.collection('requested_reliefCamp_items');


  Future<void> updateRequestedReliefCampItemRecievedby(String id, String Recievedby) async {
    await requestedCampCollectionReference.doc(id).update({'Recievedby':Recievedby });
  }

  Future<void> updateRequestedReliefCampItemStatus(String id) async {
    await requestedCampCollectionReference.doc(id).update({'status':'delivered' });
  }

  Future<List<RequestedReliefCampItem>> getAllRequestedReliefCampItemsForReliefWorker(String userId) async {
    final QuerySnapshot querySnapshot = await requestedCampCollectionReference.get();

    List<RequestedReliefCampItem> requestedItems = [];

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      RequestedReliefCampItem requestedItem =
      RequestedReliefCampItem.fromMap(docSnapshot.data() as Map<String, dynamic>);

      requestedItems.add(requestedItem);
    }
    List<RequestedReliefCampItem> filteredItems = requestedItems
        .where((item) => item.assignedReliefWorker?.id == userId).where((element) => element.status=='approved')
        .toList();
    return filteredItems;

  }
  
}
