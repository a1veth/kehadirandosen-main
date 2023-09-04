import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class QRGenerateScreen extends StatefulWidget {
  final String courseId;
  final String teacherNidn;

  QRGenerateScreen({required this.courseId, required this.teacherNidn});

  @override
  _QRGenerateScreenState createState() => _QRGenerateScreenState();
}

class _QRGenerateScreenState extends State<QRGenerateScreen> {
  bool qrCodeActive = false;
  String qrCodeData = '';

  @override
  void initState() {
    super.initState();
    generateQRCode();
  }

  Future<void> generateQRCode() async {
    String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    qrCodeData = '${widget.courseId}-${widget.teacherNidn}-$currentDate';
    setState(() {
      qrCodeActive = true;
    });

    final response = await http.post(
      Uri.parse('http://localhost:8080/api/generate-qr-code'),
      body: {
        'qrCodeData': qrCodeData,
        'course_id': widget.courseId,
      },
    );

    if (response.statusCode == 200) {
      // Successfully posted QR code data
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('An unexpected error occurred.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

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
            if (qrCodeActive)
              QrImageView(
                data: qrCodeData,
                size: 200,
              ),
            SizedBox(height: 20),
            Text(
              qrCodeActive
                  ? 'QR Code ready to scan'
                  : 'Generating QR Code...',
            ),
          ],
        ),
      ),
    );
  }
}
