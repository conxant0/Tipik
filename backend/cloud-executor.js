const express = require('express');
const cors = require('cors');
const axios = require('axios');
require('dotenv').config();

const app = express();
const port = 4000;

app.use(cors());
app.use(express.json());

// Language mappings for different online execution services
const languageMap = {
  javascript: { id: 63, name: 'JavaScript (Node.js 12.14.0)' },
  python: { id: 71, name: 'Python (3.8.1)' },
  java: { id: 62, name: 'Java (OpenJDK 13.0.1)' },
  cpp: { id: 54, name: 'C++ (GCC 9.2.0)' },
  c: { id: 50, name: 'C (GCC 9.2.0)' },
  go: { id: 60, name: 'Go (1.13.5)' },
  rust: { id: 73, name: 'Rust (1.40.0)' },
  ruby: { id: 72, name: 'Ruby (2.7.0)' },
  php: { id: 68, name: 'PHP (7.4.1)' },
  csharp: { id: 51, name: 'C# (Mono 6.6.0.161)' }
};

// Code templates optimized for online execution
const codeTemplates = {
  javascript: `// JavaScript Example
console.log("Hello from CodeSnap IDE!");

function fibonacci(n) {
  if (n <= 1) return n;
  return fibonacci(n-1) + fibonacci(n-2);
}

console.log("Fibonacci(10):", fibonacci(10));`,

  python: `# Python Example
print("Hello from CodeSnap IDE!")

def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

print("Fibonacci(10):", fibonacci(10))`,

  java: `// Java Example
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello from CodeSnap IDE!");
        System.out.println("Fibonacci(10): " + fibonacci(10));
    }
    
    public static int fibonacci(int n) {
        if (n <= 1) return n;
        return fibonacci(n-1) + fibonacci(n-2);
    }
}`,

  cpp: `// C++ Example
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
}`,

  c: `// C Example
#include <stdio.h>

int fibonacci(int n) {
    if (n <= 1) return n;
    return fibonacci(n-1) + fibonacci(n-2);
}

int main() {
    printf("Hello from CodeSnap IDE!\\n");
    printf("Fibonacci(10): %d\\n", fibonacci(10));
    return 0;
}`,

  go: `// Go Example
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
}`,

  rust: `// Rust Example
fn fibonacci(n: u32) -> u32 {
    match n {
        0 | 1 => n,
        _ => fibonacci(n - 1) + fibonacci(n - 2),
    }
}

fn main() {
    println!("Hello from CodeSnap IDE!");
    println!("Fibonacci(10): {}", fibonacci(10));
}`,

  ruby: `# Ruby Example
def fibonacci(n)
  return n if n <= 1
  fibonacci(n-1) + fibonacci(n-2)
end

puts "Hello from CodeSnap IDE!"
puts "Fibonacci(10): " + fibonacci(10).to_s`,

  php: `<?php
// PHP Example
function fibonacci($n) {
    if ($n <= 1) return $n;
    return fibonacci($n-1) + fibonacci($n-2);
}

echo "Hello from CodeSnap IDE!\\n";
echo "Fibonacci(10): " . fibonacci(10) . "\\n";
?>`,

  csharp: `// C# Example
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
}`
};

// Execute code using Judge0 API (free online code execution)
async function executeCodeOnline(code, language) {
  try {
    const languageConfig = languageMap[language];
    if (!languageConfig) {
      throw new Error(`Unsupported language: ${language}`);
    }

    // Submit code for execution
    const submitResponse = await axios.post('https://judge0-ce.p.rapidapi.com/submissions', {
      source_code: code,
      language_id: languageConfig.id,
      stdin: ""
    }, {
      headers: {
        'X-RapidAPI-Key': process.env.RAPIDAPI_KEY || 'demo-key', // You'll need to get a free API key
        'X-RapidAPI-Host': 'judge0-ce.p.rapidapi.com',
        'Content-Type': 'application/json'
      }
    });

    const token = submitResponse.data.token;

    // Poll for results
    let result;
    let attempts = 0;
    const maxAttempts = 10;

    do {
      await new Promise(resolve => setTimeout(resolve, 1000)); // Wait 1 second
      
      const resultResponse = await axios.get(`https://judge0-ce.p.rapidapi.com/submissions/${token}`, {
        headers: {
          'X-RapidAPI-Key': process.env.RAPIDAPI_KEY || 'demo-key',
          'X-RapidAPI-Host': 'judge0-ce.p.rapidapi.com'
        }
      });

      result = resultResponse.data;
      attempts++;
    } while (result.status.id <= 2 && attempts < maxAttempts); // Status 1-2 means processing

    return {
      success: result.status.id === 3, // Status 3 means accepted (successful)
      output: result.stdout || '',
      error: result.stderr || result.compile_output || '',
      status: result.status.description,
      time: result.time,
      memory: result.memory
    };

  } catch (error) {
    throw new Error(`Execution failed: ${error.message}`);
  }
}

// Fallback: Simple JavaScript execution using eval (for demo purposes)
function executeJavaScriptLocal(code) {
  try {
    // Capture console.log output
    const logs = [];
    const originalLog = console.log;
    console.log = (...args) => logs.push(args.join(' '));

    // Execute the code
    eval(code);

    // Restore console.log
    console.log = originalLog;

    return {
      success: true,
      output: logs.join('\\n'),
      error: '',
      status: 'Accepted',
      time: null,
      memory: null
    };
  } catch (error) {
    return {
      success: false,
      output: '',
      error: error.message,
      status: 'Runtime Error',
      time: null,
      memory: null
    };
  }
}

// Main execution route
app.post('/execute', async (req, res) => {
  const { code, language } = req.body;

  if (!code || !language) {
    return res.status(400).json({ error: 'Code and language are required' });
  }

  try {
    let result;

    // For demo purposes, use local JavaScript execution as fallback
    if (language === 'javascript' && (!process.env.RAPIDAPI_KEY || process.env.RAPIDAPI_KEY === 'demo-key')) {
      result = executeJavaScriptLocal(code);
    } else {
      result = await executeCodeOnline(code, language);
    }

    res.json({
      success: result.success,
      output: result.output,
      error: result.error,
      exitCode: result.success ? 0 : 1,
      executionTime: result.time,
      memoryUsage: result.memory,
      status: result.status
    });

  } catch (error) {
    res.status(500).json({ 
      error: error.message,
      suggestion: 'For full language support, please set up a RapidAPI key for Judge0 service'
    });
  }
});

// Get code templates
app.get('/templates', (req, res) => {
  res.json({
    templates: codeTemplates,
    languages: Object.keys(languageMap)
  });
});

// Get supported languages
app.get('/languages', (req, res) => {
  const supportedLanguages = Object.keys(languageMap).map(lang => ({
    id: lang,
    name: languageMap[lang].name,
    available: true // All languages are available via cloud execution
  }));

  res.json({
    languages: supportedLanguages,
    service: 'Cloud-based execution (Judge0 API)',
    note: 'No local installation required'
  });
});

// Health check
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    service: 'Cloud Code Executor',
    version: '1.0.0'
  });
});

app.listen(port, () => {
  console.log(`🚀 CodeSnap Cloud IDE Backend running on port ${port}`);
  console.log(`📱 Mobile-friendly - no local compilers needed!`);
  console.log(`🌐 Using cloud-based code execution`);
  console.log(`💡 Supported languages: ${Object.keys(languageMap).join(', ')}`);
  
  if (!process.env.RAPIDAPI_KEY) {
    console.log(`⚠️  Demo mode: Only JavaScript works locally`);
    console.log(`🔑 To enable all languages:`);
    console.log(`   1. Create a .env file in the backend directory`);
    console.log(`   2. Add: RAPIDAPI_KEY=your_actual_key_here`);
    console.log(`   3. Restart the server`);
  } else {
    console.log(`✅ RapidAPI key detected - All languages enabled!`);
    console.log(`🎯 Ready for production use`);
  }
}); 