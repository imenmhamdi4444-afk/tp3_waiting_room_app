import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waiting_room_app/queue_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => QueueProvider(),
      child: const WaitingRoomApp(),
    ),
  );
}

class WaitingRoomApp extends StatelessWidget {
  const WaitingRoomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: WaitingRoomScreen());
  }
}

class WaitingRoomScreen extends StatelessWidget {
  const WaitingRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final queueProvider = context.watch<QueueProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Waiting Room'),
        actions: [
          IconButton(
            key: const Key('nextClientButton'),
            icon: const Icon(Icons.skip_next),
            onPressed: () {
              // Call provider method without listening for the result.
              context.read<QueueProvider>().nextClient();
            },
            tooltip: 'Next Client',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const _AddClientForm(),
            const SizedBox(height: 16),
            Text('Clients in Queue: ${queueProvider.clients.length}'),
            Expanded(
              child: ListView.builder(
                itemCount: queueProvider.clients.length,
                itemBuilder: (context, index) {
                  final clientName = queueProvider.clients[index];
                  return Card(
                    child: ListTile(
                      title: Text(clientName),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<QueueProvider>().removeClient(
                            clientName,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddClientForm extends StatefulWidget {
  const _AddClientForm();

  @override
  State<_AddClientForm> createState() => _AddClientFormState();
}

class _AddClientFormState extends State<_AddClientForm> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addClient() {
    context.read<QueueProvider>().addClient(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Client Name'),
            onSubmitted: (_) => _addClient(),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(onPressed: _addClient, child: const Text('Add')),
      ],
    );
  }
}
