import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/relief_camp.dart';

class ReliefCampService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'relief_camps';

  Future<void> addReliefCamp(ReliefCamp reliefCamp) async {
    final String docId = _firestore.collection(collectionName).doc().id;
    reliefCamp.id = docId;
    await _firestore.collection(collectionName).doc(docId).set(reliefCamp.toMap());
  }

  Future<List<ReliefCamp>> getReliefCamps() async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection(collectionName)
        .where('approveOrDeny', isEqualTo: 'approved')
        .get();
    return querySnapshot.docs.map((doc) {
      return ReliefCamp.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }


  Future<List<ReliefCamp>> getPaginatedReliefCamps(
      int pageSize, DocumentSnapshot? startAfter) async {
    Query query = _firestore.collection(collectionName).orderBy('campName');

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final QuerySnapshot querySnapshot = await query.limit(pageSize).get();

    return querySnapshot.docs.map((doc) {
      return ReliefCamp.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<ReliefCamp?> getReliefCampByManagerId(String keyword) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection(collectionName)
        .where('managerId', isEqualTo: keyword)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return null;
    }
    List<ReliefCamp> reliefCamps = querySnapshot.docs.map((doc) {
      return ReliefCamp.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
    return reliefCamps[0];
  }




}
