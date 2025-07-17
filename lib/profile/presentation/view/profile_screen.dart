import 'dart:developer';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wakala/auth/data/profile_data_model.dart';
import 'package:wakala/auth/presentation/view/widgets/DefaultAuthButton.dart';
import 'package:wakala/chat/data/chat_screen_arguments.dart';
import 'package:wakala/chat/data/chats_data_model.dart';
import 'package:wakala/home/cubit/main_cubit.dart';
import 'package:wakala/home/cubit/main_cubit_states.dart';
import 'package:wakala/profile/presentation/view/widgets/profile_screen_arguments.dart';
import 'package:wakala/utilities/local/localization_services.dart';
import 'package:wakala/utilities/network/end_points.dart';
import 'package:wakala/utilities/resources/alerts.dart';
import 'package:wakala/utilities/resources/assets_manager.dart';
import 'package:wakala/utilities/resources/colors_manager.dart';
import 'package:wakala/utilities/resources/components.dart';
import 'package:wakala/utilities/resources/constants_manager.dart';
import 'package:wakala/utilities/resources/repo.dart';
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
  int? id;
  bool followed = false;
  @override
  void didChangeDependencies() async{
    ProfileScreenArguments args = ModalRoute.of(context)!.settings.arguments as ProfileScreenArguments;
    _isOther = args.isOthers;
    if(!_isOther){
      _profileDataModel = args.profileDataModel;
      log(_profileDataModel!.result!.id.toString());
      if(MainCubit.get(context).myAdsDataModel == null){
        MainCubit.get(context).getMyAds();
      }
    } else {
      id = args.id;
      if(_profileDataModel == null){
        await context.read<MainCubit>().getOtherProfile(id!);
      }
    }
    super.didChangeDependencies();
  }

  bool _checkIfFollowed(){
    bool followed = context.read<MainCubit>().followingsDataModel.any((e){
      if(e.userId == _profileDataModel!.result!.id){
        return true;
      }
      return false;
    });
    return followed;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainCubitStates>(
      listener: (context, state) {
        if(state is MainGetOtherProfileSuccessState){
          _profileDataModel = context.read<MainCubit>().otherProfile;
          followed = _checkIfFollowed();
        } else if (state is MainFollowSuccessState) {
          setState(() { followed = true; });
        }
        else if (state is MainUnfollowSuccessState) {
          setState(() { followed = false; });
        }
      },
      builder: (context, state) => Scaffold(
        body: ConditionalBuilder(
          condition: _profileDataModel != null,
          fallback: (context) => Center(child: CircularProgressIndicator(),),
          builder: (context) => Stack(
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
                            onPressed: () {
                              if(AppConstants.isAuthenticated){
                                showDialog(
                                  context: context,
                                  builder: (context) => ReportAlert(
                                    reportType: 'profile',
                                    reportedId: _profileDataModel!.result!.id.toString()
                                  )
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => LoginAlert()
                                );
                              }
                            },
                            imagePath: AssetsManager.report,
                          ),
                          followed?
                          DefaultTitledIconButton(
                            title: LocalizationService.translate(StringsManager.unfollow),
                            onPressed: () => MainCubit.get(context).unfollow(_profileDataModel!.result!.id),
                            imagePath: AssetsManager.unfollow,
                          ): DefaultTitledIconButton(
                            title: LocalizationService.translate(StringsManager.follow),
                            onPressed: () {
                              if(AppConstants.isAuthenticated){
                                MainCubit.get(context).follow(_profileDataModel!.result!.id);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => LoginAlert()
                                );
                              }
                            },
                            imagePath: AssetsManager.add,
                          ),
                          DefaultTitledIconButton(
                            title: LocalizationService.translate(StringsManager.share),
                            onPressed: () => shareButton('${AppConstants.baseUrl}${EndPoints.getOtherProfile}/${_profileDataModel!.result!.id}', 'Check ${_profileDataModel!.result!.name}\'s profile on Wikala!!'),
                            imagePath: AssetsManager.share,
                          ),
                        ]
                      )
                    ),
                  ),
                  if(!_isOther)
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
                        onPressed: () {
                          if(AppConstants.isAuthenticated){
                            Chat? chat;
                            if(MainCubit.get(context).chatsDataModel != null && MainCubit.get(context).chatsDataModel!.result!.chats.isNotEmpty){
                              for (var e in MainCubit.get(context).chatsDataModel!.result!.chats) {
                                if(e.receiver!.id == _profileDataModel!.result!.id){
                                  chat = e;
                                  break;
                                }
                              }
                            }
                            Navigator.push(context, RoutesGenerator.getRoute(RouteSettings(name: Routes.chat, arguments: ChatScreenArgument(_profileDataModel!.result!.id, _profileDataModel!.result!.name, _profileDataModel!.result!.image, chat))));
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => LoginAlert()
                            );
                          }
                        },
                        icon: AssetsManager.chatsIcon,
                        iconColor: ColorsManager.white,
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
                        onPressed: () async {
                          if(AppConstants.isAuthenticated){
                            await FlutterPhoneDirectCaller.callNumber(_profileDataModel!.result!.phone.toString());
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => LoginAlert()
                            );
                          }
                        },
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
          height: AppSizesDouble.s280,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              profileDataModel.result!.image == null?
              SvgPicture.asset(
                AssetsManager.defaultAvatar,
                fit: BoxFit.cover,
              ):
              Image.network(
                AppConstants.baseImageUrl + profileDataModel.result!.image!,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
              if(!isOther)
              Positioned(
                top: MediaQuery.of(context).padding.top + kToolbarHeight,
                right: AppPaddings.p10,
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
                      onPressed: () {
                        shareButton('${AppConstants.baseUrl}${EndPoints.getOtherProfile}/${Repo.profileDataModel!.result!.id}', 'Check this profile!!');
                      },
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
        if(profileDataModel.result!.address.isNotEmpty)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPaddings.p15,),
          child: Text('${profileDataModel.result!.address[0]!.region!.name} ${profileDataModel.result!.address[0]!.street??' '}', style: Theme.of(context).textTheme.bodyLarge, maxLines: AppSizes.s1, overflow: TextOverflow.ellipsis,),
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
    return ConditionalBuilder(
      condition: MainCubit.get(context).myAdsDataModel != null && state is !MainGetMyAdsLoadingState,
      fallback: (context) {
        if(state is MainGetMyAdsLoadingState){
          return SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(),));
        }
        return SliverToBoxAdapter(child: Center(child: Text(LocalizationService.translate(StringsManager.noItemsYet))));
      },
      builder: (context) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => HorizontalProductCard(commercialItem: MainCubit.get(context).myAdsDataModel!.result[index], isRecentlyViewing: isOthers),
          childCount: MainCubit.get(context).myAdsDataModel!.result.length
        ),
      ),
    );
  }
}

