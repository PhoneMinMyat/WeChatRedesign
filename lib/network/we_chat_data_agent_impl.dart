import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wechat_redesign/data/vos/moment_vo.dart';
import 'package:wechat_redesign/network/we_chat_data_agent.dart';

const momentsCollection = 'moments';
const uploadPath = 'uploads';

class WeChatDataAgentImpl extends WeChatDataAgent {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

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
}
