class Bin {
  Bin({
    required this.id,
    required this.content,
    this.createdTime,
    this.lastUpdatedTime,
  });

  final String id;

  final String content;

  final String? createdTime;

  final String? lastUpdatedTime;
}
