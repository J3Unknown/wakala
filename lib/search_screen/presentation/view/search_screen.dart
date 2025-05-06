import 'package:flutter/material.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:wakala/utilities/resources/strings_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  final List<DropdownMenuItem<String>> _items = [
    DropdownMenuItem(value: 'nigga1',child: Text('data1')),
    DropdownMenuItem(value: 'nigga2',child: Text('data2'),),
    DropdownMenuItem(value: 'nigga3',child: Text('data3'),),
    DropdownMenuItem(value: 'nigga4',child: Text('data4'),),
  ];

  String? _filterSelection;
  String? _locationFilterSelection;
  String? _priceFilterSelection;
  String? _conditionFilterSelection;
  List<FilterDropDown> _filterItems = [];

  @override
  Widget build(BuildContext context) {
    _filterItems = [
      FilterDropDown(
        title: StringsManager.filter,
        selectedItem: _filterSelection,
        items: _items,
        icon: Icons.filter_alt_rounded,
        onChange: (value){
          setState(() {
            _filterSelection = value;
          });
        },
      ),
      FilterDropDown(
        title: StringsManager.location,
        selectedItem: _locationFilterSelection,
        items: _items,
        icon: Icons.filter_alt_rounded,
        onChange: (value){
          setState(() {
            _locationFilterSelection = value;
          });
        },
      ),
      FilterDropDown(
        title: StringsManager.filter,
        selectedItem: _priceFilterSelection,
        items: _items,
        icon: Icons.filter_alt_rounded,
        onChange: (value){
          setState(() {
            _priceFilterSelection = value;
          });
        },
      ),
      FilterDropDown(
        title: StringsManager.filter,
        selectedItem: _conditionFilterSelection,
        items: _items,
        icon: Icons.filter_alt_rounded,
        onChange: (value){
          setState(() {
            _conditionFilterSelection = value;
          });
        },
      ),
    ];
    return Hero(
      tag: KeysManager.searchBarHeroTag,
      child: Scaffold(
        appBar: appBar(
          titleSectionList: CustomSearchBar(searchController: _searchController, onChange: (){}) //TODO: implement the search Method in the Cubit
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
          child: Column(
            children: [
              CategoriesScroll(),
              //TODO: implement on changed and add all the filtration fields
              FilterList(filterItems: _filterItems),

            ],
          ),
        ) 
      ),
    );
  }
}