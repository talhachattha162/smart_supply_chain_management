import 'package:smart_supply_chain_management_fyp/models/user.dart';
import 'grocery_item.dart';
import 'medical_facility.dart';
import 'medical_item.dart';

class RequestedGroceryItem {
  String id;
  List<GroceryItem> groceryItems;
  UserModel? assignedReliefWorker;
  UserModel? resident;
  String? status;
  String? remarks;
  String? Recievedby;
  double deliveryLatitude;
  double deliveryLongitude;

  RequestedGroceryItem({
    required this.id,
    required this.groceryItems,
    required this.resident,
    required this.status,
    required this.remarks,
    required this.Recievedby,
    required this.deliveryLatitude,
    required this.deliveryLongitude,
    this.assignedReliefWorker,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groceryItems': groceryItems.map((item) => item.toMap()).toList(),
      'resident':resident?.toMap(),
      'status':status,
      'remarks':remarks,
      'Recievedby':Recievedby,
      'deliveryLatitude':deliveryLatitude,
      'deliveryLongitude':deliveryLongitude,
      'assignedReliefWorker': assignedReliefWorker?.toMap(),
    };
  }

  factory RequestedGroceryItem.fromMap(Map<String, dynamic>? map) {
    if (map == null) return RequestedGroceryItem(id: '', groceryItems: [], resident: null,status: '',remarks: '',Recievedby: '',deliveryLatitude: 0,deliveryLongitude: 0); // Return a default instance or handle this case accordingly

    return RequestedGroceryItem(
      id: map['id'] ?? '',
      groceryItems: (map['groceryItems'] as List<dynamic>?)
          ?.map((x) => GroceryItem.fromMap(x as Map<String, dynamic>))
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
      deliveryLatitude: map['deliveryLatitude'] != null
          ? map['deliveryLatitude']
          : null,
      deliveryLongitude: map['deliveryLongitude'] != null
          ? map['deliveryLongitude']
          : null,
      assignedReliefWorker: map['assignedReliefWorker'] != null
          ? UserModel.fromMap(map['assignedReliefWorker'] as Map<String, dynamic>)
          : null,
    );
  }

}
