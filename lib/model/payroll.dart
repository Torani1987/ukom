import 'package:cloud_firestore/cloud_firestore.dart';

class Payroll {
  String? id;
  String name;
  String gender;
  String job;
  int nip;
  int salary;
  int totalbonus;
  int totalgaji;
  DateTime payrolldate;
  String noHp;

  Payroll({
    required this.totalgaji,
    required this.payrolldate,
    required this.totalbonus,
    required this.gender,
    this.id,
    required this.name,
    required this.job,
    required this.nip,
    required this.salary,
    required this.noHp,
  });

  factory Payroll.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Payroll(
      gender: data['gender'],
      totalgaji: data['totalsalary'],
      id: doc.id,
      name: data['name'],
      payrolldate: (data['payrolldate'] as Timestamp).toDate(),
      totalbonus: data['totalbonus'],
      job: data['job'],
      nip: data['nip'] as int,
      salary: data['salary'],
      noHp: data['noHp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'job': job,
      'nip': nip,
      'salary': salary,
      'payrolldate': payrolldate,
      'no_hp': noHp,
      'totalbonus': totalbonus,
      'totalgaji': totalgaji,
      'gender': gender,
    };
  }
}
