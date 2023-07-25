import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../model/payroll.dart';

class PdfDoc {
  final pdf = pw.Document();

  Future<File> createPdf(
      List<Payroll>? data, String? sortedField, bool asc) async {
    int totalGajiKaryawan = 0;
    // if (sortedField != null) {
    //   data.sort((a, b) {
    //     if (asc) {
    //       return a[sortedField].compareTo(b[sortedField]);
    //     } else {
    //       return b[sortedField].compareTo(a[sortedField]);
    //     }
    //   });
    //}

    for (var map in data!) {
      final gaji = map.totalgaji;
      totalGajiKaryawan = totalGajiKaryawan + gaji;
    }
    final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    pw.Padding headingColumn(String textContent) {
      return pw.Padding(
        padding: const pw.EdgeInsets.all(4.0),
        child: pw.Center(
          child: pw.Text(
            textContent,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (context) {
          return [
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Header(
                    text: "Laporan Bulanan Gaji",
                  ),
                  pw.Table(
                    columnWidths: {
                      0: const pw.FlexColumnWidth(2),
                      1: const pw.FlexColumnWidth(3),
                      2: const pw.FlexColumnWidth(3),
                      3: const pw.FlexColumnWidth(3),
                      4: const pw.FlexColumnWidth(3),
                      5: const pw.FlexColumnWidth(3),
                      6: const pw.FlexColumnWidth(3),
                      7: const pw.FlexColumnWidth(4),
                      8: const pw.FlexColumnWidth(4),
                    },
                    border: pw.TableBorder.all(),
                    children: [
                      pw.TableRow(
                        repeat: true,
                        children: [
                          headingColumn('NO'),
                          headingColumn("NIP"),
                          headingColumn("NAME"),
                          headingColumn("GENDER"),
                          headingColumn("JOB"),
                          headingColumn("SALARY"),
                          headingColumn("DATE OF PAYROLL"),
                          headingColumn("BONUS"),
                          headingColumn("TOTAL SALARY"),
                        ],
                      ),
                    ],
                  ),
                  pw.Table(
                    columnWidths: {
                      0: const pw.FlexColumnWidth(2),
                      1: const pw.FlexColumnWidth(3),
                      2: const pw.FlexColumnWidth(3),
                      3: const pw.FlexColumnWidth(3),
                      4: const pw.FlexColumnWidth(3),
                      5: const pw.FlexColumnWidth(3),
                      6: const pw.FlexColumnWidth(3),
                      7: const pw.FlexColumnWidth(4),
                      8: const pw.FlexColumnWidth(4),
                    },
                    border: pw.TableBorder.all(),
                    children: List.generate(
                      data.length,
                      (index) {
                        return pw.TableRow(
                          children: [
                            pw.Center(child: pw.Text("${index + 1}")),
                            pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 4),
                                child: pw.Text(data[index].nip.toString())),
                            pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 4),
                                child: pw.Text(data[index].name)),
                            pw.Center(child: pw.Text(data[index].gender)),
                            pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 4),
                                child: pw.Text((data[index].job))),
                            pw.Center(
                                child: pw.Text(
                                    formatCurrency.format(data[index].salary))),
                            pw.Center(
                                child: pw.Text(DateFormat('dd-MM-yyyy')
                                    .format(data[index].payrolldate))),
                            pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 4),
                                child: pw.Text((formatCurrency
                                    .format(data[index].totalbonus)))),
                            pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(
                                    horizontal: 4),
                                child: pw.Text((formatCurrency
                                    .format(data[index].totalgaji)))),
                          ],
                        );
                      },
                    ),
                  ),
                  pw.Table(
                    columnWidths: {
                      0: const pw.FlexColumnWidth(2),
                      1: const pw.FlexColumnWidth(3),
                      2: const pw.FlexColumnWidth(3),
                      3: const pw.FlexColumnWidth(3),
                      4: const pw.FlexColumnWidth(3),
                      5: const pw.FlexColumnWidth(3),
                      6: const pw.FlexColumnWidth(3),
                      7: const pw.FlexColumnWidth(4),
                      8: const pw.FlexColumnWidth(4),
                    },
                    border: pw.TableBorder.all(),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Center(child: pw.Text("")),
                          pw.Center(child: pw.Text("")),
                          pw.Center(child: pw.Text("")),
                          pw.Center(child: pw.Text("")),
                          pw.Center(child: pw.Text("")),
                          pw.Center(child: pw.Text("")),
                          pw.Center(child: pw.Text("")),
                          pw.Center(child: pw.Text("Total Gaji:")),
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(horizontal: 4),
                            child: pw.Text(
                                (formatCurrency.format(totalGajiKaryawan))),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ];
        },
      ),
    );
    final output = await getExternalStorageDirectory();
    final fileName = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final file = File("${output!.path}/laporan_$fileName.pdf");
    return await file.writeAsBytes(await pdf.save());
  }
}
