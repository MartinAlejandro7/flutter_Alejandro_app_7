class Usuario {
  int idUsuario;
  String cedulaUsuario;
  String nombresUsuario;
  String apellidosUsuarios;
  String correoUsuario;
  String nomloginUsuario;
  String contraseniaUsuario;
  int idRol;

  Usuario({
    required this.idUsuario,
    required this.cedulaUsuario,
    required this.nombresUsuario,
    required this.apellidosUsuarios,
    required this.correoUsuario,
    required this.nomloginUsuario,
    required this.contraseniaUsuario,
    required this.idRol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['idUsuario'] as int,
      cedulaUsuario: json['cedulaUsuario'] as String,
      nombresUsuario: json['nombresUsuario'] as String,
      apellidosUsuarios: json['apellidosUsuarios'] as String,
      correoUsuario: json['correoUsuario'] as String,
      nomloginUsuario: json['nomloginUsuario'] as String,
      contraseniaUsuario: json['contraseniaUsuario'] as String,
      idRol: json['idRol'] as int,
    );
  }
}
