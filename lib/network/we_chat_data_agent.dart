import 'dart:io';

import 'package:wechat_redesign/data/vos/moment_vo.dart';

abstract class WeChatDataAgent{
  Stream<List<MomentVO>> getMoments();
  Future<void> addNewMoment(MomentVO moment);
  Future<void> deleteMoment(int momentId);
  Stream<MomentVO> getMomentById(int momentId);
  Future<String> uploadFileToFirebase(File uploadFile);
}