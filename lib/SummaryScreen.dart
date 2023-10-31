import 'package:flutter/material.dart';
import 'package:flutter_application_1/LoginScreen.dart';

class SummaryPage extends StatelessWidget {
  final Movie movie;
  final int ticketCount;
  final int totalPrice;

  const SummaryPage({required this.movie, required this.ticketCount, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Movie movie = args['movie'];
    final int ticketCount = args['ticketCount'];
    final int totalPrice = args['totalPrice'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen de Compra'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
             
             children: [
            Text('Película: ${movie.title}'),
            Text('Cantidad de Entradas: $ticketCount'),
            Text('Precio Total: $totalPrice Bs.'),
          ],
        ),
      ),
    );
  }
}
