import 'package:json_annotation/json_annotation.dart';

part 'user_vo.g.dart';

@JsonSerializable()
class UserVO {
  @JsonKey(name: 'id')
  String? id;

  @JsonKey(name: 'email')
  String? email;

  @JsonKey(name: 'user_name')
  String? userName;

  @JsonKey(name: 'password')
  String? password;

  @JsonKey(name: 'profile_picture_url')
  String? profilePictureUrl;

  @JsonKey(name: 'phone_number')
  String? phoneNumber;

  @JsonKey(name: 'fcm_token')
  String? fcmToken;

  UserVO({
    this.id,
    this.email,
    this.userName,
    this.password,
    this.profilePictureUrl,
    this.phoneNumber,
    this.fcmToken,
  });

  factory UserVO.fromJson(Map<String, dynamic> json) => _$UserVOFromJson(json);

  Map<String, dynamic> toJson() => _$UserVOToJson(this);

  

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserVO &&
      other.id == id &&
      other.email == email &&
      other.userName == userName &&
      other.password == password &&
      other.profilePictureUrl == profilePictureUrl &&
      other.phoneNumber == phoneNumber &&
      other.fcmToken == fcmToken;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      email.hashCode ^
      userName.hashCode ^
      password.hashCode ^
      profilePictureUrl.hashCode ^
      phoneNumber.hashCode ^
      fcmToken.hashCode;
  }

  @override
  String toString() {
    return 'UserVO(id: $id, email: $email, userName: $userName, password: $password, profilePictureUrl: $profilePictureUrl, phoneNumber: $phoneNumber, fcmToken: $fcmToken)';
  }
}
