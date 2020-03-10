import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(bodyText1: TextStyle(fontSize: 22.0))),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlateNumberForm(),
    );
  }
}

class PlateNumberForm extends StatefulWidget {
  @override
  PlateNumberFormState createState() {
    return PlateNumberFormState();
  }
}

class PlateNumberFormState extends State<PlateNumberForm> {
  final _formKey = GlobalKey<FormState>();
  final _plateNumberFormController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: _plateNumberFormController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a valid plate number';
              }
              return null;
            },
            style: TextStyle(fontSize: 50),
            textAlign: TextAlign.center,
            inputFormatters: <TextInputFormatter> [
              UpperCaseTextFormatter()
            ]
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlateDetailsPage(
                            _plateNumberFormController.value.text)),
                  );
                }
              },
              child: Text('Submit', style: TextStyle(fontSize: 28)),
            ),
          ),
        ],
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class PlateDetailsPage extends StatefulWidget {
  final String plateNumber;
  PlateDetailsPage(this.plateNumber);

  @override
  _PlateDetailsPageState createState() =>
      _PlateDetailsPageState(this.plateNumber);
}

class _PlateDetailsPageState extends State<PlateDetailsPage> {
  Future<String> futureplateNumber;
  final String plateNumber;
  _PlateDetailsPageState(this.plateNumber);

  @override
  void initState() {
    super.initState();
    futureplateNumber = fetchPlateDetails(this.plateNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FutureBuilder<String>(
          future: futureplateNumber,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic> vehicleData =
                  jsonDecode(snapshot.data)['vehicle'];
              return VehicleDataTable(vehicleData: vehicleData);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        )
      ),
    );
  }
}

class VehicleDataTable extends StatelessWidget {
  final Map<String, dynamic> vehicleData;

  const VehicleDataTable({
    Key key,
    this.vehicleData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: <DataColumn>[
        DataColumn(label: Text('')),
        DataColumn(label: Text(''))
      ],
      rows: <DataRow>[
        DataRow(cells: [
          DataCell(Text('Model', style: TextStyle(fontSize: 22))),
          DataCell(
              Text(this.vehicleData['model'], style: TextStyle(fontSize: 22)))
        ]),
        DataRow(cells: [
          DataCell(Text('Manufacturer', style: TextStyle(fontSize: 22))),
          DataCell(Text(this.vehicleData['manufacturer'],
              style: TextStyle(fontSize: 22)))
        ]),
        DataRow(cells: [
          DataCell(Text('Year', style: TextStyle(fontSize: 22))),
          DataCell(Text(this.vehicleData['manufactureYear'].toString(),
              style: TextStyle(fontSize: 22)))
        ]),
        DataRow(cells: [
          DataCell(Text('Variant', style: TextStyle(fontSize: 22))),
          DataCell(
              Text(this.vehicleData['variant'], style: TextStyle(fontSize: 22)))
        ]),
        DataRow(cells: [
          DataCell(Text('Colour', style: TextStyle(fontSize: 22))),
          DataCell(Text(this.vehicleData['vehicleColour'],
              style: TextStyle(fontSize: 22)))
        ]),
      ],
    );
  }
}

Future<String> fetchPlateDetails(String plateNumber) async {
  final response =
      await http.get('https://nickmurray.dev/api/plate/$plateNumber');

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to get plate details');
  }
}
