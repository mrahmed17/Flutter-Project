import 'package:flutter/material.dart';
import 'package:hr_and_pms/features/advanceSalary/model/AdvanceSalary.dart';
import 'package:hr_and_pms/features/advanceSalary/service/AdvanceSalaryService.dart';
import '../../leave/model/RequestStatus.dart';

class AdvanceSalaryStatusScreen extends StatefulWidget {
  const AdvanceSalaryStatusScreen({Key? key}) : super(key: key);

  @override
  _AdvanceSalaryStatusScreenState createState() =>
      _AdvanceSalaryStatusScreenState();
}

class _AdvanceSalaryStatusScreenState
    extends State<AdvanceSalaryStatusScreen> {
  final AdvanceSalaryService _service = AdvanceSalaryService();
  late Future<List<AdvanceSalary>> _applications;
  bool isEmployee = true; // Assume we have the role info (set true for employee)

  @override
  void initState() {
    super.initState();
    _applications = _fetchApplications();
  }

  Future<List<AdvanceSalary>> _fetchApplications() async {
    // Fetch employee's applications or all applications depending on the role
    return await _service.getAdvanceSalaries(id); // For employee, replace with relevant filter if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advance Salary Status'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: FutureBuilder<List<AdvanceSalary>>(
        future: _applications,
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
                'No applications found.',
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
                      Text('Status: ${application.status}'),
                    ],
                  ),
                  trailing: isEmployee
                      ? null // Employees cannot approve/reject
                      : _buildStatusButtons(application),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Status buttons for admin/manager (to approve/reject)
  Widget _buildStatusButtons(AdvanceSalary application) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: application.status != 'Approved' ? () => _approveApplication(application) : null,
          child: const Text('Approve'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: application.status != 'Rejected' ? () => _rejectApplication(application) : null,
          child: const Text('Reject'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),
      ],
    );
  }

  void _approveApplication(AdvanceSalary application) async {
    // Create a new instance with updated status using enum
    final updatedApplication = application.copyWith(status: RequestStatus.approved);
    await _updateApplicationStatus(updatedApplication);
  }

  void _rejectApplication(AdvanceSalary application) async {
    // Create a new instance with updated status using enum
    final updatedApplication = application.copyWith(status: RequestStatus.rejected);
    await _updateApplicationStatus(updatedApplication);
  }


  Future<void> _updateApplicationStatus(AdvanceSalary application) async {
    try {
      // Call the backend API to update the status
      await _service.updateAdvanceSalary(application.id, application);
      setState(() {
        _applications = _fetchApplications(); // Refresh the list after status change
      });
    } catch (e) {
      // Handle any errors during the status update
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to update status: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
