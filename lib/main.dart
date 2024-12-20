import 'package:beamer/beamer.dart';
import 'package:beamer_demo/Popable.dart';
import 'package:beamer_demo/app_drawer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _routerDelegate = BeamerDelegate(
      locationBuilder: RoutesLocationBuilder(routes: {
    '/': (BuildContext context, BeamState beamerState, Object? data) =>
        const HomePage(title: 'Home Page'),
    '/page1': (BuildContext context, BeamState beamerState, Object? data) =>
        Page(title: 'First Page'),
    '/page2': (BuildContext context, BeamState beamerState, Object? data) =>
        BeamPage(
          key: ValueKey('page2'),
          type: BeamPageType.fadeTransition,
          child: Page(title: 'Second Page'),
          onPopPage: (context, delegate, state, poppedPage) {
            debugPrint(
                "poppedPage.child is Popable : ${poppedPage.child is Popable}");
            Popable popableChild = poppedPage.child as Popable;
            delegate.update(
                configuration: RouteInformation(
                  uri: Uri.parse('/'),
                ),
                rebuild: false);
            return popableChild.shouldPop();
          },
        ),
  }).call);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerDelegate: _routerDelegate,
      routeInformationParser: BeamerParser(),
      /*backButtonDispatcher:
          BeamerBackButtonDispatcher(delegate: _routerDelegate),*/
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This is the home Page',
            ),
            SizedBox(
              height: 5.0,
            ),
            InkWell(
              child: Text(
                'Navigate to first page',
                style: TextStyle(
                    color: Colors.blueAccent,
                    decorationStyle: TextDecorationStyle.wavy),
              ),
              onTap: () => context.beamToNamed('/page1'),
            ),
            SizedBox(
              height: 5.0,
            ),
            InkWell(
              child: Text(
                'Navigate to Second page',
                style: TextStyle(
                    color: Colors.green,
                    decorationStyle: TextDecorationStyle.wavy),
              ),
              onTap: () => context.beamToNamed('/page2'),
            )
          ],
        ),
      ),
    );
  }
}

class Page extends StatelessWidget implements Popable {
  const Page({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'this is page : $title',
            ),
          ],
        ),
      ),
      drawer: AppDrawer(),
    );
  }

  @override
  bool shouldPop() {
    debugPrint("$title  capture back button event on pop");
    return true;
  }
}
