/// Formats an integer amount as Chilean pesos (e.g. 32000 -> "$32.000"),
/// matching the prototype's `n.toLocaleString('es-CL')`.
String formatClp(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return '\$$buffer';
}
