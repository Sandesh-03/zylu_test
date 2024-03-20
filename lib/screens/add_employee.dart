import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  bool _isActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration:  InputDecoration(labelText: 'Name',border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: _yearsController,
              decoration: InputDecoration(
                  labelText: 'Years with Company',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 20,),

            CheckboxListTile(
              title: const Text('Active'),
              value: _isActive,
              onChanged: (bool? value) {
                setState(() {
                  _isActive = value!;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _addEmployee();
                  },
                  child: const Text(
                    'Add Employee',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    clear();
                  },
                  child: const Text(
                    'Clear Form',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void clear() {
    _nameController.clear();
    _yearsController.clear();
    _isActive = false;
  }

  void _addEmployee() {
    String name = _nameController.text.trim();
    int years = int.tryParse(_yearsController.text.trim()) ?? 0;

    if (name.isNotEmpty && years > 0) {
      FirebaseFirestore.instance.collection('employees').add({
        'name': name,
        'yearsWithCompany': years,
        'isActive': _isActive,
      }).then((value) {
        Navigator.pop(context); // Navigate back to Employee List screen
      }).catchError((error) {
        if (kDebugMode) {
          print("Failed to add employee: $error");
        }
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content:
                const Text('Please enter valid name and years with company.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _yearsController.dispose();
    super.dispose();
  }
}
