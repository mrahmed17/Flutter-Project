import 'package:flutter/material.dart';
import 'package:hr_and_pms/administration/service/AuthService.dart';
import 'package:hr_and_pms/features/leave/model/Leave.dart';
import 'package:hr_and_pms/features/leave/model/LeaveType.dart';
import 'package:hr_and_pms/features/leave/model/RequestStatus.dart';
import 'package:hr_and_pms/administration/model/User.dart';
import 'package:hr_and_pms/features/leave/service/LeaveService.dart'; // Adjust import based on your project structure

class LeaveCreateScreen extends StatefulWidget {
  @override
  _LeaveCreateScreenState createState() => _LeaveCreateScreenState();
}

class _LeaveCreateScreenState extends State<LeaveCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _reason;
  LeaveType? _leaveType;
  final RequestStatus _requestStatus = RequestStatus.pending;

  final LeaveService _leaveService = LeaveService();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveLeaveRequest() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Create the leave model
      Leave leave = Leave(
        startDate: _startDate,
        endDate: _endDate,
        reason: _reason,
        leaveType: _leaveType,
        requestStatus: _requestStatus,
        user: await AuthService().getUser(),
        requestDate: DateTime.now(),
      );

      try {
        // Call the leave service to save the leave
        await _leaveService.saveLeaveRequest(leave);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Leave request submitted successfully')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit leave request: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Request Leave')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Reason'),
                onSaved: (value) => _reason = value,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a reason' : null,
              ),
              ListTile(
                title: Text('Start Date'),
                subtitle: Text(_startDate != null ? _startDate.toString() : 'Select Start Date'),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      _startDate = picked;
                    });
                  }
                },
              ),
              ListTile(
                title: Text('End Date'),
                subtitle: Text(_endDate != null ? _endDate.toString() : 'Select End Date'),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _endDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      _endDate = picked;
                    });
                  }
                },
              ),
              DropdownButtonFormField<LeaveType>(
                value: _leaveType,
                onChanged: (LeaveType? newValue) {
                  setState(() {
                    _leaveType = newValue;
                  });
                },
                items: LeaveType.values.map<DropdownMenuItem<LeaveType>>((LeaveType value) {
                  return DropdownMenuItem<LeaveType>(
                    value: value,
                    child: Text(value.toShortString()),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Leave Type'),
                validator: (value) => value == null ? 'Please select a leave type' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveLeaveRequest,
                child: Text('Submit Leave Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
