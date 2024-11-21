import 'package:flutter/material.dart';

class ActivitiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activities'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ActivityList(),
            Divider(),
            NotificationBox(),
          ],
        ),
      ),
    );
  }
}

class ActivityList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        ActivityItem(
          avatar: Image.asset('assets/img/user.jpg'),
          name: 'Lesley Grauer',
          action: 'added new task',
          task: 'Hospital Administration',
          time: '4 mins ago',
        ),
        ActivityItem(
          avatar: Text('L'),
          name: 'Jeffery Lalor',
          action: 'added',
          extraUsers: ['Loren Gatlin', 'Tarah Shropshire'],
          task: 'Patient appointment booking',
          time: '6 mins ago',
        ),
        // Add more ActivityItems here...
      ],
    );
  }
}

class ActivityItem extends StatelessWidget {
  final Widget avatar;
  final String name;
  final String action;
  final String? task;
  final List<String>? extraUsers;
  final String time;

  ActivityItem({
    required this.avatar,
    required this.name,
    required this.action,
    this.task,
    this.extraUsers,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: avatar),
      title: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(text: '$name '),
            TextSpan(
                text: action, style: TextStyle(fontWeight: FontWeight.bold)),
            if (extraUsers != null)
              TextSpan(text: ' ${extraUsers!.join(', ')} '),
            if (task != null)
              TextSpan(
                  text: task!, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      subtitle: Text(time),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          // Handle delete action
        },
      ),
    );
  }
}

class NotificationBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Messages"),
      children: [
        MessageItem(
          author: 'Richard Miles',
          time: '12:28 AM',
          content: 'Lorem ipsum dolor sit amet, consectetur adipiscing',
        ),
        MessageItem(
          author: 'John Doe',
          time: '1 Aug',
          content: 'Lorem ipsum dolor sit amet, consectetur adipiscing',
          isNew: true,
        ),
        // Add more MessageItems here...
      ],
    );
  }
}

class MessageItem extends StatelessWidget {
  final String author;
  final String time;
  final String content;
  final bool isNew;

  MessageItem({
    required this.author,
    required this.time,
    required this.content,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(author[0]),
      ),
      title: Text(author),
      subtitle: Text(content),
      trailing: Text(time),
      tileColor: isNew ? Colors.blue.shade50 : Colors.white,
    );
  }
}

void main() => runApp(MaterialApp(home: ActivitiesPage()));
