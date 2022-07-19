import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;


class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  List<Polygon> cells = [
    Polygon(
      isFilled: true,
      points: [
        LatLng(51.5, -0.09),
        LatLng(53.3498, -6.2603),
        LatLng(48.8566, 2.3522)
      ],
      color: Color(0xFF0000FF),
    ),
    Polygon(
      isFilled: true,
      points: [
        LatLng(55.5, -0.09),
        LatLng(54.3498, -6.2603),
        LatLng(52.8566, 2.3522),
      ],
      color: Color(0xFF0000FF),
    ),
    Polygon(
      isFilled: true,
      points: [
        LatLng(49.29, -2.57),
        LatLng(51.46, -6.43),
        LatLng(49.86, -8.17),
        LatLng(48.39, -3.49),
      ],
      color: Color(0xFF0000FF),
    ),
    Polygon(
      isFilled: true,
      points: [
        LatLng(46.35, 4.94),
        LatLng(46.22, -0.11),
        LatLng(44.399, 1.76),
      ],
      color: Color(0xFF0000FF),
    ),

  ];
  

  Polygon? findContainingCell(LatLng point) {
    final mpPoint = mp.LatLng(point.latitude, point.longitude);
    
    for (var cell in cells) {
      final mpPolygon = cell.points.map((c) => mp.LatLng(c.latitude, c.longitude)).toList();
      if (mp.PolygonUtil.containsLocation(mpPoint, mpPolygon, false)) {
        return cell;
      }
    }
    return null;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Center(
        child: Container(
          child: Column(
            children: [
              Flexible(
                child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    center: LatLng(51.5, -0.09),
                    zoom: 5,
                    onTap: (tapPosition,latlong){

                      var selectedCell = findContainingCell(latlong);

                      if(selectedCell != null){
                        print("Polygon tapped");
                        selectedCell.setTapped();
                        for(Polygon cell in cells){

                          if(cell != selectedCell){
                            cell.setUntapped();
                          }
                        }

                        setState(() {
                          
                        });
                      }
                      else{
                        print("No polygon tapped");                    
                      }
                      
                    } 
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
                    ),
                    MarkerLayerOptions(
                      markers:[
                        Marker(
                          point: LatLng (30, 40),
                          builder: (context) => Icon(Icons.pin_drop )
                        )
                      ] 
                    ),
                    PolygonLayerOptions(
                      polygonCulling: false,
                      polygons: cells
                    ),
                  ]
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
