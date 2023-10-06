import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'course_details_screen.dart';
import 'qr_scan_screen.dart';

class StudentDashboardScreen extends StatefulWidget {
  final String studentNim;

  StudentDashboardScreen({required this.studentNim});

  @override
  _StudentDashboardScreenState createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  List<dynamic> enrolledCourses = [];

  @override
  void initState() {
    super.initState();
    fetchEnrolledCourses();
  }

  Future<void> fetchEnrolledCourses() async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/students/${widget.studentNim}/courses'),
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
        title: Text('Student Dashboard'),
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
                        builder: (context) => QRScanScreen(
                            studentNim: widget.studentNim,
                            courseId: enrolledCourses[index]['id']
                        ), // Navigate to QR scan screen
                      ),
                    );
                  },
                ),
              ],
            ),
            subtitle:
            Text('Teacher: ${enrolledCourses[index]['teacher']['name']}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailsScreen(
                    courseId: enrolledCourses[index]['id'],
                    studentNim: widget.studentNim,
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