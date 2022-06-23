class ConversationVO {
  String? name;
  String? profilePictureUrl;
  String? userId;
  String? lastMessage;
  int? lastMessageTimeStamp;
  ConversationVO({
    this.name,
    this.profilePictureUrl,
    this.userId,
    this.lastMessage,
    this.lastMessageTimeStamp,
  });

  String getLastMessage(){
    if(lastMessage?.isEmpty ?? true){
      return 'Sent a message';
    }else{
      return lastMessage ?? '';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConversationVO &&
        other.name == name &&
        other.profilePictureUrl == profilePictureUrl &&
        other.userId == userId &&
        other.lastMessage == lastMessage &&
        other.lastMessageTimeStamp == lastMessageTimeStamp;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        profilePictureUrl.hashCode ^
        userId.hashCode ^
        lastMessage.hashCode ^
        lastMessageTimeStamp.hashCode;
  }

  @override
  String toString() {
    return 'ConversationVO(name: $name, profilePictureUrl: $profilePictureUrl, userId: $userId, lastMessage: $lastMessage, lastMessageTimeStamp: $lastMessageTimeStamp)';
  }
}
