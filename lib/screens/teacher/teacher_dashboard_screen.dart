import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'attendance_list_screen.dart';
import 'qr_generate_screen.dart';

class TeacherDashboardScreen extends StatefulWidget {
  final String teacherNidn;
  final String teacherName;

  TeacherDashboardScreen({required this.teacherNidn, required this.teacherName});

  @override
  _TeacherDashboardScreenState createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  List<dynamic> enrolledCourses = [];

  @override
  void initState() {
    super.initState();
    fetchEnrolledCourses();
  }

  Future<void> fetchEnrolledCourses() async {
    final response = await http.get(
      Uri.parse('../teachers/${widget.teacherNidn}/courses'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        enrolledCourses = data;
      });
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
        title: Text('Teacher Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${widget.teacherName}!',
              style: TextStyle(fontSize: 20),
            ),
            for (var course in enrolledCourses)
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRGenerateScreen(
                            courseId: course['courseId'],
                            teacherNidn: widget.teacherNidn,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      '${course['courseName']}',
                      style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRGenerateScreen(
                            courseId: course['courseId'],
                            teacherNidn: widget.teacherNidn,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.qr_code),
                    label: Text('Generate QR Code'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttendanceListScreen(
                            courseId: course['courseId'],
                            teacherNidn: widget.teacherNidn,
                          ),
                        ),
                      );
                    },
                    child: Text('View Attendances'),
                  ),
                ],
              ),

          ],
        ),
      ),
    );
  }
}
