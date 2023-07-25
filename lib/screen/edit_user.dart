import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ukom/model/employee.dart';
import 'package:ukom/screen/home.dart';
import 'package:ukom/service/firebase_user.dart';

import '../utils/validator.dart';
import '../widget/input_formfield.dart';

class EditUser extends StatefulWidget {
  EditUser({required this.employee, required this.id, super.key});
  Employee employee;
  final String id;

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  String? jenisKelamin;
  String? jabatan;
  late String id = widget.id;
  TextEditingController nipController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController telpController = TextEditingController();
  final validator = Validator();
  final _formKey = GlobalKey<FormState>();
  int gajiPokok = 0;
  double bonusGaji = 0;
  @override
  void initState() {
    final employee = widget.employee;
    jenisKelamin = employee.gender;
    jabatan = employee.job;
    nipController.text = employee.nip.toString();
    namaController.text = employee.name;
    alamatController.text = employee.address;
    dateController.text = DateFormat('dd-MM-yyyy').format(employee.birthdate);
    telpController.text = employee.noHp;

    super.initState();
  }

  @override
  void dispose() {
    nipController.dispose();
    namaController.dispose();
    dateController.dispose();
    alamatController.dispose();
    telpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Expanded(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff333c4a),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(111, 44, 111, 30),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            child: ClipOval(
                              child: widget.employee.gender == 'Laki-laki'
                                  ? Image.asset(
                                      'asset/image/vector/male_avatar.png',
                                      width: 1000,
                                      height: 1000,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'asset/image/vector/female_avatar.png',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            radius: 75,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Edit User',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                                height: 1.2175,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 30, 31, 76),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color(0xfffafafa),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25))),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "NIP",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            InputFormField(
                              validator: (field) =>
                                  validator.validateNip(nip: field!),
                              controller: nipController,
                              keyboardType: TextInputType.number,
                              maxLength: 15,
                              hintText: 'Masukkan NIP Anda..',
                            ),
                            const Text(
                              "Nama",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            InputFormField(
                              validator: (field) =>
                                  validator.validateNama(nama: field!),
                              controller: namaController,
                              keyboardType: TextInputType.name,
                              maxLength: 25,
                              hintText: 'Masukkan nama Anda..',
                            ),
                            const Text(
                              "Tanggal Lahir",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            InputFormField(
                              validator: (field) =>
                                  validator.validateField(field: field!),
                              controller: dateController,
                              keyboardType: TextInputType.datetime,
                              hintText: 'Masukkan tanggal lahir Anda..',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1950, 1),
                                      lastDate: DateTime.now(),
                                      builder: (context, picker) {
                                        return Theme(
                                          data: ThemeData.light().copyWith(
                                            dialogBackgroundColor: Colors.white,
                                          ),
                                          child: picker!,
                                        );
                                      }).then((selectedDate) {
                                    if (selectedDate != null) {
                                      dateController.text =
                                          DateFormat('yyy-MM-dd')
                                              .format(selectedDate);
                                    }
                                  });
                                },
                                icon: const Icon(
                                  Icons.date_range,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Jenis Kelamin",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: const Text("Masukkan Jenis Kelamin"),
                                  borderRadius: BorderRadius.circular(10),
                                  items: <String>['Laki-laki', 'Perempuan']
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  value: widget.employee.gender,
                                  onChanged: (index) {
                                    setState(() {
                                      widget.employee.gender = index!;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Jabatan",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: const Text("Input Jabatan"),
                                  borderRadius: BorderRadius.circular(10),
                                  items: <String>[
                                    'Staff',
                                    'Supervisor',
                                    'Manager'
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  value: widget.employee.job,
                                  onChanged: (index) {
                                    setState(() {
                                      widget.employee.job = index!;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Alamat",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            InputFormField(
                              validator: (field) =>
                                  validator.validateField(field: field!),
                              controller: alamatController,
                              keyboardType: TextInputType.streetAddress,
                              hintText: 'Masukkan alamat rumah Anda..',
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "No. Telepon",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            InputFormField(
                              validator: (field) =>
                                  validator.validateTelp(noTelp: field!),
                              controller: telpController,
                              keyboardType: TextInputType.phone,
                              maxLength: 15,
                              hintText: 'Masukkan nomor telepon Anda..',
                            ),
                            SizedBox(height: 30),
                            InkWell(
                              onTap: (() {
                                if (_formKey.currentState!.validate()) {
                                  EmployeeService employeeService =
                                      EmployeeService();
                                  final String tglLahir =
                                      DateFormat("yyyy-MM-dd")
                                          .parse(dateController.text)
                                          .toString();
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Edit Karyawan"),
                                        content: const Text(
                                            "Apakah anda yakin ingin mengubah data karyawan ini?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              switch (widget.employee.job) {
                                                case 'Manager':
                                                  gajiPokok = 7000000;
                                                  bonusGaji = 0.5;
                                                  break;
                                                case 'Supervisor':
                                                  gajiPokok = 5000000;
                                                  bonusGaji = 0.4;
                                                  break;
                                                case 'Staff':
                                                  gajiPokok = 4000000;
                                                  bonusGaji = 0.3;
                                                  break;
                                                default:
                                              }
                                              final tglLahir = DateFormat(
                                                      "dd-MM-yyyy")
                                                  .parse(dateController.text);

                                              final newKaryawan = Employee(
                                                id: widget.employee.id,
                                                nip: int.parse(
                                                    nipController.text),
                                                name: namaController.text,
                                                birthdate: tglLahir,
                                                gender: widget.employee.gender,
                                                job: widget.employee.job,
                                                address: alamatController.text,
                                                noHp: telpController.text,
                                                salary: gajiPokok,
                                                bonus: bonusGaji,
                                              );
                                              employeeService
                                                  .updateEmployee(newKaryawan);
                                              Get.snackbar(
                                                'Information',
                                                'Data user berhasil diubah',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                backgroundColor:
                                                    Color(0xffff725e),
                                                margin: EdgeInsets.all(15),
                                                duration: Duration(seconds: 3),
                                                isDismissible: true,
                                                forwardAnimationCurve:
                                                    Curves.easeOutBack,
                                              );
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Home(),
                                                      ),
                                                      (route) => false);
                                            },
                                            child: const Text(
                                              "Edit",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text("Batal"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              }),
                              child: Container(
                                // autogroup9rsqRjZ (QrssFFn3amStTbGRQj9Rsq)
                                margin: EdgeInsets.fromLTRB(1.5, 0, 1.5, 0),
                                width: MediaQuery.of(context).size.width,
                                height: 59,
                                decoration: BoxDecoration(
                                  color: Color(0xffff725e),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'Edit User',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w400,
                                      height: 1.2175,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
