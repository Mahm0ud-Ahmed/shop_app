import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/model/home_model.dart';
import 'package:salla/modules/item_details/cubit.dart';
import 'package:salla/shared/network/local/salla_States.dart';
import 'package:salla/shared/style/colors.dart';

class ItemDetails extends StatelessWidget {
  static const String ITEM_DETAILS_SCREEN = 'item_details';
  int currentIndex = 0;
  ItemDetailsCubit detailsCubit;
  dynamic model;

  @override
  Widget build(BuildContext context) {
    model = ModalRoute.of(context).settings.arguments;
    return BlocProvider<ItemDetailsCubit>(
      create: (BuildContext context) {
        return ItemDetailsCubit();
      },
      child: BlocConsumer<ItemDetailsCubit, SallaStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) {
          detailsCubit = ItemDetailsCubit.get(context);
          currentIndex = detailsCubit.currentIndexImage;
          return Scaffold(
            appBar: AppBar(
              title: Text('Salla'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  buildHeadItem(model, context),
                  SizedBox(
                    height: 12,
                  ),
                  buildDescriptionItem(model, context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildHeadItem(ProductModel model, context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: AspectRatio(
            aspectRatio: 1.9,
            child: GestureDetector(
              onTap: () {
                showGeneralDialog(
                    context: context,
                    pageBuilder: (context, anim1, anim2) {},
                    barrierLabel: '',
                    barrierDismissible: true,
                    transitionDuration: Duration(milliseconds: 300),
                    transitionBuilder: (context, a1, a2, widget) {
                      return Transform.scale(
                        scale: a1.value,
                        child: Opacity(
                          opacity: a1.value,
                          child: ImageDialog(context, model),
                        ),
                      );
                    });
              },
              child: CachedNetworkImage(
                imageUrl: model.images[currentIndex],
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...List.generate(model.images.length, (index) {
                return buildSmallImage(index);
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSmallImage(int indexImage) {
    return GestureDetector(
      onTap: () {
        detailsCubit.changeIndex(indexImage);
      },
      child: Container(
        padding: EdgeInsets.all(4),
        margin: EdgeInsets.only(right: 8),
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          border: Border.all(
            color: colorPrim.withOpacity(currentIndex == indexImage ? 1 : 0),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: CachedNetworkImage(
          imageUrl: model.images[indexImage],
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget buildDescriptionItem(ProductModel model, context) {
    return Container(
      width: double.infinity,
      // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
            child: Text(
              model.name,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.black,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: detailsCubit.isSeeMore
                ? Text(
                    model.description,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.grey,
                          height: 1.3,
                        ),
                    textAlign: TextAlign.start,
                  )
                : Text(
                    model.description,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.grey,
                          height: 1.3,
                        ),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
          ),
          TextButton(
            onPressed: () {
              detailsCubit.changeSee();
            },
            child: detailsCubit.isSeeMore
                ? Text('See Less')
                : Text('See More Detail'),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Add To Cart'),
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    Size(double.infinity, 60),
                  ),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ))),
            ),
          ),
        ],
      ),
    );
  }

  Widget ImageDialog(context, ProductModel model) {
    return Dialog(
      child: AnimatedContainer(
        duration: Duration(seconds: 200),
        child: CachedNetworkImage(
          imageUrl: model.images[currentIndex],
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
