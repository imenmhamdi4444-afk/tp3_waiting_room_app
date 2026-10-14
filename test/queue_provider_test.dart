import 'package:flutter_test/flutter_test.dart';
import 'package:waiting_room_app/queue_provider.dart';

void main() {
  test('should add a client to the waiting list', () {
    final provider = QueueProvider();

    provider.addClient('John Doe');

    expect(provider.clients, ['John Doe']);
  });

  test('should remove a client from the waiting list', () {
    final provider = QueueProvider();
    provider.addClient('John Doe');
    provider.addClient('Jane Doe');

    provider.removeClient('John Doe');

    expect(provider.clients, ['Jane Doe']);
  });

  test('should remove the first client when nextClient() is called', () {
    // ARRANGE
    final provider = QueueProvider();
    provider.addClient('Client A');
    provider.addClient('Client B');

    // ACT
    provider.nextClient();

    // ASSERT
    expect(provider.clients, ['Client B']);
  });

  test('should ignore blank client names', () {
    final provider = QueueProvider();

    provider.addClient('   ');

    expect(provider.clients, isEmpty);
  });

  test('should not notify listeners when nextClient() is called on an empty queue', () {
    final provider = QueueProvider();
    var notifications = 0;
    provider.addListener(() => notifications++);

    provider.nextClient();

    expect(provider.clients, isEmpty);
    expect(notifications, 0);
    provider.dispose();
  });
}
