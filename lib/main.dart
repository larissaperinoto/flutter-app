import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/repositories/dog_repository.dart';
import 'package:flutter_application_4/repositories/dog_repository_impl.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 86, 7, 89)),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var favorites = <String>[];

  void toggleFavorite(dog) {
    if (favorites.contains(dog)) {
      db?.collection("favorites").doc().delete();
    } else {
      db?.collection("favorites").doc().set({"url": "$dog"});
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const InitialPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              // ignore: prefer_const_literals_to_create_immutables
              destinations: [
                const NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                const NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final DogRepository dogRepository = DogRepositoryImpl();

  var currentDog =
      'https://static.vecteezy.com/system/resources/previews/001/200/028/original/dog-png.png';

  changeDog() async {
    var dog = await dogRepository.getDog();
    setState(() {
      currentDog = dog;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (currentDog.contains('mp4') ||
        currentDog.contains('svg') ||
        currentDog.contains('gif')) {
      changeDog();
    }

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageCard(dog: currentDog),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite(currentDog);
                  },
                  icon: const Icon(Icons.favorite),
                  label: const Text('Like'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    changeDog();
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
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

    return Card(
      color: theme.colorScheme.primary,
      semanticContainer: true,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 400,
          width: 500,
          child: Image.network('$dog', width: 100),
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
