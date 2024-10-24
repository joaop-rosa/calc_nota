import 'dart:convert';
import 'package:aula11_calc/dao/tarefa_dao.dart';
import 'package:aula11_calc/model/calculo_model.dart';
import 'package:aula11_calc/model/tarefa_model.dart';
import 'package:flutter/services.dart';

class TarefaPresenter {
  final TarefaDao db;

  TarefaPresenter(this.db);

  // Carregar JSON trasnformando em uma lista de tarefas
  Future<List<Tarefa>> carregarTarefas() async {
    final jsonString = await rootBundle.loadString('assets/notas.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    final tarefas = jsonData.map((item) => Tarefa.fromJson(item)).toList();
    salvarTarefas(tarefas);
    final tarefasDb = await db.listarTarefas();
    return tarefasDb;
  }

  // Calcular a nota final
  double calcularNotaFinal(List<Tarefa> tarefas) {
    double somaNotasPonderadas = 0.0;
    double somaPesos = 0;
    Tarefa? prova;

    for (var tarefa in tarefas) {
      if (tarefa.titulo == 'Sprint 4 - Review - Avaliação G1') {
        prova = tarefa;
      } else if (tarefa.nota != null) {
        somaNotasPonderadas += (tarefa.nota! / 10) * 3 * tarefa.peso;
        somaPesos += tarefa.peso;
      }
    }

    if (prova != null) {
      final mediaFinalPonderada =
          somaPesos > 0 ? somaNotasPonderadas / somaPesos : 0.0;
      final notaFinal = mediaFinalPonderada + ((prova.nota! / 10) * 7);

      return notaFinal;
    }

    return 0;
  }

  // Salvar notas no banco
  Future<void> salvarTarefas(List<Tarefa> tarefas) async {
    for (var tarefa in tarefas) {
      tarefa.timestamp = DateTime.now();
      await db.inserirTarefa(tarefa);
    }
  }

  Future<void> atualizarTarefas(List<Tarefa> tarefas) async {
    for (var tarefa in tarefas) {
      tarefa.timestamp = DateTime.now();
      await db.atualizaTarefa(tarefa);
    }

    Calculo notaFinal =
        Calculo(nota: calcularNotaFinal(tarefas), timestamp: DateTime.now());
    db.inserirCalculo(notaFinal);
  }

  Future<List<Tarefa>> listarTarefaPorNome(String tarefaNome) async {
    var tarefasFiltradas = await db.listarTarefasFiltradas(tarefaNome);
    return tarefasFiltradas;
  }

  Future<Calculo> listarCalculo() async {
    return await db.listarUltimoCalculo();
  }
}
