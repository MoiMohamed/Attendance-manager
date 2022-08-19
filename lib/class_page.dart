import 'package:flutter/material.dart';
void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String className = "11-C";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue[400],
          centerTitle: true,
          elevation: 0,
          title: Text(
            "Class $className",
            style: TextStyle(
              color: Colors.amberAccent,
              fontWeight: FontWeight.bold,
            ),
          )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Sessions',
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                    primary: Colors.white,
                    side: BorderSide(color: Colors.lightBlueAccent, width: 1),
                  ),
            ),
            SizedBox(height: 70,),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'students',
                style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                primary: Colors.white,
                side: BorderSide(color: Colors.lightBlueAccent, width: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
