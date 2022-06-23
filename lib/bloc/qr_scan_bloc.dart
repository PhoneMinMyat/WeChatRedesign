import 'package:flutter/foundation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:wechat_redesign/data/models/authentication_model.dart';
import 'package:wechat_redesign/data/models/authentication_model_impl.dart';
import 'package:wechat_redesign/data/models/wechat_model.dart';
import 'package:wechat_redesign/data/models/wechat_model_impl.dart';

class QrScanBloc extends ChangeNotifier {
  bool isDisposed = false;

  Barcode? scannedResult;
  QRViewController? controller;
  String? loggedInUserId;

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
      return weChatModel.addContact(
          loggedInUserId ?? '', scannedResult?.code ?? '');
    } else {
      return Future.error('No User Detected');
    }
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
