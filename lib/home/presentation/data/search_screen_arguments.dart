import 'package:wakala/home/data/categories_data_model.dart';

class SearchScreenArguments{
  Categories? categories;
  int categoryId;

  SearchScreenArguments(this.categoryId, {this.categories});
}