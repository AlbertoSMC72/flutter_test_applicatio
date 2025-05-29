import 'package:flutter/material.dart';

class PalindromeChecker extends StatefulWidget {
  @override
  _PalindromeCheckerState createState() => _PalindromeCheckerState();
}

class _PalindromeCheckerState extends State<PalindromeChecker> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  bool _isPalindrome(String text) {
    String clean = text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toLowerCase();
    return clean == clean.split('').reversed.join('');
  }

  void _checkPalindrome() {
    String word = _controller.text.trim();
    if (word.isEmpty) {
      setState(() {
        _result = 'Por favor, ingresa una palabra.';
      });
      return;
    }
    setState(() {
      _result = _isPalindrome(word)
          ? '"$word" es un palíndromo.'
          : '"$word" no es un palíndromo.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verificador de Palíndromos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Ingresa una palabra',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _checkPalindrome(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkPalindrome,
              child: Text('Verificar'),
            ),
            SizedBox(height: 24),
            Text(
              _result,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: PalindromeChecker(),
    );
  }
}
