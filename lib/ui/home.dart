import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/chicken_data.dart';
import '../model/user_data.dart';
import 'login.dart';
import 'user.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Box _boxLogin = Hive.box("login");
  final Box<ChickenData> _chickenDataBox = Hive.box<ChickenData>('chickenData');
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const HomeContent(),
      UserContent(),  
      const Center(child: Text('Settings')),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
              onPressed: () {
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
                icon: const Icon(Icons.logout_rounded),
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
            label: 'User',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0 
          ? FloatingActionButton(
              onPressed: _addMultipleChickenData,
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add),
                  Text("Tambah", style: TextStyle(fontSize: 12)),
                ],
              ),
            )
          : null,
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<ChickenData> _chickenDataBox = Hive.box<ChickenData>('chickenData');
    final Box _boxLogin = Hive.box("login");
    
    return Container(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Hallo, Bro " + _boxLogin.get("userName"),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 10),
            const DiscountBanner(),
            const SizedBox(height: 10),
            ValueListenableBuilder<Box<ChickenData>>(
              valueListenable: _chickenDataBox.listenable(),
              builder: (context, box, _) {
                final chickenDataList = box.values.toList();

                return DataTable(
                  columns: const [
                    DataColumn(label: Text('Umur')),
                    DataColumn(label: Text('Berat\n(Gr)')),
                    DataColumn(label: Text('Habis\nPakan')),
                    DataColumn(label: Text('Mati\nAyam')),
                    DataColumn(label: Text('FCR')),
                  ],
                  rows: chickenDataList.map((data) {
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
    );
  }
}

class UserContent extends StatefulWidget {
  const UserContent({Key? key}) : super(key: key);

  @override
  State<UserContent> createState() => _UserContentState();
}

class _UserContentState extends State<UserContent> {
  /// List of users
  late Future<List<User>> futureUsers;

  @override
  void initState() {
    super.initState();
    /// Get list of users
    futureUsers = UserService().getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Pengguna')),
      /// Show list of users
      body: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, AsyncSnapshot<List<User>> snapshot) {
          /// Show loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          /// Show error message
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          /// Show empty message
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data pengguna'));
          }
          final users = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: users.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.grey),
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  /// Show user profile picture
                  backgroundImage: NetworkImage(user.picture),
                  onBackgroundImageError: (_, __) {
                    // Handle image loading error
                  },
                ),
                /// Show user name
                title: Text('${user.name.first} ${user.name.last}'),
                /// Show user email
                subtitle: Text(user.email),
                trailing: const Icon(Icons.chevron_right, size: 20),
                onTap: () => _navigateToUserDetail(context, user),
              );
            },
          );
        },
      ),
    );
  }

  /// Navigate to user detail
  void _navigateToUserDetail(BuildContext context, User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserPage(user: user),
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