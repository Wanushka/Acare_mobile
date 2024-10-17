
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emergency Alert App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: EmergencyScreen(),
    );
  }
}

class EmergencyScreen extends StatelessWidget {
  final String apiUrl = 'http://localhost:5000/api/send-alert'; // Replace with your actual backend URL

  Future<void> sendAlert(BuildContext context, String message) async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': message,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Alert sent successfully")),
        );
      } else {
        throw Exception('Failed to send alert');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send alert: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'EMERGENCY ALERT',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold ,),
        ),
      ),
      backgroundColor: Colors.blue[100],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildEmergencyButton(
            context,
            "Medical Emergency",
            "Patient requires immediate medical attention",
          ),
          SizedBox(height: 20),
          _buildEmergencyButton(
            context,
            "Happen Assident",
            "Accident happened, Need another ambulance for patient transfer",
          ),
          SizedBox(height: 20),
          _buildEmergencyButton(
            context,
            "Lack of Oxygen",
            "Oxygen ventilators is over",
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyButton(BuildContext context, String buttonText, String message) {
    return GestureDetector(
      onTap: () => sendAlert(context, message),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.red[300],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}