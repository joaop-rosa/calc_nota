import 'package:aula11_calc/model/calculo_model.dart';
import 'package:aula11_calc/model/tarefa_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TarefaDao {
  static final TarefaDao instance = TarefaDao._init();

  static Database? _database;

  TarefaDao._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tarefas.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tarefas (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          tipo TEXT,
          titulo TEXT,
          periodo TEXT,
          peso REAL,
          nota REAL,
          timestamp TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE calculo (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nota REAL,
          timestamp TEXT
      );
    ''');
  }

  Future<void> inserirTarefa(Tarefa tarefa) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> result = await db.query(
      'tarefas',
      where: 'titulo = ?',
      whereArgs: [tarefa.titulo],
    );

    if (result.isEmpty) {
      await db.insert('tarefas', tarefa.toJson());
    }
  }

  Future<void> atualizaTarefa(Tarefa tarefa) async {
    final db = await instance.database;
    await db.update('tarefas', tarefa.toJson(),
        where: 'titulo = ?', whereArgs: [tarefa.titulo]);
  }

  Future<void> inserirCalculo(Calculo notaFinal) async {
    final db = await instance.database;
    await db.insert('calculo', notaFinal.toJson());
  }

  Future<List<Tarefa>> listarTarefas() async {
    final db = await instance.database;
    final result = await db.query('tarefas');
    return result.map((json) => Tarefa.fromJson(json)).toList();
  }

  Future<List<Tarefa>> listarTarefasFiltradas(String filtro) async {
    final db = await instance.database;
    final result = await db.query('tarefas',
        where: 'titulo LIKE ?', whereArgs: ['%$filtro%'], distinct: true);
    return result.map((json) => Tarefa.fromJson(json)).toList();
  }

  Future<Calculo> listarUltimoCalculo() async {
    final db = await instance.database;
    final result = await db.query(
      'calculo',
      orderBy: 'timestamp DESC', // Ordena pela coluna 'id' em ordem decrescente
      limit: 1, // Limita o resultado a apenas 1 registro
    );

    final resultMapped = result.map((json) => Calculo.fromJson(json)).toList();

    return resultMapped
        .first; // Retorna o primeiro ou um mapa vazio se não houver resultados
  }
}
