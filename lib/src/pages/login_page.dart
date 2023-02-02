
import 'package:flutter/material.dart';
import 'package:proyectoflutter/src/provider/auth_provider.dart';
import 'package:proyectoflutter/src/routes/routes.dart';
import 'package:proyectoflutter/src/utils/constants.dart';
import 'package:proyectoflutter/src/utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthProvider provider;
  String correo = "";
  String contrasenia = "";

  @override
  void initState() {
    super.initState();
    provider = AuthProvider(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 400,
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage("images/background.jpg"),
                      fit: BoxFit.fitHeight
                    )
                ),
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(
                        margin: const EdgeInsets.only(top: 110),
                        child: const Center(
                          child: Text(
                            "Inicio sesión",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
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
                                color: Color.fromRGBO(131, 90, 48, 1.0),
                                blurRadius: 16.0,
                                offset: Offset(1, 1))
                          ]),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade200)),
                            ),
                            child: TextField(
                              autofocus: false,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Ingrese su email",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
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
                              obscureText: true,
                              autofocus: false,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Ingrese su contraseña",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                              onChanged: (nuevoValor) {
                                setState(() {
                                  contrasenia = nuevoValor;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        validarUsuario();
                      },
                      splashColor: Colors.brown,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(colors: [
                              Color.fromRGBO(245, 147, 119, 1.0),
                              Color.fromRGBO(255, 59, 0, 1.0),
                            ])),
                        child: const Center(
                          child: Text(
                            "INICIAR SESIÓN",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "¿No tienes una cuenta?",
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          child: const Text(
                            "Regístrate",
                            style: TextStyle(
                                color: Color.fromRGBO(131, 37, 10, 1.0),
                                fontWeight: FontWeight.bold),
                          ),
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, RoutePaths.registerPage);
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void validarUsuario() async {
    if (correo.isNotEmpty && contrasenia.isNotEmpty) {
      if (contrasenia.length >= 6) {
        showBarraProgreso(context, "Iniciando sesión");
        dynamic res = await provider.loginUsuario(correo, contrasenia);
        Navigator.of(context).pop();
        if (res != null) {
          mostrarMensaje(context, "Bienvenido.", Constants.MENSAJE_EXITOSO);
          Navigator.pushReplacementNamed(context, RoutePaths.homePage);
        } else {
          mostrarMensaje(
              context, "Error: ${res.code}", Constants.MENSAJE_ERROR);
        }
      } else {
        mostrarMensaje(
            context,
            "La contraseña debe tener al menos 6 caracteres.",
            Constants.MENSAJE_ERROR);
      }
    } else {
      mostrarMensaje(context, "Existen campos vacíos", Constants.MENSAJE_ERROR);
    }
  }
}
