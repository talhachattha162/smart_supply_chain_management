import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_supply_chain_management_fyp/models/user.dart';

Future<List<UserModel>> getManagers(managerrole) async {
  List<UserModel> managers = [];

  try {
    // Reference to the Firestore collection of users
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

    // Use the where clause to filter documents by userRole
    QuerySnapshot querySnapshot = await usersRef.where('userRole', isEqualTo:managerrole ).get();

    // Iterate through the documents and add them to the list
    querySnapshot.docs.forEach((doc) {
      UserModel manager = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      managers.add(manager);
    });
  } catch (e) {
    print('Error fetching $managerrole: $e');
  }

  return managers;
}