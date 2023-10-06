import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AttendanceListScreen extends StatefulWidget {
  final String courseId;
  final String teacherNidn;

  AttendanceListScreen({required this.courseId, required this.teacherNidn});

  @override
  _AttendanceListScreenState createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends State<AttendanceListScreen> {
  List<dynamic> attendanceList = [];

  @override
  void initState() {
    super.initState();
    fetchAttendanceList();
  }

  Future<void> fetchAttendanceList() async {
    final response = await http.get(
      Uri.parse('http:/localhost:8080/api/attendance-list/${widget.courseId}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        attendanceList = data;
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
        title: Text('Attendance List'),
      ),
      body: attendanceList.isNotEmpty
          ? ListView.builder(
        itemCount: attendanceList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(attendanceList[index]['student']['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NIM: ${attendanceList[index]['student']['nim']}'),
                Text('Status: ${attendanceList[index]['status']}'),
                Text('Date: ${attendanceList[index]['attendance_date']}'), // Display attendance date
              ],
            ),
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