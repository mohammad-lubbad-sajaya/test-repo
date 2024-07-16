  import '../../../features/crm/data/models/drop_down_obj.dart';

List<DropdownObj> convertToDropdownObj(List<String> list) {
    return list.map((item) => DropdownObj(id: item, name: item)).toList();
  }