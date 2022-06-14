import 'dart:io';

import 'package:wechat_redesign/data/vos/moment_vo.dart';

abstract class WeChatModel {
  Stream<List<MomentVO>> getMoment();
  Future<void> addNewMoment(String description, File? file, bool isVideo);
  Future<void> editNewMoment(MomentVO moment, File? file);
  Future<void> deleteMoment(int momentId);
  Stream<MomentVO> getMomentById(int momentId);
}
