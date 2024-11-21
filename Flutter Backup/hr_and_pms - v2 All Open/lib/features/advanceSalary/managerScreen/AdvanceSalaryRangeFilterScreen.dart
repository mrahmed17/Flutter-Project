import 'package:flutter/material.dart';
import 'package:hr_and_pms/features/advanceSalary/model/AdvanceSalary.dart';
import 'package:hr_and_pms/features/advanceSalary/service/AdvanceSalaryService.dart';

class AdvanceSalaryDateRangeFilterScreen extends StatefulWidget {
  const AdvanceSalaryDateRangeFilterScreen({Key? key}) : super(key: key);

  @override
  _AdvanceSalaryDateRangeFilterScreenState createState() => _AdvanceSalaryDateRangeFilterScreenState();
}

class _AdvanceSalaryDateRangeFilterScreenState extends State<AdvanceSalaryDateRangeFilterScreen> {
  DateTime? startDate;
  DateTime? endDate;
  bool isLoading = false;
  List<AdvanceSalary> filteredApplications = [];

  final AdvanceSalaryService _advanceSalaryService = AdvanceSalaryService();

  // Function to select a start date
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != startDate) {
      setState(() {
        startDate = pickedDate;
      });
    }
  }

  // Function to select an end date
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != endDate) {
      setState(() {
        endDate = pickedDate;
      });
    }
  }

  // Function to fetch filtered advance salaries
  Future<void> _fetchFilteredAdvanceSalaries() async {
    if (startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both start and end dates')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      List<AdvanceSalary> applications = await _advanceSalaryService.getAdvanceSalariesByDateRange(startDate!, endDate!);
      setState(() {
        filteredApplications = applications;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Advance Salaries by Date Range'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Start Date Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Start Date:'),
                TextButton(
                  onPressed: () => _selectStartDate(context),
                  child: Text(startDate == null ? 'Select Date' : startDate!.toLocal().toString().split(' ')[0]),
                ),
              ],
            ),
            // End Date Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('End Date:'),
                TextButton(
                  onPressed: () => _selectEndDate(context),
                  child: Text(endDate == null ? 'Select Date' : endDate!.toLocal().toString().split(' ')[0]),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchFilteredAdvanceSalaries,
              child: const Text('Filter'),
            ),
            const SizedBox(height: 20),
            // Displaying filtered applications
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredApplications.isEmpty
                ? const Center(child: Text('No results found for the selected date range'))
                : Expanded(
              child: ListView.builder(
                itemCount: filteredApplications.length,
                itemBuilder: (context, index) {
                  AdvanceSalary application = filteredApplications[index];
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
            ),
          ],
        ),
      ),
    );
  }
}
