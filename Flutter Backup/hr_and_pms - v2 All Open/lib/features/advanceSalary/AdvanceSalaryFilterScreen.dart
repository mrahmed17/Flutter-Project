import 'package:flutter/material.dart';
import 'package:hr_and_pms/features/advanceSalary/service/AdvanceSalaryService.dart';
import 'package:intl/intl.dart';
import 'package:hr_and_pms/features/advanceSalary/model/AdvanceSalary.dart';

class AdvanceSalaryFilterScreen extends StatefulWidget {
  const AdvanceSalaryFilterScreen({Key? key}) : super(key: key);

  @override
  State<AdvanceSalaryFilterScreen> createState() =>
      _AdvanceSalaryFilterScreenState();
}

class _AdvanceSalaryFilterScreenState
    extends State<AdvanceSalaryFilterScreen> {
  final AdvanceSalaryService _advanceSalaryService = AdvanceSalaryService();
  DateTime? _startDate;
  DateTime? _endDate;
  List<AdvanceSalary> _filteredApplications = [];
  bool _isLoading = false;

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<void> _filterApplications() async {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date range first.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final List<AdvanceSalary> applications =
      await _advanceSalaryService.getAdvanceSalariesByDateRange(
        _startDate!,
        _endDate!,
      );

      setState(() {
        _filteredApplications = applications;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter by Date Range'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Date Range:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _startDate != null
                          ? DateFormat('yyyy-MM-dd').format(_startDate!)
                          : 'Start Date',
                    ),
                    Text(
                      _endDate != null
                          ? DateFormat('yyyy-MM-dd').format(_endDate!)
                          : 'End Date',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _selectDateRange,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text('Select Date Range'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _filterApplications,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                      : const Text('Filter Applications'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: _filteredApplications.isEmpty
                ? const Center(child: Text('No applications found.'))
                : ListView.builder(
              itemCount: _filteredApplications.length,
              itemBuilder: (context, index) {
                final application = _filteredApplications[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
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
                        Text('Status: ${application.status}'),
                      ],
                    ),
                    trailing: Icon(
                      application.status == 'Approved'
                          ? Icons.check_circle
                          : application.status == 'Rejected'
                          ? Icons.cancel
                          : Icons.hourglass_top,
                      color: application.status == 'Approved'
                          ? Colors.green
                          : application.status == 'Rejected'
                          ? Colors.red
                          : Colors.orange,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
