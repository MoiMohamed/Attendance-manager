import 'package:attendance/providers/Auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() => runApp(MyApp());


class MyApp extends StatelessWidget{
  @override 
  Widget build(BuildContext context)
  {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx)=>Auth())
      ],
      child: MaterialApp(
          
      ),

    );
  }
}