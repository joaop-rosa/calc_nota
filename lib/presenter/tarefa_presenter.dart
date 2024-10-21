import 'dart:convert';
import 'package:aula11_calc/dao/tarefa_dao.dart';
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
  }

  Future<List<Tarefa>> listarTarefaPorNome(String tarefaNome) async {
    var tarefasFiltradas = await db.listarTarefasFiltradas(tarefaNome);
    return tarefasFiltradas;
  }
}
