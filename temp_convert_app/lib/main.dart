
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(const TemperatureConverterApp());

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TemperatureHomePage(),
    );
  }
}

class TemperatureHomePage extends StatefulWidget {
  const TemperatureHomePage({super.key});

  @override
  State<TemperatureHomePage> createState() => _TemperatureHomePageState();
}

class _TemperatureHomePageState extends State<TemperatureHomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<String> _history = [];
  bool _isFahrenheitToCelsius = true;
  String _result = '';
  final NumberFormat _formatter = NumberFormat("##0.00");
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  void _convertTemperature() {
    final input = double.tryParse(_controller.text);
    if (input == null) return;

    double converted;
    String conversionType;

    if (_isFahrenheitToCelsius) {
      converted = (input - 32) * 5 / 9;
      conversionType = 'F to C';
    } else {
      converted = input * 9 / 5 + 32;
      conversionType = 'C to F';
    }

    setState(() {
      _result = _formatter.format(converted);
      _history.insert(0, '$conversionType: $input => $_result');
      _animationController.forward(from: 0.0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F6),
      appBar: AppBar(
        title: const Text('Temperature Converter'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://cdn-icons-png.flaticon.com/512/1684/1684375.png',
                            width: 60,
                            height: 60,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Instructions:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '1. Enter a temperature\n'
                            '2. Choose conversion\n'
                            '3. Tap Convert\n'
                            '4. View result and history',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _controller,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Enter Temperature',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ToggleButtons(
                      isSelected: [
                        _isFahrenheitToCelsius,
                        !_isFahrenheitToCelsius,
                      ],
                      onPressed: (index) {
                        setState(() {
                          _isFahrenheitToCelsius = index == 0;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      fillColor: Colors.deepPurple.shade100,
                      selectedColor: Colors.deepPurple,
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('F to C'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('C to F'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _convertTemperature,
                      child: const Text('Convert'),
                    ),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'Result: $_result',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_history.isNotEmpty)
                      Column(
                        children: [
                          Text(
                            'History:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          ..._history
                              .take(2)
                              .map(
                                (entry) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  child: Text(entry),
                                ),
                              ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    const Text(
                      'By Wilsons Navid',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
