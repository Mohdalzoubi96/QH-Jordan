import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/view/screens/main_category/main_cat_provider/main_cat_provider.dart';
import 'package:provider/provider.dart';

import '../../../helper/responsive_helper.dart';
import '../../../helper/route_helper.dart';
import '../../../localization/language_constrants.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/category_provider.dart';
import '../../../provider/localization_provider.dart';
import '../../../provider/splash_provider.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';
import '../auth/login_screen.dart';
import '../menu/menu_screen.dart';

class MainCatScreen extends StatefulWidget {
  MainCatScreen({Key key});

  @override
  State<MainCatScreen> createState() => _MainCatScreenState();
}

class _MainCatScreenState extends State<MainCatScreen> {
  CategoryProvider categoryProvider;
  MainCatProvider mainCatProvider;
  bool loadData = false;
  bool _isLoggedIn = false;
  AuthProvider _authProvider;

  @override
  void initState() {
    categoryProvider = context.read<CategoryProvider>();
    mainCatProvider = context.read<MainCatProvider>();
    _authProvider = context.read<AuthProvider>();
    _isLoggedIn = _authProvider.isLoggedIn();
    categoryProvider
        .getCategoryList(
      context,
      Provider.of<LocalizationProvider>(context, listen: false)
          .locale
          .languageCode,
      true,
    )
        .then((apiResponse) {
      if (apiResponse.response.statusCode == 200 &&
          apiResponse.response.data != null) {
        load();
      }
    });

    super.initState();
  }

  void load() {
    if (_isLoggedIn) {
      Navigator.pushNamedAndRemoveUntil(
          context, RouteHelper.menu, (route) => false,
          arguments: MenuScreen());
    } else {
      setState(() {
        loadData = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: ResponsiveHelper.isDesktop(context)
                    ? MediaQuery.of(context).size.height - 560
                    : MediaQuery.of(context).size.height,
              ),
              child: loadData
                  ? Padding(
                      padding: ResponsiveHelper.isDesktop(context)
                          ? EdgeInsets.all(0)
                          : ResponsiveHelper.isWeb()
                              ? EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE)
                              : EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                      child: Column(
                        children: [
                          ResponsiveHelper.isDesktop(context)
                              ? SizedBox(
                                  height: 30,
                                )
                              : SizedBox(),
                          Center(
                            child: Container(
                              width: _width > 700 ? 700 : _width,
                              padding: ResponsiveHelper.isDesktop(context)
                                  ? EdgeInsets.symmetric(
                                      horizontal: 100, vertical: 50)
                                  : _width > 700
                                      ? EdgeInsets.all(
                                          Dimensions.PADDING_SIZE_DEFAULT)
                                      : null,
                              decoration: _width > 700
                                  ? BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey[300],
                                            blurRadius: 5,
                                            spreadRadius: 1)
                                      ],
                                    )
                                  : null,
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Image.asset(
                                Images.app_logo,
                                height: ResponsiveHelper.isDesktop(context)
                                    ? MediaQuery.of(context).size.height * 0.15
                                    : MediaQuery.of(context).size.height / 4.5,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Center(
                            child: Text(
                              getTranslated('choose_cat', context),
                              style: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          /// add gridview builder to show main category
                          SizedBox(
                            height: _height * 0.56,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 4,
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.5),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: GridView.builder(
                                itemCount:
                                    categoryProvider.categoryList.length ?? 0,
                                physics: BouncingScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      ResponsiveHelper.isWeb() ? 4 : 2,
                                  crossAxisSpacing: 5.0,
                                  mainAxisSpacing: 5.0,
                                  childAspectRatio: ResponsiveHelper.isWeb()
                                      ? MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height /
                                              1)
                                      : MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height /
                                              1.8),
                                ),
                                itemBuilder: (ctx, index) {
                                  return InkWell(
                                    onTap: () {
                                      final selectedCatId = categoryProvider
                                          .categoryList[index].id;
                                      mainCatProvider
                                          .saveSelectedCatToSharedPrefs(
                                              selectedCatId);
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              RouteHelper.login,
                                              arguments: LoginScreen());
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: _height * 0.19,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.5),
                                              ),
                                              borderRadius:
                                                  BorderRadiusDirectional.only(
                                                topStart: Radius.circular(14.0),
                                                topEnd: Radius.circular(14.0),
                                              ),
                                              image: DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/${categoryProvider.categoryList[index].image}',
                                                  errorListener: () {
                                                    Image.asset(
                                                      Images.placeholder(
                                                          context),
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: _height * 0.03,
                                            width: _width * 0.4,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadiusDirectional.only(
                                                bottomStart:
                                                    Radius.circular(5.0),
                                                bottomEnd: Radius.circular(5.0),
                                              ),
                                            ),
                                            child: Text(
                                              categoryProvider
                                                  .categoryList[index].name,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
