import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_supply_chain_management_fyp/models/medical_item.dart';

import '../models/grocery_item.dart';

class GroceryItemService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final collectionName='groceryItems';

  Future<void> addGroceryItem(GroceryItem groceryItem) async {
    final String docId = _firestore.collection(collectionName).doc().id;
    groceryItem.id = docId;
    await _firestore.collection(collectionName).doc(docId).set(groceryItem.toMap());
  }

  Future<void> updateGroceryItem(String itemId,  int quantity) async {
    DocumentReference docRef = _firestore.collection(collectionName).doc(itemId);
    Map<String, dynamic> updateData = {'quantityInStock': quantity};
    await docRef.update(updateData);

  }

  Future<List<GroceryItem>> getGroceryItemsForShop(String shopId) async {
    final QuerySnapshot querySnapshot =
    await _firestore.collection(collectionName).where('shopId', isEqualTo: shopId).get();

    return querySnapshot.docs.map((doc) => GroceryItem.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }

}
