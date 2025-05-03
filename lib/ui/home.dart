import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../model/chicken_data.dart';
import 'login.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final Box _boxLogin = Hive.box("login");
  final Box<ChickenData> _chickenDataBox = Hive.box<ChickenData>('chickenData');

  void _addMultipleChickenData() {
    // Define a list of ChickenData instances
    List<ChickenData> chickenDataList = [
      ChickenData(umur: 1, berat: 36, habisPakan: 0.5, matiAyam: 8, fcr: 1.5),
      ChickenData(umur: 2, berat: 50, habisPakan: 0.5, matiAyam: 2, fcr: 1.6),
      ChickenData(umur: 3, berat: 75, habisPakan: 0.5, matiAyam: 0, fcr: 1.7),
      ChickenData(umur: 4, berat: 90, habisPakan: 1, matiAyam: 1, fcr: 1.8),
      ChickenData(umur: 5, berat: 100, habisPakan: 1, matiAyam: 0, fcr: 1.9),
    ];

    // Add each instance to the Hive box
    for (var chickenData in chickenDataList) {
      _chickenDataBox.add(chickenData);
    }
  }

  void _deleteAllChickenData() {
    // Clear all data from the box
    _chickenDataBox.clear();
  }


  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Apakah kamu yakin ingin logout?'),
          actions: <Widget>[
            /// Cancel button
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); /// Close the dialog
              },
            ),
            /// Logout button
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop(); /// Close the dialog
                _boxLogin.clear(); /// Clear login data
                _boxLogin.put("loginStatus", false); /// Update login status
                /// Navigate to Login screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const Login(); /// Return to login screen
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text("Recording App"),
        elevation: 0,
        actions: [
          /// Logout button with icon
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: IconButton(
                /// On pressed, show logout dialog
                onPressed: () => _showLogoutDialog(context) ,
                icon: const Icon(Icons.logout_rounded),
              ),
            ),
          )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    /// Get username from login data
                    "Hallo, Bro " + _boxLogin.get("userName"),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const DiscountBanner(),
              const SizedBox(height: 10),
              /// Show data table
              ValueListenableBuilder<Box<ChickenData>>(
                valueListenable: _chickenDataBox.listenable(),
                builder: (context, box, _) {
                  final chickenDataList = box.values.toList();

                  return DataTable(
                    /// Define columns
                    columns: const [
                      DataColumn(label: Text('Umur')),
                      DataColumn(label: Text('Berat\n(Gr)')),
                      DataColumn(label: Text('Habis\nPakan')),
                      DataColumn(label: Text('Mati\nAyam')),
                      DataColumn(label: Text('FCR')),
                    ],
                    rows: chickenDataList.map((data) {
                      /// Define rows
                      return DataRow(cells: [
                        DataCell(Text(data.umur.toString())),
                        DataCell(Text(data.berat.toString())),
                        DataCell(Text(data.habisPakan.toString())),
                        DataCell(Text(data.matiAyam.toString())),
                        DataCell(Text(data.fcr.toString())),
                      ]);
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      /// Add button
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addMultipleChickenData(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add), // Icon
            Text("Tambah", style: TextStyle(fontSize: 12)), // Text
          ],
        ),
      ),
    );
  }
}

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 35,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Kandang kolis",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time_sharp,
                      color: Colors.indigo,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "Umur \n5 Hari",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_balance_rounded,
                      color: Colors.indigo,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "Populasi \n2000",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.bar_chart_rounded,
                      color: Colors.indigo,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "Berat \n100 Gr",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ]
      ),
    );
  }
}