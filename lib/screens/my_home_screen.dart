import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'scrumboard_screen.dart';

//Create homepage state
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//Homepage screen
class _MyHomePageState extends State<MyHomePage> {
  //Controllers for text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //Token to acces API
  late String _token;

  //Method to handle login process
  Future<bool> _login() async {
    //Gets information from the text fields via the controller
    final username = _usernameController.text;
    final password = _passwordController.text;

    //List of strings with the path to my local certificates
    final assetNames = [
      'assets/local-cert+4-client.pem',
      'assets/local-cert+4-client-key.pem',
      'assets/rootCA.pem'
    ];

    //Loads the certificates an saves them as a Uint8List
    final List<Uint8List> assetBytes =
        await Future.wait(assetNames.map((assetName) async {
      final ByteData assetData = await rootBundle.load(assetName);
      return assetData.buffer.asUint8List();
    }));

    //Create securityContext
    final SecurityContext securityContext = SecurityContext()
      ..useCertificateChainBytes(assetBytes[0])
      ..usePrivateKeyBytes(assetBytes[1])
      ..setTrustedCertificatesBytes(assetBytes[2]);
    HttpClient.enableTimelineLogging = true;

    //Create Http Client using the newly created security context
    final HttpClient client = HttpClient(context: securityContext);

    //Opens http connection
    final request = await client.postUrl(
      Uri.parse('https://192.168.56.1:5000/home/login'),
    );

    //Create the request
    request.headers.set('Content-Type', 'application/json');
    final jsonBody =
        jsonEncode({'name': username, 'password': password, 'id': ""});
    request.write(jsonBody);

    //Sends request, and reacts to the answer, based on the API response. Or prints the error if something is wrong with the request
    try {
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseData =
            json.decode(await response.transform(utf8.decoder).join());
        final token = responseData['token'];
        setState(() {
          _token = token;
        });

        print('Login successful. Token: $_token');
        return true;
      } else {
        print('Authentication failed. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  bool authrorized = await _login();
                  if (authrorized) {
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScrumboardScreen()),
                    );
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 20),
              Text('Token: $_token'),
            ],
          ),
        ),
      ),
    );
  }
}
