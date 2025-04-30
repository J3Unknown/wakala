import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:wakala/utilities/resources/icons_manager.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

import '../../../utilities/resources/colors_manager.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final _debouncer = Debouncer(milliseconds: 500);
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'Search-Bar',
      child: Scaffold(
        appBar: appBar(
          titleSectionList: CustomSearchBar(searchController: _searchController, onChange: (){})
        ),
        body: Column(
          children: [

          ],
        ) 
      ),
    );
  }
}
