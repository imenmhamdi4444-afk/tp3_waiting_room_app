import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:waiting_room_app/main.dart';
import 'package:waiting_room_app/queue_provider.dart';

void main() {
  testWidgets('WaitingRoomApp shows the local waiting room screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => QueueProvider(),
        child: const WaitingRoomApp(),
      ),
    );

    expect(find.text('Local Waiting Room'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Clients in Queue: 0'), findsOneWidget);
  });
}
