import 'dart:developer';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakala/auth/data/profile_data_model.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/home/data/commercial_ad_data_model.dart';
import 'package:wakala/profile/presentation/view/widgets/profile_screen_arguments.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:wakala/utilities/resources/routes_manager.dart';

import '../../../utilities/resources/strings_manager.dart';
import '../../../utilities/resources/values_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool _isOther;
  ProfileDataModel? _profileDataModel;

  @override
  void didChangeDependencies() async{
    ProfileScreenArguments args = ModalRoute.of(context)!.settings.arguments as ProfileScreenArguments;
    _isOther = args.isOthers;
    if(!_isOther){
      _profileDataModel = args.profileDataModel;
      MainCubit.get(context).getMyAds();
    } else {
      if(_profileDataModel == null){
        await context.read<MainCubit>().getOtherProfile();
        _profileDataModel = context.read<MainCubit>().otherProfile;
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: ColorsManager.white,
                  floating: true,
                  pinned: true,
                  expandedHeight: AppSizesDouble.s320,
                  flexibleSpace: FlexibleSpaceBar(
                    background: ImageHeaderSection(isOther: _isOther, profileDataModel: _profileDataModel!),
                  ),
                  actions: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15),
                      child: Text(LocalizationService.translate(StringsManager.profile), style: Theme.of(context).textTheme.titleLarge,),
                    ),
                  ],
                ),
                if(_isOther)
                SliverPadding(
                  padding: EdgeInsets.symmetric(vertical: AppPaddings.p10),
                  sliver: SliverToBoxAdapter(
                    child: DefaultActionsRow(
                      children: [
                        DefaultTitledIconButton(
                          title: LocalizationService.translate(StringsManager.report),
                          onPressed: (){},
                          imagePath: AssetsManager.report,
                        ),
                        DefaultTitledIconButton(
                          title: LocalizationService.translate(StringsManager.follow),
                          onPressed: (){},
                          imagePath: AssetsManager.add,
                        ),
                        DefaultTitledIconButton(
                          title: LocalizationService.translate(StringsManager.share),
                          onPressed: (){},
                          imagePath: AssetsManager.share,
                        ),
                      ]
                    )
                  ),
                ),

                SliverProductsList(isOthers: _isOther, state: state,),
              ],
            ),
            if(_isOther)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10, vertical: AppPaddings.p15),
              child: Row(
                children: [
                  Expanded(
                    child: DefaultAuthButton(
                      onPressed: (){},
                      icon: AssetsManager.chatsIcon,
                      title: LocalizationService.translate(StringsManager.message),
                      backgroundColor: ColorsManager.primaryColor,
                      hasBorder: false,
                      foregroundColor: ColorsManager.white,
                      height: AppSizesDouble.s60,
                    )
                  ),
                  SizedBox(width: AppSizesDouble.s10,),
                  Expanded(
                    child: DefaultAuthButton(
                      onPressed: (){},
                      icon: AssetsManager.call,
                      title: LocalizationService.translate(StringsManager.call),
                      backgroundColor: ColorsManager.primaryColor,
                      hasBorder: false,
                      foregroundColor: ColorsManager.white,
                      height: AppSizesDouble.s60,
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageHeaderSection extends StatelessWidget {
  const ImageHeaderSection({
    super.key,
    required this.profileDataModel,
    required this.isOther
  });

  final ProfileDataModel profileDataModel;
  final bool isOther;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: AppSizesDouble.s300,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              profileDataModel.result!.image == null?
              SvgPicture.asset(
                AssetsManager.defaultAvatar,
                fit: BoxFit.cover,
              ):
              Image.network(
                width: double.maxFinite,
                profileDataModel.result!.image!,
                fit: BoxFit.cover,
              ),
              if(!isOther)
              Positioned(
                top: MediaQuery.of(context).padding.top + kToolbarHeight,
                right: AppPaddings.p10,
                // padding: EdgeInsets.symmetric(horizontal: AppPaddings.p10, vertical: 80),
                child: Column(
                  children: [
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: ColorsManager.white,
                      ),
                      onPressed: () => Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.editProfile, arguments: profileDataModel))),
                      icon: SvgPicture.asset(AssetsManager.edit, colorFilter: ColorFilter.mode(ColorsManager.black, BlendMode.srcIn),)
                    ),
                    SizedBox(height: AppPaddings.p10,),
                    IconButton.filled(
                      style: IconButton.styleFrom(
                        backgroundColor: ColorsManager.white,
                      ),
                      onPressed: (){},
                      icon: SvgPicture.asset(AssetsManager.share, colorFilter: ColorFilter.mode(ColorsManager.black, BlendMode.srcIn),)
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(height: AppSizesDouble.s5,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15,),
          child: Text(profileDataModel.result!.name, style: Theme.of(context).textTheme.titleLarge,),
        ),
        if(profileDataModel.result!.address!= null && profileDataModel.result!.address!.isNotEmpty)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15,),
          child: Text(profileDataModel.result!.address![0], style: Theme.of(context).textTheme.bodyLarge,),
        ),
      ],
    );
  }
}

class SliverProductsList extends StatelessWidget {
  const SliverProductsList({super.key, required this.isOthers, required this.state});
  final bool isOthers;
  final MainCubitStates state;
  @override
  Widget build(BuildContext context) {
    log(state.toString());
    return SliverToBoxAdapter(
      child: ConditionalBuilder(
        condition: MainCubit.get(context).userAdDataModel != null && state is !MainGetUserAdLoadingState,
        fallback: (context) {
          if(state is MainGetUserAdLoadingState){
            return Center(child: CircularProgressIndicator(),);
          }
          return Center(child: Text('No Items Yet'));
        },
        builder: (context) => SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => HorizontalProductCard(commercialItem: MainCubit.get(context).userAdDataModel!.result!.commercialAdsItems![index], isRecentlyViewing: isOthers),
            childCount: 10
          ),
        ),
      ),
    );
  }
}

