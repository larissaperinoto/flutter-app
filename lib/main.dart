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
      'https://cdn.britannica.com/60/8160-050-08CCEABC/German-shepherd.jpg';

  changeDog() async {
    var dog = await dogRepository.getDog();
    setState(() {
      currentDog = dog;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentDog.contains('mp4') || currentDog.contains('svg')) {
      changeDog();
    }

    return Scaffold(
      body: Column(
        children: [
          ImageCard(dog: currentDog),
          ElevatedButton(
              onPressed: () {
                changeDog();
                print(currentDog);
              },
              child: const Text('Next')),
        ],
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({
    Key? key,
    required this.dog,
  }) : super(key: key);

  final dog;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    /* var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    ); */

    return Card(
      color: theme.colorScheme.primary,
      semanticContainer: true,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          child: Image.network('$dog', width: 100),
          width: 200,
        ),
      ),
    );
  }
}
