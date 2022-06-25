import 'package:flutter/cupertino.dart';
import 'package:wechat_redesign/data/models/authentication_model.dart';
import 'package:wechat_redesign/data/models/authentication_model_impl.dart';
import 'package:wechat_redesign/data/models/wechat_model.dart';
import 'package:wechat_redesign/data/models/wechat_model_impl.dart';
import 'package:wechat_redesign/data/vos/conversation_vo.dart';
import 'package:wechat_redesign/network/we_chat_data_agent.dart';
import 'package:wechat_redesign/network/we_chat_data_agent_impl.dart';

class WeChatMessageBloc extends ChangeNotifier {
  bool isDisposed = false;
  List<ConversationVO>? conversationList;
  String loggedInUserId = '';
  bool deleteForAllUsers = false;
  bool isConfirmDialogShow = false;
  String? selectUserIdToDelete;

  WeChatDataAgent dataAgent = WeChatDataAgentImpl();
  WeChatModel model = WeChatModelImpl();
  AuthenticationModel authenticationModel = AuthenticationModelImpl();

  WeChatMessageBloc() {
    authenticationModel.getLoggedInUser().then((user) {
      loggedInUserId = user.id ?? '';
      model.getConversationList(user.id ?? '').listen((conversationList) {
        this.conversationList = conversationList;
        this.conversationList?.sort(
          (a, b) {
            return b.lastMessageTimeStamp
                    ?.compareTo(a.lastMessageTimeStamp?.toInt() ?? 0) ??
                -1;
          },
        );
        safeNotifyListeners();
      });
      //dataAgent.getTestConverstaionList(loggedInUserId);
    });
  }

  Future<void> onTapDelete() {
    if (selectUserIdToDelete != null) {
      return model
          .deleteMessage(
              loggedInUserId, selectUserIdToDelete ?? '', deleteForAllUsers)
          .then((value){
            hideConfirmDialog();
            deleteForAllUsers= false;
            safeNotifyListeners();
          });
    } else {
      return Future.error('error');
    }
  }

  void onTapCheckBox(newValue) {
    print('NewValue ===> $newValue');
    deleteForAllUsers = newValue;
    safeNotifyListeners();
  }

  void showConfirmDialog(String selectUserId) {
    selectUserIdToDelete = selectUserId;
    print('SelectUserId ====> $selectUserIdToDelete');
    isConfirmDialogShow = true;
    safeNotifyListeners();
  }

  void hideConfirmDialog() {
    selectUserIdToDelete = null;
    isConfirmDialogShow = false;
    safeNotifyListeners();
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
