import 'dart:ui';

import 'package:demo/blocs/product/product_bloc.dart';
import 'package:demo/blocs/product/product_event.dart';
import 'package:demo/blocs/product/product_state.dart';
import 'package:demo/core/Colors.dart';
import 'package:demo/models/product.dart';
import 'package:demo/ui/widgets/animatedTextField.dart';
import 'package:demo/ui/widgets/customeButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _imageController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    _imageController = TextEditingController(
      text: widget.product?.imageUrl ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.product?.category ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductAdded || state is ProductUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.product == null ? 'Product added' : 'Product updated',
              ),
            ),
          );
          context.read<ProductBloc>().add(LoadProducts());
          Navigator.pop(context);
        } else if (state is ProductError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.errorColor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                title: Text(
                  widget.product == null ? 'Add Product' : 'Edit Product',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.15),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              AnimatedTextField(
                                controller: _nameController,
                                label: 'Name',
                                icon: Icons.label,
                                delay: const Duration(milliseconds: 100),
                                validator:
                                    (value) =>
                                        value!.isEmpty ? 'Required' : null,
                              ),
                              const SizedBox(height: 16),
                              AnimatedTextField(
                                controller: _priceController,
                                label: 'Price',
                                icon: Icons.attach_money,
                                delay: const Duration(milliseconds: 200),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              AnimatedTextField(
                                controller: _imageController,
                                label: 'Image URL',
                                icon: Icons.image,
                                delay: const Duration(milliseconds: 300),
                                validator:
                                    (value) =>
                                        value!.isEmpty ? 'Required' : null,
                              ),
                              const SizedBox(height: 16),
                              AnimatedTextField(
                                controller: _descriptionController,
                                label: 'Description',
                                icon: Icons.description,
                                delay: const Duration(milliseconds: 400),
                                maxLines: 3,
                                validator:
                                    (value) =>
                                        value!.isEmpty ? 'Required' : null,
                              ),
                              const SizedBox(height: 16),
                              AnimatedTextField(
                                controller: _categoryController,
                                label: 'Category',
                                icon: Icons.category,
                                delay: const Duration(milliseconds: 500),
                                validator:
                                    (value) =>
                                        value!.isEmpty ? 'Required' : null,
                              ),
                              const SizedBox(height: 24),
                              Center(
                                child: CustomSubmitButton(
                                  label:
                                      widget.product == null ? 'Add' : 'Update',
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      double? price;
                                      try {
                                        price = double.parse(
                                          _priceController.text,
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Please enter a valid price',
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      final product = Product(
                                        id:
                                            widget.product?.id ??
                                            DateTime.now().toString(),
                                        name: _nameController.text,
                                        price: price,
                                        imageUrl: _imageController.text,
                                        description:
                                            _descriptionController.text,
                                        category: _categoryController.text,
                                      );

                                      if (widget.product == null) {
                                        context.read<ProductBloc>().add(
                                          AddProduct(product: product),
                                        );
                                      } else {
                                        context.read<ProductBloc>().add(
                                          UpdateProduct(product: product),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
