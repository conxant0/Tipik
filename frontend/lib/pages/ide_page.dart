import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IDEPage extends StatefulWidget {
  const IDEPage({super.key});

  @override
  State<IDEPage> createState() => _IDEPageState();
}

class _IDEPageState extends State<IDEPage> {
  final TextEditingController _codeController = TextEditingController();
  String _selectedLanguage = 'javascript';
  String _output = '';
  bool _isRunning = false;

  // Supported languages with their configurations
  final Map<String, Map<String, String>> _languages = {
    'javascript': {
      'name': 'JavaScript',
      'extension': '.js',
      'icon': '🟨',
      'template': '''// JavaScript Example
console.log("Hello from CodeSnap IDE!");

function fibonacci(n) {
  if (n <= 1) return n;
  return fibonacci(n-1) + fibonacci(n-2);
}

console.log("Fibonacci(10):", fibonacci(10));'''
    },
    'python': {
      'name': 'Python',
      'extension': '.py',
      'icon': '🐍',
      'template': '''# Python Example
print("Hello from CodeSnap IDE!")

def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

print("Fibonacci(10):", fibonacci(10))'''
    },
    'java': {
      'name': 'Java',
      'extension': '.java',
      'icon': '☕',
      'template': '''// Java Example
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello from CodeSnap IDE!");
        System.out.println("Fibonacci(10): " + fibonacci(10));
    }
    
    public static int fibonacci(int n) {
        if (n <= 1) return n;
        return fibonacci(n-1) + fibonacci(n-2);
    }
}'''
    },
    'cpp': {
      'name': 'C++',
      'extension': '.cpp',
      'icon': '⚡',
      'template': '''// C++ Example
#include <iostream>
using namespace std;

int fibonacci(int n) {
    if (n <= 1) return n;
    return fibonacci(n-1) + fibonacci(n-2);
}

int main() {
    cout << "Hello from CodeSnap IDE!" << endl;
    cout << "Fibonacci(10): " << fibonacci(10) << endl;
    return 0;
}'''
    },
    'c': {
      'name': 'C',
      'extension': '.c',
      'icon': '🔧',
      'template': '''// C Example
#include <stdio.h>

int fibonacci(int n) {
    if (n <= 1) return n;
    return fibonacci(n-1) + fibonacci(n-2);
}

int main() {
    printf("Hello from CodeSnap IDE!\\n");
    printf("Fibonacci(10): %d\\n", fibonacci(10));
    return 0;
}'''
    },
    'go': {
      'name': 'Go',
      'extension': '.go',
      'icon': '🔵',
      'template': '''// Go Example
package main

import "fmt"

func fibonacci(n int) int {
    if n <= 1 {
        return n
    }
    return fibonacci(n-1) + fibonacci(n-2)
}

func main() {
    fmt.Println("Hello from CodeSnap IDE!")
    fmt.Printf("Fibonacci(10): %d\\n", fibonacci(10))
}'''
    },
    'rust': {
      'name': 'Rust',
      'extension': '.rs',
      'icon': '🦀',
      'template': '''// Rust Example
fn fibonacci(n: u32) -> u32 {
    match n {
        0 | 1 => n,
        _ => fibonacci(n - 1) + fibonacci(n - 2),
    }
}

fn main() {
    println!("Hello from CodeSnap IDE!");
    println!("Fibonacci(10): {}", fibonacci(10));
}'''
    },
    'ruby': {
      'name': 'Ruby',
      'extension': '.rb',
      'icon': '💎',
      'template': '''# Ruby Example
def fibonacci(n)
  return n if n <= 1
  fibonacci(n-1) + fibonacci(n-2)
end

puts "Hello from CodeSnap IDE!"
puts "Fibonacci(10): " + fibonacci(10).to_s'''
    },
    'php': {
      'name': 'PHP',
      'extension': '.php',
      'icon': '🐘',
      'template': '''<?php
// PHP Example
function fibonacci(\$n) {
    if (\$n <= 1) return \$n;
    return fibonacci(\$n-1) + fibonacci(\$n-2);
}

echo "Hello from CodeSnap IDE!\\n";
echo "Fibonacci(10): " . fibonacci(10) . "\\n";
?>'''
    },
    'csharp': {
      'name': 'C#',
      'extension': '.cs',
      'icon': '🔷',
      'template': '''// C# Example
using System;

class Program {
    static int Fibonacci(int n) {
        if (n <= 1) return n;
        return Fibonacci(n-1) + Fibonacci(n-2);
    }
    
    static void Main() {
        Console.WriteLine("Hello from CodeSnap IDE!");
        Console.WriteLine("Fibonacci(10): " + Fibonacci(10));
    }
}'''
    }
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final passedCode = ModalRoute.of(context)?.settings.arguments as String?;
    if (passedCode != null && passedCode.trim().isNotEmpty) {
      _codeController.text = passedCode;
    } else {
      _codeController.text = _languages[_selectedLanguage]?['template'] ?? '';
    }
  }



  Future<void> _executeCode() async {
    if (_codeController.text.trim().isEmpty) {
      setState(() {
        _output = 'Error: Please enter some code to execute';
      });
      return;
    }

    setState(() {
      _isRunning = true;
      _output = 'Executing code...';
    });

    try {
      final response = await http.post(
        //Uri.parse('http://10.0.2.2:3000/execute'),
        Uri.parse('http://192.168.1.2:4000/execute'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'code': _codeController.text,
          'language': _selectedLanguage,
        }),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        setState(() {
          _output = '';
          if (result['output'] != null && result['output'].isNotEmpty) {
            _output += '${result['output']}';
          }
          if (result['error'] != null && result['error'].isNotEmpty) {
            if (_output.isNotEmpty) _output += '\n\n';
            _output += 'Error:\n${result['error']}';
          }
          if (_output.isEmpty) {
            _output = 'Code executed successfully with no output.';
          }
        });
      } else {
        setState(() {
          _output = 'Error: Failed to execute code (${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _output = 'Error: Cannot connect to backend server.\nMake sure the backend is running on localhost:3000\n\nTried: http://10.0.2.2:3000/execute (Android emulator)\nError details: $e\n\nTroubleshooting:\n1. Check if backend is running\n2. Try: curl http://127.0.0.1:3000/health\n3. Check firewall settings';
      });
    }

    setState(() {
      _isRunning = false;
    });
  }

  void _onLanguageChanged(String? newLanguage) {
    if (newLanguage != null) {
      setState(() {
        _selectedLanguage = newLanguage;
        _codeController.text = _languages[newLanguage]?['template'] ?? '';
        _output = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CodeSnap IDE'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        actions: [
          // Language Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: _onLanguageChanged,
              dropdownColor: Colors.blue.shade700,
              style: const TextStyle(color: Colors.white),
              underline: Container(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: _languages.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        entry.value['icon'] ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        entry.value['name'] ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 16),
          // Run Button
          ElevatedButton.icon(
            onPressed: _isRunning ? null : _executeCode,
            icon: _isRunning 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Icon(Icons.play_arrow),
            label: Text(_isRunning ? 'Running...' : 'Run'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Language Info Bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                Text(
                  _languages[_selectedLanguage]?['icon'] ?? '',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  '${_languages[_selectedLanguage]?['name']} ${_languages[_selectedLanguage]?['extension']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                const Spacer(),
                Text(
                  'Lines: ${_codeController.text.split('\n').length}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Code Editor Section
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.code, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Text(
                          'Code Editor',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.grey.shade50,
                      child: TextField(
                        controller: _codeController,
                        maxLines: null,
                        expands: true,
                        onChanged: (value) => setState(() {}), // Update line count
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                          hintText: 'Enter your code here...',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontFamily: 'Courier',
                          ),
                        ),
                                              style: const TextStyle(
                          fontFamily: 'Courier',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Output Section
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.terminal, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Text(
                          'Output',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const Spacer(),
                        if (_output.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.clear, size: 16, color: Colors.grey.shade600),
                            onPressed: () => setState(() => _output = ''),
                            tooltip: 'Clear output',
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey.shade50,
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Text(
                          _output.isEmpty ? 'Output will appear here...' : _output,
                          style: TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _output.isEmpty ? Colors.grey.shade500 : Colors.black87,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
} 