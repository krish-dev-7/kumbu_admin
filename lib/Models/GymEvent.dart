class GymEvent {
  String? id;
  String title;
  String description;
  String date;
  String startTime;
  String endTime;
  String location;
  String host;
  double? entryFee;
  String? reward;
  String? imageUrl;

  GymEvent({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.host,
    this.entryFee,
    this.reward,
    this.imageUrl,
  });

  factory GymEvent.fromJson(Map<String, dynamic> json) {
    return GymEvent(
      id: json["_id"],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      location: json['location'],
      host: json['host'],
      entryFee: json['entryFee']?.toDouble(),
      reward: json['reward'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'host': host,
      'entryFee': entryFee,
      'reward': reward,
      'imageUrl': imageUrl,
    };
  }
}
