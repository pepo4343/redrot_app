import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/presentation/themes/app_colors.dart';
import 'package:redrotapp/presentation/widgets/primary_button.dart';
import 'package:redrotapp/presentation/widgets/redrot_app_bar.dart';
import 'package:redrotapp/presentation/widgets/redrot_dark_app_bar.dart';
import 'package:redrotapp/presentation/widgets/secondary_button.dart';
import '../../themes/app_theme.dart';

class QrScreen extends StatefulWidget {
  @override
  _QrScreenState createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? _result;
  bool _isScanned = false;

  late QRViewController _controller;
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller.pauseCamera();
    } else if (Platform.isIOS) {
      _controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RedrotDarkAppBar(
        title: "โปรดแสกน QR code",
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    _controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (_isScanned) {
        return;
      }

      _isScanned = true;
      final isConfrim = await Navigator.of(context)
          .push(QRCodeConfirmOverlay(scanData.code)) as bool;
      if (isConfrim) {
        setState(() {
          _result = scanData;
        });
        Navigator.of(context).pushNamed("/addclone", arguments: scanData.code);
      } else {}
      await Future.delayed(Duration(seconds: 1));
      _isScanned = false;
      // setState(() {

      //   _result = scanData;
      // });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class QRCodeConfirmOverlay extends ModalRoute<void> {
  final String qrData;
  QRCodeConfirmOverlay(this.qrData);

  @override
  Color? get barrierColor => Colors.black87;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          padding: EdgeInsets.all(Sizes.dimen_24),
          width: double.infinity,
          decoration: BoxDecoration(
              color: theme.colorScheme.cardColor,
              borderRadius: const BorderRadius.all(
                const Radius.circular(10),
              )),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                qrData,
                style: theme.textTheme.headline5,
              ),
              Text(
                "โปรดตรวจสอบชื่อพันธุ์",
                style: theme.textTheme.bodyText2?.copyWith(
                  color: theme.colorScheme.secondaryTextColor,
                ),
              ),
              SizedBox(
                height: Sizes.dimen_16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SecondaryButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    text: "ยกเลิก",
                  ),
                  SizedBox(
                    width: Sizes.dimen_8,
                  ),
                  PrimaryButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    text: 'ยืนยัน',
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final _curvedAnimation = animation.drive(CurveTween(curve: Curves.ease));
    final _scaleAnimation = Tween<double>(begin: 0.8, end: 1)
        .animate(CurvedAnimation(parent: animation, curve: Curves.ease));
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: _curvedAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: child,
      ),
    );
  }

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);
}
