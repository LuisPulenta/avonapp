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
import 'package:avon_app/models/models.dart';
import 'package:avon_app/screens/screens.dart';

class ClienteScreen extends StatefulWidget {
  final Cliente cliente;
  final bool myProfile;

  const ClienteScreen(
      {Key? key, required this.cliente, required this.myProfile})
      : super(key: key);

  @override
  _ClienteScreenState createState() => _ClienteScreenState();
}

//----------------------- Variables --------------------------
class _ClienteScreenState extends State<ClienteScreen> {
  bool _showLoader = false;
  bool _photoChanged = false;
  bool _habilitaPosicion = false;
  int _option = 0;
  late XFile _image;
  late Cliente _cliente;

  int _pantalla = 0;

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
  String _address1Error = '';
  bool _address1ShowError = false;
  final TextEditingController _address1Controller = TextEditingController();

  String? _address2 = '';
  final String _address2Error = '';
  final bool _address2ShowError = false;
  final TextEditingController _address2Controller = TextEditingController();

  String? _address3 = '';
  final String _address3Error = '';
  final bool _address3ShowError = false;
  final TextEditingController _address3Controller = TextEditingController();

  final String _email = '';

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

//----------------------- initState --------------------------
  @override
  void initState() {
    super.initState();
    _cliente = widget.cliente;
    _loadFieldValues();
  }

//----------------------- Pantalla --------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFFFCC),
        appBar: AppBar(
          title:
              Text(_cliente.id.isEmpty ? 'Nuevo Usuario' : _cliente.firstName),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  //_showPhoto(),
                  //_showFirstName(),
                  //_showLastName(),
                  _showAvonCount(),
                  const Divider(height: 16, color: Colors.black),
                  const Text(
                      'Toque el ICONO ROJO para cargar la Geolocalización'),
                  _showAddress1(),
                  _address1 != null
                      ? Text(
                          'Puede corregir el domicilio generado desde el Mapa')
                      : Container(),
                  //_showAddress2(),
                  const Divider(height: 16, color: Colors.black),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: const Text(
                        'Referencias adicionales que puedan servir para la localización (Ejemplo: Casa con rejas verdes)'),
                  ),
                  _showAddress3(),
                  //_showEmail(),
                  const Divider(height: 16, color: Colors.black),
                  _showPhoneNumber(),
                  const Divider(height: 16, color: Colors.black),
                  const SizedBox(
                    height: 20,
                  ),
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

//----------------------- _showPhoto --------------------------
  Widget _showPhoto() {
    return Stack(children: <Widget>[
      Container(
        margin: const EdgeInsets.only(top: 10),
        child: _cliente.id.isEmpty && !_photoChanged
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
                        imageUrl: _cliente.imageFullPath,
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

//----------------------- _showFirstName --------------------------
  Widget _showFirstName() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _firstNameController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            enabled: false,
            hintText: 'Ingresa Nombre y Apellido...',
            labelText: 'Nombre y Apellido',
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

//----------------------- _showLastName --------------------------
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

//----------------------- _showDocument --------------------------
  Widget _showAvonCount() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _documentController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            enabled: false,
            hintText: 'Ingresa Cuenta de Avon...',
            labelText: 'Cuenta de Avon',
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

//----------------------- _showAddress1 --------------------------
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
                  //labelText: 'Dirección 1',
                  labelText: 'Dirección',
                  errorText: _address1ShowError ? _address1Error : null,
                  suffixIcon: const Icon(Icons.home),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              onChanged: (value) {
                _address1 = value;
                _cliente.address1 = _address1 != null ? _address1! : '';
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: !_showLoader
                  ? () {
                      _option = 1;
                      _address();
                    }
                  : null,
              color: Colors.red,
              icon: const Icon(Icons.location_on, size: 40)),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

//----------------------- _showAddress2 --------------------------
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

//----------------------- _showAddress3 --------------------------

  Widget _showAddress3() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _address3Controller,
        maxLines: 3,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText:
                'Ingresa indicaciones adicionales que puedan servir para ubicar tu domicilio...',
            labelText: 'Referencia del domicilio (opcional)',
            errorText: _address3ShowError ? _address3Error : null,
            suffixIcon: const Icon(Icons.list),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _address3 = value;
        },
      ),
    );
  }

//----------------------- _showPhoneNumber --------------------------
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

//----------------------- _showButtons --------------------------
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
              onPressed: () {
                _pantalla = 1;
                _save();
              },
            ),
          ),
          // _cliente.id.isEmpty
          //     ? Container()
          //     : const SizedBox(
          //         width: 20,
          //       ),
          // _cliente.id.isEmpty
          //     ? Container()
          //     : widget.myProfile
          //         ? Expanded(
          //             child: ElevatedButton(
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: const [
          //                   Icon(Icons.lock),
          //                   SizedBox(
          //                     width: 15,
          //                   ),
          //                   Text('Contraseña'),
          //                 ],
          //               ),
          //               style: ElevatedButton.styleFrom(
          //                 backgroundColor: const Color(0xFFB4161B),
          //                 minimumSize: const Size(100, 50),
          //                 shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(5),
          //                 ),
          //               ),
          //               onPressed: () => _changePassword(),
          //             ),
          //           )
          //         : Expanded(
          //             child: ElevatedButton(
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: const [
          //                   Icon(Icons.delete),
          //                   SizedBox(
          //                     width: 15,
          //                   ),
          //                   Text('Borrar'),
          //                 ],
          //               ),
          //               style: ButtonStyle(
          //                 backgroundColor:
          //                     MaterialStateProperty.resolveWith<Color>(
          //                         (Set<MaterialState> states) {
          //                   return const Color(0xFFB4161B);
          //                 }),
          //               ),
          //               onPressed: () => _confirmDelete(),
          //             ),
          //           ),
        ],
      ),
    );
  }

//----------------------- _save --------------------------
  void _save() {
    if (!validateFields()) {
      return;
    }
    _cliente.id.isEmpty ? _addRecord() : _saveRecord();
  }

//----------------------- validateFields --------------------------
  bool validateFields() {
    bool isValid = true;

    if (_firstName.isEmpty) {
      isValid = false;
      _firstNameShowError = true;
      _firstNameError = 'Debes ingresar un nombre';
    } else {
      _firstNameShowError = false;
    }

    // if (_lastName.isEmpty) {
    //   isValid = false;
    //   _lastNameShowError = true;
    //   _lastNameError = 'Debes ingresar un apellido';
    // } else {
    //   _lastNameShowError = false;
    // }

    if (_address1!.isEmpty) {
      isValid = false;
      _address1ShowError = true;
      _address1Error = 'Debes ingresar una dirección';
    } else {
      _address1ShowError = false;
    }

    if (_cliente.latitude1 == 0 || _cliente.longitude1 == 0) {
      isValid = false;
      _address1ShowError = true;
      _address1Error = 'Debes ingresar una dirección geolocalizada';
      showAlertDialog(
          context: context,
          title: 'Atención',
          message:
              'Primero debe ingresar una dirección geolocalizada, y luego corrige si desea',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
    } else {
      _address1ShowError = false;
    }

    // if (_phoneNumber.isEmpty) {
    //   isValid = false;
    //   _phoneNumberShowError = true;
    //   _phoneNumberError = 'Debes ingresar un teléfono';
    // }

    if (_phoneNumber.isNotEmpty && int.tryParse(_phoneNumber) == null) {
      isValid = false;
      _phoneNumberShowError = true;
      _phoneNumberError = 'El teléfono debe contener sólo números';
    }

    // if (!((_phoneNumber.isEmpty) || (int.tryParse(_phoneNumber) == null))) {
    //   {
    //     _phoneNumberShowError = false;
    //   }

    //   setState(() {});

    //   return isValid;
    // }

    setState(() {});

    return isValid;
  }

//----------------------- _addRecord --------------------------
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

    Response response = await ApiHelper.post('/api/Users/', request);

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

//----------------------- _saveRecord --------------------------
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
      'id': widget.cliente.id,
      'modulo': _cliente.modulo,
      'avonAccount': _cliente.avonAccount,
      'firstName': _firstName,
      'lastName': _firstName,
      'document': _document,
      'address1': _cliente.address1,
      'latitude1': _cliente.latitude1,
      'longitude1': _cliente.longitude1,
      'address2': _cliente.address2,
      'latitude2': _cliente.latitude2,
      'longitude2': _cliente.longitude2,
      'address3': _address3,
      'latitude3': _cliente.latitude3,
      'longitude3': _cliente.longitude3,
      'email': _email,
      'userName': _email,
      'phoneNumber': _phoneNumber == "" ? "1" : _phoneNumber,
      'image': base64image,
      'street1': _cliente.street1,
      'administrativeArea1': _cliente.administrativeArea1,
      'country1': _cliente.country1,
      'isoCountryCode1': _cliente.isoCountryCode1,
      'locality1': _cliente.locality1,
      'subAdministrativeArea1': _cliente.subAdministrativeArea1,
      'subLocality1': _cliente.subLocality1,
      'street2': _cliente.street2,
      'administrativeArea2': _cliente.administrativeArea2,
      'country2': _cliente.country2,
      'isoCountryCode2': _cliente.isoCountryCode2,
      'locality2': _cliente.locality2,
      'subAdministrativeArea2': _cliente.subAdministrativeArea2,
      'subLocality2': _cliente.subLocality2,
      'street3': _cliente.street3,
      'administrativeArea3': _cliente.administrativeArea3,
      'country3': _cliente.country3,
      'isoCountryCode3': _cliente.isoCountryCode3,
      'locality3': _cliente.locality3,
      'subAdministrativeArea3': _cliente.subAdministrativeArea3,
      'subLocality3': _cliente.subLocality3,
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
        await ApiHelper.put('/api/Users/', _cliente.id, request);

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
    if (_pantalla == 1) {
      //Navigator.pop(context);
      //_showSnackbar();

      await showAlertDialog(
          context: context,
          title: 'Ok!!',
          message: 'Dirección guardada con éxito. Muchas gracias!!!',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);

      //exit(0);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

//----------------------- _confirmDelete --------------------------
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

//----------------------- _deleteRecord --------------------------
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

    Response response = await ApiHelper.delete('/api/Users/', _cliente.id);

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

//----------------------- _takePicture --------------------------
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

//----------------------- _selectPicture --------------------------
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

//----------------------- _loadFieldValues --------------------------
  void _loadFieldValues() {
    _firstName = _cliente.firstName;
    _firstNameController.text = _firstName;

    _lastName = _cliente.lastName;
    _lastNameController.text = _lastName;

    _document = _cliente.avonAccount;
    _documentController.text = _document;

    _address1 = _cliente.address1;
    _address2 = _cliente.address2;
    _address3 = _cliente.address3;
    _address1Controller.text = _address1.toString();
    _address2Controller.text = _address2.toString();
    _address3Controller.text = _address3.toString();

    _phoneNumber = _cliente.phoneNumber;
    _phoneNumberController.text = _phoneNumber;
  }

//----------------------- _changePassword --------------------------
  void _changePassword() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangePasswordScreen(
                  cliente: widget.cliente,
                )));
  }

//----------------------- _address --------------------------
  void _address() async {
    setState(() {
      _showLoader = true;
    });

    await _getPosition();

    if (_habilitaPosicion) {
      setState(() {
        _showLoader = false;
      });
      Cliente? userModified = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DireccionScreen(
                  cliente: _cliente,
                  option: _option,
                  positionUser: _positionUser,
                  direccionUser: _direccion)));

      if (userModified != null) {
        setState(() {
          _cliente.address1 = userModified.address1;
          _cliente.address2 = userModified.address2;
          _cliente.address3 = userModified.address3;
          _cliente.latitude1 = userModified.latitude1;
          _cliente.longitude1 = userModified.longitude1;
          _cliente.latitude2 = userModified.latitude2;
          _cliente.longitude2 = userModified.longitude2;
          _cliente.latitude3 = userModified.latitude3;
          _cliente.longitude3 = userModified.longitude3;
          _cliente.street1 = userModified.street1;
          _cliente.street2 = userModified.street2;
          _cliente.street3 = userModified.street3;
          _cliente.country1 = userModified.country1;
          _cliente.country2 = userModified.country2;
          _cliente.country3 = userModified.country3;
          _cliente.isoCountryCode1 = userModified.isoCountryCode1;
          _cliente.isoCountryCode2 = userModified.isoCountryCode2;
          _cliente.isoCountryCode3 = userModified.isoCountryCode3;
          _cliente.administrativeArea1 = userModified.administrativeArea1;
          _cliente.administrativeArea2 = userModified.administrativeArea2;
          _cliente.administrativeArea3 = userModified.administrativeArea3;
          _cliente.locality1 = userModified.locality1;
          _cliente.locality2 = userModified.locality2;
          _cliente.locality3 = userModified.locality3;
          _cliente.subAdministrativeArea1 = userModified.subAdministrativeArea1;
          _cliente.subAdministrativeArea2 = userModified.subAdministrativeArea2;
          _cliente.subAdministrativeArea3 = userModified.subAdministrativeArea3;
          _cliente.subLocality1 = userModified.subLocality1;
          _cliente.subLocality2 = userModified.subLocality2;
          _cliente.subLocality3 = userModified.subLocality3;
          _address1 = _cliente.address1;
          _address2 = _cliente.address2;
          _address3 = _cliente.address3;
          _address1Controller.text = _address1!;
          _address2Controller.text = _address2!;
          _address3Controller.text = _address3!;
        });
        _pantalla = 2;
        _save();
      }
    }
  }

//----------------------- _getPosition --------------------------
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

  void _showSnackbar() {
    SnackBar snackbar = const SnackBar(
      content: Text("Dirección guardada con éxito. Muchas gracias!!!"),
      backgroundColor: Color.fromARGB(255, 84, 228, 12),
      duration: Duration(seconds: 15),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    //ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
