import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukom/model/payroll.dart';
import 'package:http/http.dart' as http;

class PayrollService {
  final CollectionReference _payrollCollection =
      FirebaseFirestore.instance.collection('laporan_gaji');

  Stream<List<Payroll>> getPayrollsStream(String field, bool ascending) {
    if (ascending) {
      if (field == 'name') {
        return _payrollCollection
            .orderBy(
              'name',
            )
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => Payroll.fromFirestore(doc))
                .toList());
      } else if (field == 'salary') {
        return _payrollCollection
            .orderBy(
              field,
            )
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => Payroll.fromFirestore(doc))
                .toList());
      } else if (field == 'totalbonus') {
        return _payrollCollection
            .orderBy(
              field,
            )
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => Payroll.fromFirestore(doc))
                .toList());
      } else if (field == 'totalsalary') {
        return _payrollCollection
            .orderBy(
              field,
            )
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => Payroll.fromFirestore(doc))
                .toList());
      } else {
        return _payrollCollection
            .orderBy(
              'payrolldate',
            )
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => Payroll.fromFirestore(doc))
                .toList());
      }
    } else {
      if (field == 'name') {
        return _payrollCollection
            .orderBy(field, descending: true)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => Payroll.fromFirestore(doc))
                .toList());
      } else if (field == 'salary') {
        return _payrollCollection
            .orderBy(field, descending: true)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => Payroll.fromFirestore(doc))
                .toList());
      } else if (field == 'totalbonus') {
        return _payrollCollection
            .orderBy(field, descending: true)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => Payroll.fromFirestore(doc))
                .toList());
      } else if (field == 'totalsalary') {
        return _payrollCollection
            .orderBy(field, descending: true)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => Payroll.fromFirestore(doc))
                .toList());
      } else {
        return _payrollCollection
            .orderBy('payrolldate', descending: true)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => Payroll.fromFirestore(doc))
                .toList());
      }
    }
  }

  Future<List<Payroll>> getAllPayrolls() async {
    final snapshot = await _payrollCollection.get();
    return snapshot.docs.map((doc) => Payroll.fromFirestore(doc)).toList();
  }

  void addGaji(
    int nip,
    String nama,
    Timestamp payrolldate,
    String jabatan,
    String jenisKelamin,
    int gaji,
    int totalGaji,
    String noTelp,
    int totalBonus,
  ) async {
    final data = {
      "nip": nip,
      "name": nama,
      "payrolldate": payrolldate,
      "job": jabatan,
      "gender": jenisKelamin,
      "totalbonus": totalBonus,
      "noHp": noTelp,
      "salary": gaji,
      'totalsalary': totalGaji,
    };
    try {
      await FirebaseFirestore.instance
          .collection("laporan_gaji")
          .doc()
          .set(data);
    } catch (e) {
      print("Error writing document: $e");
    }
  }

  Future<void> exportAllToGoogleSheets(List<Payroll> payrolls) async {
    final url =
        'https://script.google.com/macros/s/AKfycbxXpCe87H-4q59wSiB-5OZitJFuHLgCzF27Q44DVXKXFS-StU6V8ocjR9SI7BLZsMB8/exec';

    final headers = {'Content-Type': 'application/json'};
    for (var payroll in payrolls) {
      final response = await http.post(Uri.parse(url),
          headers: headers, body: payroll.toJson());

      if (response.statusCode == 200) {
        print('Data successfully exported to Google Sheets.');
      } else {
        print(
            'Failed to export data to Google Sheets. Error: ${response.statusCode}');
      }
    }
  }
}
