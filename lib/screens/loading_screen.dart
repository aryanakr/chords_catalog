import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final Future<dynamic> future;
  final Function(Future<dynamic>) onLoaded;
  final String navigationRoute;

  LoadingScreen(
      {Key? key,
      required this.future,
      required this.onLoaded,
      required this.navigationRoute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            onLoaded(future).then((value) {
              Navigator.pushReplacementNamed(context, navigationRoute);
            });

            return const Center(
              child: Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 60,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
