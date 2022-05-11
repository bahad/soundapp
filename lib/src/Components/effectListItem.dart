import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:soundapp/src/Components/constants.dart';
import 'package:soundapp/src/Services/sqlitedb.dart';
import 'package:soundapp/src/data/favorite.dart';
import 'dart:math';
import 'customText.dart';

class EffectListItem extends StatefulWidget {
  final String? id;
  final String? name;
  final String? path;
  final String? category;
  final VoidCallback? onPressed;
  final VoidCallback? onDeleteIconPressed;
  final int? pageIndex;
  const EffectListItem(
      {Key? key,
      this.id,
      this.name,
      this.path,
      this.category,
      this.onPressed,
      this.onDeleteIconPressed,
      this.pageIndex})
      : super(key: key);

  _EffectListItemState createState() => _EffectListItemState();
}

class _EffectListItemState extends State<EffectListItem>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  late AudioPlayer? audioPlayer;
  AudioCache? audioCache;
  PlayerState? _playerState;
  late DbHelper _dbHelper;
  bool _fav = false;
  //FLIP ANIM
  late AnimationController flipAnimController;
  late Animation flipAnimation;
  AnimationStatus animationStatus = AnimationStatus.dismissed;
  @override
  void initState() {
    _dbHelper = DbHelper();
    _dbHelper.getFavoriteMatch(widget.id.toString()).then((value) {
      if (mounted) {
        setState(() {
          _fav = value;
        });
      }
    });
    flipAnimController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    flipAnimation = Tween(end: 1.0, begin: 0.0).animate(flipAnimController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        animationStatus = status;
      });
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    audioPlayer = AudioPlayer();
    _playerState = PlayerState.PAUSED;
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    audioPlayer!.onPlayerStateChanged.listen((PlayerState a) {
      if (mounted) {
        setState(() {
          _playerState = a;
          if (_playerState == PlayerState.COMPLETED) {
            animationController!.reverse();
          } else {}
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    audioCache!.clearAll();
    audioPlayer!.release();
    audioPlayer!.dispose();
    flipAnimController.dispose();
    animationController!.dispose();
    super.dispose();
  }

  playSong(path) async => await audioCache!.play(path);
  pauseSong(path) async => await audioPlayer!.pause();
  repeatSong(path) async => await audioCache!.loop(path);

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002)
        ..rotateX(pi * flipAnimation.value),
      child: flipAnimation.value <= 0.5
          ? frontWidget()
          : backWidget(widget.onDeleteIconPressed),
    );
  }

  Widget frontWidget() {
    return ElevatedButton(
        onPressed: () {},
        onLongPress: () {
          if (widget.pageIndex != 1) {
            flipAnimController.forward();
          }
        },
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(5),
            shape: MaterialStateProperty.all(CircleBorder()),
            backgroundColor: MaterialStateProperty.all(navBarItemColor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              sizes: Sizes.title,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
              text: widget.name,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    tooltip: 'Play Pause',
                    iconSize: 35,
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      progress: animationController!,
                    ),
                    onPressed: () {
                      if (_playerState == PlayerState.PLAYING) {
                        pauseSong(widget.path);
                        animationController?.reverse();
                      } else {
                        playSong(widget.path);
                        animationController?.forward();
                      }
                    }),
                // const SizedBox(width: 5),
                IconButton(
                    tooltip: 'Add Favorite',
                    iconSize: 28,
                    icon: _fav
                        ? Icon(Icons.favorite, color: scaffoldColor)
                        : Icon(Icons.favorite_outline),
                    onPressed: () {
                      if (_fav) {
                        /*_dbHelper
                            .removeFavorite(widget.id.toString())
                            .then((value) {}); */
                      } else {
                        var favorite = Favorite(
                            id: widget.id,
                            name: widget.name,
                            path: widget.path,
                            category: widget.category);
                        _dbHelper.insertFavorite(favorite).then((value) {
                          if (mounted) {
                            setState(() {
                              _fav = true;
                            });
                          }
                        });
                      }
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  tooltip: 'Loop',
                  iconSize: 28,
                  icon: Icon(Icons.loop_rounded),
                  onPressed: () {
                    if (_playerState == PlayerState.PLAYING) {
                      pauseSong(widget.path);
                      animationController?.reverse();
                    } else {
                      repeatSong(widget.path);
                      animationController?.forward();
                    }
                  },
                ),
                IconButton(
                  tooltip: 'Share',
                  iconSize: 28,
                  icon: Icon(Icons.share_outlined),
                  onPressed: () async {
                    final RenderBox box =
                        context.findRenderObject() as RenderBox;
                    if (Platform.isIOS) {
                      await Share.shareFiles(['${widget.path}'],
                          text: '${widget.name}',
                          sharePositionOrigin:
                              box.localToGlobal(Offset.zero) & box.size);
                    } else if (Platform.isAndroid) {
                      final ByteData bytes =
                          await rootBundle.load('assets/${widget.path}');
                      final Uint8List list = bytes.buffer.asUint8List();
                      final directory =
                          (await getExternalStorageDirectory())!.path;
                      File file = File('$directory/${widget.name}.mp3');
                      file.writeAsBytesSync(list);
                      Share.shareFiles(['$directory/${widget.name}.mp3'],
                          text: 'MySound',
                          sharePositionOrigin:
                              box.localToGlobal(Offset.zero) & box.size);
                    }
                  },
                ),
              ],
            )
          ],
        ));
  }

  Widget backWidget(onDeleteIconPressed) {
    return ElevatedButton(
      onPressed: () {
        flipAnimController.reverse();
      },
      style: ButtonStyle(
          shape: MaterialStateProperty.all(CircleBorder()),
          backgroundColor: MaterialStateProperty.all(navBarItemColor)),
      child: Center(
          child: RotatedBox(
        quarterTurns: 2,
        child: IconButton(
          iconSize: 40,
          icon: Icon(Icons.delete_forever),
          color: Colors.white,
          onPressed: () {
            onDeleteIconPressed();
            flipAnimController.reverse();
          },
        ),
      )),
    );
  }
}
