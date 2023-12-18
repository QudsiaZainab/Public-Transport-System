import 'package:flutter/material.dart';

class Vehicles extends StatefulWidget {
  @override
  _VehiclesState createState() => _VehiclesState();
}

class _VehiclesState extends State<Vehicles> {
  TextEditingController _busNameController = TextEditingController();
  TextEditingController _numberPlateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicles'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehicles that you drive',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0), // Add some space between the sentence and the button
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align the button to the right
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showAddVehicleDialog(context);
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 30),
            _buildVanRow('Van 1'),
            _buildVanRow('Van 2'),
          ],
        ),
      ),
    );
  }

  Widget _buildVanRow(String vanName) {
    return Container(
      margin: EdgeInsets.fromLTRB(3.0, 10.0, 3.0, 10.0),
      decoration: BoxDecoration(
        color: Colors.white, // Set the background color to white
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              vanName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddVehicleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Vehicle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _busNameController,
                decoration: InputDecoration(labelText: 'Vehicle Route'),
              ),
              TextFormField(
                controller: _numberPlateController,
                decoration: InputDecoration(labelText: 'Numberplate No'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle adding the vehicle here
                // You can access the entered values using _busNameController.text and _numberPlateController.text
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Vehicles(),
  ));
}