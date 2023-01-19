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
                  child: const Text("Chords Log",
                      style: TextStyle(fontSize: 58, fontFamily: 'GreatVibes'),
                      textAlign: TextAlign.center)),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: screenSize.width / 5 * 4,
                height: screenSize.height / 7 * 4,
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
                        Expanded(
                          child: Container(
                            color: ChordLogColors.secondary,
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: ChordLogColors.bodyColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text('Load Previous Logs'),
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
                                              child: SizedBox(
                                                height: 50,
                                                child: Card(
                                                  color: ChordLogColors.primary,
                                                  child: Center(
                                                    child: Text(logs[index].name, style: const TextStyle(color: Colors.white, fontSize: 16),)),
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
                                    }
                                  ),
                                ),
                              ],
                            ),
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
