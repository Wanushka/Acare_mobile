// import 'package:flutter/material.dart';

// class NotificationScreen extends StatefulWidget {
//   @override
//   _NotificationScreenState createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   List<Map<String, dynamic>> notifications = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchNotifications();
//   }

//   Future<void> fetchNotifications() async {
//     // Simulating API call
//     setState(() {
//       notifications = List.generate(3, (index) => {
//         'id': 'Alert 01',
//         'message': 'You have to ready for a Journey.It schedule at 11.00 pm',
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 221, 220, 252),
//       appBar: AppBar(
//         title: Text('NOTIFICATION', style: TextStyle(color: Colors.white)),
//         backgroundColor: const Color.fromARGB(255, 2, 20, 157),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: notifications.length,
//               itemBuilder: (context, index) {
//                 final notification = notifications[index];
//                 return _buildNotificationCard(notification);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNotificationCard(Map<String, dynamic> notification) {
//     return Card(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       color: Colors.white,
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   notification['id'],
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Icon(Icons.notifications, color: Colors.blue),
//               ],
//             ),
//             SizedBox(height: 8),
//             Text(notification['message']),
//             SizedBox(height: 8),
//             ElevatedButton(
//               child: Text('Accept', style: TextStyle(color: Colors.white)),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(18),
//                 ),
//               ),
//               onPressed: () {
//                 // Handle accept action
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('http://localhost:5000/messages'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          notifications = data.map((msg) => {
            'id': msg['_id'],
            'message': msg['message'],
            'timestamp': msg['createdAt'],  // Fixed field from 'timestamp' to 'createdAt'
            'accepted': msg['accepted'] ?? false,
          }).toList();
        });
      } else {
        print('Failed to load messages: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching messages: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> acceptMessage(String id) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:5000/messages/$id/accept'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        await fetchNotifications();
      } else {
        print('Failed to accept message: ${response.statusCode}');
      }
    } catch (error) {
      print('Error accepting message: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        title: Text('Notifications', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 2, 20, 157),
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(child: Text('No notifications', style: TextStyle(color: Colors.black)))
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _buildNotificationCard(notification);
                  },
                ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Alert ${notification['id'].substring(0, 5)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Icon(Icons.notifications, color: Colors.blue),
              ],
            ),
            SizedBox(height: 8),
            Text(notification['message']),
            SizedBox(height: 4),
            Text(
              DateTime.parse(notification['createdAt']).toLocal().toString(),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 8),
            if (!notification['accepted'])
              ElevatedButton(
                child: Text('Accept', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () => acceptMessage(notification['id']),
              )
            else
              Text('Accepted', style: TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
