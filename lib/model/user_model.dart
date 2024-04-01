class UserModel {
  String? name;
  String? email;
  String? uid;
  String? image;
  DateTime? time;
  String? idToken;
  String? status;

  // Constructor
  UserModel({
    this.name,
    this.email,
    this.uid,
    this.image,
    this.time,
    this.idToken,
    this.status,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          uid == other.uid;

  @override
  int get hashCode => uid.hashCode;

  // Convert UserModel object to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'status': status,
      'email': email,
      'uid': uid,
      'image': image,
      'time': time?.millisecondsSinceEpoch, // Convert DateTime to milliseconds
      'idToken': idToken,
    };
  }

  // Convert Map to UserModel object
  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      status: map['status'],
      name: map['name'],
      email: map['email'],
      uid: map['uid'],
      image: map['image'],
      time: map['time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['time'])
          : null,
      idToken: map['idToken'],
    );
  }
}
