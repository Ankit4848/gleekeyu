import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gleekeyu/src/SubPages/SearchPlaces/searchBar.dart';
import 'package:gleekeyu/src/SubPages/appBarWithTitleAndBack.dart';
import 'package:gleekeyu/utils/style/constants.dart';
import 'package:gleekeyu/widgets/property_widget.dart';
import '../../../widgets/Shimmer/property_shimmer.dart';
import 'property_type_by_id_controller.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PropertyTypeByIdPage extends StatelessWidget {
  String name;
  int id;
  PropertyTypeByIdPage({super.key, required this.name, required this.id});

  PropertyTypeByIdController getController =
      Get.put(PropertyTypeByIdController());

  @override
  Widget build(BuildContext context) {
    getController.getApi(id, getController.offset, getController.limit,
        isRefresh: false);
    getController.id = id;
    getController.update();
    return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBarWithTitleAndBack(title: name),
        body: GetBuilder<PropertyTypeByIdController>(
          initState: (a) {},
          builder: (a) {
            return Padding(
              padding:
                  const EdgeInsets.fromLTRB(pagePadding, 0, pagePadding, 8),
              child: Column(
                children: [
                  SearchBarWidget(   uniqueId: 'ptype',),
                  const SizedBox(
                    height: 15,
                  ),
                  GetBuilder<PropertyTypeByIdController>(
                    initState: (a) {},
                    builder: (a) {
                      return Flexible(
                          child: a.isDataLoaded
                              ? SmartRefresher(
                                  controller: a.refreshController,
                                  scrollController: a.controller,
                                  header: BezierHeader(
                                    child: Center(
                                      child: Icon(
                                        Icons.rocket,
                                        size: 62,
                                        color: Colors.black.withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                  onLoading: () {
                                    a.getApi(id, a.offset, a.limit,
                                        isRefresh: false);
                                  },
                                  onRefresh: () {
                                    a.getApi(id, 0, 4, isRefresh: true);
                                    // onRefresh != null ? onRefresh() : null;
                                  },
                                  enablePullUp: true,
                                  primary: false,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    controller: a.controller,
                                    itemCount: a.isExtraLoading
                                        ? a.properties.length + 1
                                        : a.properties.length,
                                    itemBuilder: ((context, index) {
                                      return index != a.properties.length
                                          ? PropertyVertical(
                                              properties: a.properties[index],fromSearch: false,startDate: "",endDate: "",)
                                          : a.isLast
                                              ? const SizedBox()
                                              : const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Center(
                                                      child: SizedBox(
                                                          height: 30,
                                                          width: 30,
                                                          child:
                                                              CircularProgressIndicator())),
                                                );
                                    }),
                                  ))
                              : ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 24,
                                    );
                                  },
                                  itemCount: 3,
                                  itemBuilder: ((context, index) {
                                    return const PropertyShimmer();
                                  })));
                    },
                  ),
                  // GetBuilder<PropertyTypeByIdController>(
                  //   initState: (a) {},
                  //   builder: (a) {
                  //     return a.isExtraLoading
                  //         ? CircularProgressIndicator()
                  //         : SizedBox();
                  //   },
                  // )
                ],
              ),
            );
          },
        ));
  }
}
