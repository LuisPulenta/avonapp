import 'dart:convert';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:avon_app/helpers/constants.dart';
import 'package:avon_app/screens/take_picture_screen.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:avon_app/components/loader_component.dart';
import 'package:avon_app/helpers/api_helper.dart';
import 'package:avon_app/models/response.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({Key? key}) : super(key: key);

  @override
  _RegisterUserScreenState createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  bool _showLoader = false;
  bool _photoChanged = false;
  late XFile _image;

  String _firstName = '';
  String _firstNameError = '';
  bool _firstNameShowError = false;
  final TextEditingController _firstNameController = TextEditingController();

  String _lastName = '';
  String _lastNameError = '';
  bool _lastNameShowError = false;
  final TextEditingController _lastNameController = TextEditingController();

  String _document = '';
  String _documentError = '';
  bool _documentShowError = false;
  final TextEditingController _documentController = TextEditingController();

  final String _address1 = '';

  final String _address2 = '';

  final String _address3 = '';

  String _email = '';
  String _emailError = '';
  bool _emailShowError = false;
  final TextEditingController _emailController = TextEditingController();

  String _phoneNumber = '';
  String _phoneNumberError = '';
  bool _phoneNumberShowError = false;
  final TextEditingController _phoneNumberController = TextEditingController();

  bool _passwordShow = false;

  String _password = '';
  String _passwordError = '';
  bool _passwordShowError = false;

  String _confirm = '';
  String _confirmError = '';
  bool _confirmShowError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nuevo Usuario'),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _showPhoto(),
                  _showFirstName(),
                  _showLastName(),
                  _showDocument(),
                  // _showAddress1(),
                  // _showAddress2(),
                  // _showAddress3(),
                  _showEmail(),
                  _showPhoneNumber(),
                  _showPassword(),
                  _showConfirm(),
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
    return InkWell(
      child: Stack(children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: !_photoChanged
              ? const Image(
                  image: AssetImage('assets/noimage.png'),
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: Image.file(
                    File(_image.path),
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover,
                  )),
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
                    color: Colors.blue,
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
                    color: Colors.blue,
                  ),
                ),
              ),
            )),
      ]),
    );
  }

  Widget _showFirstName() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _firstNameController,
        decoration: InputDecoration(
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
            hintText: 'Ingresa nombres...',
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

  Widget _showEmail() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
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

  Widget _showPassword() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
          hintText: 'Ingresa una contraseña...',
          labelText: 'Contraseña',
          errorText: _passwordShowError ? _passwordError : null,
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: _passwordShow
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordShow = !_passwordShow;
              });
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _password = value;
        },
      ),
    );
  }

  Widget _showConfirm() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
          hintText: 'Ingresa la confirmación de contraseña...',
          labelText: 'Confirmación de contraseña',
          errorText: _confirmShowError ? _confirmError : null,
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: _passwordShow
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordShow = !_passwordShow;
              });
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _confirm = value;
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
          _showRegisterButton(),
        ],
      ),
    );
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

  Widget _showRegisterButton() {
    return Expanded(
      child: ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.person_add),
            SizedBox(
              width: 15,
            ),
            Text('Registrar usuario'),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF120E43),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: () => _register(),
      ),
    );
  }

  void _register() async {
    if (!validateFields()) {
      return;
    }
    _addRecord();
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

    if (_document.isEmpty) {
      isValid = false;
      _documentShowError = true;
      _documentError = 'Debes ingresar un documento';
    } else {
      _documentShowError = false;
    }

    if (_document.length < 6) {
      isValid = false;
      _documentShowError = true;
      _documentError = 'El documento debe tener al menos 6 dìgitos';
    }

    if (_document.length > 9) {
      isValid = false;
      _documentShowError = true;
      _documentError = 'El documento no puede tener más de 9 dìgitos';
    }

    if (_email.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar tu Email';
    } else if (!EmailValidator.validate(_email)) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un Email válido';
    } else {
      _emailShowError = false;
    }

    if (_phoneNumber.isEmpty) {
      isValid = false;
      _phoneNumberShowError = true;
      _phoneNumberError = 'Debes ingresar un teléfono';
    } else {
      _phoneNumberShowError = false;
    }

    if (_password.isEmpty) {
      isValid = false;
      _passwordShowError = true;
      _passwordError = 'Debes ingresar una contraseña';
    } else {
      if (_password.length < 6) {
        isValid = false;
        _passwordShowError = true;
        _passwordError =
            'Debes ingresar una contraseña de al menos 6 caracteres';
      } else {
        _passwordShowError = false;
      }
    }

    if (_confirm.isEmpty) {
      isValid = false;
      _confirmShowError = true;
      _confirmError = 'Debes ingresar una confirmación de contraseña';
    } else {
      if (_confirm.length < 6) {
        isValid = false;
        _confirmShowError = true;
        _confirmError =
            'Debes ingresar una Confirmación de Contraseña de al menos 6 caracteres';
      } else {
        _confirmShowError = false;
      }
    }

    if ((_password.length >= 6) &&
        (_confirm.length >= 6) &&
        (_confirm != _password)) {
      isValid = false;
      _passwordShowError = true;
      _confirmShowError = true;
      _passwordError = 'La contraseña y la confirmación no son iguales';
      _confirmError = 'La contraseña y la confirmación no son iguales';
    }

    setState(() {});

    return isValid;
  }

  void _addRecord() async {
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

    String base64image = '';
    if (_photoChanged) {
      List<int> imageBytes = await _image.readAsBytes();
      base64image = base64Encode(imageBytes);
    }

    Map<String, dynamic> request = {
      'modulo': Constants.modulo,
      'firstName': pLMayusc(_firstName),
      'lastName': pLMayusc(_lastName),
      'document': _document,
      'address1': _address1,
      'address2': _address2,
      'address3': _address3,
      'email': _email,
      'userName': _email,
      'phoneNumber': _phoneNumber,
      'password': _password,
      'image': base64image,
    };

    Response response = await ApiHelper.postNoToken('/api/Account/', request);

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

    await showAlertDialog(
        context: context,
        title: 'Confirmación',
        message:
            'Se ha enviado un correo con las instrucciones para activar el usuario. Por favor actívelo para poder ingresar a la Aplicación. Luego ingrese a la Aplicación e ingrese al menos una Dirección para completar el Proceso de Registro.',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: null, label: 'Aceptar'),
        ]);

    Navigator.pop(context, 'yes');
  }

  String pLMayusc(String string) {
    String name = '';
    bool isSpace = false;
    String letter = '';
    for (int i = 0; i < string.length; i++) {
      if (isSpace || i == 0) {
        letter = string[i].toUpperCase();
        isSpace = false;
      } else {
        letter = string[i].toLowerCase();
        isSpace = false;
      }

      if (string[i] == " ") {
        isSpace = true;
      } else {
        isSpace = false;
      }

      name = name + letter;
    }
    return name;
  }
}
