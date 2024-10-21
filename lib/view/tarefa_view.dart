import 'package:aula11_calc/model/tarefa_model.dart';
import 'package:aula11_calc/presenter/tarefa_presenter.dart';
import 'package:flutter/material.dart';

class TarefaView extends StatefulWidget {
  final TarefaPresenter presenter;

  TarefaView({required this.presenter});

  @override
  _TarefasViewState createState() => _TarefasViewState();
}

class _TarefasViewState extends State<TarefaView> {
  late Future<List<Tarefa>> _tarefas;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _tarefas = widget.presenter.carregarTarefas();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold é a estrutura básica de layout em Flutter, que fornece o esqueleto de uma tela com suporte para barra de aplicativo, corpo, botão de ação flutuante, etc.
    return Scaffold(
      appBar: AppBar(
        // AppBar cria uma barra no topo da tela com o título "Notas dos Trabalhos"
        title: const Text('Notas dos Trabalhos'),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Filtrar tarefas',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              // Verifica se o filtro mudou
              setState(() {
                _tarefas = widget.presenter.listarTarefaPorNome(value);
              });
            },
          ),
        ),
        Expanded(
            child: FutureBuilder<List<Tarefa>>(
          // FutureBuilder é um widget que constrói a interface com base no estado de um Future. Aqui, ele está esperando a lista de tarefas (_tarefas).
          future: _tarefas,
          builder: (context, snapshot) {
            // O 'builder' define a lógica de construção da interface dependendo do estado do Future (snapshot).

            // Caso o Future ainda esteja sendo processado (estado de espera), mostra um indicador de progresso circular.
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // Se houver um erro durante o carregamento das tarefas, exibe uma mensagem de erro.
            else if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar tarefas'));
            }

            // Quando o Future é completado com sucesso, snapshot.data contém a lista de tarefas.
            final tarefas =
                snapshot.data!; // O uso de '!' indica que 'tarefas' não é nulo.

            // ListView.builder é um widget que constrói uma lista de forma eficiente, apenas criando os itens visíveis na tela.
            return ListView.builder(
              itemCount: tarefas
                  .length, // Define o número de itens (tarefas) na lista.
              itemBuilder: (context, index) {
                final tarefa =
                    tarefas[index]; // Acessa a tarefa na posição atual (index).

                // Cada item da lista é um ListTile, que é um widget de linha simples com título, subtítulo, e um campo de entrada de texto.
                return ListTile(
                  title: Text(tarefa.titulo), // Exibe o título da tarefa.
                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Alinha à esquerda
                    children: [
                      if (tarefa.timestamp != null)
                        Text(
                            'Ultima edição: ${tarefa.timestamp?.toUtc().day}/${tarefa.timestamp?.toUtc().month}/${tarefa.timestamp?.toUtc().year} ${tarefa.timestamp?.toUtc().add(const Duration(hours: -3)).hour}:${tarefa.timestamp?.toUtc().minute}'), // Adiciona o widget se timestamp existir
                      Text('Peso: ${tarefa.peso}')
                    ],
                  ),
                  // trailing é um widget que aparece no final da linha. Aqui, contém um TextField para inserir a nota da tarefa.
                  trailing: SizedBox(
                    width: 100, // Define a largura do campo de texto.
                    child: TextFormField(
                      initialValue:
                          tarefa.nota != null ? tarefa.nota.toString() : '',
                      // Define a decoração do campo de texto com um rótulo "Nota".
                      decoration: const InputDecoration(labelText: 'Nota'),
                      keyboardType: TextInputType.number,
                      // Define o tipo de teclado como numérico.
                      onChanged: (value) {
                        // Atualiza a nota da tarefa à medida que o valor no campo de texto muda.
                        tarefa.nota = double.tryParse(
                            value); // Converte o valor digitado para double e atribui à tarefa.
                      },
                    ),
                  ),
                );
              },
            );
          },
        ))
      ]),
      // floatingActionButton é um botão de ação flutuante que permite ao usuário salvar as notas.
      floatingActionButton: FloatingActionButton(
        child: const Icon(
            Icons.save), // Define o ícone do botão como um ícone de "salvar".
        onPressed: () async {
          // Quando o botão é pressionado, aguarda-se a lista de tarefas (_tarefas) e chama-se o método para salvar as notas.
          final tarefas = await _tarefas;
          await widget.presenter.atualizarTarefas(tarefas);
          setState(() {
            _tarefas = widget.presenter.listarTarefaPorNome(_controller.text);
          });

          // Após salvar as notas, exibe uma mensagem de confirmação usando SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Notas salvas com sucesso')),
          );
        },
      ),
    );
  }
}
