import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_system/addWasteCollection.dart';
import 'databaseService.dart';
import 'profileSettings.dart';
import 'themeProvider.dart';
import 'addWaste.dart';
import 'wasteHistory.dart';
import 'wasteMap.dart';

class HomePage extends StatefulWidget {
  final int userId;

  const HomePage({Key? key, required this.userId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<void> _wasteUpdateStream;
  late Future<Map<String, double>> _wasteDataFuture;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _wasteUpdateStream = DatabaseService().wasteUpdates;
    _wasteDataFuture = fetchWasteData();

    _wasteUpdateStream.listen((_) {
      setState(() {
        _wasteDataFuture = fetchWasteData();
      });
    });
  }

  Future<Map<String, double>> fetchWasteData() async {
    try {
      DatabaseService dbService = DatabaseService();
      double plasticWaste =
          await dbService.getTotalWasteByType(widget.userId, 1);
      double electronicWaste =
          await dbService.getTotalWasteByType(widget.userId, 2);
      double glassWaste = await dbService.getTotalWasteByType(widget.userId, 3);
      double metalWaste = await dbService.getTotalWasteByType(widget.userId, 4);
      double organicWaste =
          await dbService.getTotalWasteByType(widget.userId, 5);

      return {
        'plasticWaste': plasticWaste,
        'electronicWaste': electronicWaste,
        'glassWaste': glassWaste,
        'metalWaste': metalWaste,
        'organicWaste': organicWaste,
        'totalWaste': plasticWaste +
            electronicWaste +
            glassWaste +
            metalWaste +
            organicWaste,
      };
    } catch (e) {
      debugPrint('Error fetching waste data: $e');
      throw Exception('Failed to fetch waste data');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // Handle Home tab
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddWastePage(userId: widget.userId),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WasteHistoryPage(userId: widget.userId),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WasteMapPage(
                userId: widget.userId), // Corrected passing of userId
          ),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddWasteCollectionPage(userId: widget.userId),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor:
          themeProvider.isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        backgroundColor:
            themeProvider.isDarkMode ? Colors.grey[850] : Colors.green,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/trash_icon.png'),
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  'Welcome, Neil ',
                  style: TextStyle(
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const CircleAvatar(
                backgroundImage: AssetImage('assets/profile.png'),
                radius: 20,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileSettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/wallpaper.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          FutureBuilder<Map<String, double>>(
            future: _wasteDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                var wasteData = snapshot.data!;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Total Trash Collected',
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${wasteData['totalWaste']} kg',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildWasteCard('Plastic Waste',
                                  wasteData['plasticWaste'], Colors.blue),
                              _buildWasteCard('Electronic Waste',
                                  wasteData['electronicWaste'], Colors.orange),
                              _buildWasteCard('Glass Waste',
                                  wasteData['glassWaste'], Colors.red),
                              _buildWasteCard('Metal Waste',
                                  wasteData['metalWaste'], Colors.purple),
                              _buildWasteCard('Organic Waste',
                                  wasteData['organicWaste'], Colors.brown),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Waste',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Collection',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            themeProvider.isDarkMode ? Colors.white : Colors.black,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildWasteCard(String title, double? wasteAmount, Color color) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${wasteAmount ?? 0} kg',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp(
              theme: themeProvider.isDarkMode
                  ? ThemeData.dark()
                  : ThemeData.light(),
              home: HomePage(userId: 1),
            );
          },
        ),
      ),
    );
