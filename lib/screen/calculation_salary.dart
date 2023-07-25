import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ukom/screen/home.dart';
import 'package:ukom/service/firebase_payroll.dart';
import 'package:ukom/service/firebase_user.dart';
import 'package:ukom/widget/button.dart';
import 'package:ukom/widget/showdataform.dart';
import '../model/employee.dart';

import 'package:intl/intl.dart ';
import '../utils/validator.dart';
import '../widget/input_formfield.dart';

class Calculation extends StatefulWidget {
  const Calculation({Key? key}) : super(key: key);

  @override
  State<Calculation> createState() => _CalculationState();
}

class _CalculationState extends State<Calculation> {
  EmployeeService _firebaseInstance = EmployeeService();
  late Stream<List<Employee>> employeesStream;
  Employee? selectedEmployee;
  final nameController = TextEditingController();
  final jobController = TextEditingController();
  final phoneController = TextEditingController();
  final genderController = TextEditingController();
  final salaryController = TextEditingController();
  final noHpController = TextEditingController();
  final nipController = TextEditingController();

  final dateController = TextEditingController();
  final totalSalaryController = TextEditingController();
  final totalBonusController = TextEditingController();
  final formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  final validator = Validator();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    employeesStream = _firebaseInstance.getEmployeesStream();
  }

  String cleanCurrencyValue(String formattedValue) {
    return formattedValue.replaceAll(RegExp(r'[^\d]'), '');
  }

  int parseCurrencyToInt(String formattedValue) {
    return int.parse(formattedValue.replaceAll('Rp ', '').replaceAll('.', ''));
  }

  void calculateBonus() {
    try {
      final bonus = selectedEmployee!.salary;
      final salary = selectedEmployee!.bonus;
      final totalBonus = bonus * salary;
      totalBonusController.text = formatCurrency.format(totalBonus);
    } catch (e) {
      totalBonusController.text = 'error';
    }
  }

  void calculateTotalSalary() {
    try {
      final bonus = selectedEmployee!.bonus;
      final salary = selectedEmployee!.salary;
      double ppn = 0.05;
      final bonusTotal = bonus * salary;
      final ppnGaji = (salary + bonusTotal) * ppn;
      final totalSalary = (bonusTotal + salary) - ppnGaji;
      totalSalaryController.text = formatCurrency.format(totalSalary);
    } catch (e) {
      totalSalaryController.text = 'error';
    }
  }

  void _handleEmployeeSelected(Employee? employee) {
    setState(() {
      selectedEmployee = employee;
      if (selectedEmployee != null) {
        nameController.text = selectedEmployee!.name;
        jobController.text = selectedEmployee!.job;
        phoneController.text = selectedEmployee!.noHp;
        genderController.text = selectedEmployee!.gender;
        salaryController.text = selectedEmployee!.salary.toString();
        noHpController.text = selectedEmployee!.noHp;
        nipController.text = selectedEmployee!.nip.toString();
        calculateBonus();
        calculateTotalSalary();
      } else {
        nameController.clear();
        jobController.clear();
        phoneController.clear();
        genderController.clear();
        salaryController.clear();
        noHpController.clear();
        nipController.clear();
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    jobController.dispose();
    phoneController.dispose();
    genderController.dispose();
    salaryController.dispose();
    noHpController.dispose();
    nipController.dispose();

    super.dispose();
  }

  void _showEmployeeDetails() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Detail Gaji'),
                  const SizedBox(
                    height: 20,
                  ),
                  ShowDataForm(label: 'NIP', valueController: nipController),
                  SizedBox(
                    height: 20,
                  ),
                  ShowDataForm(label: 'Nama', valueController: nameController),
                  SizedBox(
                    height: 20,
                  ),
                  ShowDataForm(label: 'Job', valueController: jobController),
                  SizedBox(
                    height: 20,
                  ),
                  InputFormField(
                    validator: (field) =>
                        validator.validateField(field: field!),
                    controller: dateController,
                    keyboardType: TextInputType.datetime,
                    hintText: 'Masukkan Tanggal Gaji',
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
                                DateFormat('yyy-MM-dd').format(selectedDate);
                          }
                        });
                      },
                      icon: const Icon(
                        Icons.date_range,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ShowDataForm(
                      label: 'Gaji',
                      valueController: TextEditingController(
                          text:
                              formatCurrency.format(selectedEmployee!.salary))),
                  SizedBox(
                    height: 20,
                  ),
                  ShowDataForm(
                    label: 'Bonus',
                    valueController: totalBonusController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ShowDataForm(
                    label: 'Total Gaji',
                    valueController: totalSalaryController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ButtonWidget(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final String payrollDate = DateFormat("yyyy-MM-dd")
                              .parse(dateController.text)
                              .toString();
                          PayrollService _payrollService = PayrollService();
                          _payrollService.addGaji(
                            int.parse(nipController.text),
                            nameController.text,
                            Timestamp.fromDate(
                              DateTime.parse(payrollDate),
                            ),
                            jobController.text,
                            genderController.text,
                            int.parse(salaryController.text),
                            int.parse(
                                cleanCurrencyValue(totalSalaryController.text)),
                            noHpController.text,
                            int.parse(
                                cleanCurrencyValue(totalBonusController.text)),
                          );
                          Get.snackbar(
                            'Information',
                            'Data user berhasil diubah',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Color(0xffff725e),
                            margin: EdgeInsets.all(15),
                            duration: Duration(seconds: 3),
                            isDismissible: true,
                            forwardAnimationCurve: Curves.easeOutBack,
                          );
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => Home(),
                              ),
                              (route) => false);
                        }
                      },
                      nameButton: 'Submit')
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                StreamBuilder<List<Employee>>(
                  stream: employeesStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final employees = snapshot.data!;
                      return DropdownButtonFormField<Employee>(
                        value: selectedEmployee,
                        items: employees.map((employee) {
                          return DropdownMenuItem<Employee>(
                            value: employee,
                            child: Text(employee.name),
                          );
                        }).toList(),
                        onChanged: _handleEmployeeSelected,
                        decoration: const InputDecoration(
                          labelText: 'Select an employee',
                          border: OutlineInputBorder(),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Text('Error loading employees');
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
                SizedBox(height: 16),
                if (selectedEmployee != null)
                  Column(
                    children: [
                      ShowDataForm(
                          label: 'NIP', valueController: nipController),
                      SizedBox(
                        height: 20,
                      ),
                      ShowDataForm(
                          label: 'Nama', valueController: nameController),
                      SizedBox(
                        height: 20,
                      ),
                      ShowDataForm(
                          label: 'Jabatan', valueController: jobController),
                      SizedBox(
                        height: 20,
                      ),
                      ShowDataForm(
                          label: 'Jenis Kelamin',
                          valueController: genderController),
                      SizedBox(
                        height: 20,
                      ),
                      ShowDataForm(
                          label: 'Gaji',
                          valueController: TextEditingController(
                              text: formatCurrency
                                  .format(selectedEmployee!.salary))),
                      SizedBox(
                        height: 20,
                      ),
                      ShowDataForm(
                          label: 'No Hp', valueController: noHpController),
                      SizedBox(
                        height: 20,
                      ),
                      ButtonWidget(
                          onPressed: () {
                            _showEmployeeDetails();
                          },
                          nameButton: 'calculate')
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
