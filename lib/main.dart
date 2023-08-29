import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: 'Pem_Certificate_Client'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('https://192.168.56.1:5000/home/'));

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> data = json.decode(response.body);

      // Now, you can work with the data
      print(data);
    } else {
      // Handle errors
      print('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchData,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}



  // // Future<void> fetchData() async {
  //   final p12File = File('assets\fluttercertificate+4.p12');
  //   final p12Bytes = await p12File.readAsBytes();

  //   const String password = 'Passw0rd!';

  //   // Create a security context with the P12 certificate
  //   final securityContext = SecurityContext.defaultContext;
  //   securityContext.useCertificateChainBytes(Uint8List.fromList(p12Bytes),
  //       password: password);
  //   securityContext.usePrivateKeyBytes(Uint8List.fromList(p12Bytes),
  //       password: password);

  //   final client = HttpClient(context: securityContext);

  //   try {
  //     final request = await client.getUrl(
  //       Uri.parse('https://localhost:5000/swagger/index.html'),
  //     );

  //     final response = await request.close();

  //     if (response.statusCode == HttpStatus.ok) {
  //       final responseBody = await response.transform(utf8.decoder).join();
  //       print('Response data: $responseBody}');
  //     } else {
  //       // Handle errors
  //       print('Request failed with status: ${response.statusCode}');
  //     }
  //   } finally {
  //     client.close();
  //   }
  // }
