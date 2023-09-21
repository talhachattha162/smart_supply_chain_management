class MedicalItem {
  String id;
  String hospitalId;
  String itemName;
  String brand;
  String description;
  String unitOfMeasurement;
  int quantityInStock;
  int reorderLevel;
  String suppliername;
  String supplieremail;
  String supplierphone;
  String shelfLocation;
  String stockStatus;
  DateTime? expirationDate;
  String additionalNotes;

  MedicalItem({
    required this.id,
    required this.hospitalId,
    required this.itemName,
    required this.brand,
    required this.description,
    required this.unitOfMeasurement,
    required this.quantityInStock,
    required this.reorderLevel,
    required this.suppliername,
    required this.supplieremail,
    required this.supplierphone,
    required this.shelfLocation,
    required this.stockStatus,
    required this.expirationDate,
    required this.additionalNotes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hospitalId': hospitalId,
      'itemName': itemName,
      'brand': brand,
      'description': description,
      'unitOfMeasurement': unitOfMeasurement,
      'quantityInStock': quantityInStock,
      'reorderLevel': reorderLevel,
      'supplierName': suppliername,
      'supplierEmail': supplieremail,
      'supplierPhone': supplierphone,
      'shelfLocation': shelfLocation,
      'stockStatus': stockStatus,
      'expirationDate': expirationDate?.toIso8601String(),
      'additionalNotes': additionalNotes,
    };
  }

  factory MedicalItem.fromMap(Map<String, dynamic> map) {
    return MedicalItem(
      id: map['id'],
      hospitalId: map['hospitalId'],
      itemName: map['itemName'],
      brand: map['brand'],
      description: map['description'],
      unitOfMeasurement: map['unitOfMeasurement'],
      quantityInStock: map['quantityInStock'],
      reorderLevel: map['reorderLevel'],
      suppliername: map['supplierName'],
      supplieremail: map['supplierEmail'],
      supplierphone: map['supplierPhone'],
      shelfLocation: map['shelfLocation'],
      stockStatus: map['stockStatus'],
      expirationDate: map['expirationDate'] != null ? DateTime.parse(map['expirationDate']) : null,
      additionalNotes: map['additionalNotes'],
    );
  }
}
