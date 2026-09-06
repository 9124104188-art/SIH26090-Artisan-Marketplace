import 'package:flutter/material.dart';
import '../data/catalog.dart';
import '../models/product.dart';
import '../controllers/cart_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import 'category_screen.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<Product> onProduct;
  final CartController cart;
  const HomeScreen({super.key, required this.onProduct, required this.cart});
  @override Widget build(BuildContext context){
    final products=buildProducts(); final featured=products.where((p)=>p.featured).take(8).toList();
    return ListView(padding:const EdgeInsets.fromLTRB(16,12,16,20),children:[
      Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:AppColors.green,borderRadius:BorderRadius.circular(18)),child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Discover Handmade Happiness',style:TextStyle(color:Colors.white,fontSize:21,fontWeight:FontWeight.w900)),SizedBox(height:6),Text('Shop local. Support artisans. Make a difference.',style:TextStyle(color:Colors.white70)),SizedBox(height:14)])),
      const SizedBox(height:18),
      const Text('Categories',style:TextStyle(fontWeight:FontWeight.w900,fontSize:18)),
      const SizedBox(height:10), SizedBox(height:114,child:ListView.separated(scrollDirection:Axis.horizontal,itemCount:categories.length,itemBuilder:(c,i){final cat=categories[i];return SizedBox(width:92,child:InkWell(onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>CategoryScreen(onProduct:onProduct,cart:cart,initialCategory:cat.name))),child:Column(children:[Container(width:70,height:70,decoration:BoxDecoration(borderRadius:BorderRadius.circular(18),boxShadow:[BoxShadow(color:Colors.black.withValues(alpha:0.08),blurRadius:8,offset:const Offset(0,3))]),clipBehavior:Clip.antiAlias,child:Stack(fit:StackFit.expand,children:[Image.network(cat.imageUrl,fit:BoxFit.cover,errorBuilder:(_,__,___)=>Container(color:AppColors.softGreen)),Container(color:Colors.black.withValues(alpha:0.12)),Center(child:Icon(cat.icon,size:28,color:Colors.white))])),const SizedBox(height:5),Text(cat.name,textAlign:TextAlign.center,maxLines:2,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize:11,fontWeight:FontWeight.w700))])));},separatorBuilder:(_,__)=>const SizedBox(width:8))),
      const SizedBox(height:22), Row(children:[const Expanded(child:Text('Featured Products',style:TextStyle(fontWeight:FontWeight.w900,fontSize:18))),TextButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>CategoryScreen(onProduct:onProduct,cart:cart))),child:const Text('View All'))]),
      GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),itemCount:featured.length,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:10,mainAxisSpacing:10,childAspectRatio:.66),itemBuilder:(c,i)=>ProductCard(product:featured[i],onTap:()=>onProduct(featured[i]),onAdd:(){cart.add(featured[i]); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Added to cart')));})),
    ]);
  }
}
