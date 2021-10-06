import 'dart:collection';
import 'dart:convert';

import 'package:audioplayers/src/audio_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soundapp/src/Components/customAppBar.dart';
import 'package:soundapp/src/Components/customText.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:soundapp/src/Components/effectListItem.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static Future? future;

  @override
  void initState() {
    future = DefaultAssetBundle.of(context).loadString('assets/data/data.json');

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home',
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Icon(CupertinoIcons.home),
        actions: [IconButton(icon: Icon(Icons.filter_alt), onPressed: () {})],
      ),
      body: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var mydata = json.decode(snapshot.data.toString());
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 3 / 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16),
                    itemCount: mydata.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return EffectListItem(
                        name: mydata[index]['name'],
                        path: mydata[index]['path'],
                        category: mydata[index]['category'],
                      );
                    }),
              );
            } else {
              return Center(child: CircularProgressIndicator.adaptive());
            }
          }),
    );
  }
}
