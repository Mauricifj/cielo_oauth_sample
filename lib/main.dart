import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cielo_oauth/cielo_oauth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OAuth Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'OAuth Sample'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<AccessTokenResult> _getToken() {
    var oauth = OAuth(
      clientId: "YOUR-CLIENT-ID",
      clientSecret: "YOUR-CLIENT-SECRET",
      environment: Environment.SANDBOX,
    );
    return oauth.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder(
          future: _getToken(),
          builder: (context, snapshot) {
            final AccessTokenResult result = snapshot.data;
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return CenteredMessage("Unknown error");
                break;
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Loading();
                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  if (result != null) {
                    if (result.accessTokenResponse != null) {
                      return CenteredMessage(
                        "Token: ${result.accessTokenResponse.accessToken.substring(0, 15)}...\n\n"
                        "ExpiresIn: ${result.accessTokenResponse.expiresIn}\n\n"
                        "TokenType: ${result.accessTokenResponse.tokenType}\n\n"
                        "Status Code: ${result.statusCode}",
                        icon: Icons.cake,
                      );
                    } else if (result.errorResponse != null) {
                      return CenteredMessage(
                        "Error description: ${result.errorResponse.errorDescription}\n\n"
                        "Error Code: ${result.errorResponse.error}\n\n"
                        "Status Code: ${result.statusCode}",
                        icon: Icons.block,
                      );
                    }
                  }
                }
                return CenteredMessage(
                  "Error to retrieve token",
                  icon: Icons.warning,
                );
                break;
            }
            return CenteredMessage("Unknown error");
          },
        ));
  }
}

class CenteredMessage extends StatelessWidget {
  final String message;
  final IconData icon;
  final double iconSize;
  final double fontSize;

  CenteredMessage(
    this.message, {
    this.icon,
    this.iconSize = 64,
    this.fontSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Visibility(
            child: Icon(
              icon,
              size: iconSize,
            ),
            visible: icon != null,
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              message,
              style: TextStyle(fontSize: fontSize),
            ),
          )
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  final String message;

  Loading({this.message = "Loading..."});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(backgroundColor: Colors.black),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(message, style: TextStyle(fontSize: 24.0)),
          ),
        ],
      ),
    );
  }
}
