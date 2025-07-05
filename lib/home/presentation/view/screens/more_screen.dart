import 'dart:developer';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
import 'package:wakala/utilities/resources/repo.dart';
import 'package:wakala/utilities/resources/values_manager.dart';

import '../widgets/DefaultAuthenticatedMoreScreen.dart';
import '../widgets/DefaultNonAuthenticatedMoreScreen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10),
        child: BlocConsumer<MainCubit, MainCubitStates>(
          listener: (context, state){
            if(state is MainLogOutSuccessState){
              navigateToAuthLayout(context);
            }
          },
          builder: (context, state) {
            return ConditionalBuilder(
              condition: AppConstants.isAuthenticated && Repo.profileDataModel != null,
              fallback: (context) {
                if(AppConstants.isAuthenticated){
                  return Center(child: CircularProgressIndicator());
                }
                return DefaultNonAuthenticatedMoreScreen();
              },
              builder: (context) => DefaultAuthenticatedMoreScreen(),
            );
          },
        ),
      ),
    );
  }
}

