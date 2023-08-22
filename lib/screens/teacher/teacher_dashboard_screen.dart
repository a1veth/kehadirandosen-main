import 'package:flutter/material.dart';
import 'attendance_list_screen.dart';
import 'qr_generate_screen.dart';

class TeacherDashboardScreen extends StatefulWidget {
  final String teacherNidn;
  final String courseId;

  TeacherDashboardScreen({required this.teacherNidn, required this.courseId});

  @override
  _TeacherDashboardScreenState createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceListScreen(
                      teacherNidn: widget.teacherNidn,
                    ),
                  ),
                );
              },
              child: Text('View Attendance'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QrGenerateScreen(
                      teacherNidn: widget.teacherNidn,
                    ),
                  ),
                );
              },
              child: Text('Generate QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
