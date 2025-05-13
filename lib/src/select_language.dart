import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class LanguageSelection extends StatefulWidget {
  String? seletedLanguage = 'German';
  List<String> availableLanguages = <String>['German', 'English', 'French'];
  LanguageSelection({super.key});

  @override
  State<LanguageSelection> createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Language? language = widget.language;
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: const Row(
          children: [
            Icon(Icons.list, size: 16, color: Colors.yellow),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                'Select Item',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items:
            widget.availableLanguages
                .map(
                  (String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
        value: widget.seletedLanguage,
        onChanged: (String? value) {
          setState(() {
            widget.seletedLanguage = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          height: 50,
          width: 160,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black26),
            color: Colors.orangeAccent,
          ),
          elevation: 2,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.arrow_forward_outlined),
          iconSize: 14,
          iconEnabledColor: Colors.yellow,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.deepOrangeAccent,
          ),
          offset: const Offset(-20, 0),
          scrollbarTheme: ScrollbarThemeData(radius: const Radius.circular(40)),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}
