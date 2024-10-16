import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    // Simulating API call
    setState(() {
      notifications = List.generate(3, (index) => {
        'id': 'Alert 01',
        'message': 'You have to ready for a Journey.It schedule at 11.00 pm',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 220, 252),
      appBar: AppBar(
        title: Text('NOTIFICATION', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 2, 20, 157),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _buildNotificationCard(notification);
              },
            ),
          ),
        ],
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
                  notification['id'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Icon(Icons.notifications, color: Colors.blue),
              ],
            ),
            SizedBox(height: 8),
            Text(notification['message']),
            SizedBox(height: 8),
            ElevatedButton(
              child: Text('Accept', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: () {
                // Handle accept action
              },
            ),
          ],
        ),
      ),
    );
  }
}

