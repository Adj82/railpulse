class TrainQuery {
  final String trainNumber;

  TrainQuery({required this.trainNumber});

  factory TrainQuery.fromJson(Map<String, dynamic> json) {
    return TrainQuery(
      trainNumber: json['trainNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trainNumber': trainNumber,
    };
  }
}
