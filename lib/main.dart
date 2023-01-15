import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/repositories/dog_repository.dart';
import 'package:flutter_application_4/repositories/dog_repository_impl.dart';
import 'firebase_options.dart';

FirebaseFirestore? db;

void main() async {
  runApp(const MyApp());

  var app = await Firebase.initializeApp(
      name: "flutter-application-1",
      options: DefaultFirebaseOptions.currentPlatform);

  db = FirebaseFirestore.instanceFor(app: app);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DogRepository dogRepository = DogRepositoryImpl();

  var currentDog =
      'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/dog-puppy-on-garden-royalty-free-image-1586966191.jpg?crop=1.00xw:0.669xh;0,0.190xh&resize=640:*';

  changeDog() async {
    var dog = await dogRepository.getDog();
    setState(() {
      currentDog = dog;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
