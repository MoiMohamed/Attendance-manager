import 'package:attendance/providers/Auth.dart';
import 'package:attendance/providers/Sessions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Sessions>(
            update: (ctx, auth, prev) => Sessions(auth.tokenGet, auth.userIdGet,
                prev == null ? [] : prev.sessions))
      ],
      child: MaterialApp(),
    );
  }
}
