import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ukom/screen/create_pdf.dart';
import 'package:ukom/widget/button.dart';
import '../model/payroll.dart';
import '../service/firebase_payroll.dart';

class ReportPayroll extends StatefulWidget {
  const ReportPayroll({super.key});

  @override
  State<ReportPayroll> createState() => _ReportPayrollState();
}

class _ReportPayrollState extends State<ReportPayroll> {
  final PayrollService _payrollService = PayrollService();
  String field = 'name';
  final formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  bool asc = true;
  int columnIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              StreamBuilder<List<Payroll>>(
                stream: _payrollService.getPayrollsStream(field,
                    asc), // Ganti dengan metode yang sesuai untuk mendapatkan Stream data dari PayrollService
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    ); // Tampilkan loading jika masih menunggu data
                  } else if (snapshot.hasError) {
                    return Text(
                        'Error: ${snapshot.error}'); // Tampilkan pesan error jika terjadi kesalahan
                  } else {
                    var payrollDataList = snapshot.data;

                    // Ambil data dari snapshot
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            DataTable(
                              sortAscending: asc,
                              sortColumnIndex: columnIndex,
                              columns: [
                                DataColumn(
                                  label: Text('NIP'),
                                ),
                                DataColumn(
                                  label: Text('NAME'),
                                  onSort: (columnIndex, ascending) {
                                    setState(() {
                                      field = 'name';
                                      asc = !asc;
                                    });
                                  },
                                ),
                                DataColumn(label: Text('GENDER')),
                                DataColumn(label: Text('JOB')),
                                DataColumn(
                                  label: Text('SALARY'),
                                  onSort: (columnIndex, ascending) {
                                    setState(() {
                                      field = 'salary';
                                      asc = !asc;
                                    });
                                  },
                                ),
                                DataColumn(
                                  label: Text('DATE OF PAYROLL'),
                                  onSort: (columnIndex, ascending) {
                                    setState(() {
                                      field = 'payroll';
                                      asc = !asc;
                                    });
                                  },
                                ),
                                DataColumn(
                                  label: Text('BONUS'),
                                  onSort: (columnIndex, ascending) {
                                    setState(() {
                                      field = 'totalbonus';
                                      asc = !asc;
                                    });
                                  },
                                ),
                                DataColumn(
                                  label: Text('TOTAL_SALARY'),
                                  onSort: (columnIndex, ascending) {
                                    setState(() {
                                      field = 'totalsalary';
                                      asc = !asc;
                                    });
                                  },
                                ),
                              ],
                              rows: payrollDataList!.map((payrollData) {
                                // Konversi setiap data dari PayrollData menjadi DataRow
                                return DataRow(
                                  cells: [
                                    DataCell(Text(payrollData.nip.toString())),
                                    DataCell(Text(payrollData.name)),
                                    DataCell(Text(payrollData.gender)),
                                    DataCell(Text(payrollData.job)),
                                    DataCell(Text(formatCurrency
                                        .format(payrollData.salary))),
                                    DataCell(Text(DateFormat('dd-MM-yyyy')
                                        .format(payrollData.payrolldate))),
                                    DataCell(Text(formatCurrency
                                        .format(payrollData.totalbonus))),
                                    DataCell(Text(formatCurrency
                                        .format(payrollData.totalgaji))),
                                  ],
                                );
                              }).toList(),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ButtonWidget(
                                onPressed: () async {
                                  PdfDoc().createPdf(payrollDataList, '', true);
                                },
                                nameButton: 'export to PDF'),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
