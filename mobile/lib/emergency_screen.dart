// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class EmergencyScreen extends StatelessWidget {
//   final String apiUrl = 'http://localhost:5000/send-message'; // Replace with your backend URL

//   Future<void> sendMessage(String message) async {
//     try {
//       var response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({'message': message}),
//       );

//       if (response.statusCode == 200) {
//         print("Message sent successfully");
//       } else {
//         print("Failed to send message");
//       }
//     } catch (error) {
//       print("Error sending message: $error");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: Text('Emergency'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       backgroundColor: Colors.blue[100],
//       body: Column(
//         children: [
//           SizedBox(height: 20),
//           GestureDetector(
//             onTap: () {
//               sendMessage("Emergency message 1"); // Default message 1
//             },
//             child: Container(
//               margin: EdgeInsets.symmetric(horizontal: 20),
//               height: 100,
//               decoration: BoxDecoration(
//                 color: Colors.red[300],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Center(
//                 child: Text(
//                   "Emergency message 1",
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           GestureDetector(
//             onTap: () {
//               sendMessage("Emergency message 2"); // Default message 2
//             },
//             child: Container(
//               margin: EdgeInsets.symmetric(horizontal: 20),
//               height: 100,
//               decoration: BoxDecoration(
//                 color: Colors.red[300],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Center(
//                 child: Text(
//                   "Emergency message 2",
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// void main() => runApp(MaterialApp(
//   home: EmergencyScreen(),
// ));

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class EmergencyScreen extends StatelessWidget {
//   final String apiUrl = 'http://localhost:5000/send-message';

//   Future<void> sendMessage(BuildContext context, String message) async {
//     try {
//       var response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({'message': message}),
//       );
      
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Alert sent successfully")),
//         );
//       } else {
//         throw Exception('Failed to send message');
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to send alert: $error")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: Text('Emergency'),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       backgroundColor: Colors.blue[100],
//       body: Column(
//         children: [
//           SizedBox(height: 20),
//           _buildEmergencyButton(
//             context,
//             "Medical Emergency",
//             "Patient requires immediate medical attention",
//           ),
//           SizedBox(height: 20),
//           _buildEmergencyButton(
//             context,
//             "Security Emergency",
//             "Security personnel needed immediately",
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmergencyButton(BuildContext context, String buttonText, String message) {
//     return GestureDetector(
//       onTap: () => sendMessage(context, message),
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 20),
//         height: 100,
//         decoration: BoxDecoration(
//           color: Colors.red[300],
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black26,
//               offset: Offset(0, 2),
//               blurRadius: 6.0,
//             ),
//           ],
//         ),
//         child: Center(
//           child: Text(
//             buttonText,
//             style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     );
//   }
// }

// void main() => runApp(MaterialApp(home: EmergencyScreen()));


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class EmergencyScreen extends StatefulWidget {
  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final String apiUrl = 'http://localhost:5000/send-message';
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    socket = IO.io('http://localhost:5000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
  }

  Future<void> sendMessage(String message) async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'message': message}),
      );

      if (response.statusCode == 200) {
        socket.emit('new_alert', {'message': message}); // Notify web app
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Alert sent successfully")),
        );
      } else {
        throw Exception('Failed to send message');
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
        title: Text('Emergency'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.blue[100],
      body: Column(
        children: [
          SizedBox(height: 20),
          _buildEmergencyButton(
            context,
            "Medical Emergency",
            "Patient requires immediate medical attention",
          ),
          SizedBox(height: 20),
          _buildEmergencyButton(
            context,
            "Security Emergency",
            "Security personnel needed immediately",
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyButton(BuildContext context, String buttonText, String message) {
    return GestureDetector(
      onTap: () => sendMessage(message),
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

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }
}

void main() => runApp(MaterialApp(home: EmergencyScreen()));
