import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/donation.dart';

class DonationService {
  final CollectionReference _donationsCollection =
  FirebaseFirestore.instance.collection('donations');

  Future<void> addDonation(Donation donation) async {
    String id=_donationsCollection.doc().id;
    donation.id=id;
    await _donationsCollection.doc(id).set(donation.toMap());
  }

  Future<void> updateDonation(Donation donation) async {
    await _donationsCollection.doc(donation.id).update(donation.toMap());
  }

  Future<void> deleteDonation(String donationId) async {
    await _donationsCollection.doc(donationId).delete();
  }

  Future<List<Donation>> getApprovedDonations(String userId) async {
     QuerySnapshot querySnapshot =await _donationsCollection
        .where('status', isEqualTo: 'approved')
        .where('donorId', isEqualTo: userId)
        .get();

    return querySnapshot.docs.map((doc) {
      return Donation.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();

  }

  Future<List<Donation>> getDonations() async {
    QuerySnapshot querySnapshot =await _donationsCollection
        .get();

    return querySnapshot.docs.map((doc) {
      return Donation.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();

  }


}
