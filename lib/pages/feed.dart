import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_icon_shadow/flutter_icon_shadow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn_loop/pages/upload.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:video_player/video_player.dart';

import '../models/models.dart';
import '../providers/feed_utils.dart';
import 'library.dart';

int _pageIndex = 0;

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  final Controller scrollController = Controller();
  late VideoPlayerController videoController;
  FlutterTts flutterTts = FlutterTts();
  bool controllerInitialized = false;
  late Timer captionTimer;
  String currentText = "";

  List<String> captions = [];
  int curCaptionIdx = 0;
  bool running = false;

  @override
  void initState() {
    super.initState();
    flutterTts.setSpeechRate(0.4);
    scrollController.addListener((event) {
      _handleCallbackEvent(event.direction, event.success, currentIndex: event.pageNo);
    });
    whereWasIFunction();
    // captionLoop();
    // return;

    captionTimer = Timer.periodic(const Duration(milliseconds: 1200), (timer) async {
      if (curCaptionIdx >= captions.length) return;
      running = true;
      setState(() {
        currentText = captions[curCaptionIdx];
        curCaptionIdx++;
      });
      await flutterTts.speak(currentText);
      running = false;
    });
  }

  // Future<void> captionLoop() async {
  //   while (true) {
  //     if (curCaptionIdx >= captions.length) { await Future.delayed(Duration(milliseconds: 500)); continue;}
  //     running = true;
  //     setState(() {
  //       currentText = captions[curCaptionIdx];
  //       curCaptionIdx++;
  //     });
  //     flutterTts.speak(currentText);
  //     await Future.delayed(Duration(milliseconds: (100*currentText.length)));
  //     // await flutterTts.awaitSpeakCompletion(true);
  //     running = false;
  //   }
  // }

  List<String> createCaptions(String text, int maxLength) {
    List<String> result = [];
    List<String> words = text.split(' ');
    String currentSegment = '';
    for (String word in words) {
      if (currentSegment.length + word.length + 1 <= maxLength) {
        currentSegment += (currentSegment.isEmpty ? '' : ' ') + word;
      } else {
        if (currentSegment.isNotEmpty) {
          result.add(currentSegment);
        }
        if (word.length > maxLength) {
          result.add(word.substring(0, maxLength));
        } else {
          currentSegment = word;
        }
      }
    }
    if (currentSegment.isNotEmpty) {
      result.add(currentSegment);
    }
    return result;
  }


  Future<void> whereWasIFunction() async {
    // slight delay otherwise won't load
    await Future.delayed(Duration(milliseconds: 10));
    if (ref.read(FeedVideoIdsNotifierProvider).isEmpty) {
      // fetch some values, rn i'm gonna auto add random shit
      ref.read(FeedVideoIdsNotifierProvider.notifier).addVideos([
        Video(
            url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
            script: "whopper whopper chicken tender butter ",
            topic: "gang"
        ),
        Video(
            url: "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
            script: "the quick brown fox jumps over the lazy dog ",
            topic: "gang"
        ),
      ]);
    }
    scrollController.jumpToPosition(ref.read(FeedIndexNotifierProvider));
    playVideo();
  }
  

  Future<void> _handleCallbackEvent(ScrollDirection direction, ScrollSuccess success, {int? currentIndex}) async {
    // print("Scroll callback received with data: {direction: $direction, success: $success and index: ${currentIndex ?? 'not given'}}");
    if (currentIndex != null) {

      ref.read(FeedIndexNotifierProvider.notifier).update(currentIndex);
      if (currentIndex >= ref.read(FeedVideoIdsNotifierProvider).length || ref.read(FeedVideoIdsNotifierProvider).isEmpty) {
        // fetch some values, rn i'm gonna auto add random shit
        ref.read(FeedVideoIdsNotifierProvider.notifier).addVideos([
          Video(
            url: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
            script: "Erm who the fuck asked erm who the fucked fucking asked ",
            topic: "gang"
          ),
          Video(
            url: "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
            script: "FUCK this shit man I so fucking down this fucking piece of shit oh my fucking days ",
            topic: "gang"
          ),
          Video(
              url: "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
              script: "Tony bro how much did bro fall off since the talk tuah. Among us sus ",
              topic: "gang"
          ),
        ]);
      }
      playVideo();
    }
  }
  String getNextTopic(int quality) {
    List<Topic> a = ref.read(FeedTopicsNotifier);
    Topic currentTopic = a[0]
    currentTopic.update(quality)
    int i;
    for (i = 1; i < min(currentTopic.interval, a.length); i++) {
      a[i-1] = a[i]
    }
    a[i] = currentTopic
    ref.read(FeedTopicsNotifier.notifier).updateState()
    return a[0].topicString

  }
  

  Future<void> playVideo() async {
    print("hi");
    final currentVideo = ref.read(FeedVideoIdsNotifierProvider)[ref.read(FeedIndexNotifierProvider)];
    // load and play the new video
    flutterTts.pause();
    videoController = VideoPlayerController.networkUrl(
      Uri.parse(currentVideo.url)
    );
    await videoController.initialize();
    print("Bye");
    // flutterTts.speak(currentVideo.script * 20);
    captions = createCaptions(currentVideo.script * 20, 14);
    curCaptionIdx = 0;
    controllerInitialized = true;
    videoController.play();
    videoController.setLooping(true);
    setState(() {
      print("setting state");
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoIndex = ref.watch(FeedIndexNotifierProvider);
    List<Video> videoList = ref.watch(FeedVideoIdsNotifierProvider);
    final currentVideo = videoList[videoIndex];


    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          TikTokStyleFullPageScroller(
            contentSize: 1000,
            controller: scrollController,
            builder: (BuildContext context, int index) {
              // print(index);
              if (index >= videoList.length) {
                return Container(
                  color: Colors.black,
                  child: Center(
                    child: Text("Loading...", style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.white),)
                  )
                );
              }
              if (index == videoIndex) {
                return Stack(
                  children: [
                    VideoPlayer(
                        videoController
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Stack(
                          children: [
                            Text(currentText, style: GoogleFonts.modak(fontSize: 40, foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 5
                              ..color = Colors.black,)),
                            Text(currentText, style: GoogleFonts.modak(fontSize: 40, color: Colors.white))
                          ],
                        )
                      )
                    )
                  ],
                );
              }
              return Container(
                color: Colors.black
              );
            },
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(top: 300, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: IconShadow(
                      Icon(currentVideo.status == true ? Icons.favorite : Icons.favorite_border, size: 50, color: Colors.white, ),
                      shadowColor: Colors.black,
                    ),
                    onPressed: () {
                      if (currentVideo.status == true) {
                        videoList[videoIndex].status = null;
                      } else {
                        videoList[videoIndex].status = true;
                      }
                      setState(() {
                        ref.read(FeedVideoIdsNotifierProvider.notifier).updateState(videoList);
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  IconButton(
                    icon: IconShadow(
                      Icon(currentVideo.status == false ? Icons.thumb_down : Icons.thumb_down_off_alt_sharp, size: 50, color: Colors.white,),
                      shadowColor: Colors.black,
                    ),
                    onPressed: () {
                      if (currentVideo.status == false) {
                        videoList[videoIndex].status = null;
                      } else {
                        videoList[videoIndex].status = false;
                      }
                      setState(() {
                        ref.read(FeedVideoIdsNotifierProvider.notifier).updateState(videoList);
                      });
                    },
                  ),
                ],
              )
            )
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 45),
                child: IconButton(
                  icon: const IconShadow(
                    Icon(Icons.filter_list, color: Colors.white, size: 40),
                    shadowColor: Colors.black,
                  ),
                  onPressed: () {},
                ),
              )
          )
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(
                color: Colors.white,
              ),
            )
        ),
        child: NavigationBar(
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined, color: Colors.white,),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.add_circle_outline),
              icon: Icon(Icons.add_circle_outline, color: Colors.white),
              label: 'Upload',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.book, ),
              icon: Icon(Icons.book_outlined, color: Colors.white),
              label: 'Library',
            ),
          ],
          selectedIndex: _pageIndex,
          backgroundColor: Colors.black,
          onDestinationSelected: (int index) {
            if (_pageIndex == index) { return; }

            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                (index == 0) ? FeedPage() : ((index == 1) ? UploadPage() : LibraryPage()),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
        ),
      )
    );
  }
}
