
import"package:flutter/material.dart";
maintenanceDropDown(String label, String? value, List<String> items,void Function(String?)? onChanged,{ bool isIgnore=false}) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: IgnorePointer(
        ignoring: isIgnore,
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration.collapsed(hintText: ''),
            value: value,
        iconEnabledColor:isIgnore?Colors.grey :null,
            hint: Text(label,style:const  TextStyle(fontSize: 13),),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item,style:  TextStyle(fontSize: 13,color: isIgnore?Colors.grey:null)),
              );
            }).toList(),
            onChanged:onChanged
          ),
        ),
      ),
    );
  }