import 'package:flutter/material.dart';
import 'package:order_up/providers/products.dart';
import 'package:order_up/widgets/product_component/product_details.dart';

class ProductCard extends StatelessWidget {
  final Product merchandiseCard;

  const ProductCard({required this.merchandiseCard, super.key});

  void selectMeal(BuildContext context) {
    Navigator.of(context).pushNamed(
      ProductDetails.routeName,
      arguments: merchandiseCard,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectMeal(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: Image.network(
                    merchandiseCard.image[0],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  child: Container(
                    padding: EdgeInsets.only(left: 13, right: 5),
                    width: 250,
                    color: Colors.black45,
                    child: Text(
                      merchandiseCard.title,
                      style: TextStyle(fontSize: 22, color: Colors.white),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(Icons.wallet),
                      SizedBox(
                        width: 6,
                      ),
                      Text('${merchandiseCard.price[0].toString()} Rial'),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
