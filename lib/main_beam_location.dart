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
      initialPath: '/',
      locationBuilder: RoutesLocationBuilder(routes: {
        '/': (context, state, object) => const MainPage(),
        '/home': (context, state, object) => BeamPage(
              key: ValueKey('home-page'),
              type: BeamPageType.slideLeftTransition,
              child: HomePage(title: 'Home Page'),
              onPopPage: (context, delegate, state, poppedPage) {
                final Set<String?> paths = delegate.currentPages
                    .map(
                      (e) => e.path,
                    )
                    .toSet();
                debugPrint(
                    'Pop page is being called on home. currentPages  : $paths');
                return true;
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

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Main Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This is the Main Page',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 5.0,
            ),
            InkWell(
              child: Text(
                'Navigate to HomePage',
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 20,
                    decorationStyle: TextDecorationStyle.wavy),
              ),
              onTap: () => context.beamToNamed('/home'),
            ),
            /*SizedBox(
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
            )*/
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.title});

  final String title;

  final _beamerKey = GlobalKey<BeamerState>();
  final _routerDelegate = BeamerDelegate(
      locationBuilder: BeamerLocationBuilder(beamLocations: [
    ScreenLocation(),
  ]).call);

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
      body: Beamer(
          key: widget._beamerKey, routerDelegate: widget._routerDelegate),
      drawer: AppDrawer(),
    );
  }
}

class Screen extends StatelessWidget implements Popable {
  const Screen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  @override
  bool shouldPop() {
    debugPrint("$title  capture back button event on pop");
    return true;
  }
}

class HomePageLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => ['/home'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
          key: ValueKey('home-page'),
          title: 'The Home page',
          child: HomePage(title: 'Home Page')),
    ];
  }
}

class ScreenLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => ['/home/screen2', '/home/screen3'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      BeamPage(
        key: ValueKey('first-screen'),
        child: Center(
          child: LinkWidget(title: 'Second Screen', path: '/home/screen2'),
          /*child: Column(
            children: [
              const Screen(title: 'First Screen'),
              SizedBox(height: 5.0,),
              LinkWidget(title: 'Second Screen', path: '/home/screen2'),
              SizedBox(height: 5.0,),
              LinkWidget(title: 'Third Screen', path: '/home/screen3'),
            ],
          ),*/
        ),
        onPopPage: (context, delegate, state, poppedScreen) {
          debugPrint(
              "poppedScreen.child is Popable : ${poppedScreen.child is Popable}");
          if (poppedScreen.child is Popable) {
            final popableChild = poppedScreen.child as Popable;
            delegate.update(
                configuration: RouteInformation(
                  uri: Uri.parse('/home'),
                ),
                rebuild: false);
            return popableChild.shouldPop();
          }
          return true;
        },
      ),
      if (state.uri.path == '/home/screen2')
        BeamPage(
            key: ValueKey('second-screen'),
            child: const Screen(title: 'Second Screen')),
      if (state.uri.path == '/home/screen3')
        BeamPage(
            key: ValueKey('third-screen'),
            child: const Screen(title: 'Third Screen')),
    ];
  }
}

class LinkWidget extends StatelessWidget {
  const LinkWidget({super.key, required this.title, required this.path});
  final String title;
  final String path;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        title,
        style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 20,
            decorationStyle: TextDecorationStyle.wavy),
      ),
      onTap: () => context.beamToNamed(path),
    );
  }
}
