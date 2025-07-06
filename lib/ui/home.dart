import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:uts_project/service/firebase_service.dart';
import 'package:uts_project/component/statistics_section.dart';
import 'package:uts_project/component/datatable.dart';
import 'package:uts_project/component/population_widget.dart';
import 'package:uts_project/ui/form_record.dart';
import 'package:uts_project/ui/login.dart';
import 'package:uts_project/model/recording_data.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Box _boxLogin = Hive.box("login");
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const HomeContent(),
      const Center(child: Text('Peternak')),
      const Center(child: Text('Settings')),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Apakah kamu yakin ingin logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop();
                _boxLogin.clear();
                _boxLogin.put("loginStatus", false);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _navigateToAddRecord() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddRecord()),
    );

    // Jika result adalah true, StreamBuilder akan otomatis memperbarui
    if (result == true && mounted) {
      // StreamBuilder akan otomatis memperbarui karena data di Firestore sudah berubah
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil ditambahkan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text("Recording App"),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(Icons.login_outlined),
              ),
            ),
          )
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Peternak',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_max_outlined),
            label: 'Kandang',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: (index) => _onItemTapped(index),
      ),
      floatingActionButton: _selectedIndex == 0 
          ? FloatingActionButton.extended(
              onPressed: (){
                _navigateToAddRecord();
              },
              icon: Icon(Icons.add),
              label: Text("Tambah"),
            )
          : null,
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final Box _boxLogin = Hive.box("login");

    List<RecordingData> chickenDataList = [
      RecordingData(
        umur: 1,
        terimaPakan: 10,
        habisPakan: 0.5,
        matiAyam: 5,
        beratAyam: 400,
      ),
      // Add more chicken data as needed
    ];
    
    return Container(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_outline_outlined,
                ),
                const SizedBox(width: 10),
                Text(
                  _boxLogin.get("Email"),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 10),
            const PopulationSection(),
            const SizedBox(height: 15),
            const StatisticsSection(),
            const SizedBox(height: 10),
            StreamBuilder<List<RecordingData>>(
              stream: FirebaseService().getRecordingsStream(1, "kolis@gmail.com"),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  return ChickenDataTable(chickenDataList: snapshot.data!);
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
