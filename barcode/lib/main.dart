import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;


import 'package:barcode/home_data.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barcode Scanner',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  String _scanResult = '';

  Future<void> _scanBarcode(String button) async {
    final result = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancel',
      true,
      ScanMode.BARCODE,
    );

    if (!mounted) return;

    setState(() {
      _scanResult = result;
    });
    if (button == 'save') {
      _saveToDatabase(result);

    } else if (button == 'delete') {
      _deleteToDatabase(result);

    }

  }

  Future<void> _saveToDatabase(String barcode) async {
    final url = Uri.parse('https://api./input.php');

    final response = await http.post(
      url,
      body: json.encode({'barcode': barcode}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseBody['message'])),
      );
    } else { //
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save barcode.')),
      );
    }
  }
  Future<void> _deleteToDatabase(String barcode) async {
    final url = Uri.parse('https://api./del.php');

    final response = await http.post(
      url,
      body: json.encode({'barcode': barcode}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseBody['message'])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save barcode.')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner'),
      ),
      body: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage(title: 'scanned barcodes')),
                      );
                    },
                    child: Text('scanned barcodes'),
                  ),
                  SizedBox(height: 16), // adds some vertical spacing
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage(title: 'scanned barcodes')),
                      );
                    },
                    child: Text('Edit'),
                  ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Scan Result:',
              ),
              Text(
                _scanResult,
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton :Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          onPressed: (){ _scanBarcode('save');},
          icon: Icon(Icons.camera_alt),
          label: Text('Scan Barcode'),
          backgroundColor: Colors.green,
        ),
        SizedBox(height: 10),
        FloatingActionButton.extended(
          onPressed: (){ _scanBarcode('delete');},
          icon: Icon(Icons.camera_alt),
          label: Text('Delete Scaned Barcodes'),
          backgroundColor: Colors.red,
        ),
      ],
    ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,





    );
  }
}
