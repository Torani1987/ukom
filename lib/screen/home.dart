import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ukom/model/employee.dart';
import 'package:ukom/screen/add_user.dart';
import 'package:ukom/screen/edit_user.dart';
import 'package:ukom/screen/report_payroll.dart';
import '../service/firebase_user.dart';
import 'calculation_salary.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  EmployeeService _employeeService = EmployeeService();
  List<String> id = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff333c4a),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
                onTap: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Calculation(),
                      ));
                }),
                child: Icon(Icons.calculate)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
                onTap: (() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportPayroll(),
                      ));
                }),
                child: Icon(Icons.report)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xff333c4a),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: StreamBuilder(
                        stream: Stream.periodic(const Duration(days: 1)),
                        builder: (context, snapshot) {
                          return Text(
                            DateFormat('EEEE').format(DateTime.now()),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w400,
                              height: 1.2175,
                              color: Color(0xffffffff),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        child: StreamBuilder(
                            stream: Stream.periodic(const Duration(minutes: 1)),
                            builder: (context, snapshot) {
                              return Text(
                                DateFormat('hh:mm a').format(DateTime.now()),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2175,
                                  color: Color(0xffffffff),
                                ),
                              );
                            })),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        child: StreamBuilder(
                            stream: Stream.periodic(const Duration(days: 1)),
                            builder: (context, snapshot) {
                              return Text(
                                DateFormat('yMd').format(DateTime.now()),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2175,
                                  color: Color(0xffffffff),
                                ),
                              );
                            })),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddUser(),
                          ));
                    }),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(119, 0, 0, 0),
                      width: 182,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Color(0xffff725e),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Text(
                              'Add User',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                height: 1.2175,
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 33, 20, 21),
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<List<Employee>>(
                        stream: _employeeService.getEmployeesStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasData) {
                            final employees = snapshot.data!;
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: employees.length,
                              itemBuilder: (context, index) {
                                final employee = employees[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: employee.gender ==
                                            'Laki-laki'
                                        ? AssetImage(
                                            'asset/image/vector/male_avatar.png')
                                        : AssetImage(
                                            'asset/image/vector/female_avatar.png'),
                                    radius: 50,
                                    backgroundColor: Colors.grey,
                                  ),
                                  title: Text(
                                    employee.name,
                                    maxLines: 2,
                                  ),
                                  subtitle: Text(
                                    employee.job,
                                    maxLines: 2,
                                  ),
                                  trailing: Wrap(
                                    spacing: 12,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditUser(
                                                employee: employee,
                                                id: employee.nip.toString(),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(Icons.edit),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    "Hapus Karyawan"),
                                                content: const Text(
                                                    "Apakah anda yakin ingin menghapus karyawan ini?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      _employeeService
                                                          .deleteEmployee(
                                                              employee.id);
                                                      Get.snackbar(
                                                        'Information',
                                                        'Data user berhasil dihapus',
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        backgroundColor:
                                                            Color(0xffff725e),
                                                        margin:
                                                            EdgeInsets.all(15),
                                                        duration: Duration(
                                                            seconds: 3),
                                                        isDismissible: true,
                                                        forwardAnimationCurve:
                                                            Curves.easeOutBack,
                                                      );
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text(
                                                      "Hapus",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child: const Text("Batal"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text('Tidak ada karyawan.');
                          } else {
                            return const Center(
                              child: Text('Tidak ada karyawan.'),
                            );
                          }
                        },
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
