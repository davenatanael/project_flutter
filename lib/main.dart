import 'package:flutter/material.dart';
import 'package:project_uts/game.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'highscore.dart';

String active_user = "";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    //isLoggenIn adalah bool utk mengetahui user sudah log in atau belum
    if (result == '') {
      runApp(const AppRoot(isLoggedIn: false));
    } else {
      active_user = result;
      runApp(const AppRoot(isLoggedIn: true));
    }
  });
}

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String userName = prefs.getString("user_name") ?? '';
  return userName;
}

class AppRoot extends StatelessWidget {
  //isLoggenIn adalah bool utk mengetahui user sudah log in atau belum
  final bool isLoggedIn;
  const AppRoot({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory App',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: isLoggedIn ? const MyHomePage(title: 'Flutter Demo Home Page') : Login(),
      //home:... ini supaya kalau user sudah log in, langsung ke home page.
      routes: {
        'game': (context) => const Game(),
        'highscore': (context) => const Highscore(),
        'login': (context) => Login(),
        'home': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
      },
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
        active_user = value; //assign value active_user
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
              ),
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
              );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log Out"),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.remove("user_name"); //hapus sharedpref saat logout
                active_user = "";
                // pushReplacement supaya layar direplace
                Navigator.pushReplacementNamed(context, 'login');
              },
            ),
          ],
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Kelompok : Kicau Mania, Dave Natanael (160423007) & Kevin  Hendrawan (160422134)",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                "Cara Bermain:",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Ingat gambar yang muncul selama 3 detik per gambar "
                "Pilih jawaban yang benar dari 4 opsi yang tersedia. "
                "Semakin cepat menjawab, semakin tinggi poin",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "Credits: (Unity Store)",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                "Landscape Tiles & Birds (Free) by Kin Ng",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                "Shields - 40 Fantasy Icons by The Higalina Vault",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                "RPG icons free starter pack by icreatepixels",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'game'); 
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
