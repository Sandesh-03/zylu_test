import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zylu_test/constants.dart';

import '../model/employee_model.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addEmployee');
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('employees').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<Employee> employees = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Employee(
              name: data['name'],
              yearsWithCompany: data['yearsWithCompany'],
              isActive: data['isActive'],
            );
          }).toList();

          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (BuildContext context, int index) {
              final employee = employees[index];
              return Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color:  employee.isActive ? Colors.green : Colors.red),
                  color: employee.isActive && employee.yearsWithCompany >5 ? Colors.greenAccent : Colors.redAccent
                ),
                child: ListTile(
                  title: Text(employee.name,style: kTitle,),
                  subtitle: Text(
                      'Years with company: ${employee.yearsWithCompany}', style: kSubtitle,),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
