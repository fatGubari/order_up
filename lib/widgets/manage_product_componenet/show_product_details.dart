import 'package:flutter/material.dart';
import 'package:order_up/providers/products.dart';

void showProductDetails(BuildContext context, Product product) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.all(10.0),
            child: ListView(
              controller: scrollController,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.title,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Supplier: ${product.supplier}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Category: ${product.category}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Price: Rial ${product.price.join(',').toString()}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Available Amounts: ${product.amount.join(', ')}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Images:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: product.image.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Image.network(
                          product.image[index],
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
