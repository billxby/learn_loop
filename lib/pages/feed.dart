import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_loop/pages/upload.dart';
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:video_player/video_player.dart';

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
  bool controllerInitialized = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener((event) {
      _handleCallbackEvent(event.direction, event.success, currentIndex: event.pageNo);
    });
    whereWasIFunction();

  }

  Future<void> whereWasIFunction() async {
    // slight delay otherwise won't load
    await Future.delayed(Duration(milliseconds: 10));
    if (ref.read(FeedVideoIdsNotifierProvider).isEmpty) {
      // fetch some values, rn i'm gonna auto add random shit
      ref.read(FeedVideoIdsNotifierProvider.notifier).addVideos([
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
        "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
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
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
          "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
        ]);
      }
      playVideo();
    }
  }

  Future<void> playVideo() async {
    print("hi");
    // load and play the new video
    videoController = VideoPlayerController.networkUrl(
      Uri.parse(ref.read(FeedVideoIdsNotifierProvider)[ref.read(FeedIndexNotifierProvider)])
    );
    await videoController.initialize();
    print("Bye");
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
    final videoList = ref.watch(FeedVideoIdsNotifierProvider);
    print(videoIndex);
    print(videoList);

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
                return VideoPlayer(
                    videoController
                );

                videoController = VideoPlayerController.networkUrl(Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'));

                return FutureBuilder<void>(
                  future: videoController.initialize(),
                  builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      videoController.play();
                      return Container(
                          color: (index%2 == 0) ? Colors.red : Colors.blue,
                          child: Text("HOLA")
                      );
                      return VideoPlayer(
                          videoController
                      );
                    } else {
                      return Center(
                          child: Text("Hello", style: TextStyle(color: Colors.red))
                      );
                    }
                  },

                );

                videoController.play();

                return VideoPlayer(
                  videoController
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
                    icon: Icon(Icons.favorite_border, size: 50, color: Colors.white,),
                    onPressed: () {
                      scrollController.jumpToPosition(1);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  IconButton(
                    icon: Icon(Icons.thumb_down_off_alt_sharp, size: 50, color: Colors.white,),
                    onPressed: () {},
                  ),
                ],
              )
            )
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 45),
                child: IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.white, size: 40),
                  onPressed: () {  },
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
