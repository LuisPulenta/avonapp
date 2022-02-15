import 'dart:async';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:avon_app/components/loader_component.dart';
import 'package:avon_app/helpers/api_helper.dart';
import 'package:avon_app/models/response.dart';
import 'package:avon_app/models/token.dart';
import 'package:avon_app/models/user.dart';

class DireccionScreen extends StatefulWidget {
  final Token token;
  final User user;
  final int option;
  final Position positionUser;
  final String direccionUser;

  const DireccionScreen(
      {required this.token,
      required this.user,
      required this.option,
      required this.positionUser,
      required this.direccionUser});

  @override
  _DireccionScreenState createState() => _DireccionScreenState();
}

class _DireccionScreenState extends State<DireccionScreen> {
  String _direccion = '';
  String _direccionError = '';
  bool _direccionShowError = false;
  TextEditingController _direccionController = TextEditingController();
  bool ubicOk = false;
  double latitud = 0;
  double longitud = 0;
  bool _showLoader = false;
  final Set<Marker> _markers = {};
  MapType _defaultMapType = MapType.normal;
  String direccion = '';
  Position position = Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0);
  CameraPosition _initialPosition =
      CameraPosition(target: LatLng(31, 64), zoom: 16.0);
  //static const LatLng _center = const LatLng(-31.4332373, -64.226344);

  LatLng _center = LatLng(0, 0);

  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialPosition = CameraPosition(
        target:
            LatLng(widget.positionUser.latitude, widget.positionUser.longitude),
        zoom: 16.0);
    ubicOk = true;
    _center =
        LatLng(widget.positionUser.latitude, widget.positionUser.longitude);
  }

  Future _getPosition() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    latitud = position.latitude;
    longitud = position.longitude;
    direccion = placemarks[0].street.toString() +
        " - " +
        placemarks[0].locality.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dirección"),
      ),
      body: Stack(
        children: [
          ubicOk == true
              ? Container(
                  child: Stack(children: <Widget>[
                    GoogleMap(
                      myLocationEnabled: false,
                      initialCameraPosition: _initialPosition,
                      onCameraMove: _onCameraMove,
                      markers: _markers,
                      mapType: _defaultMapType,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 80, right: 10),
                      alignment: Alignment.topRight,
                      child: Column(children: <Widget>[
                        FloatingActionButton(
                            child: Icon(Icons.layers),
                            elevation: 5,
                            backgroundColor: Color(0xfff4ab04),
                            onPressed: () {
                              _changeMapType();
                            }),
                      ]),
                    ),
                    Center(
                      child: Icon(
                        Icons.my_location,
                        color: Color(0xFFfc6c0c),
                        size: 50,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: _direccionController,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Dirección...',
                            labelText: 'Dirección',
                            errorText:
                                _direccionShowError ? _direccionError : null,
                            prefixIcon: Icon(Icons.home),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onChanged: (value) {
                          _direccion = value;
                        },
                      ),
                    ),
                  ]),
                )
              : Container(),
          _showLoader
              ? LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Marcar'),
                ],
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return Color(0xFFe4540c);
                }),
              ),
              onPressed: () => _marcar(),
            ),
            ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Guardar'),
                ],
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return Color(0xFFe4540c);
                }),
              ),
              onPressed: () => _guardar(),
            ),
          ],
        ),
      ],
    );
  }

  void _onCameraMove(CameraPosition position) {
    _center = position.target;
  }

  void _marcar() async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(_center.latitude, _center.longitude);
    latitud = _center.latitude;
    longitud = _center.longitude;
    direccion = placemarks[0].street.toString() +
        " - " +
        placemarks[0].locality.toString();
    _direccionController.text = direccion;
    _markers.clear();
    _markers.add(Marker(
// This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId(_center.toString()),
      position: _center,
      infoWindow: InfoWindow(
        title: direccion,
        snippet: '',
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
    var a = placemarks[0];
    setState(() {});
  }

  void _changeMapType() {
    _defaultMapType = _defaultMapType == MapType.normal
        ? MapType.satellite
        : _defaultMapType == MapType.satellite
            ? MapType.hybrid
            : MapType.normal;
    setState(() {});
  }

  _guardar() async {
    if (_markers.length == 0) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: "Debe marcar un lugar",
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    if (latitud == 0 || longitud == 0) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message:
              "La latitud o la longitud del punto marcado están en cero. Intente marcar de nuevo.",
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    setState(() {
      _showLoader = true;
    });

    Map<String, dynamic> request = {
      'id': widget.user.id,
      'modulo': widget.user.modulo,
      'firstName': widget.user.firstName,
      'lastName': widget.user.lastName,
      'document': widget.user.document,
      'address1': widget.option == 1 ? direccion : widget.user.address1,
      'latitude1': widget.option == 1 ? latitud : widget.user.latitude1,
      'longitude1': widget.option == 1 ? longitud : widget.user.longitude1,
      'address2': widget.option == 2 ? direccion : widget.user.address2,
      'latitude2': widget.option == 2 ? latitud : widget.user.latitude2,
      'longitude2': widget.option == 2 ? longitud : widget.user.longitude2,
      'address3': widget.option == 3 ? direccion : widget.user.address3,
      'latitude3': widget.option == 3 ? latitud : widget.user.latitude3,
      'longitude3': widget.option == 3 ? longitud : widget.user.longitude3,
      'email': widget.user.email,
      'userName': widget.user.email,
      'phoneNumber': widget.user.phoneNumber,
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
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = await ApiHelper.put(
        '/api/Users/', widget.user.id, request, widget.token);

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
    Navigator.pop(context, 'yes');
  }
}
