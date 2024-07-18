import 'package:flutter/material.dart';
import 'package:order_up/widgets/product_component/text_builder.dart';

class DropdownQuantity extends StatefulWidget {
  final List<String> quantity;
  final void Function(String, int) onAmountSelected;
  const DropdownQuantity(
    this.quantity, {
    super.key,
    required this.onAmountSelected,
  });

  @override
  State<DropdownQuantity> createState() => _DropdownQuantityState();
}

class _DropdownQuantityState extends State<DropdownQuantity> {
  String? selectedAmount;

  @override
  void initState() {
    selectedAmount = widget.quantity[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextBuilder('Amount: ', 18),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          // height: 20,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButton<String>(
              underline: Container(height: 2, color: Colors.black),
              value: selectedAmount,
              hint: Text('Kg'),
              items: widget.quantity
                  .map((amountElement) => DropdownMenuItem<String>(
                        value: amountElement,
                        child: Text(amountElement),
                        onTap: () {},
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedAmount = value!;
                  int index = widget.quantity.indexOf(selectedAmount!);
                  widget.onAmountSelected(selectedAmount!, index);
                });
              },
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
