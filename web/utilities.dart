class DataPair {
  String dataName;
  String dataValue;
  
  DataPair(this.dataName, this.dataValue);
}

List<int> genIntSeq(size) {
  List<int> result = new List<int>();
  for (var i = 0; i < size; i++) {
    result.add(i);
  }
  return result;
}

String insertIntoPlaceholder(String text, String tagName, String value) {
  int startPoint = text.indexOf(tagName);
  int endPoint = startPoint + tagName.length;
  String start = text.substring(0,startPoint);
  String resume = text.substring(endPoint);
  text = start;
  text += value;
  text += resume;
  return text;
}

Map<String, String> monthNames = {
  '1': 'January',
  '2': 'February',
  '3': 'March',
  '4': 'April',
  '5': 'May',
  '6': 'June',
  '7': 'July',
  '8': 'August',
  '9': 'September',
  '10': 'October',
  '11': 'November',
  '12': 'December'
};