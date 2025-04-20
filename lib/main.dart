import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CheckInternetConnection(),
    );
  }
}

class CheckInternetConnection extends StatefulWidget {
  const CheckInternetConnection({super.key});

  @override
  State<CheckInternetConnection> createState() =>
      _CheckInternetConnectionState();
}

class _CheckInternetConnectionState extends State<CheckInternetConnection> {
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    // Listen for real-time internet changes
    Connectivity().onConnectivityChanged.listen(
      (results) => updateStatus(results),
    );
    checkInternet(); // Check at app start
  }

  void checkInternet() async {
    var results = await Connectivity().checkConnectivity();
    updateStatus(results);
  }

  void updateStatus(List<ConnectivityResult> results) {
    setState(() {
      isConnected = !results.contains(ConnectivityResult.none);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  isConnected
                      ? 'assets/animations/wifi_connected.json'
                      : 'assets/animations/no_internet.json',
                  width: 240,
                  height: 240,
                ),

                const SizedBox(height: 24),

                Text(
                  isConnected ? "Connected" : "No Internet",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: isConnected ? Colors.lightBlue : Colors.red.shade600,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  isConnected
                      ? "You're online now"
                      : "Check your network connection",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),

                const SizedBox(height: 32),

                // Only show Check Again button when there's no internet
                if (!isConnected)
                  ElevatedButton(
                    onPressed: checkInternet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      minimumSize: const Size(120, 36),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh, size: 18),
                        const SizedBox(width: 8),
                        const Text(
                          'Check Again',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
