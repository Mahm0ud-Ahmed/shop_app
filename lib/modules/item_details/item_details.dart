import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/model/item_details_model.dart';
import 'package:salla/modules/item_details/cubit.dart';
import 'package:salla/modules/item_details/states.dart';
import 'package:salla/shared/network/local/salla_States.dart';
import 'package:salla/shared/style/colors.dart';

class ItemDetails extends StatefulWidget {
  static const String ITEM_DETAILS_SCREEN = 'item_details';

  int id;

  ItemDetails({this.id});

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  int currentIndex = 0;

  ItemDetailsCubit detailsCubit;

  ItemDetailsModel itemDetailsModel;

  @override
  void initState() {
    super.initState();
    detailsCubit = ItemDetailsCubit.get(context);
    detailsCubit.getItemDetailsFromServer(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemDetailsCubit, SallaStates>(
      listener: (BuildContext context, state) {
        if (state is SuccessItemDetailsState) {
          itemDetailsModel = detailsCubit.itemDetailsModel;
          // print(itemDetailsModel.data.name);
        }
      },
      builder: (BuildContext context, state) {
        currentIndex = detailsCubit.currentIndexImage;
        return Scaffold(
          appBar: AppBar(
            title: Text('Salla'),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: itemDetailsModel != null
                  ? Column(
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        buildHeadItem(itemDetailsModel, context),
                        SizedBox(
                          height: 12,
                        ),
                        buildDescriptionItem(itemDetailsModel, context),
                      ],
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          ),
        );
      },
    );
  }

  Widget buildHeadItem(ItemDetailsModel model, context) {
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
                imageUrl: model.data.images[currentIndex],
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
              ...List.generate(model.data.images.length, (index) {
                return buildSmallImage(model.data.images, index);
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSmallImage(List<dynamic> images, int indexImage) {
    return GestureDetector(
      onTap: () {
        detailsCubit.changeIndex(images.length, indexImage);
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
          imageUrl: images[indexImage],
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget buildDescriptionItem(ItemDetailsModel model, context) {
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
              model.data.name,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.black,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: detailsCubit.isSeeMore
                ? Text(
                    model.data.description,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          color: Colors.grey,
                          height: 1.3,
                        ),
                    textAlign: TextAlign.start,
                  )
                : Text(
                    model.data.description,
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
          if (!model.data.inCart)
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

  Widget ImageDialog(context, ItemDetailsModel model) {
    return Dialog(
      child: AnimatedContainer(
        duration: Duration(seconds: 200),
        child: CachedNetworkImage(
          imageUrl: model.data.images[currentIndex],
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
