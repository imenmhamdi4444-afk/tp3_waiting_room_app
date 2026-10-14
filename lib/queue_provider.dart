import 'package:flutter/foundation.dart';

class QueueProvider extends ChangeNotifier {
  final List<String> _clients = [];

  List<String> get clients => List.unmodifiable(_clients);

  void addClient(String name) {
    if (name.trim().isNotEmpty) {
      _clients.add(name.trim());
      notifyListeners();
    }
  }

  void removeClient(String name) {
    if (_clients.remove(name)) {
      notifyListeners();
    }
  }

  void nextClient() {
    if (_clients.isNotEmpty) {
      _clients.removeAt(0);
      notifyListeners();
    }
  }
}
