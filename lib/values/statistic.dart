class Statistic {
  String statistic_id;
  List<String> user;
  String startTime;
  String endTime;
  String countedTime;
  String date;
  String isrunning;

  Statistic(this.statistic_id, this.user, this.startTime, this.endTime,
      this.countedTime, this.date, this.isrunning);

  Statistic.empty() : this("", List.empty(), "", "", "", "", "");
}

class UserAsMap {
  UserAsMap(
      {required this.statistic_id,
      required this.user,
      required this.startTime,
      required this.endTime,
      required this.countedTime,
      required this.date,
      required this.isrunning});

  UserAsMap.fromJson(Map<String, Object> json)
      : this(
          statistic_id: json['statistic_id'] as String,
          user: json['user'] as List<String>,
          startTime: json['startTime'] as String,
          endTime: json['endTime'] as String,
          countedTime: json['countedTime'] as String,
          date: json['date'] as String,
          isrunning: json['isrunning'] as String,
        );

  final String statistic_id;
  List<String> user;
  String startTime;
  String endTime;
  String countedTime;
  String date;
  String isrunning;

  Map<String, Object> toJson() {
    return {
      'statistic_id': statistic_id,
      'user': user,
      'startTime': startTime,
      'endTime': endTime,
      'countedTime': countedTime,
      'date': date,
      'isrunning': isrunning,
    };
  }
}

class UpdateableStatistic {
  int index;
  Statistic updateableStatistic;
  UpdateableStatistic(this.index, this.updateableStatistic);

  UpdateableStatistic.empty() : this(0, Statistic.empty());
}
