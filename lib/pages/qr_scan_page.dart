import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:wechat_redesign/bloc/qr_scan_bloc.dart';
import 'package:wechat_redesign/pages/home_page.dart';
import 'package:wechat_redesign/resources/colors.dart';
import 'package:wechat_redesign/resources/dimens.dart';
import 'package:wechat_redesign/resources/strings.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({Key? key}) : super(key: key);

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QrScanBloc(),
      child: Consumer<QrScanBloc>(
        builder: (context, bloc, child) => Scaffold(
          body: (bloc.isConfirmPage)
              ? const ConfirmView()
              : QRView(
                  key: qrKey,
                  onQRViewCreated: (qrViewController) {
                    bloc.onQRViewCreated(qrViewController,
                        getScanned: (scanData) {
                      bloc.getScannedData(scanData).then((value) {});
                    });
                  },
                  overlay: QrScannerOverlayShape(
                      borderColor: kPrimaryGreenColor,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: 300),
                ),
        ),
      ),
    );
  }
}

class ConfirmView extends StatelessWidget {
  const ConfirmView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryGreenColor,
      child: Center(
        child: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(kMarginMedium3),
          ),
          child: const ContentBox(),
        ),
      ),
    );
  }
}

class ContentBox extends StatelessWidget {
  const ContentBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<QrScanBloc>(
      builder: (context, bloc, child) => SizedBox(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: ContentBoxBottomPart(
                friendName: bloc.searchedUser?.userName ?? '',
                onTapAddFriend: () {
                  bloc.addUser().then((value){
                     Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage(
                                sentPage: PageName.contactsView,
                              )),
                      (route) => false);
                  });
                },
                onTapCancel: () {
                  bloc.closeConfirmView();
                },
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: -kMarginXXLarge,
              child: CircleAvatar(
                radius: kMarginXXLarge,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(kMarginXXLarge),
                  child: Image.network(
                    bloc.searchedUser?.profilePictureUrl ??
                        NETWORK_PROFILE_PLACEHOLDER,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ContentBoxBottomPart extends StatelessWidget {
  final Function onTapAddFriend;
  final Function onTapCancel;
  final String friendName;
  const ContentBoxBottomPart({
    Key? key,
    required this.onTapAddFriend,
    required this.friendName,
    required this.onTapCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            friendName,
            style: const TextStyle(color: Colors.white, fontSize: kTextHeading),
          ),
          const SizedBox(
            height: kMarginMedium2,
          ),
          GestureDetector(
            onTap: () {
              onTapAddFriend();
            },
            child: Container(
              padding: const EdgeInsets.all(kMarginMedium),
              decoration: BoxDecoration(
                  color: kPrimaryGreenColor,
                  borderRadius: BorderRadius.circular(kMarginMedium3)),
              child: const Text(
                kLblAddFriend,
                style: TextStyle(color: Colors.white, fontSize: kTextHeading),
              ),
            ),
          ),
          const SizedBox(
            height: kMarginMedium,
          ),
          TextButton(
              onPressed: () {
                onTapCancel();
              },
              child: const Text(
                kLblCancel,
                style: TextStyle(color: Colors.white),
              ))
        ]);
  }
}


//  bloc.onQRViewCreated(qrViewController, getScanned: (scanData) {
//                 QrScanBloc bloc = Provider.of(context, listen: false);
//                 bloc.getScannedData(scanData).then((value) {
//                   Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const HomePage(
//                                 sentPage: PageName.contactsView,
//                               )),
//                       (route) => false);
//                 });
//               });