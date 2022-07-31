class Wish {
  String content;
  DateTime timestamp;
  bool done;
  Wish({
    required this.content,
    required this.timestamp,
    required this.done,
  });

  factory Wish.fromMap(Map wish) {
    return Wish(
      content: wish["content"],
      timestamp: wish["timestamp"],
      done: wish["done"],
    );
  }

  Map toMap() {
    return {
      "content": content,
      "timestamp": timestamp,
      "done": done,
    };
  }
}
