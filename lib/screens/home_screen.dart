import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:avon_app/models/cliente.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avon_app/helpers/api_helper.dart';
import 'package:avon_app/models/response.dart';
import 'package:avon_app/screens/login_screen.dart';
import 'package:avon_app/screens/cliente_screen.dart';

class HomeScreen extends StatefulWidget {
  final Cliente cliente;
  const HomeScreen({Key? key, required this.cliente}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

//----------------- Variables --------------------
class _HomeScreenState extends State<HomeScreen> {
  late Cliente _cliente;

//----------------- initState --------------------
  @override
  void initState() {
    super.initState();
    _cliente = widget.cliente;
    //_getUser();
  }

//----------------- Pantalla --------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff06292),
      // appBar: AppBar(
      //   title: Text('Natura App'),
      // ),
      body: _getBody(),
      // drawer: _getMenu(),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.location_on),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Editar Perfil'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7e04cc),
                minimumSize: const Size(100, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _editUser(),
            ),
            ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.logout),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Salir'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFc41c9c),
                minimumSize: const Size(100, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _logOut(),
            ),
          ],
        ),
      ],
    );
  }

//----------------- _getBody --------------------
  Widget _getBody() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Image(
              image: AssetImage('assets/logo.png'),
              width: 250,
            ),
            const SizedBox(
              height: 40,
            ),
            ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: _cliente.imageFullPath,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                  height: 200,
                  width: 200,
                  placeholder: (context, url) => const Image(
                    image: AssetImage('assets/loading.gif'),
                    fit: BoxFit.cover,
                    height: 200,
                    width: 200,
                  ),
                )),
            const SizedBox(
              height: 30,
            ),
            const Center(
              child: Text(
                'Bienvenido/a',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                _cliente.fullName,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

//----------------- _logOut --------------------
  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', false);
    await prefs.setString('userBody', '');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

//----------------- _getUser --------------------
  Future<void> _getUser() async {
    setState(() {});

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {});
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estés conectado a Internet',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = await ApiHelper.getUser(_cliente.id);

    setState(() {});

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
    setState(() {
      _cliente = response.result;
    });
  }

//----------------- _editUser --------------------
  _editUser() async {
    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ClienteScreen(
                  cliente: _cliente,
                  myProfile: true,
                )));
    if (result == 'yes') {
      _getUser();
    }
  }
}
