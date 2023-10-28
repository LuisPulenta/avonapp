class Cliente {
  String modulo = '';
  String avonAccount = '';
  String password = '';
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
  String phoneNumber = '';
  String fechaAlta = '';
  String fechaFin = '';
  int catastroFinalizado = 0;
  int? avonZoneNumber = 0;

  Cliente({
    required this.modulo,
    required this.avonAccount,
    required this.password,
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
    required this.phoneNumber,
    required this.fechaAlta,
    required this.fechaFin,
    required this.catastroFinalizado,
    required this.avonZoneNumber,
  });

  Cliente.fromJson(Map<String, dynamic> json) {
    modulo = json['modulo'];
    avonAccount = json['avonAccount'];
    password = json['password'];
    firstName = json['firstName'];
    lastName = json['lastName'] ?? '';
    document = json['document'] ?? '';
    address1 = json['address1'] ?? '';
    latitude1 = json['latitude1'] + 0.0 ?? 0.0;
    longitude1 = json['longitude1'] + 0.0 ?? 0.0;

    street1 = json['street1'] ?? '';
    administrativeArea1 = json['administrativeArea1'] ?? '';
    country1 = json['country1'] ?? '';
    isoCountryCode1 = json['isoCountryCode1'] ?? '';
    locality1 = json['locality1'] ?? '';
    subAdministrativeArea1 = json['subAdministrativeArea1'] ?? '';
    subLocality1 = json['subLocality1'] ?? '';

    address2 = json['address2'] ?? '';
    latitude2 = json['latitude2'] + 0.0 ?? 0.0;
    longitude2 = json['longitude2'] + 0.0 ?? 0.0;

    street2 = json['street2'] ?? '';
    administrativeArea2 = json['administrativeArea2'] ?? '';
    country2 = json['country2'] ?? '';
    isoCountryCode2 = json['isoCountryCode2'] ?? '';
    locality2 = json['locality2'] ?? '';
    subAdministrativeArea2 = json['subAdministrativeArea2'] ?? '';
    subLocality2 = json['subLocality2'] ?? '';

    address3 = json['address3'] ?? '';
    latitude3 = json['latitude3'] + 0.0 ?? 0.0;
    longitude3 = json['longitude3'] + 0.0 ?? 0.0;

    street3 = json['street3'] ?? '';
    administrativeArea3 = json['administrativeArea3'] ?? '';
    country3 = json['country3'] ?? '';
    isoCountryCode3 = json['isoCountryCode3'] ?? '';
    locality3 = json['locality3'] ?? '';
    subAdministrativeArea3 = json['subAdministrativeArea3'] ?? '';
    subLocality3 = json['subLocality3'] ?? '';

    imageId = json['imageId'] ?? '';
    imageFullPath = json['imageFullPath'] ?? '';
    userType = json['userType'];
    fullName = json['fullName'] ?? '';
    id = json['id'].toString();
    phoneNumber = json['phoneNumber'] ?? '';
    fechaAlta = json['fechaAlta'] ?? '';
    fechaFin = json['fechaFin'] ?? '';
    catastroFinalizado = json['catastroFinalizado'] ?? '';
    avonZoneNumber = json['avonZoneNumber'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['modulo'] = modulo;
    data['avonAccount'] = avonAccount;
    data['password'] = password;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['document'] = document;
    data['address1'] = address1;
    data['latitude1'] = latitude1;
    data['longitude1'] = longitude1;

    data['street1'] = street1;
    data['administrativeArea1'] = administrativeArea1;
    data['country1'] = country1;
    data['isoCountryCode1'] = isoCountryCode1;
    data['locality1'] = locality1;
    data['subAdministrativeArea1'] = subAdministrativeArea1;
    data['subLocality1'] = subLocality1;

    data['address2'] = address2;
    data['latitude2'] = latitude2;
    data['longitude2'] = longitude2;

    data['street2'] = street2;
    data['administrativeArea2'] = administrativeArea2;
    data['country2'] = country2;
    data['isoCountryCode2'] = isoCountryCode2;
    data['locality2'] = locality2;
    data['subAdministrativeArea2'] = subAdministrativeArea2;
    data['subLocality2'] = subLocality2;

    data['address3'] = address3;
    data['latitude3'] = latitude3;
    data['longitude3'] = longitude3;

    data['street3'] = street3;
    data['administrativeArea3'] = administrativeArea3;
    data['country3'] = country3;
    data['isoCountryCode3'] = isoCountryCode3;
    data['locality3'] = locality3;
    data['subAdministrativeArea3'] = subAdministrativeArea3;
    data['subLocality3'] = subLocality3;

    data['imageId'] = imageId;
    data['imageFullPath'] = imageFullPath;
    data['userType'] = userType;
    data['fullName'] = fullName;
    data['id'] = id;
    data['phoneNumber'] = phoneNumber;

    data['fechaAlta'] = fechaAlta;
    data['fechaFin'] = fechaFin;
    data['catastroFinalizado'] = catastroFinalizado;
    data['avonZoneNumber'] = avonZoneNumber;
    return data;
  }
}
