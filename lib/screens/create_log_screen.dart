import 'package:chords_catalog/widgets/instrument_configuration_widget.dart';
import 'package:flutter/material.dart';

class CreateLogScreen extends StatelessWidget {
  static const routeName = '/create-log';

  const CreateLogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Create Log'),),
      body: Center(
        child: Card(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Log Name'),
                controller: _nameController,
              ),
              InstrumentConfigurationWidget()
            ],
          ),
        ),
      ),
    );
  }
}
