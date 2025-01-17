import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: "Namer App",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.tealAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners(); // ensures that anyone watching MyAppState is notified
  }

  var favorites = <WordPair>{};

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}
// MyAppState defines the data the app needs to function.
// The state class extends ChangeNotifier, which means that
// it can notify others about its own changes.
// For example, if the current word pair changes,
// some widgets in the app need to know.
// The state is created and provided to the whole app using a
// ChangeNotifierProvider(See MyApp) allowing any widget in
// the app to get hold of the state

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)){
      icon = Icons.favorite;
    }
    else{
      icon = Icons.favorite_border_outlined;
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(child: NavigationRail(
            extended: false,
            destinations: [
              NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
              NavigationRailDestination(icon: Icon(Icons.favorite), label: Text('Favorites')),
            ],
            selectedIndex: 0,
            onDestinationSelected: (value){
              print('selectes: $value');
            },
            ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: GeneratorPage(),
              ),
            )
      ],)
    );
  }
}

class GeneratorPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border_outlined;
    }

    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          // already centered horizontally, use widget inspector to see how
          // we need to wrap it with Center widget to actually center it on the page
          children: [
            // Text('A random AWESOME idea: '),
            BigCard(pair: pair),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      appState.toggleFavorite();
                    },
                    label: Text('Like'),
                    icon: Icon(icon),
                  ),
                SizedBox(width: 20,),
                ElevatedButton(
                    onPressed: () {
                      appState.getNext();
                    },
                    child: Text('Next')),
              ],
            )
          ],
        ));
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); //  requests the app's current theme
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme
          .colorScheme.onPrimary, // onPrimary means on top of the primary shade
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel:
              "${pair.first} ${pair.second}" // for screen readers to read the words separately
          ,
        ),
      ),
    );
  }
}

// flutter uses composition ver inheritance where it can
// hence, Padding is a widget instead of an attribute of Text
// Now, I can use padding to wrap any kind of widget
