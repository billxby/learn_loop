import 'package:riverpod/riverpod.dart';

class FeedIndexNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void update(int newIndex) {
    state = newIndex;
  }
}

class FeedVideoIdsNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    return [];
  }

  void addVideos(List<String> newVideos) {
    state = [...state, ...newVideos];
  }
}

final FeedIndexNotifierProvider = NotifierProvider<FeedIndexNotifier, int>(() {
  return FeedIndexNotifier();
});

final FeedVideoIdsNotifierProvider = NotifierProvider<FeedVideoIdsNotifier, List<String>>(() {
  return FeedVideoIdsNotifier();
});