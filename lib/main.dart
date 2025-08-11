import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// a new comment added to main
void main() {
  runApp(const BitwiseOperationsApp());
}

class BitwiseOperationsApp extends StatelessWidget {
  const BitwiseOperationsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitwise Operations',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurpleAccent),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.grey[850],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
        ),
      ),
      home: const BitwiseScreen(),
    );
  }
}

class BitwiseScreen extends StatefulWidget {
  const BitwiseScreen({super.key});

  @override
  _BitwiseScreenState createState() => _BitwiseScreenState();
}

class _BitwiseScreenState extends State<BitwiseScreen> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _secondNumberController = TextEditingController();
  final TextEditingController _thirdNumberController = TextEditingController();

  String _singleNumberResults = '';
  String? _customXorResult;
  String? _xorResult, _andResult, _orResult;

  @override
  void initState() {
    super.initState();
    _numberController.addListener(_calculate);
    _secondNumberController.addListener(_calculate);
    _thirdNumberController.addListener(_calculate);
  }

  @override
  void dispose() {
    _numberController.removeListener(_calculate);
    _secondNumberController.removeListener(_calculate);
    _thirdNumberController.removeListener(_calculate);
    _numberController.dispose();
    _secondNumberController.dispose();
    _thirdNumberController.dispose();
    super.dispose();
  }

  void _clearAll() {
    _numberController.clear();
    _secondNumberController.clear();
    _thirdNumberController.clear();
  }

  void _calculate() {
    final int? num1 = int.tryParse(_numberController.text);
    final int? num2 = int.tryParse(_secondNumberController.text);
    final int? num3 = int.tryParse(_thirdNumberController.text);

    setState(() {
      _customXorResult = _xorResult = _andResult = _orResult = null;

      if (num1 != null) {
        // --- SINGLE NUMBER OPERATIONS ---
        final int leftShift = num1 << 1;
        final int rightShift = num1 >> 1;
        final int notResult = ~num1;

        _singleNumberResults = 'Bitshift Left  (<< 1): $leftShift\n'
            'Bitshift Right (>> 1): $rightShift\n'
            'Bitwise NOT   (~): $notResult';

        // --- CUSTOM XOR MASK OPERATION ---
        if (num3 != null) {
          final int customXorVal = num1 ^ num3;
          _customXorResult = '$num1 ^ $num3 (your mask) = $customXorVal';
        }

        // --- TWO-NUMBER TRANSFORMATIONS ---
        if (num2 != null) {
          // XOR: Always possible. Mask is num1 ^ num2
          final int xorMask = num1 ^ num2;
          _xorResult = 'To get $num2, use mask $xorMask\n'
              '($num1 ^ $xorMask = $num2)';

          // AND: Possible only if num2's set bits are a subset of num1's.
          final bool isAndPossible = (num1 & num2) == num2;
          _andResult = isAndPossible
              ? 'To get $num2, use mask $num2\n($num1 & $num2 = $num2)'
              : 'Impossible. An AND mask cannot turn a "0" bit into a "1".';

          // OR: Possible only if num1's set bits are a subset of num2's.
          final bool isOrPossible = (num1 | num2) == num2;
          final int orMask = num1 ^ num2;
          _orResult = isOrPossible
              ? 'To get $num2, use mask $orMask\n($num1 | $orMask = $num2)'
              : 'Impossible. An OR mask cannot turn a "1" bit into a "0".';
        }
      } else {
        _singleNumberResults = 'Enter a number to see its bitwise operations.';
      }
    });
  }

  Widget _buildResultCard(String title, String? content, {Color? titleColor}) {
    if (content == null) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: titleColor ?? Colors.deepPurpleAccent[100],
              ),
            ),
            const Divider(height: 20),
            Text(
              content,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Bitwise Calculator'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // --- INPUT FIELDS ---
                TextField(
                  controller: _numberController,
                  decoration: const InputDecoration(
                    labelText: '1. Enter a number',
                    prefixIcon: Icon(Icons.looks_one_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _secondNumberController,
                  decoration: InputDecoration(
                    labelText: '2. Optional: Target number',
                    prefixIcon: const Icon(Icons.looks_two_outlined),
                    helperText: 'Finds the mask to get from #1 to #2',
                    helperStyle: TextStyle(color: Colors.greenAccent[100]),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _thirdNumberController,
                  decoration: InputDecoration(
                    labelText: '3. Optional: XOR mask',
                    prefixIcon: const Icon(Icons.key),
                    helperText: 'Applies this mask to the first number',
                    helperStyle: TextStyle(color: Colors.orangeAccent[100]),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                const SizedBox(height: 30),

                // --- RESULTS SECTION ---
                _buildResultCard(
                    'Single Number Operations',
                    _singleNumberResults.isNotEmpty
                        ? _singleNumberResults
                        : null),

                _buildResultCard('Custom XOR Operation', _customXorResult,
                    titleColor: Colors.orangeAccent),

                if (_secondNumberController.text.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Two-Number Transformations',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent[400]),
                    textAlign: TextAlign.center,
                  ),
                  _buildResultCard('XOR Transformation', _xorResult,
                      titleColor: Colors.greenAccent),
                  _buildResultCard('AND Transformation', _andResult,
                      titleColor: Colors.greenAccent),
                  _buildResultCard('OR Transformation', _orResult,
                      titleColor: Colors.greenAccent),
                ],

                const SizedBox(height: 30),
                // --- CLEAR BUTTON ---
                ElevatedButton.icon(
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Clear All Inputs'),
                  onPressed: _clearAll,
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red[700],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
