import 'dart:convert';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:avon_app/components/loader_component.dart';
import 'package:avon_app/helpers/api_helper.dart';
import 'package:avon_app/helpers/constants.dart';
import 'package:avon_app/models/models.dart';
import 'package:avon_app/screens/screens.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//------------------------------------------------------------------
//------------------------- Variables ------------------------------
//------------------------------------------------------------------
  String _email = '';
  String _password = '';
  // String _email = '12345678';
  // String _password = '123456';

  String _emailError = '';
  bool _emailShowError = false;

  String _passwordError = '';
  bool _passwordShowError = false;

  bool _rememberme = true;

  bool _passwordShow = false;

  bool _showLoader = false;

  String assetPDFPath = "";

  Modulo _modulo = Modulo(
      idModulo: 0,
      nombre: '',
      nroVersion: '',
      link: '',
      fechaRelease: '',
      actualizOblig: 0);

//------------------------------------------------------------------
//------------------------- initState ------------------------------
//------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    getFileFromAsset("assets/instructivo.pdf").then((f) {
      setState(() {
        assetPDFPath = f.path;
        print(assetPDFPath);
      });
    });
    _getModulo();
  }

//------------------------------------------------------------------
//------------------------- Pantalla -------------------------------
//------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff940cbc),
      body: Stack(
        children: <Widget>[
          Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff000000),
                    Color(0xff940cbc),
                  ],
                ),
              ),
              child: Image.asset(
                "assets/logo2.png",
                height: 200,
              )),
          Transform.translate(
            offset: const Offset(0, 160),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Constants.version,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -60),
            child: Center(
              child: SingleChildScrollView(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 15,
                  margin: const EdgeInsets.only(
                      left: 10, right: 10, top: 260, bottom: 20),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _showEmail(),
                        _showPassword(),
                        const SizedBox(
                          height: 10,
                        ),
                        _showInstructivo(),
                        _showRememberme(),
                        _showButtons(),

                        //------------------------------------------------------------
                        //------------------------------------------------------------
                        //------------------------------------------------------------

                        _modulo.nroVersion != '' &&
                                _modulo.nroVersion != Constants.version
                            ? const SizedBox(
                                height: 20,
                              )
                            : Container(),
                        _modulo.nroVersion != '' &&
                                _modulo.nroVersion != Constants.version
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Expanded(
                                    child: TextButton(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text('Nueva versión disponible',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 18,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        minimumSize:
                                            const Size(double.infinity, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () => _launchURL2(),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                SizedBox(
                  height: 40,
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
      ),
    );
  }

//----------------------- _showEmail --------------------------
  Widget _showEmail() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Cuenta...',
            labelText: 'Cuenta',
            errorText: _emailShowError ? _emailError : null,
            prefixIcon: const Icon(Icons.person),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

//----------------------- _showPassword --------------------------
  Widget _showPassword() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Contraseña...',
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
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _password = value;
        },
      ),
    );
  }

//---------------------------- _showInstructivo ---------------------------
  Widget _showInstructivo() {
    return InkWell(
      onTap: () => _goInstructivo(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: const Text(
          'Ver Instructivo',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

//---------------------------- _goInstructivo ---------------------------
  void _goInstructivo() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PdfViewPage(
                  path: assetPDFPath,
                )));
  }

//----------------------- _showRememberme --------------------------
  _showRememberme() {
    return CheckboxListTile(
      title: const Text('Recordarme:'),
      value: _rememberme,
      onChanged: (value) {
        setState(() {
          _rememberme = value!;
        });
      },
    );
  }

//----------------------- _showButtons --------------------------
  Widget _showButtons() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.login),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Login'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7e04cc),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _login(),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }

//--------------------- _login -----------------------------
  void _login() async {
    setState(() {
      _passwordShow = false;
    });

    if (!validateFields()) {
      return;
    }

    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      Response response2 = await ApiHelper.getModulo("4");
      _modulo = response2.result;
    }

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

    Map<String, dynamic> request2 = {
      'email': _email,
    };

    var url2 = Uri.parse('${Constants.apiUrl}/Api/Account/GetUserByEmail');
    var response2 = await http.post(
      url2,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(request2),
    );

    if (response2.statusCode >= 400) {
      setState(() {
        _passwordShowError = true;
        _passwordError = 'Cuenta o contraseña incorrectos';
      });
    }

    setState(() {
      _showLoader = false;
    });

    var body2 = response2.body;
    var decodedJson2 = jsonDecode(body2);
    var cliente = Cliente.fromJson(decodedJson2);

    if (cliente.password.toLowerCase() != _password.toLowerCase()) {
      setState(() {
        _passwordShowError = true;
        _passwordError = 'Contraseña incorrecta';
      });

      setState(() {
        _showLoader = false;
      });

      return;
    }

    setState(() {
      _showLoader = false;
    });

    if (_rememberme) {
      _storeUser(body2);
    }

    if (DateTime.parse(cliente.fechaFin).isBefore(DateTime.now())) {
      await showAlertDialog(
          context: context,
          title: 'Mensaje',
          message: "Su Cuenta ha vencido.",
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(
                  cliente: cliente,
                )));
  }

//----------------------- validateFields --------------------------
  bool validateFields() {
    bool isValid = true;

    if (_email.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar tu Cuenta';
    } else {
      _emailShowError = false;
    }

    if (_password.isEmpty) {
      isValid = false;
      _passwordShowError = true;
      _passwordError = 'Debes ingresar tu Contraseña';
    } else if (_password.length < 6) {
      isValid = false;
      _passwordShowError = true;
      _passwordError = 'La Contraseña debe tener al menos 6 caracteres';
    } else {
      _passwordShowError = false;
    }

    setState(() {});

    return isValid;
  }

//----------------------- _storeUser --------------------------
  void _storeUser(String body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', true);
    await prefs.setString('userBody', body);
    await prefs.setString('date', DateTime.now().toString());
  }

//---------------------------- getFileFromAsset ---------------------------
  Future<File> getFileFromAsset(String asset) async {
    try {
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/mi_archivo.pdf");
      File assetFile = await file.writeAsBytes(bytes);
      return assetFile;
    } catch (e) {
      throw Exception("Error al abrir el archivo");
    }
  }

  //---------------------------- _launchURL2 ------------------------------
  void _launchURL2() async {
    if (!await launch(
        'https://play.google.com/store/apps/details?id=com.luisnu.avon_app2&pli=1')) {
      throw 'No se puede conectar a la tienda';
    }
  }

//----------------------------------------------------------
//--------------------- _getModulo -------------------------
//----------------------------------------------------------

  Future<void> _getModulo() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      Response response2 = await ApiHelper.getModulo("4");
      _modulo = response2.result;
      var a = 1;
      setState(() {});
    }
  }
}

//-----------------------------------------------------------------------
//---------------------------- PdfViewPage ------------------------------
//-----------------------------------------------------------------------
class PdfViewPage extends StatefulWidget {
  final String path;

  const PdfViewPage({required this.path});
  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

//-----------------------------------------------------------------------
//---------------------------- _PdfViewPageState ------------------------
//-----------------------------------------------------------------------
class _PdfViewPageState extends State<PdfViewPage> {
  bool _estaListoPDF = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Instructivo"),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            swipeHorizontal: true,
            onError: (e) {},
            onRender: (_pages) {
              setState(() {
                _estaListoPDF = true;
              });
            },
            onViewCreated: (PDFViewController vc) {},
            onPageError: (page, e) {},
          ),
          !_estaListoPDF
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const Offstage()
        ],
      ),
    );
  }
}
