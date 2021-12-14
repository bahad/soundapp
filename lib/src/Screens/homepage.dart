import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soundapp/src/Components/customAppBar.dart';
import 'package:soundapp/src/Components/effectListItem.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  static late Future? future;
  //FOR SEARCH
  var _soundArray = [];
  var _searchResult = [];
  bool autofocus = false;
  //FOR SCROLL
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchQueryController.dispose();
    super.dispose();
  }

  getData() {
    future = DefaultAssetBundle.of(context)
        .loadString('assets/data/data.json')
        .then((value) {
      if (value != 0 && mounted) {
        setState(() {
          _soundArray = [];
          _soundArray = jsonDecode(value);
          _soundArray.shuffle();
        });
      }
    });
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      if (mounted) {
        setState(() {
          autofocus = false;
        });
      }

      return;
    }
    autofocus = true;
    _soundArray.forEach((element) {
      if (element['name'].toLowerCase().contains(text.toLowerCase()) ||
          element['category'].toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(element);
    });
    if (!mounted) return;
    setState(() {});
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: () {
      _searchQueryController.clear();
      onSearchTextChanged("");
      if (!mounted) return;
      setState(() {
        _isSearching = false;
      });
    }));
    if (!mounted) return;
    setState(() {
      _isSearching = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
          title: _isSearching
              ? _buildSearchField(context)
              : Text(
                  'Home',
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'OxygenBold',
                      //fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: _isSearching
              ? GestureDetector(
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        _isSearching = false;
                        _searchQueryController.clear();
                        onSearchTextChanged("");
                      });
                    }
                  },
                  child: Icon(Icons.arrow_back_ios))
              : Icon(CupertinoIcons.home),
          actions: _buildActions()),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'assets/images/bgimage.jpeg',
                    ))),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                child: _searchResult.length != 0 ||
                        _searchQueryController.text.isNotEmpty
                    ? GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 13 / 12, // 3/2
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16),
                        itemCount: _searchResult.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return EffectListItem(
                            id: _searchResult[index]['id'],
                            name: _searchResult[index]['name'],
                            path: _searchResult[index]['path'],
                            category: _searchResult[index]['category'],
                            pageIndex: 1,
                            onDeleteIconPressed: () {},
                          );
                        })
                    : Scrollbar(
                        controller: _scrollController,
                        thickness: 15.0,
                        interactive: true,
                        radius: Radius.circular(15),
                        child: GridView.builder(
                            controller: _scrollController,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 13 / 12, // 3/2
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16),
                            itemCount: _soundArray.length,
                            itemBuilder: (BuildContext ctx, index) {
                              var a = _soundArray[index];
                              return EffectListItem(
                                id: a['id'],
                                name: a['name'],
                                path: a['path'],
                                category: a['category'],
                                pageIndex: 1,
                              );
                            }),
                      )),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(context) {
    return TextField(
        controller: _searchQueryController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Car, Animals, Politic ...",
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white),
        ),
        style: TextStyle(color: Colors.white, fontSize: 16.0),
        onChanged: onSearchTextChanged);
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController.text.length == 0 ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            setState(() {
              if (mounted) {
                _searchQueryController.clear();
                onSearchTextChanged("");
              }
            });
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }
}

/*
StatefulBuilder(
          builder: (context, setState) => IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () => MyDialog.showMyDialogDialog(
                  context,
                  Container(
                      height: 300,
                      width: double.infinity,
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: filterList.length,
                            itemBuilder: (context, index) {
                              return Material(
                                  type: MaterialType.transparency,
                                  child: Container(
                                    child: FilterChip(
                                      backgroundColor: selected![index]
                                          ? CupertinoColors.activeGreen
                                          : CupertinoColors.systemIndigo,
                                      selected: selected![index],
                                      label: Text(
                                        filterList[index],
                                        style: const TextStyle(
                                            fontSize: 17, color: Colors.white),
                                      ),
                                      onSelected: (value) {
                                        setState(() {
                                          if (selected![index])
                                            selected![index] = false;
                                          else
                                            selected![index] = true;

                                          print(value);
                                          if (value &&
                                              !selectedFilterList!.contains(
                                                  filterList[index])) {
                                            selectedFilterList!
                                                .add(filterList[index]);
                                          }
                                        });
                                      },
                                      elevation: 2,
                                      pressElevation: 5,
                                    ),
                                  ));
                            },
                          ),
                          Text(selectedFilterList!.isNotEmpty
                              ? selectedFilterList![0]
                              : "")
                        ],
                      )),
                ),
              ))
              */