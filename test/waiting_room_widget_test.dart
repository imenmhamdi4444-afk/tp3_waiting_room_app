import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:waiting_room_app/main.dart';
import 'package:waiting_room_app/queue_provider.dart';

void main() {
  testWidgets('should add a new client to the list on button tap', (
    WidgetTester tester,
  ) async {
    // Provide the QueueProvider to the widget tree
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => QueueProvider(),
        child: const WaitingRoomApp(),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Alice');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Clients in Queue: 1'), findsOneWidget);
  });

  testWidgets(
    'should remove a client from the list when the delete button is tapped',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => QueueProvider(),
          child: const WaitingRoomApp(),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Bob');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      expect(find.text('Bob'), findsNothing);
      expect(find.text('Clients in Queue: 0'), findsOneWidget);
    },
  );

  testWidgets(
    'should remove the first client from the list when "Next Client" is tapped',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => QueueProvider(),
          child: const WaitingRoomApp(),
        ),
      );

      // Add two clients
      await tester.enterText(find.byType(TextField), 'Client A');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'Client B');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Tap the next client button
      await tester.tap(find.byKey(const Key('nextClientButton')));
      await tester.pump();

      // Assertions
      expect(find.text('Client A'), findsNothing);
      expect(find.text('Client B'), findsOneWidget);
      expect(find.text('Clients in Queue: 1'), findsOneWidget);
    },
  );

  testWidgets('should preserve entered text when the queue changes', (
    WidgetTester tester,
  ) async {
    final provider = QueueProvider();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const WaitingRoomApp(),
      ),
    );

    await tester.enterText(find.byType(TextField), 'Waiting client');
    provider.addClient('Existing client');
    await tester.pump();

    expect(find.text('Waiting client'), findsOneWidget);
    expect(find.text('Existing client'), findsOneWidget);
  });
}
