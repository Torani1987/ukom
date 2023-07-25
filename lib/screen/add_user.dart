import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ukom/service/firebase_user.dart';
import 'package:ukom/widget/button.dart';
import '../utils/validator.dart';
import '../widget/input_formfield.dart';
import 'package:get/get.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nipController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController telpController = TextEditingController();
  String? jenisKelamin = 'Laki-laki';
  String jabatan = 'Staff';
  int gajiPokok = 0;
  double bonusGaji = 0;
  final validator = Validator();

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
                            backgroundColor: Colors.grey,
                            radius: 75,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Add User',
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
                                  color: Colors.white,
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
                                  value: jenisKelamin,
                                  onChanged: (index) {
                                    setState(() {
                                      jenisKelamin = index;
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
                                  value: jabatan,
                                  onChanged: (index) {
                                    setState(() {
                                      jabatan = index!;
                                      switch (jabatan) {
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
                            const SizedBox(height: 30),
                            ButtonWidget(
                                onPressed: (() {
                                  if (_formKey.currentState!.validate()) {
                                    final karyawanCollection =
                                        EmployeeService();
                                    final String tglLahir =
                                        DateFormat("yyyy-MM-dd")
                                            .parse(dateController.text)
                                            .toString();

                                    karyawanCollection.addKaryawan(
                                      int.parse(nipController.text),
                                      namaController.text,
                                      Timestamp.fromDate(
                                        DateTime.parse(tglLahir),
                                      ),
                                      jabatan,
                                      jenisKelamin!,
                                      alamatController.text,
                                      telpController.text,
                                    );
                                    Get.snackbar(
                                      'Information',
                                      'Data user berhasil ditambahkan',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Color(0xffff725e),
                                      margin: EdgeInsets.all(15),
                                      duration: Duration(seconds: 3),
                                      isDismissible: true,
                                      forwardAnimationCurve: Curves.easeOutBack,
                                    );
                                    Navigator.of(context).pop();
                                  }
                                }),
                                nameButton: 'Add User')
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
