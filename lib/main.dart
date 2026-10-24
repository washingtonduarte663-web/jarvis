import 'package:flutter/material.dart';
void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: JarvisIoT()));

class JarvisIoT extends StatefulWidget {
  @override State<JarvisIoT> createState() => _IoTState();
}
class _IoTState extends State<JarvisIoT> with TickerProviderStateMixin {
  int aba=0; bool isFriday=false;
  final input=TextEditingController();
  List<Map<String,String>> chat=[{"user":"Iniciar","jarvis":"J.A.R.V.I.S MARK 3 IoT Online! Bluetooth e Wi-Fi ativos! Conecte TV, Relógio, Lâmpadas! Diga 'conectar TV' ou vá na aba IoT!"}];
  List<String> tarefas=["Conectar TV Sala","Sincronizar Relógio"];
  String placa="Arduino Uno"; String comp="LED"; String pino="13"; String codigo="";
  String tradOrig=""; String tradDest="";
  bool scanning=false;
  List<Map<String,dynamic>> dispositivos=[
    {"nome":"TV Samsung Sala","tipo":"TV","icon": Icons.tv,"conectado":false,"bluetooth":false,"wifi":true,"status":"Desconectado"},
    {"nome":"Relógio Galaxy Watch","tipo":"Relógio","icon": Icons.watch,"conectado":true,"bluetooth":true,"wifi":false,"status":"Conectado"},
    {"nome":"Lâmpada Quarto","tipo":"Luz","icon": Icons.lightbulb,"conectado":false,"bluetooth":false,"wifi":true,"status":"Desconectado"},
    {"nome":"【entity-JBL¦canonical_name=JBL】 Caixa Som","tipo":"Áudio","icon": Icons.speaker,"conectado":false,"bluetooth":true,"wifi":false,"status":"Desconectado"},
    {"nome":"Ar Condicionado","tipo":"Clima","icon": Icons.ac_unit,"conectado":false,"bluetooth":false,"wifi":true,"status":"Desconectado"},
  ];
  late AnimationController reactor;
  @override void initState(){ super.initState(); reactor=AnimationController(vsync: this, duration: Duration(seconds:3))..repeat(); }
  void trocar(){ setState(()=> isFriday=!isFriday); }
  void enviar(){ String t=input.text.trim(); if(t.isEmpty) return; processar(t); input.clear(); }
  void processar(String t){
    String l=t.toLowerCase(); String r="";
    if(l.contains("conectar")||l.contains("tv")||l.contains("relogio")||l.contains("lampada")){ setState(()=> aba=5); if(l.contains("tv")) conectar(0); r="📡 Aba IoT! Conectando!"; }
    else if(l.contains("arduino")||l.contains("led")){ aba=2; gerar(); r="🔧 Código $comp gerado!"; }
    else if(l.contains("tarefa")){ String task=t.replaceAll(RegExp(r'tarefa|adicionar', caseSensitive: false), '').trim(); if(task.length<2) task=t; setState(()=> tarefas.add(task)); r="✅ Tarefa: $task"; }
    else { r="JARVIS IoT: Entendi '$t' - TV, Relógio, Lâmpadas prontos na aba IoT!"; }
    setState(()=> chat.add({"user":t,"jarvis":r}));
  }
  void conectar(int i){ setState(()=> dispositivos[i]["conectado"]=!dispositivos[i]["conectado"]); setState(()=> dispositivos[i]["status"]=dispositivos[i]["conectado"]? "Conectado":"Desconectado"); }
  void escanear(){ setState(()=> scanning=true); Future.delayed(Duration(seconds:2), ()=> setState(()=> scanning=false)); }
  void traduzir(){ String res=tradOrig; if(res.toLowerCase().contains("oi")) res=res.replaceAll(RegExp("oi", caseSensitive: false), "hello"); setState(()=> tradDest=res); }
  void gerar(){ if(comp=="LED") codigo="// JARVIS IoT - $placa LED pino $pino\nvoid setup(){ pinMode($pino, OUTPUT); Serial.begin(9600); }\nvoid loop(){ digitalWrite($pino, HIGH); delay(800); digitalWrite($pino, LOW); delay(800); }"; else codigo="// JARVIS - $comp $placa - IoT Ready"; setState((){}); }
    @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: Color(0xFF050A14), body: Stack(children:[
      Positioned.fill(child: CustomPaint(painter: HudPainter(reactor))),
      Column(children:[
        Container(height:70, padding: EdgeInsets.only(top:28, left:12, right:12), color: Colors.black.withOpacity(0.9), child: Row(children:[
          RotationTransition(turns: reactor, child: Icon(Icons.wifi, color: isFriday? Colors.orangeAccent: Colors.cyanAccent, size:26)),
          SizedBox(width:8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(isFriday? "F.R.I.D.A.Y IoT":"J.A.R.V.I.S IoT", style: TextStyle(color: isFriday? Colors.orangeAccent: Colors.cyanAccent, letterSpacing:3, fontWeight: FontWeight.bold, fontSize:14)), Text("MARK 3 - BLUETOOTH + WIFI", style: TextStyle(color: Colors.white30, fontSize:7))]),
          Spacer(),
          GestureDetector(onTap: trocar, child: Container(padding: EdgeInsets.symmetric(horizontal:8, vertical:4), decoration: BoxDecoration(border: Border.all(color: isFriday? Colors.orangeAccent: Colors.cyanAccent), borderRadius: BorderRadius.circular(20)), child: Text(isFriday? "JARVIS":"FRIDAY", style: TextStyle(color: isFriday? Colors.orangeAccent: Colors.cyanAccent, fontSize:9)))),
        ])),
        Expanded(child: [chatTab(), tarefaTab(), arduinoTab(), appTab(), tradTab(), iotTab()][aba]),
        Container(height:70, color: Colors.black.withOpacity(0.9), child: BottomNavigationBar(currentIndex: aba, onTap: (i)=> setState(()=> aba=i), backgroundColor: Colors.transparent, selectedItemColor: Colors.cyanAccent, unselectedItemColor: Colors.white24, type: BottomNavigationBarType.fixed, items: [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label:"JARVIS"),
          BottomNavigationBarItem(icon: Icon(Icons.task), label:"Tarefas"),
          BottomNavigationBarItem(icon: Icon(Icons.developer_board), label:"ARDUINO"),
          BottomNavigationBarItem(icon: Icon(Icons.apps), label:"APPS"),
          BottomNavigationBarItem(icon: Icon(Icons.translate), label:"TRADUTOR"),
          BottomNavigationBarItem(icon: Icon(Icons.wifi), label:"IoT"),
        ])),
      ]),
    ]));
  }
  Widget chatTab(){ return Column(children:[ Expanded(child: ListView.builder(padding: EdgeInsets.all(10), itemCount: chat.length, itemBuilder: (c,i)=> Column(children:[ Align(alignment: Alignment.centerRight, child: Container(margin: EdgeInsets.symmetric(vertical:3), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(16)), child: Text(chat[i]["user"]!, style: TextStyle(color: Colors.white, fontSize:13)))), Align(alignment: Alignment.centerLeft, child: Container(margin: EdgeInsets.symmetric(vertical:3), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF101A2E), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.cyanAccent.withOpacity(0.4))), child: Text(chat[i]["jarvis"]!, style: TextStyle(color: Colors.cyanAccent, fontSize:12))))]))), Container(padding: EdgeInsets.all(8), color: Colors.black, child: Row(children:[ Expanded(child: TextField(controller: input, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "Diga: conectar TV, ligar lâmpada...", hintStyle: TextStyle(color: Colors.white24, fontSize:11), filled: true, fillColor: Color(0xFF141E33), border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none)), onSubmitted: (_)=> enviar())), SizedBox(width:6), FloatingActionButton(mini: true, backgroundColor: Colors.cyanAccent, onPressed: enviar, child: Icon(Icons.send, color: Colors.black))])) ]); }
  Widget tarefaTab(){ return ListView(padding: EdgeInsets.all(16), children:[ Text("📋 ASSISTENTE PESSOAL", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)), ...tarefas.map((t)=> Container(margin: EdgeInsets.symmetric(vertical:3), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF101A2E), borderRadius: BorderRadius.circular(8)), child: Text(t, style: TextStyle(color: Colors.white70, fontSize:12)))).toList() ]); }
  Widget arduinoTab(){ return ListView(padding: EdgeInsets.all(16), children:[ Text("🔧 ARDUINO LAB", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)), DropdownButton<String>(value: placa, isExpanded: true, dropdownColor: Color(0xFF101A2E), style: TextStyle(color: Colors.white), items: ["Arduino Uno","Arduino Mega","ESP32","ESP8266"].map((e)=> DropdownMenuItem(value:e, child: Text(e))).toList(), onChanged: (v)=> setState(()=> placa=v!)), DropdownButton<String>(value: comp, isExpanded: true, dropdownColor: Color(0xFF101A2E), style: TextStyle(color: Colors.white), items: ["LED","HC-SR04","Servo Motor","DHT11"].map((e)=> DropdownMenuItem(value:e, child: Text(e))).toList(), onChanged: (v)=> setState(()=> comp=v!)), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent), onPressed: gerar, child: Text("GERAR CÓDIGO", style: TextStyle(color: Colors.black))), if(codigo.isNotEmpty) Container(margin: EdgeInsets.only(top:10), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.black, border: Border.all(color: Colors.cyanAccent)), child: SelectableText(codigo, style: TextStyle(color: Colors.greenAccent, fontSize:10)))]); }
  Widget appTab(){ return ListView(padding: EdgeInsets.all(16), children:[ Text("📱 DEV STUDIO", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)), Text("Crie apps que controlam TV e lâmpada via Wi-Fi!", style: TextStyle(color: Colors.white60, fontSize:11))]); }
  Widget tradTab(){ return ListView(padding: EdgeInsets.all(16), children:[ TextField(maxLines:3, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "Texto...", filled: true, fillColor: Color(0xFF141E33), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))), onChanged: (v){ tradOrig=v; traduzir(); }), SizedBox(height:10), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent), onPressed: traduzir, child: Text("TRADUZIR", style: TextStyle(color: Colors.black))), Container(margin: EdgeInsets.only(top:10), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.black, border: Border.all(color: Colors.cyanAccent)), child: SelectableText(tradDest, style: TextStyle(color: Colors.greenAccent)))]); }
  Widget iotTab(){
    return Column(children:[
      Container(padding: EdgeInsets.all(12), color: Color(0xFF0F1629), child: Row(children:[
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[ Text("BLUETOOTH & WI-FI", style: TextStyle(color: Colors.cyanAccent, fontSize:12, fontWeight: FontWeight.bold)), Text("${dispositivos.where((d)=> d["conectado"]).length} conectados", style: TextStyle(color: Colors.white38, fontSize:9))])),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: scanning? Colors.orangeAccent: Colors.cyanAccent), onPressed: escanear, child: Text(scanning? "ESCANEANDO...":"ESCANEAR", style: TextStyle(color: Colors.black, fontSize:10)))
      ])),
      Expanded(child: ListView.builder(padding: EdgeInsets.all(10), itemCount: dispositivos.length, itemBuilder: (c,i){
        var d = dispositivos[i];
        return Container(margin: EdgeInsets.only(bottom:8), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: d["conectado"]? Color(0xFF0A1F1A): Color(0xFF101A2E), borderRadius: BorderRadius.circular(12), border: Border.all(color: d["conectado"]? Colors.greenAccent: Colors.cyanAccent.withOpacity(0.2))),
          child: Row(children:[
            Icon(d["icon"], color: d["conectado"]? Colors.greenAccent: Colors.cyanAccent),
            SizedBox(width:10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[ Text(d["nome"], style: TextStyle(color: Colors.white, fontSize:12, fontWeight: FontWeight.bold)), Text(d["status"], style: TextStyle(color: d["conectado"]? Colors.greenAccent: Colors.white38, fontSize:9)) ])),
            Switch(value: d["conectado"], activeColor: Colors.greenAccent, onChanged: (_)=> conectar(i)),
          ]),
        );
      })),
    ]);
  }
}

class HudPainter extends CustomPainter {
  final Animation<double> a; HudPainter(this.a): super(repaint: a);
  @override void paint(Canvas canvas, Size size){ final p=Paint()..style=PaintingStyle.stroke..strokeWidth=0.5..color=Colors.cyanAccent.withOpacity(0.12); canvas.drawCircle(Offset(size.width/2, size.height/2), 180, p); }
  @override bool shouldRepaint(old)=> true;
}
