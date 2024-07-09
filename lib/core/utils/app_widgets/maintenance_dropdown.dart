import"package:flutter/material.dart";
maintenanceDropDown(String label, String? value, List<String> items,void Function(String?)? onChanged) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration.collapsed(hintText: ''),
          value: value,
          hint: Text(label,style:const  TextStyle(fontSize: 15),),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item,style:const  TextStyle(fontSize: 15)),
            );
          }).toList(),
          onChanged:onChanged
        ),
      ),
    );
  }