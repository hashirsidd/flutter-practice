import 'package:flutter/material.dart';
import 'package:hello_rectangle/category_route.dart';


void main() {
  runApp(UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      home: CategoryRoute()
    );
  }
}

// hello rectangle code
// class HelloRectangle extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         color: Colors.greenAccent,
//         height: 400,
//         width: 300,
//         child: Center(
//           child: Text('Hello!', style: TextStyle(fontSize: 40)),
//         ),
//       ),
//     );
//   }
// }
