import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mapbox_gl/mapbox_gl.dart';

import 'package:http/http.dart' as http;

class FullScreenMap extends StatefulWidget {
  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  MapboxMapController mapController;

  final center = LatLng(10.5213228, -66.9781643);
  String seletectStyle = 'mapbox://styles/jonathan29/ckq1ge4z51ct817o02sxec9if';
  final oscuroStyle = 'mapbox://styles/jonathan29/ckq1ge4z51ct817o02sxec9if';
  final streetsStyle = 'mapbox://styles/jonathan29/ckq1gngnj2go617mn0jak7kio';

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    //_onStyleLoaded();
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/custom-icon.png");
    addImageFromUrl(
        "networkImage", Uri.parse("https://via.placeholder.com/50"));
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, Uri uri) async {
    var response = await http.get(uri);
    return mapController.addImage(name, response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: crearMapa(),
      floatingActionButton: botonesFlotantes(),
    );
  }

  Column botonesFlotantes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //simbolo
        FloatingActionButton(
          child: Icon(Icons.sentiment_very_dissatisfied),
          onPressed: () {
            mapController.addSymbol(SymbolOptions(
                geometry: center,
                //iconSize: 2,
                iconImage: 'networkImage',
                textField: 'Monstañas creadas aqui',
                textColor: '#000',
                textOffset: Offset(0, 2)));
          },
        ),
        SizedBox(height: 5),

        //zoomin
        FloatingActionButton(
          child: Icon(Icons.zoom_in),
          onPressed: () {
            mapController.animateCamera(
              CameraUpdate.zoomIn(),
            );
          },
        ),
        SizedBox(height: 5),
        //zoomout
        FloatingActionButton(
          child: Icon(Icons.zoom_out_sharp),
          onPressed: () {
            mapController.animateCamera(CameraUpdate.zoomOut());
          },
        ),
        SizedBox(height: 5),
        //titleto
        FloatingActionButton(
          child: Icon(Icons.filter_tilt_shift),
          onPressed: () {
            mapController.animateCamera(
              CameraUpdate.tiltTo(60),
            );
          },
        ),
        SizedBox(height: 5),

        //cambiar estilo
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _onStyleLoaded();
              if (seletectStyle == oscuroStyle) {
                seletectStyle = streetsStyle;
              } else {
                seletectStyle = oscuroStyle;
              }
            });
          },
          child: Icon(Icons.add_to_home_screen),
        )
      ],
    );
  }

  MapboxMap crearMapa() {
    return MapboxMap(
      styleString: seletectStyle,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: center, zoom: 10),
      onStyleLoadedCallback: _onStyleLoaded,
    );
  }
}
