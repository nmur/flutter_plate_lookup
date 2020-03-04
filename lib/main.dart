import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlateDetailsPage(_plateNumberFormController.value.text)),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

class PlateDetailsPage extends StatefulWidget {
  final String plateNumber;
  PlateDetailsPage(this.plateNumber);

  @override
  _PlateDetailsPageState createState() => _PlateDetailsPageState(this.plateNumber);
}

class _PlateDetailsPageState extends State<PlateDetailsPage> {
  final String plateNumber;
  _PlateDetailsPageState(this.plateNumber);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(plateNumber),
      ),
    );
  }
}
