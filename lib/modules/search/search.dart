import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/model/search_model.dart';
import 'package:salla/modules/search/cubit.dart';
import 'package:salla/modules/search/search_state.dart';
import 'package:salla/shared/component/components.dart';
import 'package:salla/shared/network/local/salla_States.dart';
import 'package:salla/shared/style/colors.dart';

class Search extends StatelessWidget {
  static const String SEARCH_SCREEN = 'search_layout';

  const Search({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SearchModel searchModel;
    return Scaffold(
      body: BlocProvider<SearchCubit>(
        create: (context) => SearchCubit(),
        child: BlocConsumer<SearchCubit, SallaStates>(
          listener: (BuildContext context, state) {
            if (state is SuccessSearchState) {
              searchModel = SearchCubit.get(context).searchModel;
              print(searchModel.data.total);
            }
          },
          builder: (BuildContext context, state) {
            return SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Column(
                  children: [
                    customTextEditing(
                      label: 'Search',
                      icon: Icon(Icons.search),
                      keyboard: TextInputType.text,
                      onSubmit: (String value) {
                        if (value.isNotEmpty) {
                          SearchCubit.get(context).getSearch(value.toString());
                        }
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    if (state is LoadingSearchState)
                      Center(child: LinearProgressIndicator()),
                    if (searchModel != null)
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return buildItemSearch(
                                searchModel.data.searchItemData[index]);
                          },
                          itemCount: searchModel.data.total,
                          physics: BouncingScrollPhysics(),
                        ),
                      )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildItemSearch(model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: double.infinity,
        height: 100,
        child: Card(
          color: Colors.grey.shade50,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CachedNetworkImage(
                    imageUrl: model.image,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    fit: BoxFit.fill,
                  ),
                  flex: 1,
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        model.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          height: 1.3,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${model.price} EGP',
                        style: TextStyle(
                          color: colorPrim,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
