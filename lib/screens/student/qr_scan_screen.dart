import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;

class QRScanScreen extends StatefulWidget {
  final String studentNim;
  final String courseId;

  QRScanScreen({required this.studentNim, required this.courseId});

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
      Uri.parse('http://localhost:8080/attendance/mark'),
      body: {
        'qr_code_data': qrCodeData,
        'course_id': widget.courseId,
        'student_nim': widget.studentNim,
        'status': 'marked',
        'attendance_date': DateTime.now().toString(),
      },
    );

    if (response.statusCode == 200) {
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
    } else if (response.statusCode == 400) {
      // Handle the case where the server responds with a 400 status code,
      // indicating that the attendance has already been marked.
      final data = json.decode(response.body);
      final errorMessage = data['error']; // Retrieve the error message from the server.

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
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
        title: Text('Student Attendance'),
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
