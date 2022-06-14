import 'package:flutter/cupertino.dart';
import 'package:wechat_redesign/data/models/wechat_model.dart';
import 'package:wechat_redesign/data/models/wechat_model_impl.dart';
import 'package:wechat_redesign/data/vos/moment_vo.dart';

class DiscoverBloc extends ChangeNotifier {
  bool isDisposed = false;
  List<MomentVO>? momentList;

  final WeChatModel model = WeChatModelImpl();

  DiscoverBloc() {
    model.getMoment().listen((momentList) {
      this.momentList = momentList.map((moment) {
        MomentVO tempMoment = moment;
        tempMoment.isUserMoment = (moment.userName == 'Phone Min Myat');

        return tempMoment;
      }).toList();
      safeNotifyListeners();
    });
  }

  Future onTapPostDelete(int momentId){
    return model.deleteMoment(momentId);
  }

  void safeNotifyListeners() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
