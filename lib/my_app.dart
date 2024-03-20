import 'package:flutter/material.dart';

import 'screens/add_employee.dart';
import 'screens/employee_list.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => EmployeeListScreen(),
        '/addEmployee': (context) => AddEmployeeScreen(),
      },
    );
  }
}