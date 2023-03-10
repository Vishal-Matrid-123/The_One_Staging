// import 'package:flutter/material.dart';
//
// class MultiSelectDialogItem<V> {
//   const MultiSelectDialogItem(
//     this.value,
//     this.label,
//   );
//
//   final V value;
//   final String label;
// }
//
// class MultiSelectDialog1<V> extends StatefulWidget {
//   MultiSelectDialog1(
//       {Key? key,
//       required this.items,
//       required this.initialSelectedValues,
//       required this.title})
//       : super(key: key);
//
//   final List<MultiSelectDialogItem<V>> items;
//   final Set<V> initialSelectedValues;
//   final String title;
//
//   @override
//   State<StatefulWidget> createState() => _MultiSelectDialog1State<V>();
// }
//
// class _MultiSelectDialog1State<V> extends State<MultiSelectDialog1<V>> {
//   final _selectedValues = Set<V>();
//
//   void initState() {
//     super.initState();
//     _selectedValues.addAll(widget.initialSelectedValues);
//   }
//
//   void _onItemCheckedChange(V itemValue, bool checked) {
//     setState(() {
//       if (checked) {
//         _selectedValues.add(itemValue);
//       } else {
//         _selectedValues.remove(itemValue);
//       }
//     });
//   }
//
//   void _onCancelTap() {
//     Navigator.pop(context);
//   }
//
//   void _onSubmitTap() {
//     Navigator.pop(context, _selectedValues);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(widget.title),
//       contentPadding: EdgeInsets.only(top: 12.0),
//       content: SingleChildScrollView(
//         child: ListTileTheme(
//           contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
//           child: ListBody(
//             children: widget.items.map(_buildItem).toList(),
//           ),
//         ),
//       ),
//       actions: <Widget>[
//         FlatButton(
//           child: Text('CANCEL'),
//           onPressed: _onCancelTap,
//         ),
//         FlatButton(
//           child: Text('OK'),
//           onPressed: _onSubmitTap,
//         )
//       ],
//     );
//   }
//
//   Widget _buildItem(MultiSelectDialogItem<V> item) {
//     final checked = _selectedValues.contains(item.value);
//     return CheckboxListTile(
//       value: checked,
//       title: Text(item.label),
//       controlAffinity: ListTileControlAffinity.leading,
//       onChanged: (checked) => _onItemCheckedChange(item.value, checked!),
//     );
//   }
// }
