import 'package:flutter/material.dart';
import 'package:flutter_application_7/servicios/categoria_service.dart';
import 'package:flutter_application_7/servicios/producto_service.dart';
import 'package:flutter_application_7/modelos/categoria.dart';
import 'package:flutter_application_7/modelos/producto.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final CategoriaService _categoriaService = CategoriaService();
  final ProductoService _productoService = ProductoService();
  List<Categoria> _categorias = [];
  List<Producto> _productos = [];
  int _selectedCategoryId = 0;

  final TextEditingController _nombreCategoriaController =
      TextEditingController();
  final TextEditingController _nombreProductoController =
      TextEditingController();
  final TextEditingController _descripcionProductoController =
      TextEditingController();
  final TextEditingController _precioProductoController =
      TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadCategorias();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadCategorias() async {
    try {
      _categorias = await _categoriaService.getCategorias();
      setState(() {});
      if (_categorias.isNotEmpty) {
        _selectedCategoryId = _categorias.first.idCategoria;
        _loadProductos(_selectedCategoryId);
      }
    } catch (e) {
      _showError('Error al cargar categorías: $e');
    }
  }

  Future<void> _loadProductos(int idCategoria) async {
    try {
      _productos = await _productoService.getProductos(idCategoria);
      setState(() {});
    } catch (e) {
      _showError('Error al cargar productos: $e');
    }
  }

  Future<void> _crearCategoria() async {
    if (_nombreCategoriaController.text.isEmpty) {
      _showError('Ingresa un nombre para la categoría');
      return;
    }

    try {
      await _categoriaService.crearCategoria(_nombreCategoriaController.text);
      _nombreCategoriaController.clear();
      _loadCategorias();
      _showSuccess('✅ Categoría creada exitosamente');
    } catch (e) {
      _showError('❌ Error: $e');
    }
  }

  Future<void> _crearProducto() async {
    if (_nombreProductoController.text.isEmpty ||
        _descripcionProductoController.text.isEmpty ||
        _precioProductoController.text.isEmpty) {
      _showError('Completa todos los campos del producto');
      return;
    }

    try {
      await _productoService.crearProducto(
        _nombreProductoController.text,
        _descripcionProductoController.text,
        double.parse(_precioProductoController.text),
        _selectedCategoryId,
      );
      _nombreProductoController.clear();
      _descripcionProductoController.clear();
      _precioProductoController.clear();
      _loadProductos(_selectedCategoryId);
      _showSuccess('✅ Producto creado exitosamente');
    } catch (e) {
      _showError('❌ Error: $e');
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🛍️ Gestión de Productos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple[800],
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de Categorías
            const Text(
              '📚 Categorías',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            // Lista de categorías con tarjetas
            SizedBox(
              height: 160,
              child: _categorias.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay categorías',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categorias.length,
                      itemBuilder: (context, index) {
                        final categoria = _categorias[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategoryId = categoria.idCategoria;
                              });
                              _loadProductos(categoria.idCategoria);
                              _animationController.forward();
                              Future.delayed(
                                const Duration(milliseconds: 300),
                                () {
                                  _animationController.reverse();
                                },
                              );
                            },
                            child: ScaleTransition(
                              scale:
                                  _selectedCategoryId == categoria.idCategoria
                                  ? _animation
                                  : AlwaysStoppedAnimation(1.0),
                              child: Container(
                                width: 150,
                                decoration: BoxDecoration(
                                  color:
                                      _selectedCategoryId ==
                                          categoria.idCategoria
                                      ? Colors.deepPurple[100]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  border: Border.all(
                                    color:
                                        _selectedCategoryId ==
                                            categoria.idCategoria
                                        ? Colors.deepPurple
                                        : Colors.grey[300]!,
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.category,
                                      color: Colors.deepPurple,
                                      size: 32,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      categoria.nombre,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 30),
            // Formulario para crear categoría
            const Text(
              '➕ Crear nueva categoría',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nombreCategoriaController,
              decoration: InputDecoration(
                labelText: 'Nombre de la categoría',
                prefixIcon: const Icon(Icons.label, color: Colors.deepPurple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _crearCategoria,
                icon: const Icon(Icons.add, size: 20),
                label: const Text(
                  'Crear Categoría',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Sección de Productos
            const Text(
              '📦 Productos',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            // Selector de categoría
            DropdownButtonFormField<int>(
              value: _selectedCategoryId == 0 ? null : _selectedCategoryId,
              items: _categorias.map((categoria) {
                return DropdownMenuItem(
                  value: categoria.idCategoria,
                  child: Text(
                    categoria.nombre,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                  _loadProductos(value);
                }
              },
              decoration: InputDecoration(
                labelText: 'Selecciona una categoría',
                prefixIcon: const Icon(
                  Icons.category,
                  color: Colors.deepPurple,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            // Lista de productos
            if (_productos.isEmpty)
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inbox, color: Colors.grey, size: 48),
                      SizedBox(height: 12),
                      Text(
                        'No hay productos en esta categoría',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _productos.length,
                itemBuilder: (context, index) {
                  final producto = _productos[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.shopping_bag,
                            color: Colors.deepPurple,
                            size: 30,
                          ),
                        ),
                        title: Text(
                          producto.nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          producto.descripcion,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Chip(
                          label: Text(
                            '\$${producto.precio.toStringAsFixed(2)}',
                          ),
                          backgroundColor: Colors.green[100],
                          labelStyle: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 30),
            // Formulario para crear producto
            const Text(
              '➕ Crear nuevo producto',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nombreProductoController,
              decoration: InputDecoration(
                labelText: 'Nombre del producto',
                prefixIcon: const Icon(
                  Icons.shopping_bag,
                  color: Colors.deepPurple,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descripcionProductoController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Descripción',
                prefixIcon: const Icon(
                  Icons.description,
                  color: Colors.deepPurple,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _precioProductoController,
              decoration: InputDecoration(
                labelText: 'Precio',
                prefixIcon: const Icon(
                  Icons.attach_money,
                  color: Colors.deepPurple,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _crearProducto,
                icon: const Icon(Icons.add_shopping_cart, size: 20),
                label: const Text(
                  'Crear Producto',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Botón de cerrar sesión
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
