import 'package:flutter/material.dart';
import 'package:trash_system/addWaste.dart';
import 'package:trash_system/addWasteCollection.dart';
import 'package:trash_system/homepage.dart';
import 'package:trash_system/wasteHistory.dart';

class WasteMapPage extends StatefulWidget {
  final int userId;
  const WasteMapPage({Key? key, required this.userId}) : super(key: key);

  @override
  _WasteMapPageState createState() => _WasteMapPageState();
}

class _WasteMapPageState extends State<WasteMapPage> {
  int _currentIndex = 3;

  final List<Widget> _pages = [
    Center(child: Text('Home Page')),
    Center(child: Text('Add Waste Page')),
    Center(child: Text('History Page')),
    WasteMapContent(),
    Center(child: Text('Collection Page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userId: widget.userId),
          ),
        );
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
        // Do nothing since it's the current page
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Collections Points'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2E7D32),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.green[200],
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
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
      ),
    );
  }
}

class WasteMapContent extends StatelessWidget {
  const WasteMapContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Map
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/Waste_Map_thumb_1200x630.jpg'), // Ensure this path is correct
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Recycling Icon
        const Positioned(
          top: 20,
          left: 20,
          child: Icon(
            Icons.recycling,
            size: 50,
            color: Colors.green,
          ),
        ),
        // Collection Points Icons
        Positioned(
          top: 100,
          right: 20,
          child: Column(
            children: [
              _buildCollectionIcon(Icons.local_drink, Colors.red),
              _buildCollectionIcon(Icons.battery_full, Colors.yellow),
              _buildCollectionIcon(Icons.local_drink, Colors.blue),
              _buildCollectionIcon(Icons.delete, Colors.green),
            ],
          ),
        ),
        // Bottom Info Card
        const Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Card(
            margin: EdgeInsets.all(0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lorem Street 00/00',
                          style: TextStyle(fontSize: 18)),
                      Text('30 min', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Icon(Icons.local_drink, color: Colors.blue),
                  Text('Plastic', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCollectionIcon(IconData iconData, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Icon(iconData, size: 40, color: color),
    );
  }
}
