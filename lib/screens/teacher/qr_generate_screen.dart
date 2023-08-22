import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

class QrGenerateScreen extends StatefulWidget {
  final Map<String, dynamic> courseData;

  QrGenerateScreen({required this.courseData});

  @override
  _QrGenerateScreenState createState() => _QrGenerateScreenState();
}

class _QrGenerateScreenState extends State<QrGenerateScreen> {
  String qrCodeData = '';

  @override
  void initState() {
    super.initState();
    generateQrCodeData();
  }

  Future<void> generateQrCodeData() async {
    final courseId = widget.courseData['id'];

    final response = await http.get(
      Uri.parse('YOUR_API_ENDPOINT_HERE/courses/$courseId'),
    );

    if (response.statusCode == 200) {
      final courseData = json.decode(response.body);
      setState(() {
        qrCodeData = courseData['qr_code_data'];
      });
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate QR Code'),
      ),
      body: Center(
        child: qrCodeData.isNotEmpty
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: qrCodeData,
              version: QrVersions.auto,
              size: 200.0,
            ),
            SizedBox(height: 16.0),
            Text('Scan this QR code for attendance'),
          ],
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}


