import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:wechat_redesign/bloc/qr_scan_bloc.dart';
import 'package:wechat_redesign/pages/home_page.dart';
import 'package:wechat_redesign/resources/colors.dart';

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
          body: QRView(
            key: qrKey,
            onQRViewCreated: (qrViewController) {
              bloc.onQRViewCreated(qrViewController, getScanned: (scanData) {
                QrScanBloc bloc = Provider.of(context, listen: false);
                bloc.getScannedData(scanData).then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage(sentPage: PageName.contactsView,)),
                      (route) => false);
                });
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
