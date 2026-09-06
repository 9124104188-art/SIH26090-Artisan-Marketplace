import 'package:flutter/material.dart';
import '../models/product.dart';
import '../controllers/cart_controller.dart';
import '../widgets/product_card.dart';

class SearchScreen extends StatefulWidget{final List<Product> products;final ValueChanged<Product> onProduct; final CartController cart; const SearchScreen({super.key,required this.products,required this.onProduct,required this.cart});@override State<SearchScreen> createState()=>_SearchScreenState();}
class _SearchScreenState extends State<SearchScreen>{final controller=TextEditingController();late List<Product> result;@override void initState(){super.initState();result=widget.products;}void search(String q){setState(()=>result=widget.products.where((p)=>p.name.toLowerCase().contains(q.toLowerCase())||p.category.toLowerCase().contains(q.toLowerCase())||p.artisan.toLowerCase().contains(q.toLowerCase())).toList());}
@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:TextField(controller:controller,autofocus:true,onChanged:search,decoration:const InputDecoration(hintText:'Search products, artisans...',border:InputBorder.none,filled:false),textInputAction:TextInputAction.search)),body:result.isEmpty?const Center(child:Text('No matching products')):GridView.builder(padding:const EdgeInsets.all(14),itemCount:result.length,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:10,mainAxisSpacing:10,childAspectRatio:.65),itemBuilder:(c,i)=>ProductCard(product:result[i],onTap:()=>widget.onProduct(result[i]),onAdd:(){widget.cart.add(result[i]); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Added to cart')));})));
}
