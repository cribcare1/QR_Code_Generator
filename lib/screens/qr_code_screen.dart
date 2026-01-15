import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/qr_crypto_helper.dart';

class QrCodeScreen extends StatefulWidget {
  final String data;
  final String selectedData;

  const QrCodeScreen(
      {super.key, required this.data, required this.selectedData});

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {

  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> shareQrCode() async {
    try {
      final Uint8List? imageBytes =
          await screenshotController.capture(pixelRatio: 3.0);

      if (imageBytes == null) return;

      final pdf = pw.Document();

      final image = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Center(
              child: pw.Image(image, width: 400),
            );
          },
        ),
      );

      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/Qr_${widget.selectedData}_${widget.data}.pdf',
      );

      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      debugPrint("Error sharing QR Code PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: const Text(
            "Qr Code",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: shareQrCode,
            ),
          ]),
      body: Screenshot(
        controller: screenshotController,
        child: (widget.selectedData.contains("Dot"))
            ? _qrWithBlackImage()
            : qrWithCenterImage(), //_qrWithBlackImage  qrWithCenterImage
      ),
    );
  }

  Widget _qrWithImage() {
    return Center(
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black),
        ),
        child: AspectRatio(
          aspectRatio: 1, // 👈 removes extra space
          child: PrettyQrView.data(
            data: QrCryptoHelper.encryptQR(widget.data),
            errorCorrectLevel: QrErrorCorrectLevel.H,
            decoration: const PrettyQrDecoration(
              background: Colors.white,
              quietZone: PrettyQrQuietZone.zero,
              shape: PrettyQrShape.custom(
                PrettyQrSquaresSymbol(
                  color: Colors.black,
                  density: 0.50,
                  rounding: 0.15,
                ),
                finderPattern: PrettyQrSmoothSymbol(
                  color: Colors.black,
                  roundFactor: 0.1,
                ),

              ),
              image: PrettyQrDecorationImage(
                image: AssetImage('assets/images/qr_logo_without_bg.png'),
                position: PrettyQrDecorationImagePosition.embedded,
                scale: 0.30,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget qrWithoutImage() {
    return Center(
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(12),
          // border: Border.all(color: Colors.black),
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: QrImageView(
            data: QrCryptoHelper.encryptQR(widget.data),
            version: QrVersions.auto,
            errorCorrectionLevel: QrErrorCorrectLevel.H,
            backgroundColor: Colors.white,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Colors.black,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget qrWithCenterImage() {
    return Center(
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 🔹 QR Code
              QrImageView(
                data: QrCryptoHelper.encryptQR(widget.data),
                version: QrVersions.auto,
                errorCorrectionLevel: QrErrorCorrectLevel.H,
                backgroundColor: Colors.white,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Colors.black,
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Colors.black,
                ),
              ),

              // 🔹 Clean white cut-out (removes QR noise)
              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // 🔹 Center Logo
              Image.asset(
                'assets/images/qr_logo_without_bg.png',
                width: 55,
                height: 55,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );


  }

  Widget _qrWithBlackImage() {
    return Center(
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(12),
          // border: Border.all(color: Colors.black),
        ),
        child: AspectRatio(
          aspectRatio: 1, // 👈 removes extra space
          child: PrettyQrView.data(
            data: QrCryptoHelper.encryptQR(widget.data),
            errorCorrectLevel: QrErrorCorrectLevel.H,
            decoration: const PrettyQrDecoration(
              background: Colors.white,
              quietZone: PrettyQrQuietZone.zero,
              shape: PrettyQrShape.custom(
                PrettyQrSquaresSymbol(
                  color: Colors.black,
                  density: 0.50,
                  rounding: 0.15,
                ),
                finderPattern: PrettyQrSmoothSymbol(
                  color: Colors.black,
                  roundFactor: 0.1,
                ),
              ),
              image: PrettyQrDecorationImage(
                image: AssetImage('assets/images/qr_logo_without_bg.png'),
                position: PrettyQrDecorationImagePosition.embedded,
                scale: 0.30,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
