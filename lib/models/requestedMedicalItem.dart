import 'package:smart_supply_chain_management_fyp/models/user.dart';
import 'medical_facility.dart';
import 'medical_item.dart';

class RequestedMedicalItem {
  String id;
  List<MedicalItem> medicalItems;
  UserModel? assignedReliefWorker;
  UserModel? resident;
  String? status;
  String? remarks;
  String? Recievedby;
  double deliveryLatitude;
  double deliveryLongitude;

  RequestedMedicalItem({
    required this.id,
    required this.medicalItems,
    required this.resident,
    required this.status,
    required this.remarks,
    required this.Recievedby,
    required this.deliveryLongitude,
    required this.deliveryLatitude,
    this.assignedReliefWorker,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicalItems': medicalItems.map((item) => item.toMap()).toList(),
      'resident':resident?.toMap(),
      'status':status,
      'remarks':remarks,
      'Recievedby':Recievedby,
      'deliveryLongitude':deliveryLongitude,
      'deliveryLatitude':deliveryLatitude,
      'assignedReliefWorker': assignedReliefWorker?.toMap(),
    };
  }

  factory RequestedMedicalItem.fromMap(Map<String, dynamic>? map) {
    if (map == null) return RequestedMedicalItem(id: '', medicalItems: [], resident: null,status: '',remarks: '',Recievedby: '',deliveryLongitude: 0,deliveryLatitude: 0); // Return a default instance or handle this case accordingly

    return RequestedMedicalItem(
      id: map['id'] ?? '',
      medicalItems: (map['medicalItems'] as List<dynamic>?)
          ?.map((x) => MedicalItem.fromMap(x as Map<String, dynamic>))
          ?.toList() ?? [],
      resident: map['resident'] != null
          ? UserModel.fromMap(map['resident'] as Map<String, dynamic>)
          : null,
      status: map['status'] != null
          ? map['status']
          : null,
      remarks: map['remarks'] != null
          ? map['remarks']
          : null,
      Recievedby: map['Recievedby'] != null
          ? map['Recievedby']
          : null,
      deliveryLongitude: map['deliveryLongitude'] != null
          ? map['deliveryLongitude']
          : null,
      deliveryLatitude: map['deliveryLatitude'] != null
          ? map['deliveryLatitude']
          : null,
      assignedReliefWorker: map['assignedReliefWorker'] != null
          ? UserModel.fromMap(map['assignedReliefWorker'] as Map<String, dynamic>)
          : null,
    );
  }

}
