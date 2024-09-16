import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HealthMonitoringPage extends StatefulWidget {
  @override
  _HealthMonitoringPageState createState() => _HealthMonitoringPageState();
}

class _HealthMonitoringPageState extends State<HealthMonitoringPage> {
  // Database reference to 'Falldetect' and 'predictions' nodes
  DatabaseReference _fallDetectRef = FirebaseDatabase.instance.ref().child('Falldetect');
  DatabaseReference _predictionsRef = FirebaseDatabase.instance.ref().child('predictions');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Monitoring Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<DatabaseEvent>(
              stream: _fallDetectRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red));
                }
                final fallDetectData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

                return _buildFallDetectData(fallDetectData);
              },
            ),
            const SizedBox(height: 20),
            StreamBuilder<DatabaseEvent>(
              stream: _predictionsRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red));
                }
                final predictionsData = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
                final activity = predictionsData?['activity'] ?? 'N/A';

                return Text(
                  'Current activity by the person: $activity',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallDetectData(Map<dynamic, dynamic>? fallDetectData) {
    if (fallDetectData == null) {
      return Text('No fall detection data available');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('AccelX: ${fallDetectData['AccelX']}', style: TextStyle(fontSize: 18)),
        Text('AccelY: ${fallDetectData['AccelY']}', style: TextStyle(fontSize: 18)),
        Text('AccelZ: ${fallDetectData['AccelZ']}', style: TextStyle(fontSize: 18)),
        Text('GyroX: ${fallDetectData['GyroX']}', style: TextStyle(fontSize: 18)),
        Text('GyroY: ${fallDetectData['GyroY']}', style: TextStyle(fontSize: 18)),
        Text('GyroZ: ${fallDetectData['GyroZ']}', style: TextStyle(fontSize: 18)),
      ],
    );
  }
}