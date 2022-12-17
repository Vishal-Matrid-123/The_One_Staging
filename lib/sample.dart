const text = '''
Lorem Ipsum is simply dummy text of the 123.456 printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an 12:30 unknown printer took a galley of type and scrambled it to make a
23.4567
type specimen book. It has 445566 survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
''';

final intRegex = RegExp(r'\s+(\d+)\s+', multiLine: true);
final doubleRegex = RegExp(r'\s+(\d+\.\d+)\s+', multiLine: true);
final timeRegex = RegExp(r'\s+(\d{1,2}:\d{2})\s+', multiLine: true);
void main() {
  print(intRegex.allMatches(text).map((m) => m.group(0)));
  print(doubleRegex.allMatches(text).map((m) => m.group(0)));
  print(timeRegex.allMatches(text).map((m) => m.group(0)));
}
