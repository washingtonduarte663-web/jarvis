import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math' as math;

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: JarvisReactor()));

class JarvisReactor extends StatefulWidget {
  @override State<JarvisReactor> createState() => _ReactorState();
}
class _ReactorState extends State<JarvisReactor> with TickerProviderStateMixin {
  int aba=0; bool isFriday=false;
  final input=TextEditingController();
  final apiKeyController=TextEditingController();
  String apiKey=""; bool iaAtiva=false; bool carregando=false;
  List<Map<String,String>> chat=[{"user":"Iniciar REACTOR ARC","jarvis":"MARK 3.0 REACTOR ARC Online! Núcleo de energia ativado Washington!"}];
  String placa="Arduino Uno"; String comp="LED"; String codigo="";
  List<Map<String,dynamic>> dispositivos=[
    {"nome":"TV Sala","icon": Icons.tv,"conectado":false},
    {"nome":"Watch","icon": Icons.watch,"conectado":true},
    {"nome":"Lâmpada","icon": Icons.lightbulb,"conectado":false},
  ];
  late AnimationController core; late AnimationController ring1; late AnimationController ring2;
  FlutterTts tts=FlutterTts();
  @override void initState(){
    super.initState();
    core=AnimationController(vsync: this, duration: Duration(milliseconds: 800))..repeat(reverse: true);
    ring1=AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat();
    ring2=AnimationController(vsync: this, duration: Duration(seconds: 6))..repeat();
    initTts();
  }
  initTts() async { await tts.setLanguage(isFriday?"en-US":"pt-BR"); await tts.setSpeechRate(0.46); await tts.setPitch(0.82); }
  falar(String txt) async { String limpo=txt.replaceAll(RegExp(r'[^\w\s.,!?áéíóúãõç]'), ''); if(limpo.length>250) limpo=limpo.substring(0,250); await tts.speak(limpo); }
  Future<void> perguntarIA(String p) async {
    if(apiKey.isEmpty){ String r="⚠️ Cole a chave AIzaSy... na aba REACTOR SETUP para ativar IA!"; setState(()=> chat.add({"user":p,"jarvis":r})); falar(r); return; }
    setState(()=> carregando=true);
    setState(()=> chat.add({"user":p,"jarvis":"..."}));
    try{
      var url=Uri.parse("https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash-latest:generateContent?key=$apiKey");
      var body=jsonEncode({"contents":[{"parts":[{"text":"Você é JARVIS MARK 3.0 REACTOR ARC do Washington, responda curto PT-BR. Pergunta: $p"}]}]});
      var res=await http.post(url, headers: {"Content-Type":"application/json"}, body: body);
      String resp=res.statusCode==200 ? jsonDecode(res.body)["candidates"][0]["content"]["parts"][0]["text"] : "Modo offline REACTOR: Entendi '$p'! Núcleo de energia estável!";
      setState(()=> chat.last["jarvis"]=resp); falar(resp);
    } catch(e){ setState(()=> chat.last["jarvis"]="REACTOR ARC Offline: '$p' registrado!"); }
    setState(()=> carregando=false);
  }
  void enviar(){ String t=input.text.trim(); if(t.isEmpty) return; input.clear(); perguntarIA(t); }
    @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: Colors.black, body: Stack(children:[
      // FUNDO REATOR ARC
      Positioned.fill(child: CustomPaint(painter: ReactorArcPainter(core, ring1, ring2))),
      // CONTEÚDO
      Column(children:[
        Container(height:70, padding: EdgeInsets.only(top:32, left:12, right:12), child: Row(children:[
          AnimatedBuilder(animation: core, builder: (c,child){ return Container(width:28, height:28, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.cyanAccent.withOpacity(0.3+core.value*0.7), boxShadow: [BoxShadow(color: Colors.cyanAccent.withOpacity(0.8), blurRadius: 15+core.value*10)])), child: Icon(Icons.bolt, size:16, color: Colors.white)); }),
          SizedBox(width:10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text("REACTOR ARC", style: TextStyle(color: Colors.cyanAccent, letterSpacing:5, fontWeight: FontWeight.bold, fontSize:14, shadows: [Shadow(color: Colors.cyanAccent, blurRadius: 15)])), Text("MARK 3.0 - Washington", style: TextStyle(color: Colors.white38, fontSize:8, letterSpacing:2))]),
          Spacer(),
          GestureDetector(onTap: (){ setState(()=> aba=3); }, child: Container(padding: EdgeInsets.symmetric(horizontal:10, vertical:6), decoration: BoxDecoration(border: Border.all(color: Colors.cyanAccent), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.cyanAccent.withOpacity(0.4), blurRadius: 10)]), child: Text(iaAtiva? "IA ON":"SETUP IA", style: TextStyle(color: Colors.cyanAccent, fontSize:9)))),
        ])),
        Expanded(child: _conteudo()),
        if(carregando) LinearProgressIndicator(color: Colors.cyanAccent, backgroundColor: Colors.transparent),
        // CONTROLES EM ARCO (igual reator)
        Container(height:90, child: Stack(children:[
          Center(child: AnimatedBuilder(animation: core, builder: (c,ch){ return Container(width:90+core.value*10, height:90+core.value*10, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.cyanAccent.withOpacity(0.2)), boxShadow: [BoxShadow(color: Colors.cyanAccent.withOpacity(0.15), blurRadius: 20)])); })),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children:[
            _arcButton(Icons.chat_bubble, "JARVIS", 0),
            _arcButton(Icons.developer_board, "ARDUINO", 1),
            _reactorCenter(),
            _arcButton(Icons.wifi, "IoT", 2),
            _arcButton(Icons.settings, "SETUP", 3),
          ]),
        ])),
        Container(padding: EdgeInsets.all(8), color: Colors.black.withOpacity(0.6), child: Row(children:[
          Expanded(child: Container(decoration: BoxDecoration(color: Color(0xFF0A1629), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.cyanAccent.withOpacity(0.3))), child: TextField(controller: input, style: TextStyle(color: Colors.white, fontSize:13), decoration: InputDecoration(hintText: "Comando para o REACTOR ARC...", hintStyle: TextStyle(color: Colors.white24, fontSize:11), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal:16, vertical:12)), onSubmitted: (_)=> enviar()))),
          SizedBox(width:8),
          GestureDetector(onTap: enviar, child: AnimatedBuilder(animation: core, builder: (c,ch){ return Container(width:48, height:48, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Colors.cyanAccent, Colors.blueAccent]), boxShadow: [BoxShadow(color: Colors.cyanAccent.withOpacity(0.6+core.value*0.4), blurRadius: 12+core.value*8)]), child: Icon(Icons.send, color: Colors.black, size:20)); })),
        ])),
      ]),
    ]));
  }
  Widget _conteudo(){
    if(aba==0) return ListView.builder(padding: EdgeInsets.all(12), itemCount: chat.length, itemBuilder: (c,i)=> Column(children:[
      Align(alignment: Alignment.centerRight, child: Container(margin: EdgeInsets.symmetric(vertical:4), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.blue.withOpacity(0.8), borderRadius: BorderRadius.circular(14)), child: Text(chat[i]["user"]!, style: TextStyle(color: Colors.white, fontSize:12)))),
      Align(alignment: Alignment.centerLeft, child: GestureDetector(onTap: ()=> falar(chat[i]["jarvis"]!), child: Container(margin: EdgeInsets.symmetric(vertical:4), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF0A1C36).withOpacity(0.9), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.cyanAccent.withOpacity(0.4)), boxShadow: [BoxShadow(color: Colors.cyanAccent.withOpacity(0.15), blurRadius: 10)]), child: Row(children:[Icon(Icons.volume_up, size:12, color: Colors.cyanAccent), SizedBox(width:6), Expanded(child: Text(chat[i]["jarvis"]!, style: TextStyle(color: Colors.cyanAccent, fontSize:11)))])))),
    ]));
    if(aba==1) return ListView(padding: EdgeInsets.all(16), children:[
      Center(child: AnimatedBuilder(animation: core, builder: (c,ch){ return Container(width:120, height:120, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.cyanAccent, width:2), boxShadow: [BoxShadow(color: Colors.cyanAccent.withOpacity(0.6), blurRadius: 20+core.value*10)]), child: Stack(children:[Center(child: Container(width:40+core.value*10, height:40+core.value*10, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.cyanAccent, boxShadow: [BoxShadow(color: Colors.cyanAccent, blurRadius: 20)]))), RotationTransition(turns: ring1, child: CustomPaint(size: Size(120,120), painter: RingTicksPainter()))])); })),
      SizedBox(height:16),
      Text("ARDUINO LAB - REACTOR", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
      DropdownButton<String>(value: placa, isExpanded: true, dropdownColor: Color(0xFF0A1629), style: TextStyle(color: Colors.white), items: ["Arduino Uno","ESP32","ESP8266"].map((e)=> DropdownMenuItem(value:e, child: Text(e))).toList(), onChanged: (v)=> setState(()=> placa=v!)),
      ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent), onPressed: (){ codigo="// REACTOR ARC - $placa\nvoid setup(){ pinMode(13, OUTPUT); }\nvoid loop(){ digitalWrite(13, HIGH); delay(500); digitalWrite(13, LOW); delay(500); }"; setState((){}); falar("Código gerado"); }, child: Text("GERAR CÓDIGO", style: TextStyle(color: Colors.black))),
      if(codigo.isNotEmpty) Container(margin: EdgeInsets.only(top:10), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.black, border: Border.all(color: Colors.cyanAccent)), child: SelectableText(codigo, style: TextStyle(color: Colors.greenAccent, fontSize:10))),
    ]);
    if(aba==2) return ListView(padding: EdgeInsets.all(16), children: dispositivos.map((d)=> ListTile(leading: Icon(d["icon"], color: Colors.cyanAccent), title: Text(d["nome"], style: TextStyle(color: Colors.white, fontSize:12)), trailing: Switch(value: d["conectado"], activeColor: Colors.cyanAccent, onChanged: (v){ setState(()=> d["conectado"]=v); falar("${d["nome"]} ${v? "conectado":"desconectado}"); }))).toList());
    return ListView(padding: EdgeInsets.all(16), children:[
      Text("REACTOR ARC SETUP - MARK 3.0", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
      SizedBox(height:12),
      TextField(controller: apiKeyController, style: TextStyle(color: Colors.white), decoration: InputDecoration(labelText: "API Key AIzaSy...", filled: true, fillColor: Color(0xFF0A1629), border: OutlineInputBorder()), onChanged: (v)=> apiKey=v),
      SizedBox(height:12),
      ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, padding: EdgeInsets.all(14)), onPressed: (){ setState(()=> apiKey=apiKeyController.text.trim()); setState(()=> iaAtiva=apiKey.isNotEmpty); falar(iaAtiva? "Reactor ARC e IA ativados Washington":"Cole a chave"); setState(()=> aba=0); }, child: Text("ATIVAR REACTOR ARC", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
    ]);
  }
  Widget _arcButton(IconData icon, String label, int idx){
    bool sel=aba==idx;
    return GestureDetector(onTap: ()=> setState(()=> aba=idx), child: Column(children:[
      Container(width:48, height:48, decoration: BoxDecoration(shape: BoxShape.circle, color: sel? Colors.cyanAccent: Color(0xFF0A1629), border: Border.all(color: Colors.cyanAccent.withOpacity(sel?1:0.3)), boxShadow: sel? [BoxShadow(color: Colors.cyanAccent.withOpacity(0.6), blurRadius: 12)]:[]), child: Icon(icon, color: sel? Colors.black: Colors.cyanAccent, size:20)),
      SizedBox(height:4),
      Text(label, style: TextStyle(color: sel? Colors.cyanAccent: Colors.white38, fontSize:7)),
    ]));
  }
  Widget _reactorCenter(){
    return AnimatedBuilder(animation: Listenable.merge([core, ring1]), builder: (c,ch){
      return Container(width:60, height:60, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Colors.cyanAccent.withOpacity(0.9), Colors.blueAccent.withOpacity(0.6), Colors.black]), boxShadow: [BoxShadow(color: Colors.cyanAccent.withOpacity(0.8), blurRadius: 20+core.value*15)]), child: RotationTransition(turns: ring1, child: Icon(Icons.bolt, color: Colors.white, size:28)));
    });
  }
}

class ReactorArcPainter extends CustomPainter {
  final Animation<double> core, r1, r2;
  ReactorArcPainter(this.core, this.r1, this.r2): super(repaint: Listenable.merge([core, r1, r2]));
  @override void paint(Canvas canvas, Size size){
    final center=Offset(size.width/2, size.height/2.2);
    final paint=Paint()..style=PaintingStyle.stroke;
    // Anéis externos
    for(int i=0;i<5;i++){
      paint.color=Colors.cyanAccent.withOpacity(0.08 - i*0.01);
      paint.strokeWidth=1;
      canvas.drawCircle(center, 100 + i*60 + r2.value*20, paint);
    }
    // Ticks do reator
    paint.color=Colors.cyanAccent.withOpacity(0.15);
    paint.strokeWidth=2;
    for(int i=0;i<24;i++){
      double angle=(i*15 + r1.value*360)*math.pi/180;
      double r=180;
      Offset p1=center + Offset(r*math.cos(angle), r*math.sin(angle));
      Offset p2=center + Offset((r+10)*math.cos(angle), (r+10)*math.sin(angle));
      canvas.drawLine(p1, p2, paint);
    }
    // Brilho central
    paint.style=PaintingStyle.fill;
    paint.color=Colors.cyanAccent.withOpacity(0.04 + core.value*0.06);
    canvas.drawCircle(center, 250, paint);
  }
  @override bool shouldRepaint(old)=> true;
}

class RingTicksPainter extends CustomPainter {
  @override void paint(Canvas c, Size s){
    final center=Offset(s.width/2, s.height/2);
    final p=Paint()..color=Colors.cyanAccent.withOpacity(0.6)..strokeWidth=2..style=PaintingStyle.stroke;
    for(int i=0;i<12;i++){ double a=i*30*math.pi/180; c.drawLine(center+Offset(45*math.cos(a),45*math.sin(a)), center+Offset(50*math.cos(a),50*math.sin(a)), p); }
  }
  @override bool shouldRepaint(old)=> false;
}
