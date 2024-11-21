import 'package:flutter/material.dart';
import 'package:hr_and_pms/features/advanceSalary/model/AdvanceSalary.dart';
import 'package:hr_and_pms/features/advanceSalary/service/AdvanceSalaryService.dart';

class AdvanceSalaryReviewScreen extends StatefulWidget {
  const AdvanceSalaryReviewScreen({Key? key}) : super(key: key);

  @override
  State<AdvanceSalaryReviewScreen> createState() => _AdvanceSalaryReviewScreenState();
}

class _AdvanceSalaryReviewScreenState extends State<AdvanceSalaryReviewScreen> {
  List<AdvanceSalary> pendingApplications = [];
  bool isLoading = true;
  final AdvanceSalaryService _advanceSalaryService = AdvanceSalaryService();  // Instance of the service

  @override
  void initState() {
    super.initState();
    _fetchPendingApplications();
  }

  Future<void> _fetchPendingApplications() async {
    try {
      // Fetch all advance salary applications with "PENDING" status
      List<AdvanceSalary> applications = await _advanceSalaryService.getAdvanceSalaries(); // Use the instance
      setState(() {
        pendingApplications = applications.where((app) => app.status == 'PENDING').toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch pending applications: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Advance Salaries'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pendingApplications.isEmpty
          ? const Center(
        child: Text(
          'No pending applications found.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: pendingApplications.length,
        itemBuilder: (context, index) {
          AdvanceSalary application = pendingApplications[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('Employee: ${application.user.name}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Amount: \$${application.advanceAmount.toStringAsFixed(2)}'),
                  Text('Date: ${application.advanceDate.toLocal()}'),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to the details screen for this application
                Navigator.pushNamed(
                  context,
                  '/advanceSalaryDetails',
                  arguments: application.id,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
