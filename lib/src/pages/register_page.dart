import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyectoflutter/src/provider/auth_provider.dart';
import 'package:proyectoflutter/src/routes/routes.dart';
import 'package:proyectoflutter/src/utils/constants.dart';
import 'package:proyectoflutter/src/utils/utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late AuthProvider provider;
  String correo = "";
  String contrasenia = "";
  String usuario = "";
  @override
  Widget build(BuildContext context) {
    provider = AuthProvider(context: context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 400,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/background2.png'),
                        fit: BoxFit.fill
                    )
                ),
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(
                        margin: const EdgeInsets.only(top: 110),
                        child: const Center(
                          child: Text("Registro", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30.0, left: 30.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Color.fromRGBO(49, 144, 252, 0.2),
                                blurRadius: 16.0,
                                offset: Offset(1, 1)
                            )
                          ]
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                            ),
                            child: TextField(
                              autofocus: false,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Ingrese su nombre de Usuario",
                                  hintStyle: TextStyle(color: Colors.grey[400])
                              ),
                              onChanged: (nuevoValor) {
                                setState(() {
                                  usuario = nuevoValor;
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                            ),
                            child: TextField(
                              autofocus: false,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Ingrese su email",
                                  hintStyle: TextStyle(color: Colors.grey[400])
                              ),
                              onChanged: (nuevoValor) {
                                setState(() {
                                  correo = nuevoValor;
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              autofocus: false,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Ingrese su contraseña",
                                  hintStyle: TextStyle(color: Colors.grey[400])
                              ),
                              onChanged: (nuevoValor) {
                                setState(() {
                                  contrasenia = nuevoValor;
                                });
                              },
                            ),
                          ),

                        ],
                      ),
                    ),
                    const SizedBox(height: 30,),
                    InkWell(
                      onTap: () {
                        validarUsuario();
                      },
                      splashColor: Colors.blue,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                                colors: [
                                  Color.fromRGBO(143, 201, 251, 1.0),
                                  Color.fromRGBO(32, 97, 149, 0.6),
                                ]
                            )
                        ),
                        child: const Center(
                          child: Text("REGISTRARSE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿Ya tienes una cuenta?", style: TextStyle(color: Colors.black54),),
                        const SizedBox(width: 10,),
                        GestureDetector(
                          child: const Text("Inicia Sesión", style: TextStyle(color: Color.fromRGBO(32, 97, 149, 0.6), fontWeight: FontWeight.bold),),
                          onTap: () {
                            Navigator.pushReplacementNamed(context, RoutePaths.loginPage);
                          },
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

  String fotoRandom() {
    final _random = new Random();
    List<String> imagenes = [
      "https://cdn-icons-png.flaticon.com/128/4140/4140061.png",
      "https://cdn-icons-png.flaticon.com/128/9366/9366576.png",
      "https://cdn-icons-png.flaticon.com/128/4086/4086679.png",
      "https://cdn-icons-png.flaticon.com/128/9380/9380147.png",
      "https://cdn-icons-png.flaticon.com/128/4140/4140047.png",
      "https://cdn-icons-png.flaticon.com/128/145/145843.png",
      "https://cdn-icons-png.flaticon.com/128/4140/4140051.png",
      "https://cdn-icons-png.flaticon.com/128/147/147144.png",
      "https://cdn-icons-png.flaticon.com/128/4128/4128176.png"
    ];
    return imagenes[_random.nextInt(imagenes.length)];
  }
  void validarUsuario() async{
    if(correo.isNotEmpty && contrasenia.isNotEmpty && contrasenia.isNotEmpty) {
      if(contrasenia.length >= 6) {
        showBarraProgreso(context, "Registrando");
        var res = await provider.registrarUsuario(correo, contrasenia);
        await FirebaseAuth.instance.currentUser!.updateDisplayName(usuario);
        await FirebaseAuth.instance.currentUser!.updatePhotoURL(fotoRandom());
        Navigator.of(context).pop();
        if(res != null) {
          mostrarMensaje(context, "Registro exitoso", Constants.MENSAJE_EXITOSO);
          Navigator.pushReplacementNamed(context, RoutePaths.loginPage);
        } else {
          mostrarMensaje(context, "Error: ${res.code}", Constants.MENSAJE_ERROR);
          Navigator.of(context).pop();
        }
      } else {
        mostrarMensaje(context, "La contraseña debe tener al menos 6 caracteres.", Constants.MENSAJE_ERROR);
      }
    } else {
      mostrarMensaje(context, "Existen campos vacíos", Constants.MENSAJE_ERROR);
    }
  }
}


