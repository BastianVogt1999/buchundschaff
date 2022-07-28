class UserBuS {
  String user_name;
  String user_code;
  String is_admin;

  UserBuS(this.user_name, this.user_code, this.is_admin);

  UserBuS.empty() : this("", "", "");

  String getUserName() {
    return user_name;
  }
}

class UserAsMap {
  UserAsMap(
      {required this.user_name,
      required this.user_code,
      required this.is_admin});

  UserAsMap.fromJson(Map<String, Object> json)
      : this(
          user_name: json['user_name'] as String,
          user_code: json['user_code'] as String,
          is_admin: json['is_admin'] as String,
        );

  final String user_name;
  final String user_code;
  final String is_admin;

  Map<String, Object> toJson() {
    return {
      'user_name': user_name,
      'user_code': user_code,
      'is_admin': is_admin,
    };
  }
}
