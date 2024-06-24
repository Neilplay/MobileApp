import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_system/addWasteCollection.dart';
import 'package:trash_system/homepage.dart';
import 'package:trash_system/wasteHistory.dart';
import 'package:trash_system/wasteMap.dart';
import 'package:trash_system/themeProvider.dart'; // Assuming correct import
import 'package:trash_system/databaseService.dart'; // Assuming correct import

class AddWastePage extends StatefulWidget {
  final int userId;

  const AddWastePage({Key? key, required this.userId}) : super(key: key);

  @override
  _AddWastePageState createState() => _AddWastePageState();
}

class _AddWastePageState extends State<AddWastePage> {
  String? _selectedWasteType;
  final List<String> _wasteTypes = [
    'Plastic waste',
    'Electronic waste',
    'Glass waste',
    'Metal waste',
    'Organic waste'
  ];
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  int _selectedIndex = 1;

  @override
  void dispose() {
    _weightController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _addWaste() async {
    if (_selectedWasteType != null &&
        _weightController.text.isNotEmpty &&
        _nameController.text.isNotEmpty) {
      double weight = double.tryParse(_weightController.text) ?? 0.0;
      int wasteTypeId = _getWasteTypeId(_selectedWasteType!);

      await DatabaseService().addWaste(
        widget.userId,
        wasteTypeId,
        weight,
        _nameController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Waste added successfully')),
      );

      setState(() {
        _selectedWasteType = null;
        _weightController.clear();
        _nameController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
    }
  }

  int _getWasteTypeId(String type) {
    switch (type) {
      case 'Plastic waste':
        return 1;
      case 'Electronic waste':
        return 2;
      case 'Glass waste':
        return 3;
      case 'Metal waste':
        return 4;
      case 'Organic waste':
        return 5;
      default:
        return 1; // Default to Plastic waste
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userId: widget.userId),
          ),
        );
        break;
      case 1:
        // Current page, do nothing
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WasteHistoryPage(userId: widget.userId),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WasteMapPage(userId: widget.userId),
          ),
        );
        break;
      case 4:
        Navigator.pushReplacement(
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF004D40), Color(0xFF00796B), Color(0xFF004D40)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 24.0),
              Text(
                'Add Waste',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.green[800],
                  labelText: 'Type of Waste',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                dropdownColor: Colors.green[800],
                value: _selectedWasteType,
                items: _wasteTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(
                      type,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedWasteType = newValue;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.green[800],
                  labelText: 'Weight',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.green[800],
                  labelText: 'Name of Waste',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: _addWaste,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 12.0,
                    ),
                    backgroundColor: Colors.green[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Add Waste'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
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
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        backgroundColor: Colors.green[900],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
