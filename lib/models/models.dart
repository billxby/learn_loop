

class Video{
  Video({
    required this.url,
    required this.topic
  });

  String url;
  String topic;
  bool? status;
}

class Topic {
  String topicString;
  int interval = 0;
  double easeFactor = 2.5;
  int repetitions = 0;

  Topic(this.topicString);

  void update(int quality) {
    if (quality < 1) {
      interval = 1;
    } else {
      interval = (interval * easeFactor).round();
    }

    easeFactor += 0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02);
    easeFactor = easeFactor < 1.3 ? 1.3 : easeFactor;
    repetitions++;
  }
}
