import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyectoflutter/src/model/contact.dart';
import 'package:proyectoflutter/src/provider/auth_provider.dart';
import 'package:proyectoflutter/src/routes/routes.dart';
import 'package:proyectoflutter/src/utils/constants.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late AuthProvider provider;
  late FirebaseFirestore instance;
  late Stream<QuerySnapshot> noteStream;
  late User? user;

  @override
  Widget build(BuildContext context) {
    provider = AuthProvider(context: context);
    user = provider.getUser();
    instance = FirebaseFirestore.instance;
    noteStream = instance.collection(Constants.CONTACTS)
                  .where(Constants.C_USER_ID, isEqualTo: user!.uid)
                  .snapshots();

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(34, 179, 164, 1.0),
          onPressed: () {
            Navigator.pushNamed(context, RoutePaths.addContactPage);
          },
          child: const Icon(Icons.add,),
        ),
        body: Padding(
          padding: const EdgeInsets.all(5),
          child: StreamBuilder(
            stream: noteStream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.hasError) {
                //mostrarMensaje(context, "No se pudo obtener datos", Constants.MENSAJE_ERROR);
                return const Center(child: Text("Ocurrio un error"),);
              }
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text("Cargando...")
                    ],
                  ),
                );
              }

              var contacts = convertDataToObject(snapshot.data?.docs);

              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12)
                ),
                child: ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: const Color.fromRGBO(174, 226, 214, 1.0),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ListTile(
                            onTap: () {

                            },
                            title: Text(contacts[index].nombre, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            subtitle: Text(contacts[index].telefono, style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red,),
                              onPressed: () {
                                deleteContact(contacts[index]);
                                },
                            ),
                          ),
                        ),
                      );
                    }
                ),
              );
            },
          ),
        )
    );
  }

  Future<void> deleteContact(Contact contact) async {
    await FirebaseFirestore.instance.collection(Constants.CONTACTS).doc(contact.id.toString()).delete().then(
            (value) => print("Documento eliminado"),
            onError: (e) => print("Error eliminando el contacto")
    );
  }


  List<Contact> convertDataToObject(List<QueryDocumentSnapshot>? snapshot) {
    List<Contact> lista = [];
    snapshot?.forEach((element) {
      var dataObtenido = element.data() as Map<String, dynamic>;
      dataObtenido.addAll({ 'id': element.id });
      lista.add(Contact.fromJson(dataObtenido));
    });
    return lista;
  }

}
