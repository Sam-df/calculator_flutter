import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CalculatorApp());
}

// Пастельные цвета
class PastelColors {
  static const Color rose = Color(0xFFFFB3D9);
  static const Color blue = Color(0xFFB3E5FC);
  static const Color green = Color(0xFFC8E6C9);
  static const Color yellow = Color(0xFFFFF9C4);
  static const Color purple = Color(0xFFE1BEE7);
  static const Color peach = Color(0xFFFFCCBC);
  static const Color lightGray = Color(0xFFF5F5F5);
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Универсальный калькулятор',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: PastelColors.purple,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: PastelColors.lightGray,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens = [
    const MathCalculator(),
    const MetricConverter(),
    const WeightConverter(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Математика',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.straighten),
            label: 'Метрика',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.scale),
            label: 'Вес',
          ),
        ],
        selectedItemColor: PastelColors.purple,
      ),
    );
  }
}

// ============ МАТЕМАТИЧЕСКИЙ КАЛЬКУЛЯТОР ============
class MathCalculator extends StatefulWidget {
  const MathCalculator({super.key});

  @override
  State<MathCalculator> createState() => _MathCalculatorState();
}

class _MathCalculatorState extends State<MathCalculator> {
  String _display = '0';
  double? _firstValue;
  String? _operation;
  bool _shouldResetDisplay = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _appendNumber(String number) {
    setState(() {
      if (_display == '0' || _shouldResetDisplay) {
        _display = number;
        _shouldResetDisplay = false;
      } else {
        _display += number;
      }
    });
  }

  void _appendDecimal() {
    setState(() {
      if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _setOperation(String op) {
    setState(() {
      _firstValue = double.tryParse(_display);
      _operation = op;
      _shouldResetDisplay = true;
    });
  }

  void _calculate() {
    if (_firstValue == null || _operation == null) return;

    double secondValue = double.tryParse(_display) ?? 0;
    double? result;

    switch (_operation) {
      case '+':
        result = _firstValue! + secondValue;
        break;
      case '-':
        result = _firstValue! - secondValue;
        break;
      case '×':
        result = _firstValue! * secondValue;
        break;
      case '÷':
        result = secondValue != 0 ? _firstValue! / secondValue : null;
        break;
    }

    setState(() {
      _display = result?.toString() ?? 'Ошибка';
      _firstValue = null;
      _operation = null;
      _shouldResetDisplay = true;
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _firstValue = null;
      _operation = null;
      _shouldResetDisplay = false;
    });
  }

  void _deleteLast() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
      }
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;

      if (key == LogicalKeyboardKey.digit0 || key == LogicalKeyboardKey.numpad0) {
        _appendNumber('0');
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit1 || key == LogicalKeyboardKey.numpad1) {
        _appendNumber('1');
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit2 || key == LogicalKeyboardKey.numpad2) {
        _appendNumber('2');
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit3 || key == LogicalKeyboardKey.numpad3) {
        _appendNumber('3');
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit4 || key == LogicalKeyboardKey.numpad4) {
        _appendNumber('4');
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit5 || key == LogicalKeyboardKey.numpad5) {
        _appendNumber('5');
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit6 || key == LogicalKeyboardKey.numpad6) {
        _appendNumber('6');
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit7 || key == LogicalKeyboardKey.numpad7) {
        _appendNumber('7');
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit8 || key == LogicalKeyboardKey.numpad8) {
        _appendNumber('8');
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.digit9 || key == LogicalKeyboardKey.numpad9) {
        _appendNumber('9');
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.period || key == LogicalKeyboardKey.numpadDecimal) {
        _appendDecimal();
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.numpadAdd) {
        _setOperation('+');
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.numpadSubtract || key == LogicalKeyboardKey.minus) {
        _setOperation('-');
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.numpadMultiply || key == LogicalKeyboardKey.asterisk) {
        _setOperation('×');
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.numpadDivide || key == LogicalKeyboardKey.slash) {
        _setOperation('÷');
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEqual) {
        _calculate();
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.backspace) {
        _deleteLast();
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.escape || key == LogicalKeyboardKey.delete) {
        _clear();
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Математический калькулятор'),
          backgroundColor: PastelColors.rose,
          elevation: 0,
        ),
        body: Column(
          children: [
            // Дисплей
            Container(
              width: double.infinity,
              color: PastelColors.rose,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _display,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Кнопки
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Первый ряд
                    Row(
                      children: [
                        _buildButton('C', Colors.white, () => _clear()),
                        _buildButton('←', Colors.white, () => _deleteLast()),
                        _buildButton('÷', PastelColors.yellow, () => _setOperation('÷')),
                        _buildButton('×', PastelColors.yellow, () => _setOperation('×')),
                      ],
                    ),
                    // Второй ряд
                    Row(
                      children: [
                        _buildButton('7', PastelColors.purple, () => _appendNumber('7')),
                        _buildButton('8', PastelColors.purple, () => _appendNumber('8')),
                        _buildButton('9', PastelColors.purple, () => _appendNumber('9')),
                        _buildButton('-', PastelColors.yellow, () => _setOperation('-')),
                      ],
                    ),
                    // Третий ряд
                    Row(
                      children: [
                        _buildButton('4', PastelColors.purple, () => _appendNumber('4')),
                        _buildButton('5', PastelColors.purple, () => _appendNumber('5')),
                        _buildButton('6', PastelColors.purple, () => _appendNumber('6')),
                        _buildButton('+', PastelColors.yellow, () => _setOperation('+')),
                      ],
                    ),
                    // Четвертый ряд
                    Row(
                      children: [
                        _buildButton('1', PastelColors.blue, () => _appendNumber('1')),
                        _buildButton('2', PastelColors.blue, () => _appendNumber('2')),
                        _buildButton('3', PastelColors.blue, () => _appendNumber('3')),
                        _buildButton('.', PastelColors.peach, () => _appendDecimal()),
                      ],
                    ),
                    // Пятый ряд
                    Row(
                      children: [
                        _buildButton('0', PastelColors.blue, () => _appendNumber('0')),
                        const Spacer(),
                        _buildButton('=', PastelColors.green, () => _calculate()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String label, Color color, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          height: 56, 
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              padding: EdgeInsets.zero, 
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============ МЕТРИЧЕСКИЙ КОНВЕРТЕР ============
class MetricConverter extends StatefulWidget {
  const MetricConverter({super.key});

  @override
  State<MetricConverter> createState() => _MetricConverterState();
}

class _MetricConverterState extends State<MetricConverter> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();
  String _selectedFromUnit = 'см';
  String _selectedToUnit = 'м';

  final Map<String, double> _unitToMeter = {
    'мм': 0.001,
    'см': 0.01,
    'м': 1,
    'км': 1000,
    'дюйм': 0.0254,
    'фут': 0.3048,
    'ярд': 0.9144,
    'миля': 1609.34,
  };

  void _convert({bool fromOutput = false}) {
    String inputText;
    String fromUnit;
    String toUnit;
    
    if (fromOutput) {
      inputText = _outputController.text;
      fromUnit = _selectedToUnit;
      toUnit = _selectedFromUnit;
    } else {
      inputText = _inputController.text;
      fromUnit = _selectedFromUnit;
      toUnit = _selectedToUnit;
    }

    final input = double.tryParse(inputText);
    if (input == null || inputText.isEmpty) return;

    final fromMeter = _unitToMeter[fromUnit] ?? 1;
    final toMeter = _unitToMeter[toUnit] ?? 1;
    final converted = (input * fromMeter) / toMeter;

    setState(() {
      final result = converted.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
      if (fromOutput) {
        _inputController.text = result;
      } else {
        _outputController.text = result;
      }
    });
  }

  void _swapUnits() {
    setState(() {
      final tempUnit = _selectedFromUnit;
      _selectedFromUnit = _selectedToUnit;
      _selectedToUnit = tempUnit;
      
      final tempText = _inputController.text;
      _inputController.text = _outputController.text;
      _outputController.text = tempText;
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Метрический конвертер'),
        backgroundColor: PastelColors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              color: PastelColors.blue.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Из:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _inputController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => _convert(),
                            decoration: InputDecoration(
                              hintText: 'Введите значение',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        DropdownButton<String>(
                          value: _selectedFromUnit,
                          items: _unitToMeter.keys.map((unit) {
                            return DropdownMenuItem(value: unit, child: Text(unit));
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _selectedFromUnit = value ?? 'см');
                            _convert();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            IconButton(
              onPressed: _swapUnits,
              icon: const Icon(Icons.swap_vert, size: 32),
              style: IconButton.styleFrom(
                backgroundColor: PastelColors.blue.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: PastelColors.blue.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('В:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _outputController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => _convert(fromOutput: true),
                            decoration: InputDecoration(
                              hintText: 'Результат',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        DropdownButton<String>(
                          value: _selectedToUnit,
                          items: _unitToMeter.keys.map((unit) {
                            return DropdownMenuItem(value: unit, child: Text(unit));
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _selectedToUnit = value ?? 'м');
                            _convert();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ ВЕСОВОЙ КОНВЕРТЕР ============
class WeightConverter extends StatefulWidget {
  const WeightConverter({super.key});

  @override
  State<WeightConverter> createState() => _WeightConverterState();
}

class _WeightConverterState extends State<WeightConverter> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();
  String _selectedFromUnit = 'кг';
  String _selectedToUnit = 'г';

  final Map<String, double> _unitToGram = {
    'мг': 0.001,
    'г': 1,
    'кг': 1000,
    'т': 1000000,
    'унция': 28.3495,
    'фунт': 453.592,
    'стон': 6350293,
  };

  void _convert({bool fromOutput = false}) {
    String inputText;
    String fromUnit;
    String toUnit;
    
    if (fromOutput) {
      inputText = _outputController.text;
      fromUnit = _selectedToUnit;
      toUnit = _selectedFromUnit;
    } else {
      inputText = _inputController.text;
      fromUnit = _selectedFromUnit;
      toUnit = _selectedToUnit;
    }

    final input = double.tryParse(inputText);
    if (input == null || inputText.isEmpty) return;

    final fromGram = _unitToGram[fromUnit] ?? 1;
    final toGram = _unitToGram[toUnit] ?? 1;
    final converted = (input * fromGram) / toGram;

    setState(() {
      final result = converted.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
      if (fromOutput) {
        _inputController.text = result;
      } else {
        _outputController.text = result;
      }
    });
  }

  void _swapUnits() {
    setState(() {
      final tempUnit = _selectedFromUnit;
      _selectedFromUnit = _selectedToUnit;
      _selectedToUnit = tempUnit;
      
      final tempText = _inputController.text;
      _inputController.text = _outputController.text;
      _outputController.text = tempText;
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _outputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Весовой конвертер'),
        backgroundColor: PastelColors.green,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              color: PastelColors.green.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Из:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _inputController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => _convert(),
                            decoration: InputDecoration(
                              hintText: 'Введите значение',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        DropdownButton<String>(
                          value: _selectedFromUnit,
                          items: _unitToGram.keys.map((unit) {
                            return DropdownMenuItem(value: unit, child: Text(unit));
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _selectedFromUnit = value ?? 'кг');
                            _convert();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            IconButton(
              onPressed: _swapUnits,
              icon: const Icon(Icons.swap_vert, size: 32),
              style: IconButton.styleFrom(
                backgroundColor: PastelColors.green.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: PastelColors.green.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('В:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _outputController,
                            keyboardType: TextInputType.number,
                            onChanged: (_) => _convert(fromOutput: true),
                            decoration: InputDecoration(
                              hintText: 'Результат',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        DropdownButton<String>(
                          value: _selectedToUnit,
                          items: _unitToGram.keys.map((unit) {
                            return DropdownMenuItem(value: unit, child: Text(unit));
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _selectedToUnit = value ?? 'г');
                            _convert();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}