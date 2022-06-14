import 'package:json_annotation/json_annotation.dart';

part 'moment_vo.g.dart';

@JsonSerializable()
class MomentVO {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'description')
  String? description;

  @JsonKey(name: 'post_image_url')
  String? postImageUrl;

  @JsonKey(name: 'is_file_type_video')
  bool? isFileTypeVideo;

  @JsonKey(name: 'profile_url')
  String? profilePicUrl;

  @JsonKey(name: 'user_name')
  String? userName;

  bool? isUserMoment;

  MomentVO({
    this.id,
    this.description,
    this.postImageUrl,
    this.isFileTypeVideo,
    this.profilePicUrl,
    this.userName,
    this.isUserMoment,
  });

  factory MomentVO.fromJson(Map<String, dynamic> json) =>
      _$MomentVOFromJson(json);
  Map<String, dynamic> toJson() => _$MomentVOToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MomentVO &&
        other.id == id &&
        other.description == description &&
        other.postImageUrl == postImageUrl &&
        other.isFileTypeVideo == isFileTypeVideo &&
        other.profilePicUrl == profilePicUrl &&
        other.userName == userName &&
        other.isUserMoment == isUserMoment;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        postImageUrl.hashCode ^
        isFileTypeVideo.hashCode ^
        profilePicUrl.hashCode ^
        userName.hashCode ^
        isUserMoment.hashCode;
  }

  @override
  String toString() {
    return 'MomentVO(id: $id, description: $description, postImageUrl: $postImageUrl, isFileTypeVideo: $isFileTypeVideo, profilePicUrl: $profilePicUrl, userName: $userName, isUserMoment: $isUserMoment)';
  }
}
