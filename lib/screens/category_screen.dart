import 'package:flutter/material.dart';
import '../data/catalog.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../controllers/cart_controller.dart';
import 'product_listing_screen.dart';

class CategoryScreen extends StatelessWidget {
  final ValueChanged<Product> onProduct;
  final CartController cart;
  final String? initialCategory;
  const CategoryScreen({super.key, required this.onProduct, required this.cart, this.initialCategory});
  @override Widget build(BuildContext context){return Scaffold(appBar:initialCategory==null?null:AppBar(title:Text(initialCategory!)),body:initialCategory==null?_all(context):ProductListingScreen(category:initialCategory!,onProduct:onProduct,cart:cart));}
  Widget _all(BuildContext context)=>GridView.builder(padding:const EdgeInsets.all(14),itemCount:categories.length+1,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:3,crossAxisSpacing:10,mainAxisSpacing:12,childAspectRatio:.78),itemBuilder:(c,i){if(i==0){return _tile(context,'All Products',Icons.shopping_bag_outlined,defaultCategoryImageUrl,200,null);}final x=categories[i-1];return _tile(context,x.name,x.icon,x.imageUrl,10,x.name);});
  Widget _tile(BuildContext context,String name,IconData icon,String imageUrl,int count,String? cat)=>InkWell(onTap:()=>cat==null?Navigator.push(context,MaterialPageRoute(builder:(_)=>ProductListingScreen(category:null,onProduct:onProduct,cart:cart))):Navigator.push(context,MaterialPageRoute(builder:(_)=>ProductListingScreen(category:cat,onProduct:onProduct,cart:cart))),borderRadius:BorderRadius.circular(14),child:Container(decoration:BoxDecoration(border:Border.all(color:AppColors.border),borderRadius:BorderRadius.circular(14)),padding:const EdgeInsets.all(6),child:Column(children:[Expanded(child:Container(width:double.infinity,decoration:BoxDecoration(borderRadius:BorderRadius.circular(12),boxShadow:[BoxShadow(color:Colors.black.withValues(alpha:0.08),blurRadius:8,offset:const Offset(0,3))]),clipBehavior:Clip.antiAlias,child:Stack(fit:StackFit.expand,children:[Image.network(imageUrl,fit:BoxFit.cover,errorBuilder:(_,__,___)=>Container(color:AppColors.softGreen)),Container(color:Colors.black.withValues(alpha:0.18)),Center(child:Icon(icon,size:34,color:Colors.white))]))),const SizedBox(height:7),Text(name,maxLines:2,textAlign:TextAlign.center,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize:11.5,fontWeight:FontWeight.w800)),Text('($count)',style:const TextStyle(color:AppColors.muted,fontSize:11))])));
}
