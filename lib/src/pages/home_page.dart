import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyectoflutter/src/pages/contacts_page.dart';
import 'package:proyectoflutter/src/pages/todos_page.dart';
import 'package:proyectoflutter/src/pages/profile_page.dart';
import 'package:proyectoflutter/src/provider/auth_provider.dart';
import 'package:proyectoflutter/src/routes/routes.dart';
import 'package:proyectoflutter/src/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class _HomePageState extends State<HomePage> {
  late AuthProvider provider;
  late List<UserInfo> providerProfile;
  int selectedPage = 0;
  final pagesc = [ProfilePage(), NotesPage(), ContactsPage()];
  final drawerItems = [
    DrawerItem("Inicio", Icons.home),
    DrawerItem("Favoritos", Icons.star),
    DrawerItem("Imagenes", Icons.image),
    DrawerItem("Perfil", Icons.person),
  ];

  @override
  void initState() {
    super.initState();
    provider = AuthProvider(context: context);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < drawerItems.length; i++) {
      drawerOptions.add(ListTile(
        title: Text(drawerItems[i].title),
        leading: Icon(drawerItems[i].icon),
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('TO-DO APP'),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                cerrarSesion();
              })
        ],
        backgroundColor: const Color.fromRGBO(128, 197, 132, 1.0),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(provider.getUser()!.displayName.toString()),
              accountEmail: Text(provider.getUser()!.email.toString()),
              currentAccountPicture: GestureDetector(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 34,
                    backgroundImage: Image.network(provider.getUser()!.photoURL.toString()).image,
                  ),
                ),
                onTap: () {},
              ),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Colors.greenAccent,
                    Colors.green,
                    Colors.green.shade900
                  ])),
            ),
            Column(
              children: drawerOptions,
            )
          ],
        ),
      ),
      body: pagesc[selectedPage],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(right: 15, left: 15),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 5, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Inicio',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.note_add),
                label: 'To-Do',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.contacts),
                label: 'Contactos',
              ),
            ],
            currentIndex: selectedPage,
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color.fromRGBO(95, 148, 88, 1.0),
            fixedColor: Colors.white,
            unselectedItemColor: Colors.black12,
            onTap: (index) {
              setState(() {
                selectedPage = index;
              });
            },
          ),
        ),
      ),
    );
  }

  cerrarSesion() async {
    await provider.logOut();
    Navigator.pushReplacementNamed(context, RoutePaths.loginPage);
    mostrarMensaje(context, "Se cerro sesion", 2);
  }
}
