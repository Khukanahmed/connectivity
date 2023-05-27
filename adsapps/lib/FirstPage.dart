import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Newapps').snapshots();

  @override
  Widget build(BuildContext context) {
    Connectivity connectivity = Connectivity();

    return Scaffold(
      appBar: AppBar(title: Text("Test Apps")),
      body: StreamBuilder<ConnectivityResult>(
          stream: connectivity.onConnectivityChanged,
          builder: (_, snapshot) {
            return InternetConnect(snapshot: snapshot,
            widget:  StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['Name']),
                  subtitle: Image.network(data['Image']),
                );
              }).toList(),
            );
          },
        ));
          }),
    );
  }
}

class InternetConnect extends StatelessWidget {
  final AsyncSnapshot<ConnectivityResult>snapshot;
  final Widget widget;
   
  const InternetConnect({super.key,
  required this.snapshot,
  required this.widget
  
  }  );
  

  @override
  Widget build(BuildContext context) {
    switch(snapshot.connectionState ){

      case ConnectionState.active:
      final state =snapshot.data!;
      switch(state){
        case ConnectivityResult.none:
        return Center( child: Text("No Internet"),);
        default:
        return widget;
      
      }
      default:
      return Text("data");
    }
  }
}
