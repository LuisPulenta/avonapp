class User {
  String modulo = '';
  String firstName = '';
  String lastName = '';
  String document = '';
  String? address1 = '';
  double? latitude1 = 0.0;
  double? longitude1 = 0.0;
  String? address2 = '';
  double? latitude2 = 0.0;
  double? longitude2 = 0.0;
  String? address3 = '';
  double? latitude3 = 0.0;
  double? longitude3 = 0.0;
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
    required this.address2,
    required this.latitude2,
    required this.longitude2,
    required this.address3,
    required this.latitude3,
    required this.longitude3,
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
    address2 = json['address2'];
    latitude2 = json['latitude2'] + .0;
    longitude2 = json['longitude2'] + .0;
    address3 = json['address3'];
    latitude3 = json['latitude3'] + .0;
    longitude3 = json['longitude3'] + .0;
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
    data['address2'] = this.address2;
    data['latitude2'] = this.latitude2;
    data['longitude2'] = this.longitude2;
    data['address3'] = this.address3;
    data['latitude3'] = this.latitude3;
    data['longitude3'] = this.longitude3;
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
