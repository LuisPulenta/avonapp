import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:avon_app/screens/direccion_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avon_app/helpers/api_helper.dart';
import 'package:avon_app/models/response.dart';
import 'package:avon_app/models/token.dart';
import 'package:avon_app/models/user.dart';
import 'package:avon_app/screens/login_screen.dart';
import 'package:avon_app/screens/user_screen.dart';

class HomeScreen extends StatefulWidget {
  final Token token;

  HomeScreen({required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showLoader = false;
  late User _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = widget.token.user;
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfcbb04),
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
                children: [
                  Icon(Icons.location_on),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Editar Perfil'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFfc6c0c),
                minimumSize: Size(100, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _editUser(),
            ),
            ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Salir'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFe4540c),
                minimumSize: Size(100, 50),
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

  Widget _getBody() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Image(
              image: AssetImage('assets/logo.png'),
              width: 250,
            ),
            SizedBox(
              height: 40,
            ),
            ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: _user.imageFullPath,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                  height: 200,
                  width: 200,
                  placeholder: (context, url) => Image(
                    image: AssetImage('assets/loading.gif'),
                    fit: BoxFit.cover,
                    height: 200,
                    width: 200,
                  ),
                )),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                'Bienvenido/a ${_user.fullName}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', false);
    await prefs.setString('userBody', '');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Future<Null> _getUser() async {
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
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = await ApiHelper.getUser(widget.token, _user.id);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    setState(() {
      _user = response.result;
    });
  }

  _editUser() async {
    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserScreen(
                  token: widget.token,
                  user: _user,
                  myProfile: true,
                )));
    if (result == 'yes') {
      _getUser();
    }
  }
}
