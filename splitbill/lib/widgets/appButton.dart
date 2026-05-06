import 'package:flutter/material.dart'; // importa widgets Material

class AppButton extends StatelessWidget { // botão reutilizável da app
  final String text; // texto do botão
  final VoidCallback onPressed; // callback ao pressionar
  final IconData? icon; // ícone opcional
  final Color? backgroundColor; // cor de fundo opcional

  const AppButton({
    super.key,
    required this.text, // texto obrigatório
    required this.onPressed, // ação obrigatória
    this.icon, // ícone opcional
    this.backgroundColor, // cor opcional
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox( // tamanho fixo do botão
      width: double.infinity, // ocupa toda a largura disponível
      height: 50, // altura fixa
      child: icon != null
          ? ElevatedButton.icon( // se houver ícone utiliza ElevatedButton.icon
              icon: Icon(icon, size: 20), // ícone com tamanho definido
              label: Text(text), // rótulo do botão
              onPressed: onPressed, // callback
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
              ),
            )
          : ElevatedButton( // caso sem ícone utiliza ElevatedButton simples
              onPressed: onPressed, // callback
              child: Text(text), // rótulo
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
              ),
            ),
    );
  }
}