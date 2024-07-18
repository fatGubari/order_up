import 'package:flutter/material.dart';
import 'package:order_up/items/side_bar_supplier.dart';
import 'package:order_up/providers/auth.dart';
import 'package:order_up/providers/products.dart';
import 'package:provider/provider.dart';

class AddEditProduct extends StatefulWidget {
  const AddEditProduct({super.key});
  static const routeName = '/add-edit-product';

  @override
  State<AddEditProduct> createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProduct> {
  final _form = GlobalKey<FormState>();
  final _imageUrlController = TextEditingController();
  final _priceFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  var _isLoading = false;
  var _isInit = true;

  var _editedProduct = Product(
    id: '',
    title: '',
    supplier: '',
    category: '',
    amount: [],
    description: '',
    image: [],
    price: [],
  );

  var _initValues = {
    'title': '',
    'price': '',
    'amount': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void dispose() {
    _imageUrlController.dispose();
    _priceFocusNode.dispose();
    _amountFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      final authProvider = Provider.of<Auth>(context, listen: false);
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId.toString());
        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.join(' , '),
          'amount': _editedProduct.amount.join(' , '),
          'description': _editedProduct.description,
          'imageUrl':
              _editedProduct.image.isNotEmpty ? _editedProduct.image[0] : '',
        };
        _imageUrlController.text = _initValues['imageUrl']!;
      } else {
        _editedProduct = Product(
          id: '',
          title: '',
          supplier: authProvider.profileData?.name ?? '',
          category: authProvider.profileData?.category ?? '',
          amount: [],
          description: '',
          image: [],
          price: [],
        );
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future _saveForm() async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id.isNotEmpty) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
            // ignore: use_build_context_synchronously
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occurred!'),
                  content: Text(e.toString()),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text('Okay'))
                  ],
                ));
        rethrow;
      }
    }

    setState(() {
      _isLoading = false;
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBarSupplier(),
      appBar: AppBar(
        title: Text('Product Info',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
              onPressed: () {
                _saveForm();
              },
              icon: Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value!,
                          supplier: _editedProduct.supplier,
                          category: _editedProduct.category,
                          amount: _editedProduct.amount,
                          description: _editedProduct.description,
                          image: _editedProduct.image,
                          price: _editedProduct.price,
                        );
                      },
                    ),
                    // TextFormField(
                    //   initialValue: _initValues['price'],
                    //   decoration: InputDecoration(labelText: 'Price'),
                    //   textInputAction: TextInputAction.next,
                    //   keyboardType: TextInputType.number,
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return 'Please enter a price.';
                    //     }
                    //     if (double.tryParse(value) == null) {
                    //       return 'Please enter a valid number.';
                    //     }
                    //     if (double.parse(value) <= 0) {
                    //       return 'Please enter a number greater than zero.';
                    //     }
                    //     return null;
                    //   },
                    //   focusNode: _priceFocusNode,
                    //   onFieldSubmitted: (_) {
                    //     FocusScope.of(context).requestFocus(_amountFocusNode);
                    //   },
                    //   onSaved: (value) {
                    //     _editedProduct = Product(
                    //       id: _editedProduct.id,
                    //       title: _editedProduct.title,
                    //       supplier: _editedProduct.supplier,
                    //       category: _editedProduct.category,
                    //       amount: _editedProduct.amount,
                    //       description: _editedProduct.description,
                    //       image: _editedProduct.image,
                    //       price: double.parse(value!),
                    //     );
                    //   },
                    // ),
                    if (_editedProduct.price.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _editedProduct.price.length,
                        itemBuilder: (ctx, index) => Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue:
                                    _editedProduct.price[index].toString(),
                                decoration: InputDecoration(
                                  labelText: 'Price ${index + 1}',
                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please provide a value.';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid number.';
                                  }
                                  if (double.parse(value) <= 0) {
                                    return 'Please enter a number greater than zero.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedProduct.price[index] =
                                      value!;
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  _editedProduct.price.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _editedProduct.price.add('');
                        });
                      },
                      child: Text('Add Price'),
                    ),

                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _editedProduct.amount.length,
                      itemBuilder: (ctx, index) => Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: _editedProduct.amount[index],
                              decoration: InputDecoration(
                                labelText: 'Amount ${index + 1}',
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please provide a value.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedProduct.amount[index] = value!;
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _editedProduct.amount.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _editedProduct.amount.add('');
                        });
                      },
                      child: Text('Add Amount'),
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description.';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          supplier: _editedProduct.supplier,
                          category: _editedProduct.category,
                          amount: _editedProduct.amount,
                          description: value!,
                          image: _editedProduct.image,
                          price: _editedProduct.price,
                        );
                      },
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _editedProduct.image.length,
                      itemBuilder: (ctx, index) => Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: _editedProduct.image[index],
                              decoration: InputDecoration(
                                labelText: 'Image URL ${index + 1}',
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (!value!.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg')) {
                                  return 'Please enter a valid image URL';
                                }
                                if (value.isEmpty) {
                                  return 'Please enter an image URL.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedProduct.image[index] = value!;
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _editedProduct.image.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _editedProduct.image.add('');
                        });
                      },
                      child: Text('Add Image URL'),
                    ),
                  ],
                )),
      ),
    );
  }
}
