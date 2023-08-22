import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'attendance_list_screen.dart';
import 'qr_generate_screen.dart';

class TeacherDashboardScreen extends StatefulWidget {
  final String teacherNidn;

  TeacherDashboardScreen({required this.teacherNidn});

  @override
  _TeacherDashboardScreenState createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  String courseId = '';
  String qrCodeData = '';

  @override
  void initState() {
    super.initState();
    fetchCourseData();
  }

  Future<void> fetchCourseData() async {
    final response = await http.get(
      Uri.parse('YOUR_COURSE_API_ENDPOINT_HERE'), // Replace with actual API endpoint
    );

    if (response.statusCode == 200) {
      final courseData = json.decode(response.body);
      setState(() {
        courseId = courseData['course_id'];
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
        title: Text('Teacher Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, Teacher!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'NIDN: ${widget.teacherNidn}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            courseId.isNotEmpty
                ? ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceListScreen(
                      courseId: courseId,
                      teacherNidn: widget.teacherNidn,
                    ),
                  ),
                );
              },
              child: Text('View Attendance'),
            )
                : CircularProgressIndicator(),
            SizedBox(height: 20),
            qrCodeData.isNotEmpty
                ? ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QrGenerateScreen(
                      courseId: courseId,
                      qrCodeData: qrCodeData,
                      teacherNidn: widget.teacherNidn,
                    ),
                  ),
                );
              },
              child: Text('Generate QR Code'),
            )
                : CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
