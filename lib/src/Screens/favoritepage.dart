import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soundapp/src/Components/constants.dart';
import 'package:soundapp/src/Components/customAppBar.dart';
import 'package:soundapp/src/Components/customText.dart';
import 'package:soundapp/src/Components/effectListItem.dart';
import 'package:soundapp/src/Components/myDialogs.dart';
import 'package:soundapp/src/Providers/favProvider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with SingleTickerProviderStateMixin {
  bool selection = false;
  @override
  void initState() {
    final favProvider = Provider.of<FavProvider>(context, listen: false);
    favProvider.getFav();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final favProvider = Provider.of<FavProvider>(context);
    return Scaffold(
        backgroundColor: scaffoldColor,
        appBar: CustomAppBar(
          title: Text(
            'Favorites',
            style: const TextStyle(
                fontSize: 18.0,
                fontFamily: 'OxygenBold',
                //fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            /* Container(
              width: double.infinity,
              height: size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'assets/images/bgimage.jpeg',
                      ))),
            ), */
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: favProvider.favList == null
                    ? Center(child: CircularProgressIndicator())
                    : favProvider.favList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/folder.png',
                                  height: 100,
                                ),
                                /*  Icon(
                                  Icons.folder,
                                  size: size.width * 0.20,
                                  color: Colors.white,
                                ), */
                                const SizedBox(height: 20),
                                CustomText(
                                    sizes: Sizes.normal,
                                    color: Colors.white,
                                    text: "You haven't added favorites yet!")
                              ],
                            ),
                          )
                        : _buildGrid(favProvider.favList, favProvider, size))
          ],
        ));
  }

  Widget _buildGrid(favList, FavProvider favProvider, size) {
    return Container(
      child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 13 / 12, // 3/2
              crossAxisSpacing: 16,
              mainAxisSpacing: 16),
          itemCount: favList.length,
          itemBuilder: (BuildContext context, index) {
            return EffectListItem(
                id: favList[index].id,
                name: favList[index].name,
                path: favList[index].path,
                category: favList[index].category,
                pageIndex: 2,
                onDeleteIconPressed: () {
                  MyDialog.confirmDilaog(
                      context, size, favProvider, favList[index].id);
                });
          }),
    );
  }
}
