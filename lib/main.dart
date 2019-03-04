import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?format=json&key=f228edf4';

void main() async {
  runApp(MaterialApp(home: Home()));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("\$ Conversor \$"),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando Dados...",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                  ),
                );
                break;
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao carregar Dados...",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    ),
                  );
                } else {
                  var currencies = List<Widget>();
                  currencies.add(Icon(
                    Icons.monetization_on,
                    color: Colors.amber,
                    size: 150.0,
                  ));
                  print(snapshot.data["results"]["currencies"]);
                  snapshot.data["results"]["currencies"]
                      .forEach((key, currency) => (key == "source")
                          ? currencies.add(TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: "Reais",
                                  labelStyle: TextStyle(color: Colors.amber),
                                  border: OutlineInputBorder()),
                            ))
                          : currencies.add(TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: currency["name"],
                                  labelStyle: TextStyle(color: Colors.amber),
                                  border: OutlineInputBorder()),
                            )));
                  return SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: currencies,
                  ));
                }
            }
          },
        ));
  }
}
