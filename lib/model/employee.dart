import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  String? id;
  String name;
  String gender;
  String address;
  String job;
  int nip;
  int salary;
  double bonus;
  DateTime birthdate;
  String noHp;

  Employee({
    this.id,
    required this.name,
    required this.gender,
    required this.address,
    required this.job,
    required this.nip,
    required this.salary,
    required this.bonus,
    required this.birthdate,
    required this.noHp,
  });

  factory Employee.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Employee(
      id: doc.id,
      name: data['name'],
      gender: data['gender'],
      address: data['address'],
      job: data['job'],
      nip: data['nip'] as int,
      salary: data['salary'],
      bonus: data['bonus'],
      birthdate: (data['birthdate'] as Timestamp).toDate(),
      noHp: data['noHp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender,
      'address': address,
      'job': job,
      'nip': nip,
      'salary': salary,
      'bonus': bonus,
      'birthdate': birthdate,
      'no_hp': noHp,
    };
  }
}
