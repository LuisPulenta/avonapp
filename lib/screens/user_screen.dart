import 'dart:convert';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:avon_app/components/loader_component.dart';
import 'package:avon_app/helpers/api_helper.dart';
import 'package:avon_app/models/user.dart';
import 'package:avon_app/models/response.dart';
import 'package:avon_app/models/token.dart';
import 'package:avon_app/screens/change_password_screen.dart';
import 'package:avon_app/screens/direccion_screen.dart';
import 'package:avon_app/screens/take_picture_screen.dart';

class UserScreen extends StatefulWidget {
  final Token token;
  final User user;
  final bool myProfile;

  const UserScreen(
      {Key? key,
      required this.token,
      required this.user,
      required this.myProfile})
      : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _showLoader = false;
  bool _photoChanged = false;
  bool _habilitaPosicion = false;
  int _option = 0;
  late XFile _image;
  late User _user;

  String _firstName = '';
  String _firstNameError = '';
  bool _firstNameShowError = false;
  final TextEditingController _firstNameController = TextEditingController();

  String _lastName = '';
  String _lastNameError = '';
  bool _lastNameShowError = false;
  final TextEditingController _lastNameController = TextEditingController();

  String _document = '';
  final String _documentError = '';
  final bool _documentShowError = false;
  final TextEditingController _documentController = TextEditingController();

  String? _address1 = '';
  final String _address1Error = '';
  final bool _address1ShowError = false;
  final TextEditingController _address1Controller = TextEditingController();

  String? _address2 = '';
  final String _address2Error = '';
  final bool _address2ShowError = false;
  final TextEditingController _address2Controller = TextEditingController();

  String? _address3 = '';
  final String _address3Error = '';
  final bool _address3ShowError = false;
  final TextEditingController _address3Controller = TextEditingController();

  String _email = '';
  final String _emailError = '';
  final bool _emailShowError = false;
  final TextEditingController _emailController = TextEditingController();

  String _phoneNumber = '';
  String _phoneNumberError = '';
  bool _phoneNumberShowError = false;
  final TextEditingController _phoneNumberController = TextEditingController();

  String _direccion = '';
  Position _positionUser = const Position(
      longitude: 0.0,
      latitude: 0.0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0);

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _loadFieldValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFFFCC),
        appBar: AppBar(
          title: Text(_user.id.isEmpty ? 'Nuevo Usuario' : _user.fullName),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  _showPhoto(),
                  _showFirstName(),
                  _showLastName(),
                  _showDocument(),
                  _showAddress1(),
                  _showAddress2(),
                  _showAddress3(),
                  _showEmail(),
                  _showPhoneNumber(),
                  _showButtons(),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            _showLoader
                ? const LoaderComponent(
                    text: 'Por favor espere...',
                  )
                : Container(),
          ],
        ));
  }

  Widget _showPhoto() {
    return Stack(children: <Widget>[
      Container(
        margin: const EdgeInsets.only(top: 10),
        child: _user.id.isEmpty && !_photoChanged
            ? const Image(
                image: AssetImage('assets/nouser.png'),
                width: 160,
                height: 160,
                fit: BoxFit.cover)
            : ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: _photoChanged
                    ? Image.file(File(_image.path),
                        width: 160, height: 160, fit: BoxFit.cover)
                    : CachedNetworkImage(
                        imageUrl: _user.imageFullPath,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                        height: 160,
                        width: 160,
                        placeholder: (context, url) => const Image(
                          image: AssetImage('assets/logo.png'),
                          fit: BoxFit.cover,
                          height: 160,
                          width: 160,
                        ),
                      ),
              ),
      ),
      Positioned(
          bottom: 0,
          left: 100,
          child: InkWell(
            onTap: () => _takePicture(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                color: Colors.green[50],
                height: 60,
                width: 60,
                child: const Icon(
                  Icons.photo_camera,
                  size: 40,
                  color: Colors.black,
                ),
              ),
            ),
          )),
      Positioned(
          bottom: 0,
          left: 0,
          child: InkWell(
            onTap: () => _selectPicture(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                color: Colors.green[50],
                height: 60,
                width: 60,
                child: const Icon(
                  Icons.image,
                  size: 40,
                  color: Colors.black,
                ),
              ),
            ),
          )),
    ]);
  }

  Widget _showFirstName() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _firstNameController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Ingresa nombres...',
            labelText: 'Nombres',
            errorText: _firstNameShowError ? _firstNameError : null,
            suffixIcon: const Icon(Icons.person),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _firstName = value;
        },
      ),
    );
  }

  Widget _showLastName() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _lastNameController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Ingresa apellido...',
            labelText: 'Apellido',
            errorText: _lastNameShowError ? _lastNameError : null,
            suffixIcon: const Icon(Icons.person),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _lastName = value;
        },
      ),
    );
  }

  Widget _showDocument() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _documentController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            enabled: false,
            hintText: 'Ingresa documento...',
            labelText: 'Documento',
            errorText: _documentShowError ? _documentError : null,
            suffixIcon: const Icon(Icons.assignment_ind),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _document = value;
        },
      ),
    );
  }

  Widget _showAddress1() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _address1Controller,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Ingresa dirección...',
                  labelText: 'Dirección 1',
                  errorText: _address1ShowError ? _address1Error : null,
                  suffixIcon: const Icon(Icons.home),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              onChanged: (value) {
                _address1 = value;
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () {
                _option = 1;
                _address();
              },
              color: Colors.red,
              icon: const Icon(Icons.location_on, size: 40)),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget _showAddress2() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _address2Controller,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Ingresa dirección...',
                  labelText: 'Dirección 2',
                  errorText: _address2ShowError ? _address2Error : null,
                  suffixIcon: const Icon(Icons.home),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              onChanged: (value) {
                _address2 = value;
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () {
                _option = 2;
                _address();
              },
              color: Colors.red,
              icon: const Icon(Icons.location_on, size: 40)),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget _showAddress3() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _address3Controller,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Ingresa dirección...',
                  labelText: 'Dirección 3',
                  errorText: _address3ShowError ? _address3Error : null,
                  suffixIcon: const Icon(Icons.home),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              onChanged: (value) {
                _address3 = value;
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () {
                _option = 3;
                _address();
              },
              color: Colors.red,
              icon: const Icon(Icons.location_on, size: 40)),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget _showEmail() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        enabled: _user.id.isEmpty,
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            enabled: false,
            hintText: 'Ingresa Email...',
            labelText: 'Email',
            errorText: _emailShowError ? _emailError : null,
            suffixIcon: const Icon(Icons.email),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

  Widget _showPhoneNumber() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _phoneNumberController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Ingresa Teléfono...',
            labelText: 'Teléfono',
            errorText: _phoneNumberShowError ? _phoneNumberError : null,
            suffixIcon: const Icon(Icons.phone),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _phoneNumber = value;
        },
      ),
    );
  }

  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save),
                  SizedBox(
                    width: 15,
                  ),
                  Text('Guardar'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF120E43),
                minimumSize: const Size(100, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _save(),
            ),
          ),
          _user.id.isEmpty
              ? Container()
              : const SizedBox(
                  width: 20,
                ),
          _user.id.isEmpty
              ? Container()
              : widget.myProfile
                  ? Expanded(
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.lock),
                            SizedBox(
                              width: 15,
                            ),
                            Text('Contraseña'),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB4161B),
                          minimumSize: const Size(100, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () => _changePassword(),
                      ),
                    )
                  : Expanded(
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.delete),
                            SizedBox(
                              width: 15,
                            ),
                            Text('Borrar'),
                          ],
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                            return const Color(0xFFB4161B);
                          }),
                        ),
                        onPressed: () => _confirmDelete(),
                      ),
                    ),
        ],
      ),
    );
  }

  void _save() {
    if (!validateFields()) {
      return;
    }
    _user.id.isEmpty ? _addRecord() : _saveRecord();
  }

  bool validateFields() {
    bool isValid = true;

    if (_firstName.isEmpty) {
      isValid = false;
      _firstNameShowError = true;
      _firstNameError = 'Debes ingresar un nombre';
    } else {
      _firstNameShowError = false;
    }

    if (_lastName.isEmpty) {
      isValid = false;
      _lastNameShowError = true;
      _lastNameError = 'Debes ingresar un apellido';
    } else {
      _lastNameShowError = false;
    }

    if (_phoneNumber.isEmpty) {
      isValid = false;
      _phoneNumberShowError = true;
      _phoneNumberError = 'Debes ingresar un teléfono';
    } else {
      _phoneNumberShowError = false;
    }

    setState(() {});

    return isValid;
  }

  _addRecord() async {
    setState(() {
      _showLoader = true;
    });

    String base64image = '';
    if (_photoChanged) {
      List<int> imageBytes = await _image.readAsBytes();
      base64image = base64Encode(imageBytes);
    }

    Map<String, dynamic> request = {
      'firstName': _firstName,
      'lastName': _lastName,
      'document': _document,
      'address1': _address1,
      'address2': _address2,
      'address3': _address3,
      'email': _email,
      'userName': _email,
      'phoneNumber': _phoneNumber,
      'image': base64image,
    };

    Response response =
        await ApiHelper.post('/api/Users/', request, widget.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    Navigator.pop(context, 'yes');
  }

  _saveRecord() async {
    setState(() {
      _showLoader = true;
    });

    String base64image = '';
    if (_photoChanged) {
      List<int> imageBytes = await _image.readAsBytes();
      base64image = base64Encode(imageBytes);
    }

    Map<String, dynamic> request = {
      'id': widget.user.id,
      'modulo': _user.modulo,
      'firstName': _firstName,
      'lastName': _lastName,
      'document': _document,
      'address1': _user.address1,
      'latitude1': _user.latitude1,
      'longitude1': _user.longitude1,
      'address2': _user.address2,
      'latitude2': _user.latitude2,
      'longitude2': _user.longitude2,
      'address3': _user.address3,
      'latitude3': _user.latitude3,
      'longitude3': _user.longitude3,
      'email': _email,
      'userName': _email,
      'phoneNumber': _phoneNumber,
      'image': base64image,
      'street1': _user.street1,
      'administrativeArea1': _user.administrativeArea1,
      'country1': _user.country1,
      'isoCountryCode1': _user.isoCountryCode1,
      'locality1': _user.locality1,
      'subAdministrativeArea1': _user.subAdministrativeArea1,
      'subLocality1': _user.subLocality1,
      'street2': _user.street2,
      'administrativeArea2': _user.administrativeArea2,
      'country2': _user.country2,
      'isoCountryCode2': _user.isoCountryCode2,
      'locality2': _user.locality2,
      'subAdministrativeArea2': _user.subAdministrativeArea2,
      'subLocality2': _user.subLocality2,
      'street3': _user.street3,
      'administrativeArea3': _user.administrativeArea3,
      'country3': _user.country3,
      'isoCountryCode3': _user.isoCountryCode3,
      'locality3': _user.locality3,
      'subAdministrativeArea3': _user.subAdministrativeArea3,
      'subLocality3': _user.subLocality3,
    };

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estés conectado a Internet',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response =
        await ApiHelper.put('/api/Users/', _user.id, request, widget.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    Navigator.pop(context, 'yes');
  }

  void _confirmDelete() async {
    var response = await showAlertDialog(
        context: context,
        title: 'Confirmación',
        message: '¿Estás seguro de querer borrar el registro?',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: 'no', label: 'No'),
          const AlertDialogAction(key: 'yes', label: 'Sí'),
        ]);
    if (response == 'yes') {
      _deleteRecord();
    }
  }

  void _deleteRecord() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estés conectado a Internet',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response =
        await ApiHelper.delete('/api/Users/', _user.id, widget.token);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    Navigator.pop(context, '');
    Navigator.pop(context, 'yes');
  }

  void _takePicture() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    var firstCamera = cameras.first;
    var response1 = await showAlertDialog(
        context: context,
        title: 'Seleccionar cámara',
        message: '¿Qué cámara desea utilizar?',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: 'no', label: 'Trasera'),
          const AlertDialogAction(key: 'yes', label: 'Delantera'),
          const AlertDialogAction(key: 'cancel', label: 'Cancelar'),
        ]);
    if (response1 == 'yes') {
      firstCamera = cameras.first;
    }
    if (response1 == 'no') {
      firstCamera = cameras.last;
    }

    if (response1 != 'cancel') {
      Response? response = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TakePictureScreen(
                    camera: firstCamera,
                  )));
      if (response != null) {
        setState(() {
          _photoChanged = true;
          _image = response.result;
        });
      }
    }
  }

  void _selectPicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _photoChanged = true;
        _image = image;
      });
    }
  }

  void _loadFieldValues() {
    _firstName = _user.firstName;
    _firstNameController.text = _firstName;

    _lastName = _user.lastName;
    _lastNameController.text = _lastName;

    _document = _user.document;
    _documentController.text = _document;

    _address1 = _user.address1;
    _address2 = _user.address2;
    _address3 = _user.address3;
    _address1Controller.text = _address1.toString();
    _address2Controller.text = _address2.toString();
    _address3Controller.text = _address3.toString();

    _email = _user.email;
    _emailController.text = _email;

    _phoneNumber = _user.phoneNumber;
    _phoneNumberController.text = _phoneNumber;
  }

  void _changePassword() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangePasswordScreen(
                  token: widget.token,
                )));
  }

  void _address() async {
    await _getPosition();

    if (_habilitaPosicion) {
      User? userModified = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DireccionScreen(
                  token: widget.token,
                  user: _user,
                  option: _option,
                  positionUser: _positionUser,
                  direccionUser: _direccion)));

      if (userModified != null) {
        setState(() {
          _user.address1 = userModified.address1;
          _user.address2 = userModified.address2;
          _user.address3 = userModified.address3;
          _user.latitude1 = userModified.latitude1;
          _user.longitude1 = userModified.longitude1;
          _user.latitude2 = userModified.latitude2;
          _user.longitude2 = userModified.longitude2;
          _user.latitude3 = userModified.latitude3;
          _user.longitude3 = userModified.longitude3;
          _user.street1 = userModified.street1;
          _user.street2 = userModified.street2;
          _user.street3 = userModified.street3;
          _user.country1 = userModified.country1;
          _user.country2 = userModified.country2;
          _user.country3 = userModified.country3;
          _user.isoCountryCode1 = userModified.isoCountryCode1;
          _user.isoCountryCode2 = userModified.isoCountryCode2;
          _user.isoCountryCode3 = userModified.isoCountryCode3;
          _user.administrativeArea1 = userModified.administrativeArea1;
          _user.administrativeArea2 = userModified.administrativeArea2;
          _user.administrativeArea3 = userModified.administrativeArea3;
          _user.locality1 = userModified.locality1;
          _user.locality2 = userModified.locality2;
          _user.locality3 = userModified.locality3;
          _user.subAdministrativeArea1 = userModified.subAdministrativeArea1;
          _user.subAdministrativeArea2 = userModified.subAdministrativeArea2;
          _user.subAdministrativeArea3 = userModified.subAdministrativeArea3;
          _user.subLocality1 = userModified.subLocality1;
          _user.subLocality2 = userModified.subLocality2;
          _user.subLocality3 = userModified.subLocality3;
          _address1 = _user.address1;
          _address2 = _user.address2;
          _address3 = _user.address3;
          _address1Controller.text = _address1!;
          _address2Controller.text = _address2!;
          _address3Controller.text = _address3!;
        });
      }
    }
  }

  Future _getPosition() async {
    LocationPermission permission;
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();

    // if (!serviceEnabled == false) {
    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //         return AlertDialog(
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(10),
    //           ),
    //           title: Text('Aviso'),
    //           content:
    //               Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
    //             Text('El permiso de localización está deshabilitado.'),
    //             SizedBox(
    //               height: 10,
    //             ),
    //           ]),
    //           actions: <Widget>[
    //             TextButton(
    //                 onPressed: () => Navigator.of(context).pop(),
    //                 child: Text('Ok')),
    //           ],
    //         );
    //       });
    //   return;
    // }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: const Text('Aviso'),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Text('El permiso de localización está negado.'),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Ok')),
                ],
              );
            });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text('Aviso'),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Text(
                        'El permiso de localización está negado permanentemente. No se puede requerir este permiso.'),
                    SizedBox(
                      height: 10,
                    ),
                  ]),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Ok')),
              ],
            );
          });
      return;
    }

    _habilitaPosicion = true;
    _positionUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks = await placemarkFromCoordinates(
        _positionUser.latitude, _positionUser.longitude);
    _direccion = placemarks[0].street.toString() +
        " - " +
        placemarks[0].locality.toString();
  }
}
