import 'package:flutter/foundation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:wechat_redesign/data/models/authentication_model.dart';
import 'package:wechat_redesign/data/models/authentication_model_impl.dart';
import 'package:wechat_redesign/data/models/wechat_model.dart';
import 'package:wechat_redesign/data/models/wechat_model_impl.dart';
import 'package:wechat_redesign/data/vos/user_vo.dart';

class QrScanBloc extends ChangeNotifier {
  bool isDisposed = false;
  bool isConfirmPage = false;

  Barcode? scannedResult;
  QRViewController? controller;
  String? loggedInUserId;
  UserVO? searchedUser;

  WeChatModel weChatModel = WeChatModelImpl();
  AuthenticationModel authenticationModel = AuthenticationModelImpl();

  QrScanBloc() {
    authenticationModel.getLoggedInUser().then((user) {
      loggedInUserId = user.id;
      safeNotifyListeners();
    });
  }
  void onQRViewCreated(QRViewController controller,
      {required Function(Barcode) getScanned}) {
    this.controller = controller;
    this.controller?.resumeCamera();
    safeNotifyListeners();

    controller.scannedDataStream.listen((scanData) {
      getScanned(scanData);
    });
  }

  Future<void> getScannedData(Barcode data) {
    scannedResult = data;
    if (scannedResult != null &&
        scannedResult?.code != null &&
        (scannedResult?.code?.isNotEmpty ?? false)) {
      return weChatModel
          .getUserById(scannedResult?.code ?? '')
          .then((resultUser) {
        searchedUser = resultUser;
        openConfirmView();
        safeNotifyListeners();
      });
    } else {
      return Future.error('No User Detected');
    }
  }

  Future<void> addUser() {
    if (searchedUser != null) {
      return weChatModel.addContact(
          loggedInUserId ?? '', searchedUser?.id ?? '');
    } else {
      return Future.error('error');
    }
  }

  void openConfirmView(){
    isConfirmPage = true;
    safeNotifyListeners();
  }

  void closeConfirmView(){
    isConfirmPage = false;
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
