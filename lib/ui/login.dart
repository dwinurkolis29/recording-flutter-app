import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'home.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  // focus node  untuk email
  final FocusNode _focusNodePassword = FocusNode();

  // membuat controller untuk email dan password
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  // membuat variabel untuk menyimpan status password
  bool _obscurePassword = true;

  // hive box untuk login
  final Box _boxLogin = Hive.box("login");

  // hive box untuk accounts
  final Box _boxAccounts = Hive.box("accounts");

  // fungsi untuk login
  void login() async {
    try {
      // Menggunakan FirebaseAuth untuk login
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      if (_formKey.currentState?.validate() ?? false) {
        // Menyimpan email dan password ke Hive box ketika login berhasil
        _boxLogin.put("loginStatus", true);
        _boxLogin.put("Email", _controllerEmail.text);

        Navigator.pushReplacement(
          context,
          // Navigasi ke halaman Home
          MaterialPageRoute(
            builder: (context) {
              return Home();
            },
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // cek apakah user sudah login
    if (_boxLogin.get("loginStatus") ?? false) {
      return Home();
    }

    return Scaffold(
      // Membuat background warna biru
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Form(
        key: _formKey,
        // menggunakan scroll view agar form dapat di scroll
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              // Header aplikasi
              const SizedBox(height: 150),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // load gambar
                  const Image(
                    width: 50,
                    height: 50,
                    image: AssetImage('images/hen.png'),
                  ),
                  Text(
                    "Recording App",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Silahkan login terlebih dahulu",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 60),
              // Email field
              TextFormField(
                controller: _controllerEmail,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // validasi email
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !value.contains('@') ||
                      !value.contains('.')) {
                    return 'Email tidak valid';
                  }
                  return null;
                },
                onEditingComplete: () => _focusNodePassword.requestFocus(),
              ),
              const SizedBox(height: 10),
              // Password field
              TextFormField(
                controller: _controllerPassword,
                focusNode: _focusNodePassword,
                obscureText: _obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.password_outlined),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        // mengubah status password untuk menampilkan password
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon:
                        _obscurePassword
                            ? const Icon(Icons.visibility_outlined)
                            : const Icon(Icons.visibility_off_outlined),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              // Tombol login
              Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    // memanggil fungsi login
                    onPressed: login,
                    child: const Text("Login"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Belum punya account?"),
                      TextButton(
                        onPressed: () {
                          _formKey.currentState?.reset();

                          // Navigasi ke halaman signup jika tombol "Daftar" ditekan
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const Signup();
                              },
                            ),
                          );
                        },
                        child: const Text("Daftar"),
                      ),
                    ],
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
    // membuang focus node agar tidak terjadi memory leak
    _focusNodePassword.dispose();

    // membuang controller agar tidak terjadi memory leak
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
