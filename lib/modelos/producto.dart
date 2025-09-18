class Producto {
  int idProductos;
  String nombre;
  String descripcion;
  double precio;
  int idCategoria;

  Producto({
    required this.idProductos,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.idCategoria,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProductos: json['idProductos'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      precio: double.parse(json['precio'].toString()),
      idCategoria: json['idCategoria'] as int,
    );
  }
}
