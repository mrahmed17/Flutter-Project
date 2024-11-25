import 'package:flutter/material.dart';
import 'package:hr_and_pms/features/bonus/model/Bonus.dart';
import 'package:hr_and_pms/features/bonus/model/BonusType.dart'; // Ensure BonusType is imported
import 'package:hr_and_pms/features/bonus/service/BonusService.dart';

class BonusCreateScreen extends StatefulWidget {
  @override
  _BonusCreateScreenState createState() => _BonusCreateScreenState();
}

class _BonusCreateScreenState extends State<BonusCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final BonusService _bonusService = BonusService();

  double _bonusAmount = 0.0;
  DateTime _bonusDate = DateTime.now();
  BonusType? _bonusType;
  String _statusMessage = '';

  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Bonus'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bonus Amount Field
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Bonus Amount',
                    labelStyle: TextStyle(color: Colors.teal),
                    prefixIcon: Icon(Icons.attach_money, color: Colors.teal),
                    filled: true,
                    fillColor: Colors.teal[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    setState(() {
                      _bonusAmount = double.tryParse(value) ?? 0.0;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a bonus amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Bonus Date Field
                GestureDetector(
                  onTap: _selectDate,
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Bonus Date',
                        labelStyle: TextStyle(color: Colors.teal),
                        prefixIcon: Icon(Icons.date_range, color: Colors.teal),
                        filled: true,
                        fillColor: Colors.teal[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      controller: TextEditingController(
                        text: _bonusDate != null
                            ? _bonusDate.toLocal().toString().split(' ')[0]
                            : '',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a bonus date';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Bonus Type Dropdown
                DropdownButtonFormField<BonusType>(
                  decoration: InputDecoration(
                    labelText: 'Bonus Type',
                    labelStyle: TextStyle(color: Colors.teal),
                    filled: true,
                    fillColor: Colors.teal[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  value: _bonusType,
                  items: BonusType.values.map((BonusType type) {
                    return DropdownMenuItem<BonusType>(
                      value: type,
                      child: Text(type.toShortString()),
                    );
                  }).toList(),
                  onChanged: (BonusType? newType) {
                    setState(() {
                      _bonusType = newType;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a bonus type';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // Teal button
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _createBonus,
                    child: Text(
                      'Create Bonus',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Status Message
                if (_statusMessage.isNotEmpty)
                  Center(
                    child: Text(
                      _statusMessage,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Date Picker for selecting date
  Future<void> _selectDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _bonusDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ) ?? _bonusDate;

    if (picked != null && picked != _bonusDate)
      setState(() {
        _bonusDate = picked;
      });
  }

  // Method to create the bonus
  Future<void> _createBonus() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _statusMessage = 'Creating bonus...';
      });

      Bonus bonus = Bonus(
        bonusAmount: _bonusAmount,
        bonusDate: _bonusDate,
        bonusType: _bonusType ?? BonusType.PERFORMANCE, // Default to PERFORMANCE
      );

      Bonus? createdBonus = await _bonusService.createBonus(bonus);

      if (createdBonus != null) {
        setState(() {
          _statusMessage = 'Bonus created successfully!';
        });
      } else {
        setState(() {
          _statusMessage = 'Error creating bonus. Please try again.';
        });
      }
    }
  }
}
