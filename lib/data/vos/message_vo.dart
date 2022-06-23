import 'package:json_annotation/json_annotation.dart';

part 'message_vo.g.dart';

@JsonSerializable()
class MessageVO {
  @JsonKey(name: 'timestamp')
  int? timestamp;

  @JsonKey(name: 'file_url')
  String? fileUrl;

  @JsonKey(name: 'is_file_type_video')
  bool? isFileTypeVideo;

  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'sent_user_id')
  String? sentUserId;

  @JsonKey(name: 'sent_user_profile_url')
  String? sentUserProfileUrl;

  @JsonKey(name: 'sent_user_name')
  String? sentUserName;

  @JsonKey(name: 'received_user_id')
  String? receivedUserId;

  @JsonKey(name: 'received_user_profile_url')
  String? receivedUserProfileUrl;

  @JsonKey(name: 'received_user_name')
  String? receivedUserName;

  bool? isUserMessage;

  MessageVO({
    this.timestamp,
    this.fileUrl,
    this.isFileTypeVideo,
    this.message,
    this.sentUserId,
    this.sentUserProfileUrl,
    this.sentUserName,
    this.receivedUserId,
    this.receivedUserProfileUrl,
    this.receivedUserName,
    this.isUserMessage,
  });

  String getUserNameById(String userId){
    if(userId == sentUserId){
      return sentUserName ?? '';
    }
    else{
      return receivedUserName ?? '';
    }
  }

   String getUserProfileById(String userId){
    if(userId == sentUserId){
      return sentUserProfileUrl ?? '';
    }
    else{
      return receivedUserProfileUrl ?? '';
    }
  }

  factory MessageVO.fromJson(Map<String, dynamic> json) =>
      _$MessageVOFromJson(json);

  Map<String, dynamic> toJson() => _$MessageVOToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageVO &&
        other.timestamp == timestamp &&
        other.fileUrl == fileUrl &&
        other.isFileTypeVideo == isFileTypeVideo &&
        other.message == message &&
        other.sentUserId == sentUserId &&
        other.sentUserProfileUrl == sentUserProfileUrl &&
        other.sentUserName == sentUserName &&
        other.receivedUserId == receivedUserId &&
        other.receivedUserProfileUrl == receivedUserProfileUrl &&
        other.receivedUserName == receivedUserName &&
        other.isUserMessage == isUserMessage;
  }

  @override
  int get hashCode {
    return timestamp.hashCode ^
        fileUrl.hashCode ^
        isFileTypeVideo.hashCode ^
        message.hashCode ^
        sentUserId.hashCode ^
        sentUserProfileUrl.hashCode ^
        sentUserName.hashCode ^
        receivedUserId.hashCode ^
        receivedUserProfileUrl.hashCode ^
        receivedUserName.hashCode ^
        isUserMessage.hashCode;
  }

  @override
  String toString() {
    return 'MessageVO(timestamp: $timestamp, fileUrl: $fileUrl, isFileTypeVideo: $isFileTypeVideo, message: $message, sentUserId: $sentUserId, sentUserProfileUrl: $sentUserProfileUrl, sentUserName: $sentUserName, receivedUserId: $receivedUserId, receivedUserProfileUrl: $receivedUserProfileUrl, receivedUserName: $receivedUserName, isUserMessage: $isUserMessage)';
  }
}
