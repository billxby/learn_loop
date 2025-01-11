import 'package:riverpod/riverpod.dart';

import '../models/models.dart';

class FeedIndexNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void update(int newIndex) {
    state = newIndex;
  }
}

class FeedVideoIdsNotifier extends Notifier<List<Video>> {
  @override
  List<Video> build() {
    return [];
  }

  void addVideos(List<Video> newVideos) {
    state = [...state, ...newVideos];
  }

  void updateState(List<Video> videoList) {
    state = videoList;
  }
}

class FeedTopicsNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    return [];
  }

  void addTopics(List<String> topics) {

  }
}

final FeedIndexNotifierProvider = NotifierProvider<FeedIndexNotifier, int>(() {
  return FeedIndexNotifier();
});

final FeedVideoIdsNotifierProvider = NotifierProvider<FeedVideoIdsNotifier, List<Video>>(() {
  return FeedVideoIdsNotifier();
});