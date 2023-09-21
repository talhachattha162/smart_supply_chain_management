class GroceryStore {

  String id;
  String managerId;
  String storeName;
  String location;
  double latitude;
  double longitude;
  String contactPhone;
  String contactEmail;
  String? selectedStoreType;
  String inventorydesc;
  bool hasDeliveryServices;
  String? selectedStatus;
  String? accessibility;
  DateTime? selectedStartTime;
  DateTime? selectedEndTime;
String approveOrDeny;

  GroceryStore({
    required this.id,
    required this.managerId,
    required this.storeName,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.contactPhone,
    required this.contactEmail,
    required this.selectedStoreType,
    required this.inventorydesc,
    required this.hasDeliveryServices,
    required this.selectedStatus,
    required this.accessibility,
    required this.selectedStartTime,
    required  this.selectedEndTime,
    required this.approveOrDeny,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'managerId': managerId,
      'storeName': storeName,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'contactPhone': contactPhone,
      'contactEmail': contactEmail,
      'selectedStoreType': selectedStoreType,
      'inventorydesc': inventorydesc,
      'hasDeliveryServices': hasDeliveryServices,
      'selectedStatus': selectedStatus,
      'accessibility': accessibility,
      'selectedStartTime': selectedStartTime?.toIso8601String(), // Convert DateTime to ISO 8601 format
      'selectedEndTime': selectedEndTime?.toIso8601String(), // Convert DateTime to ISO 8601 format
      'approveOrDeny': approveOrDeny, // Convert DateTime to ISO 8601 format
    };
  }

  factory GroceryStore.fromMap(Map<String, dynamic> map) {
    return GroceryStore(
      id: map['id'],
      managerId: map['managerId'],
      storeName: map['storeName'],
      location: map['location'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      contactPhone: map['contactPhone'],
      contactEmail: map['contactEmail'],
      selectedStoreType: map['selectedStoreType'],
      inventorydesc: map['inventorydesc'],
      hasDeliveryServices: map['hasDeliveryServices'],
      selectedStatus: map['selectedStatus'],
      accessibility: map['accessibility'],
      selectedStartTime: map['selectedStartTime'] != null
          ? DateTime.parse(map['selectedStartTime']) // Parse ISO 8601 string to DateTime
          : null,
      selectedEndTime: map['selectedEndTime'] != null
          ? DateTime.parse(map['selectedEndTime']) // Parse ISO 8601 string to DateTime
          : null,
      approveOrDeny: map['approveOrDeny'],
    );
  }

}
