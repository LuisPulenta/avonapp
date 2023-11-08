import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:avon_app/models/cliente.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:avon_app/components/loader_component.dart';

class DireccionScreen extends StatefulWidget {
  final Cliente cliente;
  final int option;
  final Position positionUser;
  final String direccionUser;

  const DireccionScreen(
      {Key? key,
      required this.cliente,
      required this.option,
      required this.positionUser,
      required this.direccionUser})
      : super(key: key);

  @override
  _DireccionScreenState createState() => _DireccionScreenState();
}

class _DireccionScreenState extends State<DireccionScreen> {
  final String _direccionError = '';
  final bool _direccionShowError = false;
  final TextEditingController _direccionController = TextEditingController();
  bool ubicOk = false;
  double latitud = 0;
  double longitud = 0;
  bool _showLoader = false;
  final Set<Marker> _markers = {};
  MapType _defaultMapType = MapType.normal;
  String direccion = '';
  String street = '';
  String administrativeArea = '';
  String country = '';
  String isoCountryCode = '';
  String locality = '';
  String subAdministrativeArea = '';
  String subLocality = '';
  Position position = const Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0);
  CameraPosition _initialPosition =
      const CameraPosition(target: LatLng(31, 64), zoom: 16.0);
  //static const LatLng _center = const LatLng(-31.4332373, -64.226344);

  LatLng _center = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _initialPosition = CameraPosition(
        target:
            LatLng(widget.positionUser.latitude, widget.positionUser.longitude),
        zoom: 16.0);
    ubicOk = true;
    _center =
        LatLng(widget.positionUser.latitude, widget.positionUser.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dirección"),
      ),
      body: Stack(
        children: [
          ubicOk == true
              ? Stack(children: <Widget>[
                  GoogleMap(
                    myLocationEnabled: false,
                    initialCameraPosition: _initialPosition,
                    onCameraMove: _onCameraMove,
                    markers: _markers,
                    mapType: _defaultMapType,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 80, right: 10),
                    alignment: Alignment.topRight,
                    child: Column(children: <Widget>[
                      FloatingActionButton(
                          child: const Icon(Icons.layers),
                          elevation: 5,
                          backgroundColor: const Color(0xfff4ab04),
                          onPressed: () {
                            _changeMapType();
                          }),
                    ]),
                  ),
                  const Center(
                    child: Icon(
                      Icons.my_location,
                      color: Color(0xFFfc6c0c),
                      size: 50,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: _direccionController,
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Dirección...',
                          labelText: 'Dirección',
                          errorText:
                              _direccionShowError ? _direccionError : null,
                          prefixIcon: const Icon(Icons.home),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onChanged: (value) {},
                    ),
                  ),
                ])
              : Container(),
          _showLoader
              ? const LoaderComponent(
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
                children: const [
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
                  return const Color(0xFFe4540c);
                }),
              ),
              onPressed: () => _marcar(),
            ),
            ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Seleccionar'),
                ],
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return const Color(0xFFe4540c);
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

    street = placemarks[0].street.toString();
    administrativeArea = placemarks[0].administrativeArea.toString();
    country = placemarks[0].country.toString();
    isoCountryCode = placemarks[0].isoCountryCode.toString();
    locality = placemarks[0].locality.toString();
    subAdministrativeArea = placemarks[0].subAdministrativeArea.toString();
    subLocality = placemarks[0].subLocality.toString();

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

    setState(() {
      _showSnackbar();
    });
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
    if (_markers.isEmpty) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: "Debe marcar un lugar",
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
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
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    var response = await showAlertDialog(
        context: context,
        title: 'Aviso',
        message:
            '¿Está seguro de seleccionar la dirección ${_direccionController.text}?',
        actions: <AlertDialogAction>[
          const AlertDialogAction(key: 'si', label: 'SI'),
          const AlertDialogAction(key: 'no', label: 'NO'),
        ]);
    if (response == 'no') {
      return;
    }

    setState(() {
      _showLoader = true;
    });

    Cliente userModified = widget.cliente;
    userModified.address1 = widget.option == 1
        ? _direccionController.text
        : widget.cliente.address1;
    userModified.latitude1 =
        widget.option == 1 ? latitud : widget.cliente.latitude1;
    userModified.longitude1 =
        widget.option == 1 ? longitud : widget.cliente.longitude1;

    userModified.street1 = widget.option == 1 ? street : widget.cliente.street1;
    userModified.administrativeArea1 = widget.option == 1
        ? administrativeArea
        : widget.cliente.administrativeArea1;
    userModified.country1 =
        widget.option == 1 ? country : widget.cliente.country1;
    userModified.isoCountryCode1 =
        widget.option == 1 ? isoCountryCode : widget.cliente.isoCountryCode1;
    userModified.locality1 =
        widget.option == 1 ? locality : widget.cliente.locality1;
    userModified.subAdministrativeArea1 = widget.option == 1
        ? subAdministrativeArea
        : widget.cliente.subAdministrativeArea1;
    userModified.subLocality1 =
        widget.option == 1 ? subLocality : widget.cliente.subLocality1;

    userModified.street1 = userModified.address2 = widget.option == 2
        ? _direccionController.text
        : widget.cliente.address2;
    userModified.latitude2 =
        widget.option == 2 ? latitud : widget.cliente.latitude2;
    userModified.longitude2 =
        widget.option == 2 ? longitud : widget.cliente.longitude2;

    userModified.street2 = widget.option == 2 ? street : widget.cliente.street2;
    userModified.administrativeArea2 = widget.option == 2
        ? administrativeArea
        : widget.cliente.administrativeArea2;
    userModified.country2 =
        widget.option == 2 ? country : widget.cliente.country2;
    userModified.isoCountryCode2 =
        widget.option == 2 ? isoCountryCode : widget.cliente.isoCountryCode2;
    userModified.locality2 =
        widget.option == 2 ? locality : widget.cliente.locality2;
    userModified.subAdministrativeArea2 = widget.option == 2
        ? subAdministrativeArea
        : widget.cliente.subAdministrativeArea2;
    userModified.subLocality2 =
        widget.option == 2 ? subLocality : widget.cliente.subLocality2;

    userModified.address3 = widget.option == 3
        ? _direccionController.text
        : widget.cliente.address3;
    userModified.latitude3 =
        widget.option == 3 ? latitud : widget.cliente.latitude3;
    userModified.longitude3 =
        widget.option == 3 ? longitud : widget.cliente.longitude3;

    userModified.street3 = widget.option == 3 ? street : widget.cliente.street3;
    userModified.administrativeArea3 = widget.option == 3
        ? administrativeArea
        : widget.cliente.administrativeArea3;
    userModified.country3 =
        widget.option == 3 ? country : widget.cliente.country3;
    userModified.isoCountryCode3 =
        widget.option == 3 ? isoCountryCode : widget.cliente.isoCountryCode3;
    userModified.locality3 =
        widget.option == 3 ? locality : widget.cliente.locality3;
    userModified.subAdministrativeArea3 = widget.option == 3
        ? subAdministrativeArea
        : widget.cliente.subAdministrativeArea3;
    userModified.subLocality3 =
        widget.option == 3 ? subLocality : widget.cliente.subLocality3;

    // var connectivityResult = await Connectivity().checkConnectivity();

    // if (connectivityResult == ConnectivityResult.none) {
    //   setState(() {
    //     _showLoader = false;
    //   });
    //   await showAlertDialog(
    //       context: context,
    //       title: 'Error',
    //       message: 'Verifica que estés conectado a Internet',
    //       actions: <AlertDialogAction>[
    //         AlertDialogAction(key: null, label: 'Aceptar'),
    //       ]);
    //   return;
    // }

    // Response response = await ApiHelper.put(
    //     '/api/Users/', widget.cliente.id, request, widget.token);

    // setState(() {
    //   _showLoader = false;
    // });

    // if (!response.isSuccess) {
    //   await showAlertDialog(
    //       context: context,
    //       title: 'Error',
    //       message: response.message,
    //       actions: <AlertDialogAction>[
    //         AlertDialogAction(key: null, label: 'Aceptar'),
    //       ]);
    //   return;
    // }
    //Navigator.pop(context, 'yes');
    Navigator.pop(context, userModified);
  }

//*****************************************************************************
//************************** METODO SHOWSNACKBAR ******************************
//*****************************************************************************

  void _showSnackbar() {
    SnackBar snackbar = const SnackBar(
      content: Text(
          "Verifique que la dirección sea correcta. Sino puede editarla antes de seleccionarla."),
      backgroundColor: Color(0xFFe4540c),
      duration: Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    //ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
