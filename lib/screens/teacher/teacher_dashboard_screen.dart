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
      Uri.parse('http://localhost:8080/api/teacher-courses/${widget.teacherNidn}')
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
      body: enrolledCourses.isNotEmpty
          ? ListView.builder(
        itemCount: enrolledCourses.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: [
                Text(enrolledCourses[index]['course_name']),
                IconButton(
                  icon: Icon(Icons.qr_code),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QRGenerateScreen(
                            teacherNidn: widget.teacherNidn,
                            courseId: enrolledCourses[index]['id']
                        ), // Navigate to QR scan screen
                      ),
                    );
                  },
                ),
              ],
            ),
            subtitle:
            Text('Course Details'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceListScreen(
                    courseId: enrolledCourses[index]['id'],
                    teacherNidn: widget.teacherNidn,
                  ),
                ),
              );
            },
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

// test