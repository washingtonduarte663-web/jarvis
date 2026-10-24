import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: JarvisAI()));

class JarvisAI extends StatefulWidget {
  @override State<JarvisAI> createState() => _AIState();
}
class _AIState extends State<JarvisAI> {
  int aba=0;
  final input=TextEditingController();
  final apiKeyController=TextEditingController();
  List<Map<String,String>> chat=[{"user":"Iniciar","jarvis":"JARVIS MARK 4 AI Online! Cole sua API Key do Gemini na aba IA para ativar minha inteligência real!"}];
  String apiKey=""; bool iaAtiva=false; bool carregando=false;
  List<String> tarefas=["Ativar IA do Jarvis"];
  String placa="Arduino Uno"; String comp="LED"; String pino="13"; String codigo="";
  List<Map<String,dynamic>> dispositivos=[
    {"nome":"TV 【entity-Samsung¦canonical_name=Samsung】","icon": Icons.tv,"conectado":false},
    {"nome":"Relógio","icon": Icons.watch,"conectado":true},
    {"nome":"Lâmpada","icon": Icons.lightbulb,"conectado":false},
  ];
  
  Future<void> perguntarIA(String pergunta) async {
    if(apiKey.isEmpty){ setState(()=> chat.add({"user":pergunta,"jarvis":"⚠️ Primeiro vá na aba IA e cole sua API Key do Gemini (aistudio.google.com)!"})); return; }
    setState(()=> carregando=true);
    setState(()=> chat.add({"user":pergunta,"jarvis":"..."}));
    try{
      var url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey");
      var body = jsonEncode({"contents":[{"parts":[{"text":"Você é o JARVIS do Washington Duarte, assistente estilo filme do Homem de Ferro. Responda curto, em PT-BR, com humor. Você configura Arduino ($placa $comp pino $pino), cria apps Flutter e jogos, controla IoT (TV, relógio, lâmpada) via Bluetooth/WiFi, traduz e gerencia tarefas. Pergunta: $pergunta"}]}]});
      var res = await http.post(url, headers: {"Content-Type":"application/json"}, body: body);
      String resposta;
      if(res.statusCode==200){
        var data = jsonDecode(res.body);
        resposta = data["candidates"][0]["content"]["parts"][0]["text"];
        // Se pedir Arduino, gera código
        if(pergunta.toLowerCase().contains("arduino")||pergunta.toLowerCase().contains("led")) gerar();
      } else {
        resposta = "Erro IA: ${res.statusCode} - Verifique sua API Key na aba IA! ${res.body.substring(0,100)}";
      }
      setState(()=> chat.last["jarvis"]=resposta);
    } catch(e){
      setState(()=> chat.last["jarvis"]="Erro de conexão: $e - Verifique internet e API Key!");
    }
    setState(()=> carregando=false);
  }
  void enviar(){ String t=input.text.trim(); if(t.isEmpty) return; input.clear(); perguntarIA(t); }
  void gerar(){ codigo="// Código JARVIS AI - $placa $comp pino $pino\nvoid setup(){ pinMode($pino, OUTPUT); }\nvoid loop(){ digitalWrite($pino, HIGH); delay(500); digitalWrite($pino, LOW); delay(500); }"; setState((){}); }
    @override Widget build(BuildContext context){
    return Scaffold(backgroundColor: Color(0xFF050A14),
      appBar: AppBar(backgroundColor: Colors.black, title: Row(children:[Icon(Icons.memory, color: Colors.cyanAccent), SizedBox(width:8), Text("JARVIS MARK 4 AI", style: TextStyle(color: Colors.cyanAccent, letterSpacing:3, fontSize:14)), Spacer(), Container(padding: EdgeInsets.symmetric(horizontal:8, vertical:4), decoration: BoxDecoration(color: iaAtiva? Colors.green.withOpacity(0.2): Colors.red.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: Text(iaAtiva? "IA ON":"IA OFF", style: TextStyle(color: iaAtiva? Colors.greenAccent: Colors.redAccent, fontSize:9)))])),
      body: Column(children:[
        Expanded(child: [chatTab(), iaTab(), arduinoTab(), iotTab()][aba]),
        Container(height:70, color: Colors.black.withOpacity(0.9), child: BottomNavigationBar(currentIndex: aba, onTap: (i)=> setState(()=> aba=i), backgroundColor: Colors.transparent, selectedItemColor: Colors.cyanAccent, unselectedItemColor: Colors.white24, type: BottomNavigationBarType.fixed, items: [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label:"JARVIS AI"),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label:"IA SETUP"),
          BottomNavigationBarItem(icon: Icon(Icons.developer_board), label:"ARDUINO"),
          BottomNavigationBarItem(icon: Icon(Icons.wifi), label:"IoT TV/Relógio"),
        ])),
      ]),
    );
  }
  Widget chatTab(){ return Column(children:[ Expanded(child: ListView.builder(padding: EdgeInsets.all(10), itemCount: chat.length, itemBuilder: (c,i)=> Column(children:[
    Align(alignment: Alignment.centerRight, child: Container(margin: EdgeInsets.symmetric(vertical:3), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(16)), child: Text(chat[i]["user"]!, style: TextStyle(color: Colors.white, fontSize:13)))),
    Align(alignment: Alignment.centerLeft, child: Container(margin: EdgeInsets.symmetric(vertical:3), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF101A2E), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.cyanAccent.withOpacity(0.4))), child: Text(chat[i]["jarvis"]!, style: TextStyle(color: Colors.cyanAccent, fontSize:12)))),
  ]))), if(carregando) LinearProgressIndicator(color: Colors.cyanAccent), Container(padding: EdgeInsets.all(8), color: Colors.black, child: Row(children:[ Expanded(child: TextField(controller: input, style: TextStyle(color: Colors.white), decoration: InputDecoration(hintText: iaAtiva? "Pergunte qualquer coisa ao JARVIS com IA...":"Ative a IA primeiro na aba IA", hintStyle: TextStyle(color: Colors.white24, fontSize:11), filled: true, fillColor: Color(0xFF141E33), border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none)), onSubmitted: (_)=> enviar())), SizedBox(width:6), FloatingActionButton(mini: true, backgroundColor: Colors.cyanAccent, onPressed: enviar, child: Icon(Icons.send, color: Colors.black))])) ]); }
  Widget iaTab(){ return ListView(padding: EdgeInsets.all(16), children:[
    Text("🧠 ATIVAR INTELIGÊNCIA ARTIFICIAL", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize:16)),
    SizedBox(height:12),
    Container(padding: EdgeInsets.all(12), decoration: BoxDecoration(color: Color(0xFF101A2E), borderRadius: BorderRadius.circular(10)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
      Text("1. Vá em aistudio.google.com/app/apikey", style: TextStyle(color: Colors.white70, fontSize:11)),
      Text("2. Crie API Key grátis", style: TextStyle(color: Colors.white70, fontSize:11)),
      Text("3. Cole aqui embaixo:", style: TextStyle(color: Colors.white70, fontSize:11)),
    ])),
    SizedBox(height:12),
    TextField(controller: apiKeyController, style: TextStyle(color: Colors.white), decoration: InputDecoration(labelText: "Cole sua Gemini API Key aqui", labelStyle: TextStyle(color: Colors.white54), filled: true, fillColor: Color(0xFF141E33), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))), onChanged: (v)=> apiKey=v),
    SizedBox(height:12),
    ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, padding: EdgeInsets.all(14)), onPressed: (){ setState(()=> apiKey=apiKeyController.text.trim()); setState(()=> iaAtiva=apiKey.isNotEmpty); chat.add({"user":"Ativar IA","jarvis": iaAtiva? "✅ IA ATIVADA! Agora sou inteligente de verdade, Washington! Pergunte qualquer coisa!" : "❌ Cole a API Key!"}); setState(()=> aba=0); }, child: Text("ATIVAR IA DO JARVIS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
    SizedBox(height:16),
    Text("Com IA o JARVIS vai:", style: TextStyle(color: Colors.white70, fontSize:12)),
    Text("• Responder qualquer pergunta\n• Criar código Arduino perfeito\n• Criar apps e jogos completos\n• Controlar TV, relógio via texto\n• Traduzir com contexto", style: TextStyle(color: Colors.cyanAccent, fontSize:11)),
  ]); }
  Widget arduinoTab(){ return ListView(padding: EdgeInsets.all(16), children:[ Text("🔧 【entity-ARDUINO¦canonical_name=Arduino】 LAB AI", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)), DropdownButton<String>(value: placa, isExpanded: true, dropdownColor: Color(0xFF101A2E), style: TextStyle(color: Colors.white), items: ["Arduino Uno","ESP32","ESP8266"].map((e)=> DropdownMenuItem(value:e, child: Text(e))).toList(), onChanged: (v)=> setState(()=> placa=v!)), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent), onPressed: gerar, child: Text("GERAR CÓDIGO", style: TextStyle(color: Colors.black))), if(codigo.isNotEmpty) Container(margin: EdgeInsets.only(top:10), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.black, border: Border.all(color: Colors.cyanAccent)), child: SelectableText(codigo, style: TextStyle(color: Colors.greenAccent, fontSize:10)))]); }
  Widget iotTab(){ return ListView(padding: EdgeInsets.all(16), children:[ Text("📡 IoT - TV, RELÓGIO, LÂMPADAS", style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)), SizedBox(height:10), ...dispositivos.map((d)=> ListTile(leading: Icon(d["icon"], color: Colors.cyanAccent), title: Text(d["nome"], style: TextStyle(color: Colors.white, fontSize:12)), trailing: Switch(value: d["conectado"], activeColor: Colors.greenAccent, onChanged: (v)=> setState(()=> d["conectado"]=v)))).toList(), Container(margin: EdgeInsets.only(top:10), padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Color(0xFF101A2E), borderRadius: BorderRadius.circular(8)), child: Text("Com IA: Diga 'Ligar TV da sala' ou 'Conectar relógio' que a IA entende e conecta!", style: TextStyle(color: Colors.white60, fontSize:11))) ]); }
}
