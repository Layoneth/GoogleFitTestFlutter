import 'package:fit_kit/fit_kit.dart';
import 'package:flutter/material.dart';
import 'package:googlefittest/services/auth.dart';
import 'package:googlefittest/services/google_fit.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Authentication _auth = Authentication();
  final GoogleFitService _googleFit = GoogleFitService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          MaterialButton(
            color: Colors.amber,
            child: Text('Sign out'),
            onPressed: () => _auth.singOut()
            // onPressed: (){},
          ),
        ],
      ),
      body: Column(
        children: [
          // MaterialButton(
          //   color: Colors.amber,
          //   child: Text('Google'),
          //   onPressed: () => _auth.signInWithGoogle()
          //   // onPressed: (){},
          // ),
          MaterialButton(
            color: Colors.redAccent,
            child: Text('FitData'),
            onPressed: () {
              setState(() {
                _googleFit.readFitData();
              });
            }
            // onPressed: (){},
          ),
          Container(
            height: 100,
            child: FutureBuilder<List<FitData>>(
              future: _googleFit.readFitData(),
              builder: (BuildContext context, AsyncSnapshot<List<FitData>> snapshot) {
                if(!snapshot.hasData) return CircularProgressIndicator();
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                  return Text(snapshot.data.elementAt(index) != null 
                    ? snapshot.data.elementAt(index).value.toString()
                    : 'No data');
                 },
                );
              },
            ),
          ),
          Text( 'Last sync: ' + _googleFit.lastSync.toString())
        ]
      )
    );
  }
}
