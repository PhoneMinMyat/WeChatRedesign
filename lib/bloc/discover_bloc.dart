import 'package:flutter/cupertino.dart';
import 'package:wechat_redesign/data/models/wechat_model.dart';
import 'package:wechat_redesign/data/models/wechat_model_impl.dart';
import 'package:wechat_redesign/data/vos/moment_vo.dart';

class DiscoverBloc extends ChangeNotifier {
  bool isDisposed = false;
  List<MomentVO>? momentList;
  bool isAddCommentShow = false;
  bool isMomentDetailsShow = false;

  MomentVO? choseMomentToShowDetails;

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

  void onTapAddComment(int momentId) {
    isAddCommentShow = true;
    safeNotifyListeners();
  }

  void onTapMomentDetails(MomentVO selectMoment) {
    isMomentDetailsShow = true;
    choseMomentToShowDetails = selectMoment;
    safeNotifyListeners();
  }

  void onTapCloseMomentDetails(){
    isMomentDetailsShow = false;
    choseMomentToShowDetails = null;
    safeNotifyListeners();
  }

  Future onTapPostDelete(int momentId) {
    isMomentDetailsShow = false;
    choseMomentToShowDetails = null;
    safeNotifyListeners();
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
