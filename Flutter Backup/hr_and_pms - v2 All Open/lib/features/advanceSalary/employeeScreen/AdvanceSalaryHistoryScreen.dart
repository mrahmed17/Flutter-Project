import 'package:flutter/material.dart';
import 'package:hr_and_pms/features/advanceSalary/model/AdvanceSalary.dart';
import 'package:hr_and_pms/features/advanceSalary/service/AdvanceSalaryService.dart';
import 'package:hr_and_pms/features/leave/model/RequestStatus.dart';

class AdvanceSalaryHistoryScreen extends StatefulWidget {
  const AdvanceSalaryHistoryScreen({Key? key}) : super(key: key);

  @override
  State<AdvanceSalaryHistoryScreen> createState() =>
      _AdvanceSalaryHistoryScreenState();
}

class _AdvanceSalaryHistoryScreenState extends State<AdvanceSalaryHistoryScreen> {
  final AdvanceSalaryService _advanceSalaryService = AdvanceSalaryService();
  late Future<List<AdvanceSalary>> _advanceSalaryHistory;

  @override
  void initState() {
    super.initState();
    // Fetch the advance salary history
    _advanceSalaryHistory = _advanceSalaryService.getAdvanceSalaries();
  }

  // Method to handle the status icon color and label
  IconData _getStatusIcon(RequestStatus status) {
    switch (status) {
      case RequestStatus.approved:
        return Icons.check_circle;
      case RequestStatus.rejected:
        return Icons.cancel;
      default:
        return Icons.hourglass_top;
    }
  }

  Color _getStatusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.approved:
        return Colors.green;
      case RequestStatus.rejected:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advance Salary History'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<AdvanceSalary>>(
        future: _advanceSalaryHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No advance salary history available.'),
            );
          } else {
            final advanceSalaryList = snapshot.data!;
            return ListView.builder(
              itemCount: advanceSalaryList.length,
              itemBuilder: (context, index) {
                final application = advanceSalaryList[index];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Text(
                        application.id.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      '\$${application.advanceAmount.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reason: ${application.reason}'),
                        Text(
                          'Date: ${application.advanceDate.toLocal().toString().split(' ')[0]}',
                        ),
                        Text('Status: ${application.status.toShortString()}'), // Directly use the enum's toShortString
                      ],
                    ),
                    trailing: Icon(
                      _getStatusIcon(application.status), // Directly pass the status as an enum
                      color: _getStatusColor(application.status), // Pass the enum directly
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
