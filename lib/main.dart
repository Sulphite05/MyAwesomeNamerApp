import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/view/login_view.dart';
import 'package:mynotes/view/register_view.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(   
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
   
   @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  
          
          switch (snapshot.connectionState){

            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if(user?.emailVerified ?? false){
                print('You are a Verified User.');
              }
              else{
                print('You are a not a Verified User.');

              }
              return Text('Done');

            default:
              return const Text("Loading...");
          }   
        },
        future: Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,)     
      ),
    );
  }
}