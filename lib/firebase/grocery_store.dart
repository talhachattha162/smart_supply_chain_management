import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/grocery_store.dart';

class GroceryStoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'grocery_stores';


  Future<void> addGroceryStore(GroceryStore groceryStore) async {
    final String docId = _firestore.collection(collectionName).doc().id;
    groceryStore.id = docId;
    await _firestore.collection(collectionName).doc(docId).set(groceryStore.toMap());
  }


  Future<List<GroceryStore>> getGroceryStores() async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection(collectionName)
        .where('approveOrDeny', isEqualTo: 'approved')
        .get();
    return querySnapshot.docs.map((doc) {
      return GroceryStore.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }



  // Search for GroceryStore documents based on a keyword
  Future<List<GroceryStore>> getGroceryStoresByStoreType(String keyword) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection(collectionName)
        .where('selectedStoreType', isEqualTo: keyword)
        .where('approveOrDeny', isEqualTo: 'approved')
        .get();
    return querySnapshot.docs.map((doc) {
      return GroceryStore.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // Retrieve a paginated list of GroceryStore documents
  Future<List<GroceryStore>> getPaginatedGroceryStores(
      int pageSize, DocumentSnapshot? startAfter) async {
    Query query = _firestore.collection(collectionName).orderBy('storeName');

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final QuerySnapshot querySnapshot = await query.limit(pageSize).get();

    return querySnapshot.docs.map((doc) {
      return GroceryStore.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }


  Future<GroceryStore?> getGroceryStoreByManagerId(String keyword) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection(collectionName)
        .where('managerId', isEqualTo: keyword)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return null;
    }
    List<GroceryStore> groceryStores = querySnapshot.docs.map((doc) {
      return GroceryStore.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
    return groceryStores[0];
  }


}
