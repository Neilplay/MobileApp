import 'package:flutter/material.dart';
import 'package:trash_system/addWasteCollection.dart';
import 'databaseService.dart';
import 'homepage.dart';
import 'addWaste.dart';
import 'wasteMap.dart';

class WasteHistoryPage extends StatelessWidget {
  final int userId;

  const WasteHistoryPage({Key? key, required this.userId}) : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userId: userId),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AddWastePage(userId: userId),
          ),
        );
        break;
      case 2:
        // Current Page, do nothing
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WasteMapPage(userId: userId),
          ),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AddWasteCollectionPage(userId: userId),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste History'),
        backgroundColor: Colors.teal[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Implement delete functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          HeaderSection(userId: userId),
          Expanded(child: LogList(userId: userId)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.teal[800],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.teal[200],
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        currentIndex: 2,
        onTap: (index) => _onItemTapped(context, index),
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

class HeaderSection extends StatelessWidget {
  final int userId;

  const HeaderSection({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal[800],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Waste Data Log',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<dynamic>>(
            future: DatabaseService().getUserLogs(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text(
                  'Total Logs: Loading...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text(
                  'Total Logs: Error\n${snapshot.error}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                );
              } else {
                List<dynamic> logs = snapshot.data ?? [];
                return Text(
                  'Total Logs: ${logs.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class LogList extends StatelessWidget {
  final int userId;

  const LogList({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: DatabaseService().getUserLogs(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading logs\n${snapshot.error}'));
        } else {
          List<dynamic> logs = snapshot.data ?? [];
          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              return LogEntryWidget(log: LogEntry.fromMap(logs[index]));
            },
          );
        }
      },
    );
  }
}

class LogEntry {
  final int logId;
  final int wasteId;
  final int userId;
  final int wasteTypeId;
  final double weight;
  final String wasteName;
  final DateTime createdAt;
  final DateTime logCreatedAt;

  LogEntry({
    required this.logId,
    required this.wasteId,
    required this.userId,
    required this.wasteTypeId,
    required this.weight,
    required this.wasteName,
    required this.createdAt,
    required this.logCreatedAt,
  });

  factory LogEntry.fromMap(Map<String, dynamic> map) {
    return LogEntry(
      logId: map['log_id'] ?? 0,
      wasteId: map['waste_id'] ?? 0,
      userId: map['user_id'] ?? 0,
      wasteTypeId: map['waste_type_id'] ?? 0,
      weight: map['weight']?.toDouble() ?? 0.0,
      wasteName: map['waste_name'] ?? '',
      createdAt: map['created_at'] is String
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      logCreatedAt: map['log_created_at'] is String
          ? DateTime.parse(map['log_created_at'])
          : DateTime.now(),
    );
  }
}

class LogEntryWidget extends StatelessWidget {
  final LogEntry log;

  const LogEntryWidget({Key? key, required this.log}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal[700],
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Waste Name: ${log.wasteName}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Weight: ${log.weight.toStringAsFixed(2)} kg',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 4),
            Text(
              'Waste Type: ${log.wasteTypeId}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 4),
            Text(
              'User ID: ${log.userId}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 4),
            Text(
              'Created At: ${log.createdAt.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 4),
            Text(
              'Log Created At: ${log.logCreatedAt.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
