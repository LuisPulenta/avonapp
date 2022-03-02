import 'package:avon_app/models/user.dart';

class Token {
  String token = '';
  String expiration = '';
  User user = User(
      modulo: '',
      firstName: '',
      lastName: '',
      document: '',
      address1: '',
      latitude1: 0,
      longitude1: 0,
      street1: '',
      administrativeArea1: '',
      country1: '',
      isoCountryCode1: '',
      locality1: '',
      subAdministrativeArea1: '',
      subLocality1: '',
      address2: '',
      latitude2: 0,
      longitude2: 0,
      street2: '',
      administrativeArea2: '',
      country2: '',
      isoCountryCode2: '',
      locality2: '',
      subAdministrativeArea2: '',
      subLocality2: '',
      address3: '',
      latitude3: 0,
      longitude3: 0,
      street3: '',
      administrativeArea3: '',
      country3: '',
      isoCountryCode3: '',
      locality3: '',
      subAdministrativeArea3: '',
      subLocality3: '',
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
