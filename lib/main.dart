import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:soundapp/src/Providers/favProvider.dart';
import 'package:soundapp/src/Screens/homescreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: false);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme:
            ThemeData(primarySwatch: Colors.blue, fontFamily: 'OxygenRegular'),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<FavProvider>(create: (_) => FavProvider()),
          ],
          child: HomeScreen(),
        ));
  }
}
