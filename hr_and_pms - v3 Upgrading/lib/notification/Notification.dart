import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Notification 1
          Card(
            elevation: 2.0,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: Icon(Icons.notifications, color: Colors.blue),
              title: Text(
                "New Message from John",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("You have received a new message."),
              trailing: Text("Just now", style: TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          ),

          // Notification 2
          Card(
            elevation: 2.0,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: Icon(Icons.update, color: Colors.green),
              title: Text(
                "System Update Available",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Please update to the latest version."),
              trailing: Text("1 hour ago", style: TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          ),

          // Notification 3
          Card(
            elevation: 2.0,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: Icon(Icons.event, color: Colors.orange),
              title: Text(
                "Meeting Reminder",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Your meeting is scheduled at 3:00 PM."),
              trailing: Text("Yesterday", style: TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          ),

          // Notification 4
          Card(
            elevation: 2.0,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: Icon(Icons.warning, color: Colors.red),
              title: Text(
                "Critical System Alert",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("There was a critical issue detected."),
              trailing: Text("2 days ago", style: TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }
}
