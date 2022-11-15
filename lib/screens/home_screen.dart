import 'package:chords_catalog/models/log.dart';
import 'package:chords_catalog/providers/log_provider.dart';
import 'package:chords_catalog/screens/create_log_screen.dart';
import 'package:chords_catalog/screens/dashboard_screen.dart';
import 'package:chords_catalog/theme/chord_log_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  void _loadLog(Log log, BuildContext context) {
    Provider.of<LogProvider>(context, listen: false).loadLog(log);
    Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration:
            const BoxDecoration(gradient: ChordLogColors.mainBackgroundColor),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Text("Guitar Chord Logs",
                      style: TextStyle(fontSize: 58, fontFamily: 'GreatVibes'),
                      textAlign: TextAlign.center)),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: screenSize.width / 4 * 3,
                height: screenSize.height / 2 * 1,
                child: Card(
                  elevation: 8,
                  child: Container(
                    margin: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          child: const Text('Create New Log'),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(CreateLogScreen.routeName);
                          },
                        ),
                        const SizedBox(height: 16),
                        Container(
                          color: Colors.grey,
                          child: Column(
                            children: [
                              Container(
                                height: 40,
                                color: Colors.blue,
                                child: Row(
                                  children: [
                                    Text('Log 1'),
                                  ],
                                ),
                              
                              ),
                              MediaQuery.removePadding(
                                removeTop: true,
                                context: context,
                                child: FutureBuilder(
                                    future: Log.retrieveSavedLogs(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final List<Log> logs =
                                            snapshot.data as List<Log>;
                                        return ListView.builder(
                                          
                                          itemCount: logs.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () => _loadLog(logs[index], context), // Navigate to dashboard
                                              child: Container(
                                                height: 55,
                                                child: Card(
                                                  color: Colors.red,
                                                  child: Text(logs[index].name)
                                                ),
                                              ),
                                            );
                                          });
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
                                    }),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
