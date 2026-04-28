import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

String active_user = "";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '') {
      runApp(MyLogin());
    } else {
      active_user = result;
      runApp(MyApp());
    }
  });
}

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String userName = prefs.getString("user_name") ?? '';
  return userName;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory App',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    checkUser().then(
      (value) => setState(() {
        active_user = value;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memorimage - Utama'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                active_user,
              ), // Nama dari global variable [cite: 466]
              accountEmail: const Text("Pemain Aktif"),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events),
              title: const Text("High Score"),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
                Navigator.pushNamed(
                  context,
                  'highscore',
                ); // Rute ke layar High Score
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log Out"),
              onTap: () async {
                // Logika Logout dari PPT [cite: 471]
                final prefs = await SharedPreferences.getInstance();
                prefs.remove("user_name"); // Hapus sesi
                active_user = "";

                // Kembali ke Login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyLogin()),
                );
              },
            ),
          ],
        ),
      ),
      // 2. Body dengan penjelasan cara bermain
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Cara Bermain:",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Ingat gambar yang muncul selama 3 detik. "
                "Pilih jawaban yang benar dari 4 opsi yang tersedia. "
                "Semakin cepat menjawab, semakin tinggi poinmu!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'permainan'); // Lanjut ke game
                },
                child: const Text("PLAY GAME", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
