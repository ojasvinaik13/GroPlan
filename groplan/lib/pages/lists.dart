import 'package:flutter/material.dart';

class ListsPage extends StatefulWidget {
  @override
  _ListsPageState createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lists'),
      ),
      body: const Center(
        child: Text(
          'This is the lists page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
