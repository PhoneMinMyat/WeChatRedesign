// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageVO _$MessageVOFromJson(Map<String, dynamic> json) => MessageVO(
      timestamp: json['timestamp'] as int?,
      fileUrl: json['file_url'] as String?,
      isFileTypeVideo: json['is_file_type_video'] as bool?,
      message: json['message'] as String?,
      sentUserId: json['sent_user_id'] as String?,
      sentUserProfileUrl: json['sent_user_profile_url'] as String?,
      sentUserName: json['sent_user_name'] as String?,
      receivedUserId: json['received_user_id'] as String?,
      receivedUserProfileUrl: json['received_user_profile_url'] as String?,
      receivedUserName: json['received_user_name'] as String?,
    );

Map<String, dynamic> _$MessageVOToJson(MessageVO instance) => <String, dynamic>{
      'timestamp': instance.timestamp,
      'file_url': instance.fileUrl,
      'is_file_type_video': instance.isFileTypeVideo,
      'message': instance.message,
      'sent_user_id': instance.sentUserId,
      'sent_user_profile_url': instance.sentUserProfileUrl,
      'sent_user_name': instance.sentUserName,
      'received_user_id': instance.receivedUserId,
      'received_user_profile_url': instance.receivedUserProfileUrl,
      'received_user_name': instance.receivedUserName,
    };
