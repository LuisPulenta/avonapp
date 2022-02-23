class User2 {
  String email = '';
  bool emailConfirmed = false;

  User2({
    required this.email,
    required this.emailConfirmed,
  });

  User2.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    emailConfirmed = json['emailConfirmed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['emailConfirmed'] = this.emailConfirmed;

    return data;
  }
}
