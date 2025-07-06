import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uts_project/model/recording_data.dart';

import '../service/firebase_service.dart';

class AddRecord extends StatefulWidget {
  const AddRecord({super.key});

  /// Creates the state of the [Signup] widget.
  @override
  State<AddRecord> createState() => _AddRecord();
}

class _AddRecord extends State<AddRecord> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;

  final FocusNode _focusNodeUmur = FocusNode();
  final FocusNode _focusNodeTerimaPakan = FocusNode();
  final FocusNode _focusNodeHabisPakan = FocusNode();
  final FocusNode _focusNodeMatiAyam = FocusNode();
  final FocusNode _focusNodeBeratAyam = FocusNode();
  final TextEditingController _controllerUmur = TextEditingController();
  final TextEditingController _controllerTerimaPakan = TextEditingController();
  final TextEditingController _controllerHabisPakan = TextEditingController();
  final TextEditingController _controllerMatiAyam = TextEditingController();
  final TextEditingController _controllerBeratAyam = TextEditingController();

  final db = FirebaseFirestore.instance;
  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addRecord() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final user = _auth.currentUser;
      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Anda harus login terlebih dahulu')),
          );
        }
        return;
      }

      final recording = RecordingData(
        umur: int.tryParse(_controllerUmur.text) ?? 0,
        terimaPakan: int.tryParse(_controllerTerimaPakan.text) ?? 0,
        habisPakan: double.tryParse(_controllerHabisPakan.text) ?? 0,
        matiAyam: int.tryParse(_controllerMatiAyam.text) ?? 0,
        beratAyam: int.tryParse(_controllerBeratAyam.text) ?? 0,
        id_periode: 1, // Sesuaikan dengan periode yang sesuai
      );

      await _firebaseService.addRecording(recording, user.email!);
      
      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              /// Header
              const SizedBox(height: 30),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "Tamba Data Recording",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: 10),
              /// Subtitle
              Text(
                "Menambakan data recording ayam broiler.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 35),
              /// Username field
              TextFormField(
                controller: _controllerUmur,
                focusNode: _focusNodeUmur,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Umur Ayam (hari)",
                  prefixIcon: const Icon(Icons.data_saver_on_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                /// Username validation
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Umur tidak boleh kosong. Silahkan masukkan umur ayam.";
                  }
                  return null;
                },
                onEditingComplete: () => _focusNodeTerimaPakan.requestFocus(),
              ),
              const SizedBox(height: 10),
              /// Terima pakan field
              TextFormField(
                controller: _controllerTerimaPakan,
                focusNode: _focusNodeTerimaPakan,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Terima pakan (sak)",
                  prefixIcon: const Icon(Icons.arrow_circle_down),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onEditingComplete: () => _focusNodeHabisPakan.requestFocus(),
              ),
              const SizedBox(height: 10),
              /// Phone field
              TextFormField(
                controller: _controllerHabisPakan,
                focusNode: _focusNodeHabisPakan,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Habis pakan (sak)",
                  prefixIcon: const Icon(Icons.arrow_circle_up),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Habis pakan tidak boleh kosong. Silahkan masukkan jumlah pakan ayam.";
                  }
                  return null;
                },
                onEditingComplete: () => _focusNodeMatiAyam.requestFocus(),
              ),
              const SizedBox(height: 10),
              /// mati ayam field
              TextFormField(
                controller: _controllerMatiAyam,
                focusNode: _focusNodeMatiAyam,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Mati ayam (Ekor)",
                  prefixIcon: const Icon(Icons.highlight_remove),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                /// Username validation
                onEditingComplete: () => _focusNodeBeratAyam.requestFocus(),
              ),
              const SizedBox(height: 10),
              /// Berat ayam field
              TextFormField(
                controller: _controllerBeratAyam,
                focusNode: _focusNodeBeratAyam,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Berat Ayam (gram)",
                  prefixIcon: const Icon(Icons.scale),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              /// Register button
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: _isLoading ? null : () {
                    if (_formKey.currentState?.validate() ?? false) {
                      addRecord();
                    }
                  },
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text("Tambah Data"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the focus nodes to prevent memory leaks.
    _focusNodeUmur.dispose();
    _focusNodeTerimaPakan.dispose();
    _focusNodeHabisPakan.dispose();
    _focusNodeMatiAyam.dispose();
    _focusNodeBeratAyam.dispose();

    // Dispose of the text editing controllers to prevent memory leaks.
    _controllerUmur.dispose();
    _controllerTerimaPakan.dispose();
    _controllerHabisPakan.dispose();
    _controllerMatiAyam.dispose();
    _controllerBeratAyam.dispose();

    // Call the superclass's dispose method.
    super.dispose();
  }
}
