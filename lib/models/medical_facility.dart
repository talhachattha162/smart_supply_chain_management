class MedicalFacility {
  String id; // Add id field
  String managerId; // Add managerId field
  String facilityName;
  String location;
  double latitude;
  double longitude;
  String medicalFacilityEmail;
  String medicalFacilityPhone;
  String? selectedFacilityType;
  int numberOfBeds;
  int medicalStaff;
  int availableMedicalEquipmentCount;
  String inventoryDesc;
  String? selectedStatus;
  String accessibility;
  DateTime? selectedStartTime;
  DateTime? selectedEndTime;
  String approveOrDeny;

  MedicalFacility({
    required this.id,
    required this.managerId,
    required this.facilityName,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.medicalFacilityEmail,
    required this.medicalFacilityPhone,
    required this.selectedFacilityType,
    required this.numberOfBeds,
    required this.medicalStaff,
    required this.availableMedicalEquipmentCount,
    required this.inventoryDesc,
    required this.selectedStatus,
    required this.accessibility,
    required this.selectedStartTime,
    required this.selectedEndTime,
    required this.approveOrDeny,
  });

  // Convert MedicalFacility to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'managerId': managerId,
      'facilityName': facilityName,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'medicalFacilityEmail': medicalFacilityEmail,
      'medicalFacilityPhone': medicalFacilityPhone,
      'selectedFacilityType': selectedFacilityType,
      'numberOfBeds': numberOfBeds,
      'medicalStaff': medicalStaff,
      'availableMedicalEquipmentCount': availableMedicalEquipmentCount,
      'inventoryDesc': inventoryDesc,
      'selectedStatus': selectedStatus,
      'accessibility': accessibility,
      'selectedStartTime': selectedStartTime?.toIso8601String(),
      'selectedEndTime': selectedEndTime?.toIso8601String(),
      'approveOrDeny':approveOrDeny
    };
  }

  // Create a MedicalFacility object from a map
  factory MedicalFacility.fromMap(Map<String, dynamic> map) {
    return MedicalFacility(
      id: map['id'],
      managerId: map['managerId'],
      facilityName: map['facilityName'],
      location: map['location'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      medicalFacilityEmail: map['medicalFacilityEmail'],
      medicalFacilityPhone: map['medicalFacilityPhone'],
      selectedFacilityType: map['selectedFacilityType'],
      numberOfBeds: map['numberOfBeds'],
      medicalStaff: map['medicalStaff'],
      availableMedicalEquipmentCount: map['availableMedicalEquipmentCount'],
      inventoryDesc: map['inventoryDesc'],
      selectedStatus: map['selectedStatus'],
      accessibility: map['accessibility'],
      selectedStartTime: DateTime.parse(map['selectedStartTime']),
      selectedEndTime: DateTime.parse(map['selectedEndTime']),
      approveOrDeny: map['approveOrDeny'],
    );
  }
}
