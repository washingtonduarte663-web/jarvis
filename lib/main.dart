import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math' as math;

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: ReactorApp()));

class ReactorApp extends StatefulWidget {
  @override State<ReactorApp> createState() => _ReactorState();
}
class _ReactorState extends State<ReactorApp> with TickerProviderStateMixin {
  int aba=0;
  final input=TextEditingController();
  final apiKeyController=TextEditingController();
  String apiKey=""; bool iaAtiva=false; bool loading=false;
  List<Map<String,String>> chat=[{"u":"Reator","j":"REATOR ARC AZUL MARK 3.0 Online!"}];
  String placa="【entity-Arduino¦canonical_name=Arduino】 Uno";
  late AnimationController core;
  late AnimationController ring;
  FlutterTts tts=FlutterTts();
  @override void initState(){
    super.initState();
    core=AnimationController(vsync: this, duration: Duration(milliseconds: 900))..repeat(reverse: true);
    ring=AnimationController(vsync: this, duration: Duration(seconds: 4))..repeat();
    tts.setLanguage("pt-BR");
    tts.setSpeechRate(0.45);
  }
  falar(String t) async { if(t.length>250) t=t.substring(0,250); await tts.speak(t); }
  Future<void> perguntar(String p) async {
    if(apiKey.isEmpty){ setState(()=> chat.add({"u":p,"j":"Cole a chave AIzaSy na aba SETUP"})); return; }
    setState(()=> loading=true);
    setState(()=> chat.add({"u":p,"j":"..."}));
    try{
      var url=Uri.parse("https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash-latest:generateContent?key=$apiKey");
      var body=jsonEncode({"contents":[{"parts":[{"text":"JARVIS MARK 3.0: $p"}]}]});
      var res=await http.post(url, headers: {"Content-Type":"application/json"}, body: body);
      String r = res.statusCode==200 ? jsonDecode(res.body)["candidates"][0]["content"]["parts"][0]["text"] : "Offline AZUL: $p";
      setState(()=> chat.last["j"]=r); falar(r);
    } catch(e){ setState(()=> chat.last["j"]="Offline: $p"); }
    setState(()=> loading=false);
  }
  void enviar(){ var t=input.text.trim(); if(t.isEmpty) return; input.clear(); perguntar(t); }

  @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: Color(0xFF020A1A), body: Stack(children:[
      Positioned.fill(child: AnimatedBuilder(animation: Listenable.merge([core,ring]), builder: (c,ch){ return CustomPaint(painter: ArcPainter(core.value, ring.value)); })),
      Column(children:[
        Container(height:70, padding: EdgeInsets.only(top:32, left:12, right:12), child: Row(children:[
          AnimatedBuilder(animation: core, builder: (c,ch)=> Container(width:32, height:32, decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFF0066FF).withOpacity(0.5+core.value*0.5), boxShadow: [BoxShadow(color: Color(0xFF0066FF), blurRadius: 18+core.value*12)]), child: Icon(Icons.bolt, size:18, color: Colors.white))),
          SizedBox(width:10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text("MARK 3.0", style: TextStyle(color: Color(0xFF2A8DFF), letterSpacing:5, fontWeight: FontWeight.bold, fontSize:16)), Text("REACTOR ARC AZUL", style: TextStyle(color: Color(0xFF2A8DFF), fontSize:8, letterSpacing:3))]),
          Spacer(),
          Container(padding: EdgeInsets.symmetric(horizontal:10, vertical:5), decoration: BoxDecoration(border: Border.all(color: Color(0xFF2A8DFF)), borderRadius: BorderRadius.circular(20)), child: Text(iaAtiva? "AZUL ON":"SETUP", style: TextStyle(color: Color(0xFF2A8DFF), fontSize:9))),
        ])),
        Expanded(child: aba==0 ? chatTab() : aba==1 ? arduinoTab() : setupTab()),
        if(loading) LinearProgressIndicator(color: Color(0xFF0066FF)),
        Container(height:88, child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children:[
          _btn(Icons.chat, "JARVIS", 0),
          _btn(Icons.developer_board, "【entity-ARDUINO¦canonical_name=Arduino】", 1),
          _center(),
          _btn(Icons.wifi, "IoT", 2),
          _btn(Icons.settings, "SETUP", 3),
        ])),
        Container(padding: EdgeInsets.all(8), color: Colors.black.withOpacity(0.6), child: Row(children:[
          Expanded(child: TextField(controller: input, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "Comando REATOR AZUL...", hintStyle: TextStyle(color: Colors.white24, fontSize:11), filled: true, fillColor: Color(0xFF061530), border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none)), onSubmitted: (_)=> enviar())),
          SizedBox(width:8),
          FloatingActionButton(mini: true, backgroundColor: Color(0xFF0066FF), onPressed: enviar, child: Icon(Icons.send, color: Colors.white)),
        ])),
      ]),
    ]));
  }
  Widget chatTab()=> ListView.builder(padding: EdgeInsets.all(12), itemCount: chat.length, itemBuilder: (c,i)=> Column(children:[
    Align(alignment: Alignment.centerRight, child: Container(margin: EdgeInsets.symmetric(vertical:4), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF0066FF), borderRadius: BorderRadius.circular(12)), child: Text(chat[i]["u"]!, style: TextStyle(color: Colors.white, fontSize:12)))),
    Align(alignment: Alignment.centerLeft, child: GestureDetector(onTap: ()=> falar(chat[i]["j"]!), child: Container(margin: EdgeInsets.symmetric(vertical:4), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF061530), borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xFF0066FF).withOpacity(0.6))), child: Text(chat[i]["j"]!, style: TextStyle(color: Color(0xFF2A8DFF), fontSize:11))))),
  ]));
  Widget arduinoTab()=> ListView(padding: EdgeInsets.all(16), children:[
    Center(child: AnimatedBuilder(animation: core, builder: (c,ch)=> Container(width:100, height:100, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Color(0xFF0066FF), width:2), boxShadow: [BoxShadow(color: Color(0xFF0066FF), blurRadius: 25+core.value*15)]), child: Center(child: Container(width:40+core.value*15, height:40+core.value*15, decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFF0066FF)))))))),
    SizedBox(height:16),
    Text("【entity-ARDUINO¦canonical_name=Arduino】 - REATOR AZUL", style: TextStyle(color: Color(0xFF2A8DFF), fontWeight: FontWeight.bold)),
    DropdownButton<String>(value: placa, isExpanded: true, dropdownColor: Color(0xFF061530), style: TextStyle(color: Colors.white), items: ["【entity-Arduino¦canonical_name=Arduino】 Uno","ESP32","ESP8266"].map((e)=> DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v){ setState(()=> placa=v!); }),
    ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0066FF)), onPressed: ()=> falar("Codigo $placa gerado"), child: Text("GERAR CODIGO AZUL", style: TextStyle(color: Colors.white))),
  ]);
  Widget setupTab()=> ListView(padding: EdgeInsets.all(16), children:[
    Text("REACTOR AZUL SETUP", style: TextStyle(color: Color(0xFF2A8DFF), fontWeight: FontWeight.bold)),
    TextField(controller: apiKeyController, style: TextStyle(color: Colors.white), decoration: InputDecoration(labelText: "API Key AIzaSy...", filled: true, fillColor: Color(0xFF061530)), onChanged: (v)=> apiKey=v),
    SizedBox(height:12),
    ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0066FF), padding: EdgeInsets.all(14)), onPressed: (){ setState(()=> apiKey=apiKeyController.text.trim()); setState(()=> iaAtiva=apiKey.isNotEmpty); setState(()=> aba=0); falar("Reator azul ativado"); }, child: Text("ATIVAR REATOR AZUL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
  ]);
  Widget _btn(IconData ic, String lb, int id){ bool sel=aba==id; return GestureDetector(onTap: ()=> setState(()=> aba=id), child: Column(children:[Container(width:46, height:46, decoration: BoxDecoration(shape: BoxShape.circle, color: sel? Color(0xFF0066FF): Color(0xFF061530), border: Border.all(color: Color(0xFF0066FF).withOpacity(sel?1:0.4))), child: Icon(ic, color: sel? Colors.white: Color(0xFF2A8DFF), size:20)), SizedBox(height:3), Text(lb, style: TextStyle(color: sel? Color(0xFF2A8DFF): Colors.white38, fontSize:6))])); }
  Widget _center(){ return AnimatedBuilder(animation: core, builder: (c,ch)=> Container(width:62, height:62, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Color(0xFF2A8DFF), Color(0xFF0066FF), Color(0xFF003399)]), boxShadow: [BoxShadow(color: Color(0xFF0066FF), blurRadius: 20+core.value*15)]), child: Icon(Icons.bolt, color: Colors.white, size:30))); }
}

class ArcPainter extends CustomPainter {
  final double core, ring;
  ArcPainter(this.core, this.ring);
  @override void paint(Canvas canvas, Size size){
    final center=Offset(size.width/2, size.height/2.3);
    final p=Paint()..style=PaintingStyle.stroke;
    for(int i=0;i<5;i++){ p.color=Color(0xFF0066FF).withOpacity(0.08); p.strokeWidth=1; canvas.drawCircle(center, 90+i*65+ring*20, p); }
    p.color=Color(0xFF2A8DFF).withOpacity(0.25); p.strokeWidth=2;
    for(int i=0;i<24;i++){ double a=(i*15+ring*360)*math.pi/180; double r=170; canvas.drawLine(center+Offset(r*math.cos(a), r*math.sin(a)), center+Offset((r+12)*math.cos(a), (r+12)*math.sin(a)), p); }
    p.style=PaintingStyle.fill; p.color=Color(0xFF0066FF).withOpacity(0.05+core*0.08); canvas.drawCircle(center, 280, p);
  }
  @override bool shouldRepaint(old)=> true;
}
