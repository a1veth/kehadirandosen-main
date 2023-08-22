import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;

class QRScanScreen extends StatefulWidget {
  final String studentNim;

  QRScanScreen({required this.studentNim});

  @override
  _QRScanScreenState createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  Future<void> scanQRCode() async {
    String? qrCodeData = await scanner.scan();

    if (qrCodeData != null) {
      // Send QR code data to the server
      await markAttendance(qrCodeData);
    }
  }

  Future<void> markAttendance(String qrCodeData) async {
    final response = await http.post(
      Uri.parse('YOUR_API_ENDPOINT_HERE/attendances/mark'),
      body: {
        'qr_code_data': qrCodeData,
      },
    );

    if (response.statusCode == 200) {
      // Handle successful attendance marking
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Attendance Marked'),
          content: Text('Your attendance has been marked.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: scanQRCode,
          child: Text('Scan QR Code'),
        ),
      ),
    );
  }
}

