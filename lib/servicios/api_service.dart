class ApiService {
  final String baseUrl = "http://192.168.100.91/APIJAPON_V1/APIAPPJAPON";

  String urlLogin() => '$baseUrl/login.php';
  String urlRegistro() => '$baseUrl/usuario.php';
  String urlCategorias() => '$baseUrl/categorias.php';
  String urlProductos() => '$baseUrl/productos.php';
}
