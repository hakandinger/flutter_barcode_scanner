import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _filter = TextEditingController();
  String _searchText = "";
  List<dynamic> data = [];
  List<dynamic> _filteredItems = [];

  Future<void> getData() async {
    var url = Uri.parse('https://api./db.php');
    var response = await http.get(url);

    setState(() {
      data = jsonDecode(response.body);
      _filteredItems = data;
    });
  }

  void _filterItems(String searchText) {
    _filteredItems = data.where((item) => item['barcode'].toLowerCase().contains(searchText.toLowerCase())).toList();
  }

  @override
  void initState() {
    super.initState();
    getData();
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _filteredItems = data;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
          _filterItems(_searchText);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: TextField(
              onChanged: (value) {
                _filterItems(value);
                setState(() {});
              },
              controller: _filter,
              decoration: InputDecoration(
                labelText: 'Ara',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (BuildContext context, int index) {
                List<dynamic> duplicateItems = data.where((item) => item['barcode']+'-'+item['product_name'] == _filteredItems[index]['barcode']+'-'+_filteredItems[index]['product_name']).toList();
                Color textColor = duplicateItems.length > 1 ? Colors.red : Colors.black;

                return ListTile(
                  title: Text(_filteredItems[index]['barcode']+'-'+_filteredItems[index]['product_name'], style: TextStyle(color: textColor)),
                  subtitle: Text(_filteredItems[index]['created_at'], style: TextStyle(color: textColor)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
