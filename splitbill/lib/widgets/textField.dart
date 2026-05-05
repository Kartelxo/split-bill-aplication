import 'package:flutter/material.dart'; // importa widgets Material

class AppTextField extends StatelessWidget { // campo de texto reutilizável
  final String label; // rótulo do campo
  final TextEditingController controller; // controller para gerir texto
  final TextInputType keyboardType; // tipo de teclado esperado

  const AppTextField({
    super.key,
    required this.label, // rótulo obrigatório
    required this.controller, // controller obrigatório
    this.keyboardType = TextInputType.text, // tipo por defeito
  });

  @override
  Widget build(BuildContext context) {
    return TextField( // TextField padrão com decoração
      controller: controller, // associa controller
      keyboardType: keyboardType, // define tipo de teclado
      decoration: InputDecoration(
        labelText: label, // mostra rótulo dentro do campo
        border: const OutlineInputBorder(), // borda padrão
      ),
    );
  }
}