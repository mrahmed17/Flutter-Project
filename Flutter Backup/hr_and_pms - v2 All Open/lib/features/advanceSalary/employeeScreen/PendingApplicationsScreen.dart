import 'package:flutter/material.dart';
import 'package:hr_and_pms/features/advanceSalary/model/AdvanceSalary.dart';
import 'package:hr_and_pms/features/advanceSalary/service/AdvanceSalaryService.dart';

class PendingApplicationsScreen extends StatefulWidget {
  const PendingApplicationsScreen({Key? key}) : super(key: key);

  @override
  _PendingApplicationsScreenState createState() =>
      _PendingApplicationsScreenState();
}

class _PendingApplicationsScreenState
    extends State<PendingApplicationsScreen> {
  final AdvanceSalaryService _service = AdvanceSalaryService();
  late Future<List<AdvanceSalary>> _pendingApplications;

  @override
  void initState() {
    super.initState();
    _pendingApplications = _fetchPendingApplications();
  }

  Future<List<AdvanceSalary>> _fetchPendingApplications() async {
    // Replace this API call with one that fetches pending applications
    return await _service.getAdvanceSalaries(); // Example placeholder
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Applications'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: FutureBuilder<List<AdvanceSalary>>(
        future: _pendingApplications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No pending applications found.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          }

          final applications = snapshot.data!;
          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final application = applications[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(application.user.profilePhoto),
                    radius: 30,
                    backgroundColor: Colors.grey[200],
                  ),
                  title: Text(
                    application.user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Reason: ${application.reason}'),
                      Text(
                          'Amount: \$${application.advanceAmount.toStringAsFixed(2)}'),
                      Text(
                          'Date: ${application.advanceDate.toLocal().toString().split(' ')[0]}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    color: Colors.teal,
                    onPressed: () {
                      _viewDetails(application);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _viewDetails(AdvanceSalary application) {
    // Navigate to a detailed view of the application
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplicationDetailsScreen(application: application),
      ),
    );
  }
}

class ApplicationDetailsScreen extends StatelessWidget {
  final AdvanceSalary application;

  const ApplicationDetailsScreen({Key? key, required this.application})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${application.user.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Email: ${application.user.email}'),
            const SizedBox(height: 8),
            Text('Reason: ${application.reason}'),
            const SizedBox(height: 8),
            Text('Amount: \$${application.advanceAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text(
                'Date: ${application.advanceDate.toLocal().toString().split(' ')[0]}'),
            const SizedBox(height: 8),
            Text('Contact: ${application.user.contact}'),
          ],
        ),
      ),
    );
  }
}
