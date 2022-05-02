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
        primarySwatch: Colors.blue,
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
  double? preco_gasolina;
  double? preco_etanol;

  double _calcularRelacaoEtanolGasolina() {
    return preco_etanol! / preco_gasolina!;
  }

  _buildResultado(BuildContext context) {
    if (preco_etanol != null && preco_gasolina != null) {
      double relacao = _calcularRelacaoEtanolGasolina();
      if (relacao <= 0.7) {
        return Text('É melhor abastecer com etanol');
      } else {
        return Text('É melhor abastecer com gasolina');
      }
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                      onChanged: (value) {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                        } else {
                          setState(() {
                            preco_etanol = null;
                          });
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          preco_etanol = double.parse(value!);
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
                      onChanged: (value) {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                        } else {
                          setState(() {
                            preco_gasolina = null;
                          });
                        }
                      },
                      onSaved: (value) {
                        preco_gasolina = double.parse(value!);
                      },
                    ),
                    SizedBox(
                      height: 40,
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
