import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: JarvisMark3()));

class JarvisMark3 extends StatefulWidget {
  @override State<JarvisMark3> createState() => _Mark3State();
}

class _Mark3State extends State<JarvisMark3> with TickerProviderStateMixin {
  int aba = 0;
  final input = TextEditingController();
  final tts = FlutterTts();
  bool isFriday = false;
  List<Map<String,String>> chat = [];
  List<String> tarefas = ["Configurar 【entity-Arduino¦canonical_name=arduino】 UNO", "Criar app Jarvis", "Testar voz do filme"];
  String placa = "【entity-Arduino¦canonical_name=arduino】 Uno";
  String componente = "LED";
  String pino = "13";
  String codigo = "";
  String tradutorOrigem = "";
  String tradutorDestino = "";
  String idiomaOrigem = "PT";
  String idiomaDestino = "EN";
  late AnimationController reactorController;
  
  @override
  void initState(){
    super.initState();
    reactorController = AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat();
    initTts();
    chat.add({"user":"Jarvis iniciar","jarvis": isFriday ? "Good morning Washington, Friday is online. All systems operational." : "Bom dia Washington! JARVIS MARK 3 Movie Edition online! Sistemas de 【entity-Arduino¦canonical_name=arduino】, Dev e Tradução ativos. Como posso ajudar?"});
    falar(chat.last["jarvis"]!);
  }

  initTts() async {
    await tts.setLanguage(isFriday ? "en-US" : "pt-BR");
    await tts.setSpeechRate(isFriday ? 0.48 : 0.52);
    await tts.setPitch(isFriday ? 1.0 : 0.85);
    await tts.setVolume(1.0);
  }

  trocarPersonalidade() async {
    setState(()=> isFriday = !isFriday);
    await initTts();
    String msg = isFriday ? "Switching to Friday. Hello Washington, I'm Friday." : "Voltando para JARVIS. Olá Washington, voz do filme ativada!";
    setState(()=> chat.add({"user":"Trocar para ${isFriday?'FRIDAY':'JARVIS'}","jarvis":msg}));
    falar(msg);
  }

  falar(String txt) async {
    String limpo = txt.replaceAll(RegExp(r'[^\w\s.,!?áéíóúÁÉÍÓÚãõÃÕçÇ]'), '');
    await tts.speak(limpo);
  }
    enviar(){
    String t = input.text.trim();
    if(t.isEmpty) return;
    processar(t);
    input.clear();
  }

  processar(String t){
    String l = t.toLowerCase();
    String r = "";
    if(l.contains("【entity-arduino¦canonical_name=arduino】") || l.contains("led") || l.contains("sensor") || l.contains("esp32")){
      setState(()=> aba=2);
      if(l.contains("led")) componente="LED";
      if(l.contains("ultrassonico")||l.contains("hc-sr04")) componente="HC-SR04";
      if(l.contains("servo")) componente="Servo Motor";
      if(l.contains("esp32")) placa="ESP32";
      gerarCodigo();
      r = isFriday ? "【entity-Arduino¦canonical_name=arduino】 configuration generated in 【entity-Arduino¦canonical_name=arduino】 tab, Washington." : "🔧 Código 【entity-Arduino¦canonical_name=arduino】 gerado na aba 【entity-ARDUINO¦canonical_name=arduino】! Placa: $placa, Componente: $componente no pino $pino!";
    } else if(l.contains("app") || l.contains("aplicativo") || l.contains("flutter")){
      setState(()=> aba=3);
      r = isFriday ? "App development module open." : "📱 Aba DEV aberta! Posso gerar estrutura de App Flutter!";
    } else if(l.contains("jogo") || l.contains("game")){
      setState(()=> aba=3);
      r = isFriday ? "Game development protocols ready." : "🎮 Vamos criar jogos! Qual tipo de jogo?";
    } else if(l.contains("traduz") || l.contains("translate")){
      setState(()=> aba=4);
      tradutorOrigem = t;
      traduzir();
      r = isFriday ? "Translator activated." : "🌍 Tradutor ativado! Aba TRADUTOR!";
    } else if(l.contains("tarefa")){
      String task = t.replaceAll(RegExp(r'tarefa|adicionar', caseSensitive: false), '').trim();
      if(task.length<2) task=t;
      setState(()=> tarefas.add(task));
      r = isFriday ? "Task added: $task" : "✅ Tarefa adicionada: $task";
    } else {
      r = isFriday ? "Understood: '$t'." : "Entendi: '$t'. Sou JARVIS MARK 3 - Arduino, Apps, Jogos, Tradutor!";
    }
    setState(()=> chat.add({"user":t,"jarvis":r}));
    falar(r);
  }

  traduzir(){
    Map<String,String> dic = {"oi":"hello","olá":"hello","bom dia":"good morning","obrigado":"thank you","arduino":"arduino","led":"led","aplicativo":"app","jogo":"game","tarefa":"task"};
    String texto = tradutorOrigem.toLowerCase();
    String traducao = tradutorOrigem;
    dic.forEach((pt,en){ if(texto.contains(pt)) traducao = traducao.replaceAll(RegExp(pt, caseSensitive: false), idiomaDestino=="EN"?en:pt); });
    if(traducao==tradutorOrigem) traducao = idiomaDestino=="EN" ? "[EN] $tradutorOrigem" : "[PT] $tradutorOrigem";
    setState(()=> tradutorDestino = traducao);
  }

  gerarCodigo(){
    if(componente=="LED"){
      codigo = """// JARVIS MARK 3 - $placa - Washington
void setup() {
  pinMode($pino, OUTPUT);
  Serial.begin(9600);
  Serial.println("JARVIS: LED Online");
}
void loop() {
  digitalWrite($pino, HIGH); delay(800);
  digitalWrite($pino, LOW); delay(800);
}""";
    } else if(componente=="HC-SR04"){
      codigo = """// JARVIS MARK 3 - HC-SR04 - $placa
const int trig = 9, echo = 10;
void setup(){
  Serial.begin(9600);
  pinMode(trig, OUTPUT); pinMode(echo, INPUT);
}
void loop(){
  digitalWrite(trig, LOW); delayMicroseconds(2);
  digitalWrite(trig, HIGH); delayMicroseconds(10);
  digitalWrite(trig, LOW);
  float d = pulseIn(echo, HIGH) * 0.034 / 2;
  Serial.println(d); delay(500);
}""";
    } else {
      codigo = "// JARVIS MARK 3 - $componente - $placa pino $pino - Pronto!";
    }
    setState((){});
  }
    @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFF050A14),
      body: Stack(children:[
        Positioned.fill(child: CustomPaint(painter: HudPainter(reactorController))),
        Column(children:[
          Container(height: 70, padding: EdgeInsets.only(top: 28, left: 12, right: 12), color: Colors.black.withOpacity(0.8), child: Row(children:[
            RotationTransition(turns: reactorController, child: Icon(Icons.settings, color: isFriday? Colors.orangeAccent : Colors.cyanAccent, size: 28)),
            SizedBox(width:10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
              Text(isFriday ? "F.R.I.D.A.Y" : "J.A.R.V.I.S", style: TextStyle(color: isFriday? Colors.orangeAccent : Colors.cyanAccent, fontSize: 18, letterSpacing: 4, fontWeight: FontWeight.bold)),
              Text("MARK 3 - MOVIE", style: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 2)),
            ]),
            Spacer(),
            GestureDetector(onTap: trocarPersonalidade, child: Container(padding: EdgeInsets.symmetric(horizontal:10, vertical:6), decoration: BoxDecoration(border: Border.all(color: isFriday? Colors.orangeAccent: Colors.cyanAccent), borderRadius: BorderRadius.circular(20)), child: Text(isFriday? "JARVIS" : "FRIDAY", style: TextStyle(color: isFriday? Colors.orangeAccent: Colors.cyanAccent, fontSize:10)))),
            SizedBox(width:8),
            Icon(Icons.circle, color: Colors.greenAccent, size:10),
          ])),
          Expanded(child: [chatTab(), devTab(), arduinoTab(), devAppTab(), tradutorTab()][aba]),
          Container(height: 72, color: Colors.black.withOpacity(0.9), child: BottomNavigationBar(currentIndex: aba, onTap: (i)=> setState(()=> aba=i), backgroundColor: Colors.transparent, selectedItemColor: isFriday? Colors.orangeAccent : Colors.cyanAccent, unselectedItemColor: Colors.white24, type: BottomNavigationBarType.fixed, items: [
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: "JARVIS"),
            BottomNavigationBarItem(icon: Icon(Icons.developer_mode), label: "DEV"),
            BottomNavigationBarItem(icon: Icon(Icons.developer_board), label: "ARDUINO"),
            BottomNavigationBarItem(icon: Icon(Icons.videogame_asset), label: "APPS"),
            BottomNavigationBarItem(icon: Icon(Icons.translate), label: "TRADUTOR"),
          ])),
        ]),
      ]),
    );
  }

  Widget chatTab(){
    return Column(children:[
      Container(height:32, child: ListView(scrollDirection: Axis.horizontal, padding: EdgeInsets.all(4), children:[
        _hudChip("${tarefas.length} TASKS"), _hudChip("${chat.length} LOGS"), _hudChip(isFriday? "FRIDAY VOICE":"JARVIS FILME"), _hudChip("TRANSLATOR ON"),
      ])),
      Expanded(child: ListView.builder(padding: EdgeInsets.all(10), itemCount: chat.length, itemBuilder: (c,i)=> Column(children:[
        Align(alignment: Alignment.centerRight, child: Container(margin: EdgeInsets.symmetric(vertical:4), padding: EdgeInsets.symmetric(horizontal:14, vertical:10), decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blueAccent, Colors.blue]), borderRadius: BorderRadius.circular(16)), child: Text(chat[i]["user"]!, style: TextStyle(color: Colors.white, fontSize:13)))),
        Align(alignment: Alignment.centerLeft, child: Container(margin: EdgeInsets.symmetric(vertical:4), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF101A2E), borderRadius: BorderRadius.circular(16), border: Border.all(color: (isFriday? Colors.orangeAccent: Colors.cyanAccent).withOpacity(0.5))), child: Text(chat[i]["jarvis"]!, style: TextStyle(color: isFriday? Colors.orangeAccent: Colors.cyanAccent, fontSize:12)))),
      ]))),
      Container(padding: EdgeInsets.all(8), color: Colors.black, child: Row(children:[
        IconButton(icon: Icon(Icons.mic, color: isFriday? Colors.orangeAccent: Colors.cyanAccent), onPressed: ()=> falar(isFriday? "Listening Washington": "Escutando Washington")),
        Expanded(child: TextField(controller: input, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: isFriday? "Talk to FRIDAY..." : "Fale com JARVIS filme...", hintStyle: TextStyle(color: Colors.white24, fontSize:11), filled: true, fillColor: Color(0xFF141E33), border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none)), onSubmitted: (_)=> enviar())),
        SizedBox(width:6),
        FloatingActionButton(mini: true, backgroundColor: isFriday? Colors.orangeAccent: Colors.cyanAccent, onPressed: enviar, child: Icon(Icons.send, color: Colors.black)),
      ])),
    ]);
  }

  Widget devTab(){
    return ListView(padding: EdgeInsets.all(16), children:[
      Text("🧠 TAREFAS PESSOAIS", style: TextStyle(color: Colors.cyanAccent, fontSize:14, fontWeight: FontWeight.bold)),
      SizedBox(height:12),
      ...tarefas.map((t)=> Container(margin: EdgeInsets.symmetric(vertical:4), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF101A2E), borderRadius: BorderRadius.circular(10)), child: Row(children:[Icon(Icons.task_alt, color: Colors.cyanAccent, size:16), SizedBox(width:8), Expanded(child: Text(t, style: TextStyle(color: Colors.white70, fontSize:12))), IconButton(icon: Icon(Icons.delete, size:16, color: Colors.white24), onPressed: ()=> setState(()=> tarefas.remove(t)))]))).toList(),
    ]);
  }
    Widget arduinoTab(){
    return ListView(padding: EdgeInsets.all(16), children:[
      Text("🔧 【entity-ARDUINO¦canonical_name=arduino】 LAB", style: TextStyle(color: isFriday? Colors.orangeAccent: Colors.cyanAccent, fontWeight: FontWeight.bold)),
      SizedBox(height:12),
      _drop("Placa", placa, ["【entity-Arduino¦canonical_name=arduino】 Uno","【entity-Arduino¦canonical_name=arduino】 Mega","ESP32","ESP8266","Arduino Nano"], (v)=> setState(()=> placa=v!)),
      _drop("Componente", componente, ["LED","HC-SR04","Servo Motor","DHT11","Buzzer","LCD 16x2"], (v)=> setState(()=> componente=v!)),
      SizedBox(height:14),
      ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: isFriday? Colors.orangeAccent: Colors.cyanAccent, padding: EdgeInsets.all(14)), onPressed: gerarCodigo, child: Text("GERAR CÓDIGO", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
      if(codigo.isNotEmpty) Container(margin: EdgeInsets.only(top:14), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10), border: Border.all(color: isFriday? Colors.orangeAccent: Colors.cyanAccent)), child: SelectableText(codigo, style: TextStyle(color: Colors.greenAccent, fontSize:10, fontFamily: "monospace"))),
    ]);
  }

  Widget devAppTab(){
    return ListView(padding: EdgeInsets.all(16), children:[
      Text("📱 DEV STUDIO - APPS & JOGOS", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
      SizedBox(height:12),
      _devCard("FLUTTER APP", "Criar app igual JARVIS", "flutter create meu_app"),
      _devCard("JOGO FLAPPY", "Gravidade e colisão", "class Game { update(){} }"),
      _devCard("ARDUINO + APP", "App controla Arduino", "BluetoothSerial"),
      Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF101A2E), borderRadius: BorderRadius.circular(10)), child: Text("💡 Diga 'criar app de tarefas' ou 'criar jogo da cobrinha' que eu gero!", style: TextStyle(color: Colors.white70, fontSize:11))),
    ]);
  }

  Widget tradutorTab(){
    return ListView(padding: EdgeInsets.all(16), children:[
      Row(children:[
        _langChip("PT", idiomaOrigem=="PT", ()=> setState(()=> idiomaOrigem="PT")),
        Icon(Icons.compare_arrows, color: Colors.cyanAccent),
        _langChip("EN", idiomaOrigem=="EN", ()=> setState(()=> idiomaOrigem="EN")),
        Spacer(), Text("TRADUTOR", style: TextStyle(color: Colors.cyanAccent, fontSize:10)),
      ]),
      SizedBox(height:12),
      TextField(maxLines: 4, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: "Digite...", filled: true, fillColor: Color(0xFF141E33), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), onChanged: (v){ tradutorOrigem=v; traduzir(); }),
      SizedBox(height:10),
      ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent), onPressed: traduzir, child: Text("TRADUZIR", style: TextStyle(color: Colors.black))),
      SizedBox(height:12),
      Container(minHeight:100, padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.cyanAccent)), child: SelectableText(tradutorDestino.isEmpty? "Tradução..." : tradutorDestino, style: TextStyle(color: Colors.greenAccent))),
      SizedBox(height:12),
      ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF101A2E)), onPressed: ()=> falar(tradutorDestino), icon: Icon(Icons.volume_up, color: Colors.cyanAccent), label: Text("FALAR COM VOZ DO FILME", style: TextStyle(color: Colors.cyanAccent, fontSize:10))),
    ]);
  }

  Widget _drop(String label, String val, List<String> items, Function(String?) onC){
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
      Text(label, style: TextStyle(color: Colors.white54, fontSize:10)),
      DropdownButton<String>(value: val, isExpanded: true, dropdownColor: Color(0xFF101A2E), style: TextStyle(color: Colors.white), items: items.map((e)=> DropdownMenuItem(value:e, child: Text(e, style: TextStyle(fontSize:12)))).toList(), onChanged: onC),
      SizedBox(height:8),
    ]);
  }
  Widget _hudChip(String t)=> Container(margin: EdgeInsets.only(right:6), padding: EdgeInsets.symmetric(horizontal:8, vertical:4), decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)), child: Text(t, style: TextStyle(color: Colors.white54, fontSize:8)));
  Widget _langChip(String txt, bool sel, VoidCallback on){ return GestureDetector(onTap: on, child: Container(margin: EdgeInsets.all(4), padding: EdgeInsets.symmetric(horizontal:12, vertical:6), decoration: BoxDecoration(color: sel? Colors.cyanAccent: Colors.white10, borderRadius: BorderRadius.circular(12)), child: Text(txt, style: TextStyle(color: sel? Colors.black: Colors.white70, fontWeight: FontWeight.bold, fontSize:12)))); }
  Widget _devCard(String title, String desc, String code){ return Container(margin: EdgeInsets.only(bottom:10), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF101A2E), borderRadius: BorderRadius.circular(10)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[Text(title, style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize:12)), Text(desc, style: TextStyle(color: Colors.white60, fontSize:10)), Container(margin: EdgeInsets.only(top:6), padding: EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6)), child: Text(code, style: TextStyle(color: Colors.greenAccent, fontSize:9)))])); }
}

class HudPainter extends CustomPainter {
  final Animation<double> animation;
  HudPainter(this.animation): super(repaint: animation);
  @override void paint(Canvas canvas, Size size){
    final p = Paint()..style=PaintingStyle.stroke..strokeWidth=0.5..color=Colors.cyanAccent.withOpacity(0.15);
    canvas.drawCircle(Offset(size.width/2, size.height/2), 200, p);
    canvas.drawCircle(Offset(size.width/2, size.height/2), 220, p);
  }
  @override bool shouldRepaint(old)=> true;
}
