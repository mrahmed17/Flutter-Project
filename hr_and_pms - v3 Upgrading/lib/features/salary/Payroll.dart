import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw; // for PDF generation
import 'package:flutter/services.dart'; // for rootBundle
import 'package:path_provider/path_provider.dart'; // for getting file paths
import 'dart:io';
import 'package:csv/csv.dart';

class PayslipPage extends StatefulWidget {
  @override
  _PayslipPageState createState() => _PayslipPageState();
}

class _PayslipPageState extends State<PayslipPage> {
  final TextEditingController _basicSalaryController = TextEditingController();
  double basicSalary = 6500;
  double houseRentAllowance = 0.0;
  double conveyance = 0.0;
  double otherAllowance = 0.0;
  double totalEarnings = 0.0;
  double tds = 0.0;
  double providentFund = 0.0;
  double esi = 0.0;
  double loan = 300.0;
  double totalDeductions = 0.0;
  double netSalary = 0.0;

  @override
  void initState() {
    super.initState();
    _basicSalaryController.text = basicSalary.toString();
    _calculateSalary();
  }

  void _calculateSalary() {
    setState(() {
      basicSalary = double.tryParse(_basicSalaryController.text) ?? 6500;
      houseRentAllowance = basicSalary * 0.08; // Example: 8% of basic salary
      conveyance = basicSalary * 0.05; // Example: 5% of basic salary
      otherAllowance = basicSalary * 0.02; // Example: 2% of basic salary

      totalEarnings = basicSalary + houseRentAllowance + conveyance + otherAllowance;

      tds = 0.0;
      providentFund = 0.0;
      esi = 0.0;
      loan = 300.0;

      totalDeductions = tds + providentFund + esi + loan;

      netSalary = totalEarnings - totalDeductions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payslip'),
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: _downloadCSV,
          ),
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: _downloadPDF,
          ),
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () {
              // Add functionality for printing here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderSection(),
            SizedBox(height: 16.0),
            EmployeeDetails(),
            SizedBox(height: 16.0),
            _buildBasicSalaryInput(),
            SizedBox(height: 16.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: EarningsTable(basicSalary, houseRentAllowance, conveyance, otherAllowance, totalEarnings)),
                SizedBox(width: 8.0),
                Expanded(child: DeductionsTable(tds, providentFund, esi, loan, totalDeductions)),
              ],
            ),
            SizedBox(height: 16.0),
            NetSalary(netSalary),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicSalaryInput() {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Basic Salary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _basicSalaryController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Basic Salary',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _calculateSalary(),
            ),
          ],
        ),
      ),
    );
  }

  void _downloadCSV() async {
    List<List<String>> data = [
      ["Description", "Amount"],
      ["Basic Salary", basicSalary.toString()],
      ["House Rent Allowance (H.R.A.)", houseRentAllowance.toString()],
      ["Conveyance", conveyance.toString()],
      ["Other Allowance", otherAllowance.toString()],
      ["Total Earnings", totalEarnings.toString()],
      ["Tax Deducted at Source (T.D.S.)", tds.toString()],
      ["Provident Fund", providentFund.toString()],
      ["ESI", esi.toString()],
      ["Loan", loan.toString()],
      ["Total Deductions", totalDeductions.toString()],
      ["Net Salary", netSalary.toString()],
    ];

    String csvData = const ListToCsvConverter().convert(data);
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/payslip.csv";
    final file = File(path);
    await file.writeAsString(csvData);
    print('CSV downloaded at $path');
  }

  void _downloadPDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Payslip for September 2024"),
            pw.SizedBox(height: 16),
            pw.Text("Employee Name: Albina Simonis"),
            pw.Text("Position: Nurse"),
            pw.Text("Employee ID: NS-0001"),
            pw.SizedBox(height: 16),
            pw.Text("Earnings:"),
            pw.Table.fromTextArray(data: [
              ["Basic Salary", basicSalary.toString()],
              ["House Rent Allowance (H.R.A.)", houseRentAllowance.toString()],
              ["Conveyance", conveyance.toString()],
              ["Other Allowance", otherAllowance.toString()],
              ["Total Earnings", totalEarnings.toString()]
            ]),
            pw.SizedBox(height: 16),
            pw.Text("Deductions:"),
            pw.Table.fromTextArray(data: [
              ["Tax Deducted at Source (T.D.S.)", tds.toString()],
              ["Provident Fund", providentFund.toString()],
              ["ESI", esi.toString()],
              ["Loan", loan.toString()],
              ["Total Deductions", totalDeductions.toString()]
            ]),
            pw.SizedBox(height: 16),
            pw.Text("Net Salary: \$${netSalary.toString()}"),
          ],
        ),
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/payslip.pdf";
    final file = File(path);
    await file.writeAsBytes(await pdf.save());
    print('PDF downloaded at $path');
  }
}

class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/img/logo-dark.png', height: 60),
        SizedBox(height: 8.0),
        Text(
          'PreClinic',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text('3864 Quiet Valley Lane,'),
        Text('Sherman Oaks, CA, 91403'),
        SizedBox(height: 16.0),
        Text(
          'Payslip for the month of September 2024',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 4.0),
        Text('Payslip #49029 | Salary Month: August, 2024'),
      ],
    );
  }
}

class EmployeeDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Albina Simonis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Nurse'),
            Text('Employee ID: NS-0001'),
            Text('Joining Date: 7 May 2023'),
          ],
        ),
      ),
    );
  }
}

class EarningsTable extends StatelessWidget {
  final double basicSalary, houseRentAllowance, conveyance, otherAllowance, totalEarnings;

  EarningsTable(this.basicSalary, this.houseRentAllowance, this.conveyance, this.otherAllowance, this.totalEarnings);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Earnings',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Table(
              children: [
                TableRow(children: [Text("Basic Salary"), Text(basicSalary.toString())]),
                TableRow(children: [Text("House Rent Allowance (H.R.A.)"), Text(houseRentAllowance.toString())]),
                TableRow(children: [Text("Conveyance"), Text(conveyance.toString())]),
                TableRow(children: [Text("Other Allowance"), Text(otherAllowance.toString())]),
                TableRow(children: [Text("Total Earnings"), Text(totalEarnings.toString())]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DeductionsTable extends StatelessWidget {
  final double tds, providentFund, esi, loan, totalDeductions;

  DeductionsTable(this.tds, this.providentFund, this.esi, this.loan, this.totalDeductions);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Deductions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Table(
              children: [
                TableRow(children: [Text("Tax Deducted at Source (T.D.S.)"), Text(tds.toString())]),
                TableRow(children: [Text("Provident Fund"), Text(providentFund.toString())]),
                TableRow(children: [Text("ESI"), Text(esi.toString())]),
                TableRow(children: [Text("Loan"), Text(loan.toString())]),
                TableRow(children: [Text("Total Deductions"), Text(totalDeductions.toString())]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NetSalary extends StatelessWidget {
  final double netSalary;

  NetSalary(this.netSalary);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Net Salary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              '\$$netSalary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
