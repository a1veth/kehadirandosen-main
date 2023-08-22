import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

class QrGenerateScreen extends StatefulWidget {
  final String courseId;
  final String qrCodeData;
  final String teacherNidn;

  QrGenerateScreen({
    required this.courseId,
    required this.qrCodeData,
    required this.teacherNidn,
  });

  @override
  _QrGenerateScreenState createState() => _QrGenerateScreenState();
}

class _QrGenerateScreenState extends State<QrGenerateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: widget.qrCodeData,
              version: QrVersions.auto,
              size: 200.0,
            ),
            SizedBox(height: 16.0),
            Text('Scan this QR code for attendance'),
          ],
        ),
      ),
    );
  }
}
