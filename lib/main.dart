import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assistente de abastecimento',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const MyHomePage(title: 'Assistente de abastecimento'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  double? precoDaGasolina;
  double? precoDoEtanol;

  double _calcularRelacaoEtanolGasolina() {
    return precoDoEtanol! / precoDaGasolina!;
  }

  _buildResultado(BuildContext context) {
    var estiloDoTexto = Theme.of(context)
        .textTheme
        .titleLarge
        ?.merge(TextStyle(color: Colors.white));
    if (precoDoEtanol != null && precoDaGasolina != null) {
      double relacao = _calcularRelacaoEtanolGasolina();
      var texto;
      var cor;
      if (relacao <= 0.7) {
        texto = Text(
          'É melhor abastecer com etanol',
          style: estiloDoTexto,
        );
        cor = Colors.green;
      } else {
        texto = Text(
          'É melhor abastecer com gasolina',
          style: estiloDoTexto,
        );
        cor = Colors.blueGrey;
      }
      var caixa = Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cor,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Center(
                child: texto,
              ),
            ),
          ),
        ],
      );
      return caixa;
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text('Forneça o preço do etanol e da gasolina e, '
                  'em seguida, pressione o botão CALCULAR.'),
              SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        prefix: Text('R\$ '),
                        suffix: Text('/litro'),
                        labelText: 'Preço do etanol',
                        helperText: 'Informe o preço do etanol',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o preço do etanol';
                        }
                        try {
                          var a = double.parse(value);
                        } catch (e) {
                          return 'Informe um número válido';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          precoDoEtanol = double.parse(value!);
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        prefix: Text('R\$ '),
                        suffix: Text('/litro'),
                        labelText: 'Preço da gasolina',
                        helperText: 'Informe o preço da gasolina',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o preço da gasolina';
                        }
                        try {
                          var a = double.parse(value);
                        } catch (e) {
                          return 'Informe um número válido';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          precoDaGasolina = double.parse(value!);
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                              } else {
                                setState(() {
                                  precoDoEtanol = null;
                                  precoDaGasolina = null;
                                });
                              }
                            },
                            child: const Text('CALCULAR'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: OutlinedButton(
                            child: Text('LIMPAR'),
                            onPressed: () {
                              _formKey.currentState!.reset();
                              setState(() {
                                precoDoEtanol = null;
                                precoDaGasolina = null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buildResultado(context),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
