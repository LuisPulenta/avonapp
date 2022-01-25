import 'package:avon_app/models/user.dart';

class Token {
  String token = '';
  String expiration = '';
  User user = User(
      firstName: '',
      lastName: '',
      document: '',
      address1: '',
      latitude1: 0,
      longitude1: 0,
      address2: '',
      latitude2: 0,
      longitude2: 0,
      address3: '',
      latitude3: 0,
      longitude3: 0,
      imageId: '',
      imageFullPath: '',
      userType: 0,
      fullName: '',
      id: '',
      userName: '',
      email: '',
      phoneNumber: '');

  Token({required this.token, required this.expiration, required this.user});

  Token.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiration = json['expiration'];
    user = new User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['expiration'] = this.expiration;
    data['user'] = this.user.toJson();
    return data;
  }
}
