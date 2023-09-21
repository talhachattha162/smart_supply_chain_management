class UserModel {
  String id;
  String name;
  String email;
  String userRole;
  String photoUrl;
  String phoneno;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.userRole,
    required this.photoUrl,
    required this.phoneno,
  });

  factory UserModel.fromMap(Map<String, dynamic> data,) {
    return UserModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      userRole: data['userRole'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
        phoneno:data['phoneno'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'name': name,
      'email': email,
      'userRole': userRole,
      'photoUrl': photoUrl,
      'phoneno':phoneno,
    };
  }
}
