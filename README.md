<p align="center">
<img src="https://raw.githubusercontent.com/jhomlala/betterplayer/master/media/logo.png">
</p>

# Better Player
[![pub package](https://img.shields.io/pub/v/better_player.svg)](https://pub.dartlang.org/packages/better_player)
[![pub package](https://img.shields.io/github/license/jhomlala/betterplayer.svg?style=flat)](https://github.com/jhomlala/betterplayer)
[![pub package](https://img.shields.io/badge/platform-flutter-blue.svg)](https://github.com/jhomlala/betterplayer)

Advanced video player based on video_player and Chewie. It's solves many typical use cases and it's easy to run.

## Introduction
This plugin is based on [Chewie](https://github.com/brianegan/chewie). Chewie is awesome plugin and works well in many cases. Better Player is a continuation of ideas introduced in Chewie. Better player fix common bugs, adds more configuration options and solves typical use cases. 

**Features:**  
✔️ Fixed common bugs  
✔️ Added advanced configuration options  
✔️ Refactored player controls  
✔️ Playlist support  
✔️ Video in ListView support  
✔️ Subtitles support: (formats: SRT, WEBVTT with HTML tags support; subtitles from HLS; multiple subtitles for video)  
✔️ HTTP Headers support  
✔️ BoxFit of video support  
✔️ Playback speed support  
✔️ HLS support (track, subtitles selection)  
✔️ Alternative resolution support  
✔️ Cache support  
✔️ ... and much more! 


## Install

1. Add this to your **pubspec.yaml** file:

```yaml
dependencies:
  better_player: ^0.0.36
```

2. Install it

```bash
$ flutter packages get
```

3. Import it

```dart
import 'package:better_player/better_player.dart';
```

## General Usage
Check [Example project](https://github.com/jhomlala/betterplayer/tree/master/example) which shows how to use Better Player in different scenarios.

### Basic usage
There are 2 basic methods which you can use to setup Better Player:
```dart
BetterPlayer.network(url, configuration)
BetterPlayer.file(url, configuration)
```
There methods setup basic configuration for you and allows you to start using player in few seconds.
Here is an example:
```dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Example player"),
      ),
      body: AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer.network(
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
          betterPlayerConfiguration: BetterPlayerConfiguration(
            aspectRatio: 16 / 9,
          ),
        ),
      ),
    );
  }
```
In this example, we're just showing video from url with aspect ratio = 16/9.
Better Player has many more configuration options which are presented below.


### Normal usage

Create BetterPlayerDataSource and BetterPlayerController. You should do it in initState:
```dart
BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    super.initState();
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.NETWORK,
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4");
    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(),
        betterPlayerDataSource: betterPlayerDataSource);
  }
````

Create BetterPlayer widget wrapped in AspectRatio widget:
```dart
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayer(
        controller: _betterPlayerController,
      ),
    );
  }
```

### Playlist
To use playlist, you need to create dataset with multiple videos:
```dart
  List<BetterPlayerDataSource> createDataSet() {
    List dataSourceList = List<BetterPlayerDataSource>();
    dataSourceList.add(
      BetterPlayerDataSource(
        BetterPlayerDataSourceType.NETWORK,
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
      ),
    );
    dataSourceList.add(
      BetterPlayerDataSource(BetterPlayerDataSourceType.NETWORK,
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"),
    );
    dataSourceList.add(
      BetterPlayerDataSource(BetterPlayerDataSourceType.NETWORK,
          "http://sample.vodobox.com/skate_phantom_flex_4k/skate_phantom_flex_4k.m3u8"),
    );
    return dataSourceList;
  }
```

Then create BetterPlayerPlaylist:
```dart
@override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayerPlaylist(
          betterPlayerConfiguration: BetterPlayerConfiguration(),
          betterPlayerPlaylistConfiguration: const BetterPlayerPlaylistConfiguration(),
          betterPlayerDataSourceList: dataSourceList),
    );
  }
```

### BetterPlayerListViewPlayer
BetterPlayerListViewPlayer will auto play/pause video once video is visible on screen with playFraction. PlayFraction describes percent of video that must be visibile to play video. If playFraction is 0.8 then 80% of video height must be visible on screen to auto play video

```dart
 @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayerListVideoPlayer(
        BetterPlayerDataSource(
            BetterPlayerDataSourceType.NETWORK, videoListData.videoUrl),
        key: Key(videoListData.hashCode.toString()),
        playFraction: 0.8,
      ),
    );
  }
```

You can control BetterPlayerListViewPlayer with BetterPlayerListViewPlayerController. You need to pass
BetterPlayerListViewPlayerController to BetterPlayerListVideoPlayer. See more in example app.

### Subtitles
Subtitles can be configured from 3 different sources: file, network and memory. Subtitles source is passed in BetterPlayerDataSource:

Network subtitles:
```dart
    var dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.NETWORK,
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
      subtitles: BetterPlayerSubtitlesSource.single(
          type: BetterPlayerSubtitlesSourceType.NETWORK,
          url:
              "https://dl.dropboxusercontent.com/s/71nzjo2ux3evxqk/example_subtitles.srt"),
    );
```

File subtitles:
```dart
 var dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.FILE,
      "${directory.path}/testvideo.mp4",
      subtitles: BetterPlayerSubtitlesSource.single(
        type: BetterPlayerSubtitlesSourceType.FILE,
        url: "${directory.path}/example_subtitles.srt",
      ),
    );
```
You can pass multiple subtitles for one video:
```dart
var dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.NETWORK,
      "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8",
      liveStream: false,
      useHlsSubtitles: true,
      hlsTrackNames: ["Low quality", "Not so low quality", "Medium quality"],
      subtitles: [
        BetterPlayerSubtitlesSource(
          type: BetterPlayerSubtitlesSourceType.NETWORK,
          name: "EN",
          urls: [
            "https://dl.dropboxusercontent.com/s/71nzjo2ux3evxqk/example_subtitles.srt"
          ],
        ),

        BetterPlayerSubtitlesSource(
          type: BetterPlayerSubtitlesSourceType.NETWORK,
          name: "DE",
          urls: [
            "https://dl.dropboxusercontent.com/s/71nzjo2ux3evxqk/example_subtitles.srt"
          ],
        ),
      ],
    );
```

### BetterPlayerConfiguration
You can provide configuration to your player when creating BetterPlayerController.

```dart
    var betterPlayerConfiguration = BetterPlayerConfiguration(
      autoPlay: true,
      looping: true,
      fullScreenByDefault: true,
    );
```

Possible configuration options:
```dart
    /// Play the video as soon as it's displayed
    final bool autoPlay;

    /// Start video at a certain position
    final Duration startAt;

    /// Whether or not the video should loop
    final bool looping;

    /// Weather or not to show the controls when initializing the widget.
    final bool showControlsOnInitialize;

    /// When the video playback runs  into an error, you can build a custom
    /// error message.
    final Widget Function(BuildContext context, String errorMessage) errorBuilder;

    /// The Aspect Ratio of the Video. Important to get the correct size of the
    /// video!
    ///
    /// Will fallback to fitting within the space allowed.
    final double aspectRatio;

    /// The placeholder is displayed underneath the Video before it is initialized
    /// or played.
    final Widget placeholder;

    /// Should the placeholder be shown until play is pressed
    final bool showPlaceholderUntilPlay;

    /// A widget which is placed between the video and the controls
    final Widget overlay;

    /// Defines if the player will start in fullscreen when play is pressed
    final bool fullScreenByDefault;

    /// Defines if the player will sleep in fullscreen or not
    final bool allowedScreenSleep;

    /// Defines aspect ratio which will be used in fullscreen
    final double fullScreenAspectRatio;

    /// Defines the set of allowed device orientations on entering fullscreen
    final List<DeviceOrientation> deviceOrientationsOnFullScreen;

    /// Defines the system overlays visible after exiting fullscreen
    final List<SystemUiOverlay> systemOverlaysAfterFullScreen;

    /// Defines the set of allowed device orientations after exiting fullscreen
    final List<DeviceOrientation> deviceOrientationsAfterFullScreen;

    /// Defines a custom RoutePageBuilder for the fullscreen
    final BetterPlayerRoutePageBuilder routePageBuilder;

    /// Defines a event listener where video player events will be send
    final Function(BetterPlayerEvent) eventListener;

    ///Defines subtitles configuration
    final BetterPlayerSubtitlesConfiguration subtitlesConfiguration;

    ///Defines controls configuration
    final BetterPlayerControlsConfiguration controlsConfiguration;

    ///Defines fit of the video, allows to fix video stretching, see possible
    ///values here: https://api.flutter.dev/flutter/painting/BoxFit-class.html
    final BoxFit fit;

    ///Defines rotation of the video in degrees. Default value is 0. Can be 0, 90, 180, 270.
    ///Angle will rotate only video box, controls will be in the same place.
    final double rotation;
    
    ///Defines function which will react on player visibility changed
    final Function(double visibilityFraction) playerVisibilityChangedBehavior;

    ///Defines translations used in player. If null, then default english translations
    ///will be used.
    final List<BetterPlayerTranslations> translations;

    ///Defines if player should auto detect full screen device orientation based
    ///on aspect ratio of the video. If aspect ratio of the video is < 1 then
    ///video will played in full screen in portrait mode. If aspect ratio is >= 1
    ///then video will be played horizontally. If this parameter is true, then
    ///[deviceOrientationsOnFullScreen] and [fullScreenAspectRatio] value will be
    /// ignored.
    final bool autoDetectFullscreenDeviceOrientation;
```

### BetterPlayerSubtitlesConfiguration
You can provide subtitles configuration with this class. You should put BetterPlayerSubtitlesConfiguration in BetterPlayerConfiguration.
```dart
 var betterPlayerConfiguration = BetterPlayerConfiguration(
      subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
        fontSize: 20,
        fontColor: Colors.green,
      ),
    );
```

Possible configuration options:
```dart
 ///Subtitle font size
  final double fontSize;

  ///Subtitle font color
  final Color fontColor;

  ///Enable outline (border) of the text
  final bool outlineEnabled;

  ///Color of the outline stroke
  final Color outlineColor;

  ///Outline stroke size
  final double outlineSize;

  ///Font family of the subtitle
  final String fontFamily;

  ///Left padding of the subtitle
  final double leftPadding;

  ///Right padding of the subtitle
  final double rightPadding;

  ///Bottom padding of the subtitle
  final double bottomPadding;

  ///Alignment of the subtitle
  final Alignment alignment;

  ///Background color of the subtitle
  final Color backgroundColor;

  ///Subtitles selected by default, without user interaction
  final bool selectedByDefault;
```

### BetterPlayerControlsConfiguration
Configuration for player GUI. You should pass this configuration to BetterPlayerConfiguration.

```dart
var betterPlayerConfiguration = BetterPlayerConfiguration(
      controlsConfiguration: BetterPlayerControlsConfiguration(
        textColor: Colors.black,
        iconsColor: Colors.black,
      ),
    );
```
```dart
   ///Color of the control bars
   final Color controlBarColor;

   ///Color of texts
   final Color textColor;

   ///Color of icons
   final Color iconsColor;

   ///Icon of play
   final IconData playIcon;

   ///Icon of pause
   final IconData pauseIcon;

   ///Icon of mute
   final IconData muteIcon;

   ///Icon of unmute
   final IconData unMuteIcon;

   ///Icon of fullscreen mode enable
   final IconData fullscreenEnableIcon;

   ///Icon of fullscreen mode disable
   final IconData fullscreenDisableIcon;

   ///Cupertino only icon, icon of skip
   final IconData skipBackIcon;

   ///Cupertino only icon, icon of forward
   final IconData skipForwardIcon;

   ///Flag used to enable/disable fullscreen
   final bool enableFullscreen;

   ///Flag used to enable/disable mute
   final bool enableMute;

   ///Flag used to enable/disable progress texts
   final bool enableProgressText;

   ///Flag used to enable/disable progress bar
   final bool enableProgressBar;

   ///Flag used to enable/disable play-pause
   final bool enablePlayPause;

   ///Flag used to enable skip forward and skip back
   final bool enableSkips;

   ///Progress bar played color
   final Color progressBarPlayedColor;

   ///Progress bar circle color
   final Color progressBarHandleColor;

   ///Progress bar buffered video color
   final Color progressBarBufferedColor;

   ///Progress bar background color
   final Color progressBarBackgroundColor;

   ///Time to hide controls
   final Duration controlsHideTime;

   ///Custom controls, it will override Material/Cupertino controls
   final Widget customControls;

   ///Flag used to show/hide controls
   final bool showControls;

   ///Flag used to show controls on init
   final bool showControlsOnInitialize;

   ///Control bar height
   final double controlBarHeight;

   ///Live text color;
   final Color liveTextColor;

   ///Flag used to show/hide overflow menu which contains playback, subtitles,
   ///qualities options.
   final bool enableOverflowMenu;

   ///Flag used to show/hide playback speed
   final bool enablePlaybackSpeed;

   ///Flag used to show/hide subtitles
   final bool enableSubtitles;

   ///Flag used to show/hide qualities
   final bool enableQualities;

   ///Custom items of overflow menu
   final List<BetterPlayerOverflowMenuItem> overflowMenuCustomItems;

   ///Icon of the overflow menu
   final IconData overflowMenuIcon;

   ///Icon of the playback speed menu item from overflow menu
   final IconData playbackSpeedIcon;

   ///Icon of the subtitles menu item from overflow menu
   final IconData subtitlesIcon;

   ///Icon of the qualities menu item from overflow menu
   final IconData qualitiesIcon;

   ///Color of overflow menu icons
   final Color overflowMenuIconsColor;

   ///Time which will be used once user uses rewind and forward
   final int skipsTimeInMilliseconds;
```

### BetterPlayerPlaylistConfiguration
Configure your playlist. Pass this object to BetterPlayerPlaylist

```dart
 var betterPlayerPlaylistConfiguration = BetterPlayerPlaylistConfiguration(
      loopVideos: false,
      nextVideoDelay: Duration(milliseconds: 5000),
    );
```

Possible configuration options:
```dart
  ///How long user should wait for next video
  final Duration nextVideoDelay;

  ///Should videos be looped
  final bool loopVideos;
```

### BetterPlayerDataSource
Define source for one video in your app. There are 3 types of data sources:
* Network - data source which uses url to play video from external resources
* File - data source which uses url to play video from internal resources
* Memory - data source which uses list of bytes to play video from memory
```dart
    var dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.NETWORK,
      "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
      subtitles: BetterPlayerSubtitlesSource(
        type: BetterPlayerSubtitlesSourceType.FILE,
        url: "${directory.path}/example_subtitles.srt",
      ),
      headers: {"header":"my_custom_header"}
    );
```

You can use type specific factories to build your data source.
Use BetterPlayerDataSource.network to build network data source, BetterPlayerDataSource.file to build file data source and BetterPlayerDataSource.memory
to build memory data source.

Possible configuration options:
```
  ///Type of source of video
  final BetterPlayerDataSourceType type;

  ///Url of the video
  final String url;

  ///Subtitles configuration
  ///You can pass here multiple subtitles
  final List<BetterPlayerSubtitlesSource> subtitles;

  ///Flag to determine if current data source is live stream
  final bool liveStream;

  /// Custom headers for player
  final Map<String, String> headers;

  ///Should player use hls subtitles. Default is true.
  final bool useHlsSubtitles;

  ///Should player use hls tracks
  final bool useHlsTracks;

  ///List of strings that represents tracks names.
  ///If empty, then better player will choose name based on track parameters
  final List<String> hlsTrackNames;

  ///Optional, alternative resolutions for non-hls video. Used to setup
  ///different qualities for video.
  ///Data should be in given format:
  ///{"360p": "url", "540p": "url2" }
  final Map<String, String> resolutions;

  ///Optional cache configuration, used only for network data sources
  final BetterPlayerCacheConfiguration cacheConfiguration;
```


### BetterPlayerCacheConfiguration
Define cache configuration for given data source. Cache works only for network data sources.
```dart
  ///Enable cache for network data source
  final bool useCache;

  /// The maximum cache size to keep on disk in bytes.
  /// Android only option.
  final int maxCacheSize;

  /// The maximum size of each individual file in bytes.
  /// Android only option.
  final int maxCacheFileSize;
```


### BetterPlayerSubtitlesSource
Define source of subtitles in your video:
```dart
 var subtitles = BetterPlayerSubtitlesSource(
        type: BetterPlayerSubtitlesSourceType.FILE,
        url: "${directory.path}/example_subtitles.srt",
      );
```

Possible configuration options:
```dart
  ///Source type
  final BetterPlayerSubtitlesSourceType type;

  ///Url of the subtitles, used with file or network subtitles
  final String url;

  ///Content of subtitles, used when type is memory
  final String content;
```

### BetterPlayerTranslations
You can provide translations for different languages. You need to pass list of BetterPlayerTranslations to
the BetterPlayerConfiguration. Here is an example:

```dart
 translations: [
              BetterPlayerTranslations(
                languageCode: "language_code for example pl",
                generalDefaultError: "translated text",
                generalNone: "translated text",
                generalDefault: "translated text",
                playlistLoadingNextVideo: "translated text",
                controlsLive: "translated text",
                controlsNextVideoIn: "translated text",
                overflowMenuPlaybackSpeed: "translated text",
                overflowMenuSubtitles: "translated text",
                overflowMenuQuality: "translated text",
              ),
              BetterPlayerTranslations(
                languageCode: "other language for example cz",
                generalDefaultError: "translated text",
                generalNone: "translated text",
                generalDefault: "translated text",
                playlistLoadingNextVideo: "translated text",
                controlsLive: "translated text",
                controlsNextVideoIn: "translated text",
                overflowMenuPlaybackSpeed: "translated text",
                overflowMenuSubtitles: "translated text",
                overflowMenuQuality: "translated text",
              ),
            ],
```
There are 4 pre build in languages: EN, PL, ZH (chinese simplified), HI (hindi). If you didn't provide
any translation then EN translations will be used or any of the pre build in translations, only if it's
match current user locale.

You need to setup localizations in your app first to make it work. Here's how you can do that:
https://flutter.dev/docs/development/accessibility-and-localization/internationalization

### Listen to video events
You can listen to video player events like:
```dart
  INITIALIZED,
  PLAY,
  PAUSE,
  SEEK_TO,
  OPEN_FULLSCREEN,
  HIDE_FULLSCREEN,
  SET_VOLUME,
  PROGRESS,
  FINISHED,
  EXCEPTION,
  CONTROLS_VISIBLE,
  CONTROLS_HIDDEN,
  SET_SPEED,
  CHANGED_SUBTITLES,
  CHANGED_TRACK,
  CHANGED_PLAYER_VISIBILITY,
  CHANGED_RESOLUTION,
```

After creating BetterPlayerController you can add event listener this way:
```dart
 _betterPlayerController.addEventsListener((event){
      print("Better player event: ${event.betterPlayerEventType}");
    });
```
Your event listener will ne auto-disposed on dispose time :)


### Change player behavior if player is not visible
You can change player behavior if player is not visible by using playerVisibilityChangedBehavior option in BetterPlayerConfiguration.
Here is an example for player used in list:
```dart
 void onVisibilityChanged(double visibleFraction) async {
    bool isPlaying = await _betterPlayerController.isPlaying();
    bool initialized = _betterPlayerController.isVideoInitialized();
    if (visibleFraction >= widget.playFraction) {
      if (widget.autoPlay && initialized && !isPlaying && !_isDisposing) {
        _betterPlayerController.play();
      }
    } else {
      if (widget.autoPause && initialized && isPlaying && !_isDisposing) {
        _betterPlayerController.pause();
      }
    }
  }
```
Player behavior works in the basis of VisibilityDetector (it uses visibilityFraction, which is value from 0.0 to 1.0 that describes how much given widget is on the viewport). So if value 0.0, player is not visible, so we need to pause the video. If the visibilityFraction is 1.0, we need to play it again.

### Pass multiple resolutions of the video
You can setup video with different resolutions. Use resolutions parameter in data source. This should be used
only for normal videos (non-hls) to setup different qualities of the original video.

```dart
    var dataSource = BetterPlayerDataSource(BetterPlayerDataSourceType.NETWORK,
        "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4",
        resolutions: {
          "LOW":
              "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4",
          "MEDIUM":
              "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_640_3MG.mp4",
          "LARGE":
              "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_1280_10MG.mp4",
          "EXTRA_LARGE":
              "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_1920_18MG.mp4"
        });
```

### Add custom element to overflow menu
You can use BetterPlayerControlsConfiguration to add custom element to the overflow menu:
```dart
  controlsConfiguration: BetterPlayerControlsConfiguration(
              overflowMenuCustomItems: [
                BetterPlayerOverflowMenuItem(
                  Icons.account_circle_rounded,
                  "Custom element",
                  () => print("Click!"),
                )
              ],
            ),
```

### More documentation
https://pub.dev/documentation/better_player/latest/better_player/better_player-library.html






