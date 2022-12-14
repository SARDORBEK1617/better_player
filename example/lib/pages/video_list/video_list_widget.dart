import 'package:better_player/better_player.dart';
import 'package:better_player_example/pages/video_list/video_list_data.dart';
import 'package:flutter/material.dart';

class VideoListWidget extends StatefulWidget {
  final VideoListData videoListData;

  const VideoListWidget({Key key, this.videoListData}) : super(key: key);

  @override
  _VideoListWidgetState createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends State<VideoListWidget> {
  VideoListData get videoListData => widget.videoListData;
  BetterPlayerConfiguration betterPlayerConfiguration;
  BetterPlayerListVideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = BetterPlayerListVideoPlayerController();
    betterPlayerConfiguration = BetterPlayerConfiguration(autoPlay: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            videoListData.videoTitle,
            style: TextStyle(fontSize: 50),
          ),
        ),
        AspectRatio(
            child: BetterPlayerListVideoPlayer(
              BetterPlayerDataSource(
                  BetterPlayerDataSourceType.NETWORK, videoListData.videoUrl),
              configuration: BetterPlayerConfiguration(
                autoPlay: false,
                aspectRatio: 1,
                fit: BoxFit.cover,
              ),
              //key: Key(videoListData.hashCode.toString()),
              playFraction: 0.8,
              betterPlayerListVideoPlayerController: controller,
            ),
            aspectRatio: 1),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
              "Horror: In Steven Spielberg's Jaws, a shark terrorizes a beach "
              "town. Plainspoken sheriff Roy Scheider, hippie shark "
              "researcher Richard Dreyfuss, and a squirrely boat captain "
              "set out to find the beast, but will they escape with their "
              "lives? 70's special effects, legendary score, and trademark "
              "humor set this classic apart."),
        ),
        Row(children: [
          RaisedButton(
            child: Text("Play"),
            onPressed: () {
              controller.play();
            },
          ),
          const SizedBox(width: 8),
          RaisedButton(
            child: Text("Pause"),
            onPressed: () {
              controller.pause();
            },
          ),
          const SizedBox(width: 8),
          RaisedButton(
            child: Text("Set max volume"),
            onPressed: () {
              controller.setVolume(100);
            },
          ),
        ])
      ],
    );
  }
}
