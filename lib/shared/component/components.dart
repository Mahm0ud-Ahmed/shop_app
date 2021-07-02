import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salla/shared/style/colors.dart';

void pushAndReplace(context, routeName) {
  Navigator.of(context).pushReplacementNamed(routeName);
}

void pushInStack(context, routeName) {
  Navigator.of(context).pushNamed(routeName);
}

Widget customTextEditing({
  @required String label,
  TextEditingController controller,
  @required Icon icon,
  Function valid,
  Function onSubmit,
  Function onTab,
  @required TextInputType keyboard,
  bool obscureText = false,
  IconButton suffixIcon,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.green.shade700,
          width: 2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          width: 2,
        ),
      ),
      labelText: label,
      prefixIcon: icon,
      suffixIcon: suffixIcon,
    ),
    validator: valid,
    keyboardType: keyboard,
    obscureText: obscureText,
    onFieldSubmitted: onSubmit,
    onTap: onTab,
  );
}

Widget customItem({
  @required BuildContext context,
  @required String image,
  @required String nameProduct,
  @required dynamic price,
  @required dynamic oldPrice,
  @required dynamic discount,
  @required Icon favoriteIcon,
  @required bool isCart,
  @required Function addCart,
  @required Function addFavorite,
  @required Function onPressed,
}) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    child: Card(
      elevation: 4,
      margin: EdgeInsets.all(6),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onPressed,
                    child: CachedNetworkImage(
                      imageUrl: image,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  /*Image(
                    image: NetworkImage(
                      image,
                    ),
                  ),*/
                  flex: 4,
                ),
                SizedBox(
                  height: 8,
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        nameProduct,
                        style: TextStyle(
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                            ('${price.toString()} EGP'),
                            style: TextStyle(
                                fontWeight: FontWeight.w700, color: colorPrim),
                          ),
                          Spacer(),
                          if (discount != 0)
                            Text(
                              '${oldPrice.toString()} EGP',
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: isCart
                            ? ElevatedButton.icon(
                                onPressed: addCart,
                                label: Text('Added'),
                                icon: Icon(Icons.check),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.green.shade300),
                                ),
                              )
                            : ElevatedButton.icon(
                                onPressed: addCart,
                                label: Text('Add to cart'),
                                icon: Icon(Icons.add_shopping_cart_outlined),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // if (discount != 0)
              //   Banner(
              //     message: 'SALE',
              //     location: BannerLocation.topStart,
              //   ),
              /*Text(
                    'DISCOUNT',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),*/
              // decoration: BoxDecoration(color: Colors.amber.withOpacity(1)),
              Spacer(),
              IconButton(icon: favoriteIcon, onPressed: addFavorite),
            ],
          ),
          if (discount != 0)
            Banner(
              message: 'SALE',
              location: BannerLocation.topStart,
            ),
        ],
        // alignment: AlignmentDirectional.topEnd,
      ),
    ),
  );
}
