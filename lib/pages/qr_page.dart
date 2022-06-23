import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_redesign/bloc/qr_bloc.dart';
import 'package:wechat_redesign/pages/qr_scan_page.dart';
import 'package:wechat_redesign/resources/colors.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wechat_redesign/resources/dimens.dart';

class QrViewPage extends StatelessWidget {
  const QrViewPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QrBloc(),
      child: Consumer<QrBloc>(
        builder: (context, bloc, child) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: kRegistrationBlackColor,
          body: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: kMarginMedium3, vertical: kMarginMedium2),
              decoration: BoxDecoration(
                  color: kPrimaryGreenColor,
                  borderRadius: BorderRadius.circular(kMarginMedium2)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: kMarginXLarge,
                    backgroundImage: NetworkImage(bloc.userProfileUrl),
                  ),
                  const SizedBox(
                    height: kMarginMedium2,
                  ),
                  QrImage(
                    data: bloc.userId,
                    version: QrVersions.auto,
                    size: 300,
                    semanticsLabel: bloc.userName,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(
                    height: kMarginMedium2,
                  ),
                  Text(
                    bloc.userName,
                    style: const TextStyle(
                        color: Colors.white, fontSize: kTextRegular3x),
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const QrScanPage()));
            },
            backgroundColor: kPrimaryGreenColor,
            child: const Icon(Icons.camera_alt),
          ),
        ),
      ),
    );
  }
}
