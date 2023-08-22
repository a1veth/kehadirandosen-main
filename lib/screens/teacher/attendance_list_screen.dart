import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AttendanceListScreen extends StatefulWidget {
  final String courseId;

  AttendanceListScreen({required this.courseId});

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
      Uri.parse('YOUR_API_ENDPOINT_HERE/courses/${widget.courseId}/attendance'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        attendanceList = data;
      });
    } else {
      // Handle error
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
            subtitle: Text(
                'NIM: ${attendanceList[index]['student']['nim']}'),
            trailing: Text(
                'Status: ${attendanceList[index]['status']}'),
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
