import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/employee.dart';

class EmployeeService {
  final CollectionReference _employeesCollection =
      FirebaseFirestore.instance.collection('karyawan');

  Stream<List<Employee>> getEmployeesStream() {
    return _employeesCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Employee.fromFirestore(doc)).toList());
  }

  Future<void> addEmployee(Employee employee) async {
    await _employeesCollection.add(employee.toJson());
  }

  Future<void> updateEmployee(Employee employee) async {
    await _employeesCollection.doc(employee.id).update(employee.toJson());
  }

  Future<void> deleteEmployee(String? id) async {
    await _employeesCollection.doc(id).delete();
  }

  void addKaryawan(
    int nip,
    String nama,
    Timestamp tglLahir,
    String jabatan,
    String jenisKelamin,
    String alamat,
    String noTelp,
  ) async {
    int? gajiPokok;
    double? bonusGaji;

    switch (jabatan) {
      case 'Staff':
        gajiPokok = 4000000;
        bonusGaji = 0.3;
        break;
      case 'Supervisor':
        gajiPokok = 5000000;
        bonusGaji = 0.4;
        break;
      case 'Manager':
        gajiPokok = 7000000;
        bonusGaji = 0.5;
        break;
      default:
    }

    final data = {
      "nip": nip,
      "name": nama,
      "birthdate": tglLahir,
      "job": jabatan,
      "gender": jenisKelamin,
      "address": alamat,
      "noHp": noTelp,
      "salary": gajiPokok,
      "bonus": bonusGaji,
    };

    try {
      await FirebaseFirestore.instance.collection("karyawan").doc().set(data);
    } catch (e) {
      print("Error writing document: $e");
    }
  }

  void updateKaryawan(
    String docId,
    String nip,
    String nama,
    Timestamp tglLahir,
    String jabatan,
    String jenisKelamin,
    String alamat,
    String noTelp,
  ) async {
    int? gajiPokok;
    double? bonusGaji;

    switch (jabatan) {
      case 'Staff':
        gajiPokok = 4000000;
        bonusGaji = 0.3;
        break;
      case 'Supervisor':
        gajiPokok = 5000000;
        bonusGaji = 0.4;
        break;
      case 'Manager':
        gajiPokok = 7000000;
        bonusGaji = 0.5;
        break;
      default:
        gajiPokok = 0;
        bonusGaji = 0;
    }

    final data = {
      "nip": nip,
      "nama": nama,
      "tgl_lahir": tglLahir,
      "jabatan": jabatan,
      "jenis_kelamin": jenisKelamin,
      "alamat": alamat,
      "no_telp": noTelp,
      "gaji_pokok": gajiPokok,
      "bonus_gaji": bonusGaji,
    };

    try {
      await _employeesCollection.doc(docId).update(data);
    } catch (e) {
      print("Error updating document: $e");
    }
  }
}
