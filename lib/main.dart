import 'package:flutter/material.dart';
void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Jarvis()));
class Jarvis extends StatefulWidget {
  @override State<Jarvis> createState() => _JarvisState();
}
class _JarvisState extends State<Jarvis> {
  String fala = "Olá Washington! Eu sou o JARVIS, pronto para ajudar!";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E1A),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 140, height: 140,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent.withOpacity(0.2), border: Border.all(color: Colors.cyanAccent, width: 2)),
          child: Icon(Icons.memory, size: 70, color: Colors.cyanAccent),
        ),
        SizedBox(height: 20),
        Text("JARVIS", style: TextStyle(color: Colors.cyanAccent, fontSize: 42, fontWeight: FontWeight.bold, letterSpacing: 6)),
        Text("MARK 1", style: TextStyle(color: Colors.white54, letterSpacing: 8)),
        SizedBox(height: 30),
        Padding(padding: EdgeInsets.all(20), child: Text(fala, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20))),
        SizedBox(height: 40),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, foregroundColor: Colors.black, padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
          onPressed: (){
            setState((){ fala = "JARVIS online! O que você precisa, Washington?"; });
          },
          child: Text("ATIVAR JARVIS", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        )
      ])),
    );
  }
}
