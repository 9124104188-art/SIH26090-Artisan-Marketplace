import 'package:flutter/material.dart';
import '../data/catalog.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
class RecommendationsScreen extends StatelessWidget{final ValueChanged<Product> onProduct;const RecommendationsScreen({super.key,required this.onProduct});@override Widget build(BuildContext context){final p=buildProducts().where((x)=>x.featured).skip(3).take(8).toList();return Scaffold(appBar:AppBar(title:const Text('Recommended for You')),body:GridView.builder(padding:const EdgeInsets.all(14),itemCount:p.length,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:10,mainAxisSpacing:10,childAspectRatio:.65),itemBuilder:(c,i)=>ProductCard(product:p[i],onTap:()=>onProduct(p[i]),onAdd:()=>onProduct(p[i]))) );}}
