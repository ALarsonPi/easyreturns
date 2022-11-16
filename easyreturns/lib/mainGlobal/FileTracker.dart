import 'dart:io' as io;
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class FileTracker {
  static const String registeredPath = "registered.txt";
  static const String loggedInPath = "loggedIn.txt";

  static Future<List<bool>> readRegisterAndLoginStatus() async {
    List<bool> statuses = List.empty(growable: true);

    // Will be either one or zero
    String valueInRegisterFile = "";
    String valueInLoggedInFile = "";

    await readFile(registeredPath).then((value) {
      valueInRegisterFile = value;
    });
    await readFile(loggedInPath).then((value) {
      valueInLoggedInFile = value;
    });
    if (valueInRegisterFile != "1") {
      valueInRegisterFile = "0";
      await writeRegisteredFile(valueInRegisterFile);
    }
    if (valueInLoggedInFile != "1") {
      valueInLoggedInFile = "0";
      await writeLoggedInFile(valueInLoggedInFile);
    }

    // Order is Register (T/F), then Login (T/F)
    statuses.add(valueInRegisterFile == "1");
    statuses.add(valueInLoggedInFile == "1");
    return statuses;
  }

  static register() async {
    await writeRegisteredFile("1");
  }

  static login() async {
    await writeLoggedInFile("1");
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<io.File> _localFile(String filePath) async {
    final path = await _localPath;
    return io.File('$path/$filePath');
  }

  static Future<io.File> writeRegisteredFile(String stringToWrite) async {
    final file = await _localFile(registeredPath);
    return file.writeAsString(stringToWrite);
  }

  static Future<io.File> writeLoggedInFile(String stringToWrite) async {
    final file = await _localFile(registeredPath);
    return file.writeAsString(stringToWrite);
  }

  static readFile(String filePath) async {
    try {
      final file = await _localFile(filePath);
      bool fileExists = await file.exists();
      if (fileExists) {
        return file.readAsString();
      } else {
        return "notAvailable";
      }
    } catch (e) {
      debugPrint("IO ERROR");
    }
  }
}
