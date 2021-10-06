import 'package:audioplayers/src/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'customText.dart';

class EffectListItem extends StatefulWidget {
  final String? name;
  final String? path;
  final String? category;

  const EffectListItem({Key? key, this.name, this.path, this.category})
      : super(key: key);

  _EffectListItemState createState() => _EffectListItemState();
}

class _EffectListItemState extends State<EffectListItem>
    with SingleTickerProviderStateMixin {
  static AudioPlayer audioPlayer = AudioPlayer();
  static AudioPlayerState audioPlayerState = AudioPlayerState.PAUSED;
  static AudioCache? audioCache;
  AnimationController? animationController;
  Future? future;
  @override
  void initState() {
    future = DefaultAssetBundle.of(context).loadString('assets/data/data.json');
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState a) {
      setState(() {
        audioPlayerState = a;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    audioCache?.clearCache();
    super.dispose();
  }

  playMusic(path) async {
    await audioCache?.play(path);
  }

  pauseMusic() async {
    await audioPlayer.pause();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            backgroundColor: MaterialStateProperty.all(Colors.amber)),
        onPressed: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              sizes: Sizes.normal,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
              text: widget.name,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    iconSize: 35,
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      progress: animationController!,
                    ),
                    onPressed: () {
                      if (audioPlayerState == AudioPlayerState.PLAYING) {
                        pauseMusic();
                        animationController?.reverse();
                      } else {
                        playMusic(widget.path);
                        animationController?.forward();
                      }
                    }),
                // const SizedBox(width: 5),
                IconButton(
                    iconSize: 28,
                    icon: Icon(Icons.favorite_outline),
                    onPressed: () {}),
              ],
            )
          ],
        ));
  }
}
