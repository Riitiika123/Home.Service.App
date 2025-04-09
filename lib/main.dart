import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_service_app/screens/splashscreen.dart';

Future main() async{                        
  WidgetsFlutterBinding.ensureInitialized();
  //for web
  try{
  if(kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
      apiKey: "AIzaSyB6KZLUrjPTdHIfYxsv7pV0cXl4iE5AzNU",
      appId: "1:1036807177189:web:34ea4970620c12ab1c250c",
      messagingSenderId: "1036807177189",
      projectId: "authenticationapp-e72da",
      )
    );
  }
  else{
    await Firebase.initializeApp(); //for android and ios devices
  }
  runApp(const MyApp());
}
catch(e){
  print('Error initializing Firebase :$e');
}
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Home Service App',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}


