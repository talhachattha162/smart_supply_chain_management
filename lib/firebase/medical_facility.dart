import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/medical_facility.dart';

class MedicalFacilityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName =
      'medical_facilities'; // Change to your Firestore collection name

  // Create a new MedicalFacility document in Firestore
  Future<void> addMedicalFacility(MedicalFacility medicalFacility) async {
    final String docId = _firestore.collection(collectionName).doc().id;
    medicalFacility.id = docId;
    await _firestore
        .collection(collectionName)
        .doc(docId)
        .set(medicalFacility.toMap());
  }

  // Retrieve a list of all MedicalFacility documents from Firestore
  Future<List<MedicalFacility>> getMedicalFacilities() async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection(collectionName)
        .where('approveOrDeny', isEqualTo: 'approved')
        .get();
    return querySnapshot.docs.map((doc) {
      return MedicalFacility.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // Get a MedicalFacility document by its unique ID
  Future<MedicalFacility?> getMedicalFacilityById(String documentId) async {
    final DocumentSnapshot doc =
        await _firestore.collection(collectionName).doc(documentId).get();
    if (doc.exists) {
      return MedicalFacility.fromMap(doc.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  // Search for MedicalFacility documents based on a keyword
  Future<List<MedicalFacility>> getMedicalFacilitiesByFacilityType(
      String keyword) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection(collectionName)
        .where('selectedFacilityType', isEqualTo: keyword)
        .where('approveOrDeny', isEqualTo: 'approved')
        .get();
    return querySnapshot.docs.map((doc) {
      return MedicalFacility.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  // Retrieve a paginated list of MedicalFacility documents
  Future<List<MedicalFacility>> getPaginatedMedicalFacilities(
      int pageSize, DocumentSnapshot? startAfter) async {
    Query query = _firestore.collection(collectionName).orderBy('facilityName');

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final QuerySnapshot querySnapshot = await query.limit(pageSize).get();

    return querySnapshot.docs.map((doc) {
      return MedicalFacility.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<MedicalFacility?> getMedicalFacilityByManagerId(String keyword) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection(collectionName)
        .where('managerId', isEqualTo: keyword)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return null;
    }
    List<MedicalFacility> medicalFacilities = querySnapshot.docs.map((doc) {
      return MedicalFacility.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
    return medicalFacilities[0];
  }

// Add other methods as needed for additional CRUD operations
}
