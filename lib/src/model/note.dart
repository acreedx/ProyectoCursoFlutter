
import 'dart:ffi';

class Todo {
  String? id;
  String userId;
  String titulo;
  String contenido;
  bool estado;
  Todo({required this.userId, required this.titulo, required this.contenido, this.estado = true});

  Todo.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'] as String,
      userId = json['userId'] as String,
      titulo = json['titulo'] as String,
      contenido = json['contenido'] as String,
      estado = json['estado'] as bool;

  Map<String, Object> toMap() {
    return {
      'userId': userId,
      'titulo': titulo,
      'contenido': contenido,
      'estado': estado
    };
  }

}