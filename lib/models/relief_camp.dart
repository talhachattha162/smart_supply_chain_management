class ReliefCamp {
  String id;
  String campName;
  String email;
  String phoneNumber;
  String description;
  String approveOrDeny;
  String managerId;
  String location;
  double latitude;
  double longitude;


  ReliefCamp({
   required this.id,
   required this.campName,
   required this.email,
   required this.phoneNumber,
   required this.description,
    required this.approveOrDeny,
    required this.managerId,
    required this.location,
    required this.latitude,
    required this.longitude  });

  factory ReliefCamp.fromMap(Map<String, dynamic> json) {
    return ReliefCamp(
      id:json['id'] ,
      campName: json['campName'] ,
      email: json['email'] ,
      phoneNumber: json['phoneNumber'] ,
      description: json['description'] ,
      approveOrDeny: json['approveOrDeny'] ,
      managerId: json['managerId'] ,
      location: json['location'] ,
latitude: json['latitude'] ,
        longitude: json['longitude'] ,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'campName': campName,
      'email': email,
      'phoneNumber': phoneNumber,
      'description': description,
      'approveOrDeny':approveOrDeny,
      'managerId':managerId,
      'location': location,
'latitude':latitude,
      'longitude':longitude
    };
  }
}
