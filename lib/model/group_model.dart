import 'package:app/model/user_model.dart';

class GroupModel {
  String? groupId;
  String? groupName;
  List<UserModel>? groupMembers;
  String? groupImage;
  String? admin;
  DateTime? createdAt;
  

  GroupModel({
    this.groupId,
    this.groupName,
    this.groupMembers,
    this.groupImage,
    this.admin,
    this.createdAt,
  });

  // Convert GroupModel object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'groupMembers': groupMembers != null
          ? groupMembers!.map((user) => user.toMap()).toList()
          : null,
      'groupImage': groupImage,
      'admin': admin,
      'createdAt': createdAt != null ? createdAt!.millisecondsSinceEpoch : null,
    };
  }

  // Convert JSON format to GroupModel object
  static GroupModel fromJson(Map<String, dynamic> json) {
    return GroupModel(
      groupId: json['groupId'],
      groupName: json['groupName'],
      groupMembers: json['groupMembers'] != null
          ? (json['groupMembers'] as List)
              .map((userJson) => UserModel.fromMap(userJson))
              .toList()
          : null,
      groupImage: json['groupImage'],
      admin: json['admin'],
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'])
          : null,
    );
  }
}
