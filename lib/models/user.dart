class User {
  String modulo = '';
  String firstName = '';
  String lastName = '';
  String document = '';
  String address1 = '';
  double? latitude1 = 0.0;
  double? longitude1 = 0.0;
  String? street1 = '';
  String? administrativeArea1 = '';
  String? country1 = '';
  String? isoCountryCode1 = '';
  String? locality1 = '';
  String? subAdministrativeArea1 = '';
  String? subLocality1 = '';
  String address2 = '';
  double? latitude2 = 0.0;
  double? longitude2 = 0.0;
  String? street2 = '';
  String? administrativeArea2 = '';
  String? country2 = '';
  String? isoCountryCode2 = '';
  String? locality2 = '';
  String? subAdministrativeArea2 = '';
  String? subLocality2 = '';
  String address3 = '';
  double? latitude3 = 0.0;
  double? longitude3 = 0.0;
  String? street3 = '';
  String? administrativeArea3 = '';
  String? country3 = '';
  String? isoCountryCode3 = '';
  String? locality3 = '';
  String? subAdministrativeArea3 = '';
  String? subLocality3 = '';
  String imageId = '';
  String imageFullPath = '';
  int userType = 0;
  String fullName = '';
  String id = '';
  String userName = '';
  String email = '';
  String phoneNumber = '';

  User({
    required this.modulo,
    required this.firstName,
    required this.lastName,
    required this.document,
    required this.address1,
    required this.latitude1,
    required this.longitude1,
    required this.street1,
    required this.administrativeArea1,
    required this.country1,
    required this.isoCountryCode1,
    required this.locality1,
    required this.subAdministrativeArea1,
    required this.subLocality1,
    required this.address2,
    required this.latitude2,
    required this.longitude2,
    required this.street2,
    required this.administrativeArea2,
    required this.country2,
    required this.isoCountryCode2,
    required this.locality2,
    required this.subAdministrativeArea2,
    required this.subLocality2,
    required this.address3,
    required this.latitude3,
    required this.longitude3,
    required this.street3,
    required this.administrativeArea3,
    required this.country3,
    required this.isoCountryCode3,
    required this.locality3,
    required this.subAdministrativeArea3,
    required this.subLocality3,
    required this.imageId,
    required this.imageFullPath,
    required this.userType,
    required this.fullName,
    required this.id,
    required this.userName,
    required this.email,
    required this.phoneNumber,
  });

  User.fromJson(Map<String, dynamic> json) {
    modulo = json['modulo'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    document = json['document'];
    address1 = json['address1'];
    latitude1 = json['latitude1'] + .0;
    longitude1 = json['longitude1'] + .0;

    street1 = json['street1'];
    administrativeArea1 = json['administrativeArea1'];
    country1 = json['country1'];
    isoCountryCode1 = json['isoCountryCode1'];
    locality1 = json['locality1'];
    subAdministrativeArea1 = json['subAdministrativeArea1'];
    subLocality1 = json['subLocality1'];

    address2 = json['address2'];
    latitude2 = json['latitude2'] + .0;
    longitude2 = json['longitude2'] + .0;

    street2 = json['street2'];
    administrativeArea2 = json['administrativeArea2'];
    country2 = json['country2'];
    isoCountryCode2 = json['isoCountryCode2'];
    locality2 = json['locality2'];
    subAdministrativeArea2 = json['subAdministrativeArea2'];
    subLocality2 = json['subLocality2'];

    address3 = json['address3'];
    latitude3 = json['latitude3'] + .0;
    longitude3 = json['longitude3'] + .0;

    street3 = json['street3'];
    administrativeArea3 = json['administrativeArea3'];
    country3 = json['country3'];
    isoCountryCode3 = json['isoCountryCode3'];
    locality3 = json['locality3'];
    subAdministrativeArea3 = json['subAdministrativeArea3'];
    subLocality3 = json['subLocality3'];

    imageId = json['imageId'];
    imageFullPath = json['imageFullPath'];
    userType = json['userType'];
    fullName = json['fullName'];
    id = json['id'];
    userName = json['userName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['modulo'] = this.modulo;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['document'] = this.document;
    data['address1'] = this.address1;
    data['latitude1'] = this.latitude1;
    data['longitude1'] = this.longitude1;

    data['street1'] = this.street1;
    data['administrativeArea1'] = this.administrativeArea1;
    data['country1'] = this.country1;
    data['isoCountryCode1'] = this.isoCountryCode1;
    data['locality1'] = this.locality1;
    data['subAdministrativeArea1'] = this.subAdministrativeArea1;
    data['subLocality1'] = this.subLocality1;

    data['address2'] = this.address2;
    data['latitude2'] = this.latitude2;
    data['longitude2'] = this.longitude2;

    data['street2'] = this.street2;
    data['administrativeArea2'] = this.administrativeArea2;
    data['country2'] = this.country2;
    data['isoCountryCode2'] = this.isoCountryCode2;
    data['locality2'] = this.locality2;
    data['subAdministrativeArea2'] = this.subAdministrativeArea2;
    data['subLocality2'] = this.subLocality2;

    data['address3'] = this.address3;
    data['latitude3'] = this.latitude3;
    data['longitude3'] = this.longitude3;

    data['street3'] = this.street3;
    data['administrativeArea3'] = this.administrativeArea3;
    data['country3'] = this.country3;
    data['isoCountryCode3'] = this.isoCountryCode3;
    data['locality3'] = this.locality3;
    data['subAdministrativeArea3'] = this.subAdministrativeArea3;
    data['subLocality3'] = this.subLocality3;

    data['imageId'] = this.imageId;
    data['imageFullPath'] = this.imageFullPath;
    data['userType'] = this.userType;
    data['fullName'] = this.fullName;
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
