import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'farmer_model.dart';

class AddFarmerPage extends StatefulWidget {
  const AddFarmerPage({super.key});

  @override
  State<AddFarmerPage> createState() => _AddFarmerPageState();
}

class _AddFarmerPageState extends State<AddFarmerPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final bankController = TextEditingController();
  final ifscController = TextEditingController();

  final supabase = Supabase.instance.client;

  bool isSaving = false;

  Future<void> saveFarmer() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => isSaving = true);

      final response = await supabase
          .from('farmers')
          .insert({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'bank_account': bankController.text.trim(),
        'ifsc': ifscController.text.trim(),
        'rating': 0,
        'is_active': true,
      })
          .select()
          .single();

      final newFarmer = FarmerModel.fromMap(response);

      Get.back(result: true);

      Get.snackbar(
        'Success',
        'Farmer ${newFarmer.farmerCode} added successfully',
      );

    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Farmer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _input(nameController, 'Farmer Name'),
              _input(phoneController, 'Phone'),
              _input(bankController, 'Bank Account'),
              _input(ifscController, 'IFSC Code'),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: isSaving ? null : saveFarmer,
                  child: isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Save Farmer'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
        value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }
}