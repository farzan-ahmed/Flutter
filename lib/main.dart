import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';
import './screens/browser/browser.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  const App();

  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  WidgetBuilder builder = buildProgressIndicator;

  @override
  Widget build(BuildContext context) {
    return RateMyAppBuilder(
      builder: builder,
      onInitialized: (context, rateMyApp) {
        setState(() => builder = (context) => MaterialApp(
              title: 'BrowserApp',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                }),
              ),
              home: BrowserScreen(rateMyApp: rateMyApp),
            ));
      },
    );
  }

  static Widget buildProgressIndicator(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}
