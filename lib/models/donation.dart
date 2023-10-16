class Donation {
  String itemName;
  String brand;
  String description;
  String? unitOfMeasurement;
  int quantityInStock;
  DateTime? expirationDate;
  String donorId;
  String status;
  String id;

  Donation({
    required this.itemName,
    required this.brand,
    required this.description,
    this.unitOfMeasurement,
    required this.quantityInStock,
    this.expirationDate,
    required this.donorId,
    required this.status,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'brand': brand,
      'description': description,
      'unitOfMeasurement': unitOfMeasurement,
      'quantityInStock': quantityInStock,
      'expirationDate': expirationDate?.millisecondsSinceEpoch,
      'donorId': donorId,
      'status': status,
      'id': id,
    };
  }

  factory Donation.fromMap(Map<String, dynamic> map) {
    return Donation(
      itemName: map['itemName'],
      brand: map['brand'],
      description: map['description'],
      unitOfMeasurement: map['unitOfMeasurement'],
      quantityInStock: map['quantityInStock'],
      expirationDate: map['expirationDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['expirationDate'])
          : null,
      donorId: map['donorId'],
      status: map['status'],
      id: map['id'],
    );
  }
}
