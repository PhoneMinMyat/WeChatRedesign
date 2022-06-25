import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wechat_redesign/data/vos/conversation_vo.dart';
import 'package:wechat_redesign/data/vos/message_vo.dart';
import 'package:wechat_redesign/data/vos/moment_vo.dart';
import 'package:wechat_redesign/data/vos/user_vo.dart';
import 'package:wechat_redesign/network/we_chat_data_agent.dart';

const momentsCollection = 'moments';
const contactsCollection = 'contacts';
const uploadPath = 'uploads';
const userCollection = 'users';
const messageAndContactPath = 'messagesAndContacts';

class WeChatDataAgentImpl extends WeChatDataAgent {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _firebaseDatabase = FirebaseDatabase.instance.ref();

  @override
  Stream<List<MomentVO>> getMoments() {
    return _firestore
        .collection(momentsCollection)
        .snapshots()
        .map((querySnapShot) {
      return querySnapShot.docs.map<MomentVO>((document) {
        return MomentVO.fromJson(document.data());
      }).toList();
    });
  }

  @override
  Future<void> addNewMoment(MomentVO moment) {
    return _firestore
        .collection(momentsCollection)
        .doc(moment.id.toString())
        .set(moment.toJson());
  }

  @override
  Future<void> deleteMoment(int momentId) {
    return _firestore
        .collection(momentsCollection)
        .doc(momentId.toString())
        .delete();
  }

  @override
  Stream<MomentVO> getMomentById(int momentId) {
    return _firestore
        .collection(momentsCollection)
        .doc(momentId.toString())
        .get()
        .asStream()
        .where((documentSnapShot) => documentSnapShot.data() != null)
        .map((documentSnapShot) => MomentVO.fromJson(documentSnapShot.data()!));
  }

  @override
  Future<String> uploadFileToFirebase(File uploadFile) {
    String milisecondId = DateTime.now().millisecondsSinceEpoch.toString();
    return _firebaseStorage
        .ref(uploadPath)
        .child(milisecondId)
        .putFile(uploadFile)
        .then((taskSnapShot) => taskSnapShot.ref.getDownloadURL());
  }

  //Authentication
  @override
  Future registerNewUser(UserVO newUser) {
    print('Register New User Form Data Agent ===> ${newUser.toString()}');
    return _auth
        .createUserWithEmailAndPassword(
            email: newUser.email ?? '', password: newUser.password ?? '')
        .then((userCredential) =>
            userCredential.user?..updateDisplayName(newUser.userName))
        .then((user) {
      newUser.id = user?.uid;
      addNewUser(newUser);
    });
  }

  @override
  Future<void> addNewUser(UserVO newUser) {
    return _firestore
        .collection(userCollection)
        .doc(newUser.id.toString())
        .set(newUser.toJson());
  }

  @override
  Future<void> logInUser(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  bool isLoggedIn() {
    return (_auth.currentUser != null);
  }

  @override
  Future logOut() {
    return _auth.signOut();
  }

  @override
  Future<UserVO> getUserById(String userId) {
    return _firestore
        .collection(userCollection)
        .doc(userId)
        .get()
        .then((documnetSnapShot) {
      if (documnetSnapShot.data() != null) {
        return UserVO.fromJson(documnetSnapShot.data()!);
      } else {
        return Future.error('User Not Found');
      }
    });
  }

  @override
  Future<UserVO> getLogInUser() {
    return _firestore
        .collection(userCollection)
        .doc(_auth.currentUser?.uid.toString())
        .get()
        .then((documnetSnapShot) {
      if (documnetSnapShot.data() != null) {
        return UserVO.fromJson(documnetSnapShot.data()!);
      } else {
        return Future.error('User Not Found');
      }
    });
  }

  // Contacts

  @override
  Future addContact(UserVO sentUser, UserVO receivedUser) {
    return _firestore
        .collection(userCollection)
        .doc(sentUser.id.toString())
        .collection(contactsCollection)
        .doc(receivedUser.id.toString())
        .set(receivedUser.toJson())
        .then((value) {
      _firestore
          .collection(userCollection)
          .doc(receivedUser.id.toString())
          .collection(contactsCollection)
          .doc(sentUser.id.toString())
          .set(sentUser.toJson());
    });
  }

  @override
  Stream<List<UserVO>> getContactList(String userId) {
    return _firestore
        .collection(userCollection)
        .doc(userId)
        .collection(contactsCollection)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map<UserVO>((document) {
        return UserVO.fromJson(document.data());
      }).toList();
    });
  }

  @override
  Future<void> deleteMessage(
      String userId, String receiverId, bool isDeleteForAllUsers) {
    return _firebaseDatabase
        .child(messageAndContactPath)
        .child(userId)
        .child(receiverId)
        .remove()
        .then((value) {
      if (isDeleteForAllUsers) {
        _firebaseDatabase
            .child(messageAndContactPath)
            .child(receiverId)
            .child(userId)
            .remove();
      }
    });
  }

  @override
  Stream<List<ConversationVO>> getConversationList(String userId) {
    return _firebaseDatabase
        .child(messageAndContactPath)
        .child(userId)
        .onValue
        .map((event) {
      if (event.snapshot.value != null) {
        var data = event.snapshot.value as Map;
        return data.entries.map((e) {
          ConversationVO tempConversation = ConversationVO();
          tempConversation.userId = e.key.toString();
          var valueData = e.value as Map;

          List<MessageVO> messageList = valueData.values.map((rawData) {
            return MessageVO.fromJson(
                Map<String, dynamic>.from(rawData as Map));
          }).toList();

          messageList.sort(
            (a, b) {
              return a.timestamp?.compareTo(b.timestamp?.toInt() ?? 0) ?? -1;
            },
          );

          MessageVO tempMessage = messageList.last;
          // MessageVO tempMessage = MessageVO.fromJson(
          //     Map<String, dynamic>.from(valueData.values.last));
          //print(tempMessage.message);
          tempConversation.profilePictureUrl =
              tempMessage.getUserProfileById(e.key.toString());
          tempConversation.name = tempMessage.getUserNameById(e.key.toString());
          tempConversation.lastMessage = tempMessage.message;
          tempConversation.lastMessageTimeStamp = tempMessage.timestamp;
          return tempConversation;
        }).toList();
      } else {
        List<ConversationVO> tempList = [];
        return tempList;
      }
    });
    // return Stream.value(tempConversationList);
  }

  void getTestConverstaionList(String userId) {
    var data = _firebaseDatabase
        .child(messageAndContactPath)
        .child(userId)
        .onValue
        .map((event) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      return data.entries.map<ConversationVO>((mapValue) {
        ConversationVO tempConversation =
            ConversationVO(userId: mapValue.key.toString());
        var valueData = mapValue.value as Map;

        MessageVO tempMessage = MessageVO.fromJson(
            Map<String, dynamic>.from(valueData.values.first));
        tempConversation.profilePictureUrl =
            tempMessage.getUserProfileById(mapValue.key.toString());
        tempConversation.name =
            tempMessage.getUserNameById(mapValue.key.toString());
        tempConversation.lastMessage = tempMessage.message;
        tempConversation.lastMessageTimeStamp = tempMessage.timestamp;
        return tempConversation;
      });
    }).toList();

    print('data ===> $data');
  }

  void temp(String userId) {
    _firebaseDatabase
        .child(messageAndContactPath)
        .child(userId)
        .onValue
        .listen((event) {
      var keyData = event.snapshot.key;
      Map<String, dynamic> data =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      print('Data ==> $data');
      print('Data value ==> ${data.values}');
      print('Data Keys ==> ${data.keys}');
      print('Key Data ===> $keyData');
      print('Data first value ==> ${data.values.first}');
      data.forEach((key, value) {
        print('Key ===> $key');
        print('value ==> ${value}');
        MessageVO tempMessage =
            MessageVO.fromJson(Map<String, dynamic>.from(value as Map));
        print('Temp Message ===> ${tempMessage.message}');
      });

      // //var data = event.snapshot.children.map((snapshot) => snapshot.value).toList();
      // List<ConversationVO> tempConversationList = [];
      // var data = event.snapshot.value as Map;
      // //print('Data ===> $data');
      // data.forEach((key, value) {
      //   ConversationVO tempConversation = ConversationVO();
      //   tempConversation.userId = key.toString();
      //   //print('Key ==> $key');
      //   var valueData = value as Map;

      //   MessageVO tempMessage = MessageVO.fromJson(
      //       Map<String, dynamic>.from(valueData.values.first));
      //   //print(tempMessage.message);
      //   tempConversation.profilePictureUrl =
      //       tempMessage.getUserProfileById(key.toString());
      //   tempConversation.name = tempMessage.getUserNameById(key.toString());
      //   tempConversation.lastMessage = tempMessage.message;
      //   tempConversation.lastMessageTimeStamp = tempMessage.timestamp;
      //   tempConversationList.add(tempConversation);
      // });
    });
  }

  @override
  Stream<List<MessageVO>> getMessageList(String userId, String receiverId) {
    return _firebaseDatabase
        .child(messageAndContactPath)
        .child(userId)
        .child(receiverId)
        .onValue
        .map((event) {
      return event.snapshot.children.map<MessageVO>((snapshot) {
        return MessageVO.fromJson(
            Map<String, dynamic>.from(snapshot.value as Map));
      }).toList();
    });
  }

  @override
  Future<void> sentMessage(MessageVO message) {
    return _firebaseDatabase
        .child(messageAndContactPath)
        .child(message.sentUserId ?? '')
        .child(message.receivedUserId ?? '')
        .child(message.timestamp.toString())
        .set(message.toJson())
        .then((value) {
      _firebaseDatabase
          .child(messageAndContactPath)
          .child(message.receivedUserId ?? '')
          .child(message.sentUserId ?? '')
          .child(message.timestamp.toString())
          .set(message.toJson())
          .then((value) {
        print('Sent From Data Agent ===> ${message.toString()}');
      });
    });
  }
  
  @override
  Future<void> updateUserBioText(UserVO user) {
    return addNewUser(user);
  }
}
