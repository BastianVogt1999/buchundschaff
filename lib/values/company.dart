class Company {
  String company_name;
  String company_code;

  Company(this.company_name, this.company_code);

  Company.empty() : this("", "");

 
}

class UserAsMap {
  UserAsMap({required this.user_name, required this.company_code});

  UserAsMap.fromJson(Map<String, Object> json)
      : this(
          user_name: json['user_name'] as String,
          company_code: json['company_code'] as String,
        );

  final String user_name;
  final String company_code;

  Map<String, Object> toJson() {
    return {
      'user_name': user_name,
      'company_code': company_code,
    };
  }
}
