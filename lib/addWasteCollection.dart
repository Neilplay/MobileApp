import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'databaseService.dart';
import 'themeProvider.dart';
import 'homepage.dart';
import 'addWaste.dart'; // Assuming this is correctly imported as per your project structure
import 'wasteHistory.dart';
import 'wasteMap.dart';

class AddWasteCollectionPage extends StatefulWidget {
  final int userId;

  const AddWasteCollectionPage({Key? key, required this.userId})
      : super(key: key);

  @override
  _AddWasteCollectionPageState createState() => _AddWasteCollectionPageState();
}

class _AddWasteCollectionPageState extends State<AddWasteCollectionPage> {
  int? _selectedLocationId;
  String? _selectedStatus;
  String? _selectedWasteTypeName;
  String? _selectedVehicleName;
  final TextEditingController _quantityController = TextEditingController();

  final List<Map<String, dynamic>> _locations = [
    {'id': 1, 'name': 'Location A'},
    {'id': 2, 'name': 'Location B'},
    {'id': 3, 'name': 'Location C'}
  ];
  final List<String> _statuses = ['Completed', 'Pending'];
  final List<Map<String, dynamic>> _wasteTypes = [
    {'id': 1, 'name': 'Plastic'},
    {'id': 2, 'name': 'Electric'},
    {'id': 3, 'name': 'Glass'},
    {'id': 4, 'name': 'Metal'},
    {'id': 5, 'name': 'Organic'}
  ];
  final List<Map<String, dynamic>> _vehicles = [
    {'id': 1, 'name': 'Vehicle A'},
    {'id': 2, 'name': 'Vehicle B'},
    {'id': 3, 'name': 'Vehicle C'}
  ];

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _addWasteCollection() async {
    if (_selectedLocationId != null &&
        _selectedStatus != null &&
        _selectedWasteTypeName != null &&
        _selectedVehicleName != null &&
        _quantityController.text.isNotEmpty) {
      double quantity = double.tryParse(_quantityController.text) ?? 0.0;

      int selectedWasteTypeId = _wasteTypes
          .firstWhere((type) => type['name'] == _selectedWasteTypeName)['id'];
      int selectedVehicleId = _vehicles.firstWhere(
          (vehicle) => vehicle['name'] == _selectedVehicleName)['id'];

      await DatabaseService().addWasteCollection(
        widget.userId,
        _selectedLocationId!,
        selectedWasteTypeId,
        quantity,
        selectedVehicleId,
        _selectedStatus!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Waste collection added successfully')),
      );

      setState(() {
        _selectedLocationId = null;
        _selectedStatus = null;
        _selectedWasteTypeName = null;
        _selectedVehicleName = null;
        _quantityController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
    }
  }

  void _onItemTapped(int index) {
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WasteMapPage(userId: widget.userId),
          ),
        );
        break;
      case 4:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor:
          themeProvider.isDarkMode ? Colors.green[900] : Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E7D32), Color(0xFF388E3C), Color(0xFF43A047)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 24.0),
              const Text(
                'Add Waste Collection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24.0),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.green[800],
                  labelText: 'Location',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                ),
                dropdownColor: Colors.green[800],
                value: _selectedLocationId,
                items: _locations.map((location) {
                  return DropdownMenuItem<int>(
                    value: location['id'] as int,
                    child: Text(
                      location['name'] as String,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedLocationId = newValue;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.green[800],
                  labelText: 'Status',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                ),
                dropdownColor: Colors.green[800],
                value: _selectedStatus,
                items: _statuses.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(
                      status,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.green[800],
                  labelText: 'Waste Type',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                ),
                dropdownColor: Colors.green[800],
                value: _selectedWasteTypeName,
                items: _wasteTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type['name'] as String,
                    child: Text(
                      type['name'] as String,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedWasteTypeName = newValue;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.green[800],
                  labelText: 'Vehicle',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                ),
                dropdownColor: Colors.green[800],
                value: _selectedVehicleName,
                items: _vehicles.map((vehicle) {
                  return DropdownMenuItem<String>(
                    value: vehicle['name'] as String,
                    child: Text(
                      vehicle['name'] as String,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedVehicleName = newValue;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.green[800],
                  labelText: 'Quantity',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: _addWasteCollection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Add Collection',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2E7D32),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.green[200],
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        currentIndex: 4, // Adjust this according to your selected index logic
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
