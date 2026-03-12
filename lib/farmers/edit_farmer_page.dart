import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'farmer_model.dart';

class EditFarmerPage extends StatefulWidget {
  final FarmerModel farmer;

  const EditFarmerPage({super.key, required this.farmer});

  @override
  State<EditFarmerPage> createState() => _EditFarmerPageState();
}

class _EditFarmerPageState extends State<EditFarmerPage> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController bankController;
  late TextEditingController ifscController;

  bool isActive = true;
  bool isSaving = false;

  @override
  void initState() {
    final f = widget.farmer;

    nameController = TextEditingController(text: f.name);
    phoneController = TextEditingController(text: f.phone ?? '');
    bankController = TextEditingController(text: f.bankAccount ?? '');
    ifscController = TextEditingController(text: f.ifsc ?? '');
    isActive = f.isActive;

    super.initState();
  }

  Future<void> updateFarmer() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => isSaving = true);

      await supabase
          .from('farmers')
          .update({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'bank_account': bankController.text.trim(),
        'ifsc': ifscController.text.trim(),
        'is_active': isActive,
      })
          .eq('id', widget.farmer.id);

      Get.back(result: true);
      Get.snackbar('Success', 'Farmer updated');

    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      setState(() => isSaving = false);
    }
  }

  Future<void> softDeleteFarmer() async {
    await supabase
        .from('farmers')
        .update({'is_active': false})
        .eq('id', widget.farmer.id);

    Get.back(result: true);
    Get.snackbar('Deleted', 'Farmer deactivated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Farmer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _input(nameController, 'Name'),
              _input(phoneController, 'Phone'),
              _input(bankController, 'Bank Account'),
              _input(ifscController, 'IFSC'),

              SwitchListTile(
                title: const Text('Active'),
                value: isActive,
                onChanged: (val) {
                  setState(() => isActive = val);
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: isSaving ? null : updateFarmer,
                child: const Text('Update Farmer'),
              ),

              const SizedBox(height: 12),

              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                onPressed: softDeleteFarmer,
                child: const Text('Deactivate Farmer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (v) =>
        v == null || v.isEmpty ? 'Required' : null,
      ),
    );
  }
}