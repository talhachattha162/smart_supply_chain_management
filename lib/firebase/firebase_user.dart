import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class UserService {

  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('users');

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {

      DocumentSnapshot userSnapshot = await _usersCollection.doc(userId).get();

      if (userSnapshot.exists) {
        return UserModel.fromMap(
            userSnapshot.data() as Map<String, dynamic>);
      } else {
        return null; // User not found
      }
  }

  // Store user
  Future<void> storeUser(UserModel user) async {
      await _usersCollection.doc(user.id).set(user.toMap());
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
      await _usersCollection.doc(userId).delete();
  }

  // Update user
  Future<void> updateUser(UserModel user) async {
      await _usersCollection.doc(user.id).update(user.toMap());

  }

  Future<List<UserModel>> getUsersByRole(String userRole) async {
    QuerySnapshot userSnapshots =
    await _usersCollection.where('userRole', isEqualTo: userRole).get();

    List<UserModel> users = [];

    for (QueryDocumentSnapshot doc in userSnapshots.docs) {
      UserModel user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      users.add(user);
    }

    return users;
  }

}
