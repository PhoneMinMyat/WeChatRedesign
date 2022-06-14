// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moment_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MomentVO _$MomentVOFromJson(Map<String, dynamic> json) => MomentVO(
      id: json['id'] as int?,
      description: json['description'] as String?,
      postImageUrl: json['post_image_url'] as String?,
      isFileTypeVideo: json['is_file_type_video'] as bool?,
      profilePicUrl: json['profile_url'] as String?,
      userName: json['user_name'] as String?,
      isUserMoment: json['isUserMoment'] as bool?,
    );

Map<String, dynamic> _$MomentVOToJson(MomentVO instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'post_image_url': instance.postImageUrl,
      'is_file_type_video': instance.isFileTypeVideo,
      'profile_url': instance.profilePicUrl,
      'user_name': instance.userName,
      'isUserMoment': instance.isUserMoment,
    };
