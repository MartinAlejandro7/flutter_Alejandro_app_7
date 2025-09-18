class Categoria {
  int idCategoria;
  String nombre;

  Categoria({required this.idCategoria, required this.nombre});

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      idCategoria: json['idCategoria'] as int,
      nombre: json['nombre'] as String,
    );
  }
}
