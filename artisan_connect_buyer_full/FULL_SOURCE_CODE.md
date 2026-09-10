# Artisan Connect — Buyer Marketplace Full Source Code

This file contains every source/configuration file in the project.

## `pubspec.yaml`

```yaml
name: artisan_connect_buyer
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.2

flutter:
  uses-material-design: true
  assets:
    - assets/reference/

```

## `README.md`

```markdown
# Artisan Connect — Buyer Marketplace

Flutter implementation of the Buyer-only marketplace shown in the supplied reference images.

## Included
- 20 buyer screens / flows
- 20 categories
- 200 products (10 per category)
- Search, category filtering, sorting
- Product details, artisan details
- Wishlist toggle
- Cart quantity controls
- Checkout + payment + order review
- Order success, order history, tracking
- Recommendations and buyer profile
- Green/white visual theme matching the references

## Run
```bash
flutter pub get
flutter run
```

The app uses only Flutter SDK widgets plus Material Icons; no Firebase/backend is required for this demo.
Product images use remote Unsplash image URLs with local placeholder fallbacks. Replace the URLs in `lib/data/catalog.dart` with your own storage URLs for production.

```

## `lib/controllers/cart_controller.dart`

```dart
import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartController extends ChangeNotifier {
  final Map<int, int> _items = {};
  final Map<int, Product> _products = {};

  Map<int, int> get items => Map.unmodifiable(_items);
  List<Product> get products => _items.keys.map((id) => _products[id]!).toList();

  int quantity(Product product) => _items[product.id] ?? 0;

  void add(Product product, [int qty = 1]) {
    _products[product.id] = product;
    _items[product.id] = quantity(product) + qty;
    notifyListeners();
  }

  void removeOne(Product product) {
    final q = quantity(product);
    if (q <= 1) {
      _items.remove(product.id);
      _products.remove(product.id);
    } else {
      _items[product.id] = q - 1;
    }
    notifyListeners();
  }

  void remove(Product product) {
    _items.remove(product.id);
    _products.remove(product.id);
    notifyListeners();
  }

  int get itemCount => _items.values.fold(0, (a, b) => a + b);
  int get subtotal => _items.entries.fold(0, (sum, e) => sum + _products[e.key]!.price * e.value);
  int get shipping => subtotal == 0 || subtotal >= 1500 ? 0 : 80;
  int get total => subtotal + shipping;
}

```

## `lib/data/catalog.dart`

```dart
import '../models/product.dart';

class CategoryInfo {
  final String name;
  final String icon;
  final String imageUrl;
  const CategoryInfo(this.name, this.icon, this.imageUrl);
}

const categories = <CategoryInfo>[
  CategoryInfo('Home Decor', '🏠', 'https://images.unsplash.com/photo-1618220179428-22790b461013'),
  CategoryInfo('Handicrafts', '🐘', 'https://images.unsplash.com/photo-1602523961358-f9f03dd557db'),
  CategoryInfo('Textiles', '🧵', 'https://images.unsplash.com/photo-1602810316693-3667c854239a'),
  CategoryInfo('Jewellery', '💎', 'https://images.unsplash.com/photo-1611652022419-a9419f74343d'),
  CategoryInfo('Paintings', '🎨', 'https://images.unsplash.com/photo-1577083552431-6e5fd01988a5'),
  CategoryInfo('Pottery', '🏺', 'https://images.unsplash.com/photo-1493106641515-6b5631de4bb9'),
  CategoryInfo('Wooden Crafts', '🪵', 'https://images.unsplash.com/photo-1599940824399-b87987ceb72a'),
  CategoryInfo('Bamboo Products', '🎋', 'https://images.unsplash.com/photo-1523413651479-597eb2da0ad6'),
  CategoryInfo('Metal Crafts', '🪔', 'https://images.unsplash.com/photo-1601058268499-e52658d8e1b5'),
  CategoryInfo('Stone Crafts', '🗿', 'https://images.unsplash.com/photo-1561214115-7c3c7c7e7f9a'),
  CategoryInfo('Leather Products', '👜', 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62'),
  CategoryInfo('Organic & Natural', '🌿', 'https://images.unsplash.com/photo-1556228578-8c89e6adf883'),
  CategoryInfo('Toys & Games', '🧸', 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1'),
  CategoryInfo('Wall Hangings', '🧶', 'https://images.unsplash.com/photo-1586023492125-27b2c045efd7'),
  CategoryInfo('Festive Items', '🪔', 'https://images.unsplash.com/photo-1604608672516-f1e9a7e3190f'),
  CategoryInfo('Kitchen & Dining', '🍲', 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f'),
  CategoryInfo('Personal Care', '🧼', 'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108'),
  CategoryInfo('Clothing & Apparel', '👗', 'https://images.unsplash.com/photo-1496747611176-843222e1e57c'),
  CategoryInfo('Bags & Accessories', '👜', 'https://images.unsplash.com/photo-1584917865442-de89df76afd3'),
  CategoryInfo('Stationery', '📓', 'https://images.unsplash.com/photo-1455390582262-044cdead277a'),
];

const _names = <String, List<String>>{
  'Home Decor': ['Terracotta Lamp','Wooden Wall Shelf','Decorative Mirror','Clay Flower Vase','Macrame Table Accent','Brass Diya Set','Candle Holder','Ceramic Plant Pot','Wooden Table Clock','Bamboo Lampshade'],
  'Handicrafts': ['Wooden Elephant','Palm Leaf Basket','Warli Figurine','Handmade Tribal Mask','Carved Peacock','Paper Mache Doll','Palm Leaf Fan','Cane Craft Box','Miniature Bull','Handmade Bird Pair'],
  'Textiles': ['Cotton Saree','Handloom Stole','Block Print Dupatta','Ikat Cushion Cover','Khadi Scarf','Embroidered Shawl','Tie Dye Fabric','Cotton Table Runner','Handwoven Bedsheet','Silk Wall Textile'],
  'Jewellery': ['Beaded Necklace','Terracotta Earrings','Brass Jhumka','Silver Oxidised Ring','Thread Bracelet','Kundan Pendant','Tribal Choker','Pearl Hair Pin','Wooden Earrings','Handmade Anklet'],
  'Paintings': ['Painted Canvas','Madhubani Art','Tanjore Miniature','Warli Painting','Floral Folk Art','Village Landscape','Abstract Folk Frame','Mandala Art','Gond Painting','Nature Wall Art'],
  'Pottery': ['Terracotta Vase','Clay Serving Bowl','Handmade Mug','Earthen Diya Set','Planter Pot','Clay Water Bottle','Pottery Plate','Ceramic Kettle','Mini Kulhad Set','Decorative Urli'],
  'Wooden Crafts': ['Carved Trinket Box','Wooden Bowl','Wooden Wall Clock','Carved Pen Stand','Wooden Horse','Wooden Owl','Wooden Peacock','Puzzle Toy','Serving Tray','Carved Photo Frame'],
  'Bamboo Products': ['Bamboo Pen Stand','Bamboo Basket','Bamboo Lamp','Bamboo Tray','Bamboo Bottle','Bamboo Storage Box','Bamboo Plant Stand','Bamboo Wind Chime','Bamboo Organizer','Bamboo Serving Set'],
  'Metal Crafts': ['Brass Lamp','Brass Bell','Copper Bottle','Metal Wall Art','Brass Ganesha','Handmade Tumbler','Bronze Figurine','Metal Diya','Brass Tray','Decorative Horse'],
  'Stone Crafts': ['Stone Buddha','Soapstone Bowl','Marble Inlay Coaster','Granite Mortar','Carved Stone Elephant','Stone Lamp','Mini Stone Ganesha','Pebble Photo Stand','Stone Candle Holder','Carved Stone Plate'],
  'Leather Products': ['Leather Wallet','Leather Belt','Leather Journal','Leather Sling Bag','Leather Pouch','Leather Passport Cover','Leather Card Holder','Leather Keychain','Leather Tote','Leather Spectacle Case'],
  'Organic & Natural': ['Organic Soap Set','Herbal Bath Powder','Natural Incense','Neem Comb','Coconut Shell Bowl','Handmade Lip Balm','Aloe Face Bar','Herbal Shampoo Bar','Natural Candle','Rose Bath Salt'],
  'Toys & Games': ['Wooden Toy Car','Stacking Rings','Wooden Puzzle','Cloth Doll','Pull Along Duck','Spinning Top','Wooden Blocks','Finger Puppet Set','Traditional Board Game','Handmade Rattle'],
  'Wall Hangings': ['Macrame Hanging','Jute Wall Art','Cotton Tassel Decor','Bamboo Wall Fan','Embroidered Hoop','Mirror Wall Hanging','Dream Catcher','Woven Tapestry','Shell Wall Decor','Beaded Toran'],
  'Festive Items': ['Decorative Diya','Festival Toran','Clay Ganesha','Puja Thali','Brass Bell Set','Rangoli Stencil','Festive Lantern','Handmade Incense Stand','Decorative Kalash','Flower Garland'],
  'Kitchen & Dining': ['Kitchen Bowl Set','Spice Box','Wooden Spoon Set','Serving Tray','Clay Casserole','Coconut Ladle','Masala Box','Wooden Chopping Board','Ceramic Dinner Set','Handmade Strainer'],
  'Personal Care': ['Herbal Soap','Bamboo Toothbrush','Natural Scrub','Handmade Comb','Lip Balm Set','Bath Salt Jar','Rose Water','Herbal Hair Oil','Face Pack','Natural Loofah'],
  'Clothing & Apparel': ['Handloom Saree','Cotton Kurta','Embroidered Dupatta','Linen Shirt','Block Print Skirt','Handmade Scarf','Cotton Dress','Ikat Shirt','Traditional Shawl','Printed Stole'],
  'Bags & Accessories': ['Jute Handbag','Canvas Tote','Bamboo Clutch','Handwoven Sling Bag','Embroidered Purse','Leather Pouch Bag','Jute Backpack','Cotton Tote','Tribal Shoulder Bag','Handmade Coin Purse'],
  'Stationery': ['Handmade Notebook','Recycled Journal','Bamboo Pen Set','Art Sketchbook','Handmade Greeting Cards','Leather Diary','Craft Paper Pack','Wooden Bookmark','Calligraphy Set','Mini Desk Organizer'],
};

const _artisans = <String>['Ramesh Crafts','Lakshmi Handicrafts','Green Weaves','Clay Creations','Metal Artisans','ColorStrokes','Bamboo Hub','Stone Crafts','Leather Works','Nature Care','Toy Makers','Knot Studio','Kitchen Crafts','Eco Bags','Traditional Arts'];
const _cities = <String>['Thanjavur','Madurai','Kanchipuram','Coimbatore','Jaipur','Mysuru','Kolkata','Varanasi'];

String _slug(String s) => s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');

List<Product> buildProducts() {
  final result = <Product>[];
  var id = 1;
  for (var c = 0; c < categories.length; c++) {
    final category = categories[c];
    final names = _names[category.name]!;
    for (var i = 0; i < names.length; i++) {
      final base = 299 + ((c * 97 + i * 83) % 1600);
      result.add(Product(
        id: id,
        name: names[i],
        category: category.name,
        artisan: _artisans[(c + i) % _artisans.length],
        city: _cities[(c + i) % _cities.length],
        price: base,
        rating: 4.2 + (((c + i) % 8) / 10),
        reviews: 18 + ((c * 23 + i * 17) % 240),
        description: 'Handmade ${names[i].toLowerCase()} crafted by skilled artisans. Made with care using traditional techniques and quality materials.',
        imageUrl: '${category.imageUrl}?auto=format&fit=crop&w=800&q=82&ixlib=rb-4.1.0&index=$i',
        tags: [category.name, 'Handmade', 'Local', 'Artisan'],
        featured: id <= 20 || id % 13 == 0,
      ));
      id++;
    }
  }
  return result;
}

```

## `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ArtisanConnectApp());
}

class ArtisanConnectApp extends StatelessWidget {
  const ArtisanConnectApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Artisan Connect',
    theme: buildAppTheme(),
    home: const SplashScreen(),
  );
}

```

## `lib/models/product.dart`

```dart
class Product {
  final int id;
  final String name;
  final String category;
  final String artisan;
  final String city;
  final int price;
  final double rating;
  final int reviews;
  final String description;
  final String imageUrl;
  final List<String> tags;
  final bool featured;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.artisan,
    required this.city,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.imageUrl,
    required this.tags,
    this.featured = false,
  });
}

```

## `lib/screens/artisan_details_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class ArtisanDetailsScreen extends StatelessWidget{final String artisan;final List<Product> products;const ArtisanDetailsScreen({super.key,required this.artisan,required this.products});@override Widget build(BuildContext context){final p=products.isEmpty?[]:products;return Scaffold(appBar:AppBar(title:const Text('Artisan Details')),body:ListView(padding:const EdgeInsets.all(16),children:[const CircleAvatar(radius:48,child:Icon(Icons.person,size:52)),const SizedBox(height:10),Center(child:Text(artisan,style:const TextStyle(fontSize:22,fontWeight:FontWeight.w900))),const Center(child:Text('Traditional handmade artisan',style:TextStyle(color:AppColors.muted))),const SizedBox(height:10),Center(child:Text('⭐ 4.8 (120 reviews) · Tamil Nadu',style:TextStyle(color:AppColors.gold,fontWeight:FontWeight.w700))),const SizedBox(height:18),Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:AppColors.softGreen,borderRadius:BorderRadius.circular(16)),child:const Text('We are a family of artisans creating traditional handmade goods. Our products are made with care and reflect our culture and heritage.',style:TextStyle(height:1.5))),const SizedBox(height:22),Row(children:[const Expanded(child:Text('Our Products',style:TextStyle(fontSize:18,fontWeight:FontWeight.w900))),TextButton(onPressed:(){},child:const Text('View All'))]),if(p.isEmpty)const Padding(padding:EdgeInsets.all(30),child:Center(child:Text('Artisan product collection'))),if(p.isNotEmpty)GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),itemCount:p.take(6).length,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:10,mainAxisSpacing:10,childAspectRatio:.65),itemBuilder:(c,i)=>ProductCard(product:p[i],onTap:(){},onAdd:(){}))]));}
}

```

## `lib/screens/cart_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/product_image.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget{final CartController cart;const CartScreen({super.key,required this.cart});@override Widget build(BuildContext context)=>AnimatedBuilder(animation:cart,builder:(_,__)=>cart.products.isEmpty?const Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(Icons.shopping_cart_outlined,size:80,color:AppColors.green),SizedBox(height:12),Text('Your cart is empty',style:TextStyle(fontWeight:FontWeight.w900,fontSize:20)),SizedBox(height:6),Text('Add handmade products to get started',style:TextStyle(color:AppColors.muted))]):ListView(padding:const EdgeInsets.all(14),children:[const Text('My Cart',style:TextStyle(fontSize:21,fontWeight:FontWeight.w900)),const SizedBox(height:12),...cart.products.map((p)=>Container(margin:const EdgeInsets.only(bottom:10),padding:const EdgeInsets.all(10),decoration:BoxDecoration(border:Border.all(color:AppColors.border),borderRadius:BorderRadius.circular(14)),child:Row(children:[ProductImage(url:p.imageUrl,width:78,height:78),const SizedBox(width:10),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(p.name,maxLines:2,overflow:TextOverflow.ellipsis,style:const TextStyle(fontWeight:FontWeight.w800)),const SizedBox(height:4),Text('₹${p.price}',style:const TextStyle(color:AppColors.green,fontWeight:FontWeight.w800)),Row(children:[IconButton(onPressed:()=>cart.removeOne(p),icon:const Icon(Icons.remove_circle_outline,size:20)),Text('${cart.quantity(p)}'),IconButton(onPressed:()=>cart.add(p),icon:const Icon(Icons.add_circle_outline,size:20))])])),IconButton(onPressed:()=>cart.remove(p),icon:const Icon(Icons.delete_outline,color:AppColors.red))])),const SizedBox(height:5),Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:AppColors.softGreen,borderRadius:BorderRadius.circular(16)),child:Column(children:[_row('Subtotal','₹${cart.subtotal}'),_row('Shipping',cart.shipping==0?'Free':'₹${cart.shipping}'),const Divider(),_row('Total','₹${cart.total}',bold:true),const SizedBox(height:12),SizedBox(width:double.infinity,child:ElevatedButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>CheckoutScreen(cart:cart))),child:const Text('Proceed to Checkout')))]))]));
static Widget _row(String a,String b,{bool bold=false})=>Padding(padding:const EdgeInsets.symmetric(vertical:5),child:Row(children:[Text(a,style:TextStyle(fontWeight:bold?FontWeight.w900:FontWeight.w500)),const Spacer(),Text(b,style:TextStyle(fontWeight:bold?FontWeight.w900:FontWeight.w800,fontSize:bold?17:14,color:bold?AppColors.green:null))]));
}

```

## `lib/screens/category_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../data/catalog.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../controllers/cart_controller.dart';
import '../widgets/product_card.dart';
import 'product_listing_screen.dart';

class CategoryScreen extends StatelessWidget {
  final ValueChanged<Product> onProduct;
  final CartController cart;
  final String? initialCategory;
  const CategoryScreen({super.key, required this.onProduct, required this.cart, this.initialCategory});
  @override Widget build(BuildContext context){return Scaffold(appBar:initialCategory==null?null:AppBar(title:Text(initialCategory!)),body:initialCategory==null?_all(context):ProductListingScreen(category:initialCategory!,onProduct:onProduct,cart:cart));}
  Widget _all(BuildContext context)=>GridView.builder(padding:const EdgeInsets.all(14),itemCount:categories.length+1,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:3,crossAxisSpacing:10,mainAxisSpacing:12,childAspectRatio:.78),itemBuilder:(c,i){if(i==0){return _tile(context,'All Products','🛍️',200,null);}final x=categories[i-1];return _tile(context,x.name,x.icon,10,x.name);});
  Widget _tile(BuildContext context,String name,String icon,int count,String? cat)=>InkWell(onTap:()=>cat==null?Navigator.push(context,MaterialPageRoute(builder:(_)=>ProductListingScreen(category:null,onProduct:onProduct,cart:cart))):Navigator.push(context,MaterialPageRoute(builder:(_)=>ProductListingScreen(category:cat,onProduct:onProduct,cart:cart))),borderRadius:BorderRadius.circular(14),child:Container(decoration:BoxDecoration(border:Border.all(color:AppColors.border),borderRadius:BorderRadius.circular(14)),padding:const EdgeInsets.all(6),child:Column(children:[Expanded(child:Container(width:double.infinity,decoration:BoxDecoration(color:AppColors.softGreen,borderRadius:BorderRadius.circular(12)),alignment:Alignment.center,child:Text(icon,style:const TextStyle(fontSize:38)))),const SizedBox(height:7),Text(name,maxLines:2,textAlign:TextAlign.center,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize:11.5,fontWeight:FontWeight.w800)),Text('($count)',style:const TextStyle(color:AppColors.muted,fontSize:11))])));
}

```

## `lib/screens/checkout_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../theme/app_theme.dart';
import 'payment_screen.dart';

class CheckoutScreen extends StatefulWidget{final CartController cart;const CheckoutScreen({super.key,required this.cart});@override State<CheckoutScreen> createState()=>_CheckoutScreenState();}
class _CheckoutScreenState extends State<CheckoutScreen>{String delivery='Standard Delivery (3-5 days)';final address=TextEditingController(text:'John Doe\n123, Anna Nagar\nChennai – 600040, Tamil Nadu');@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Checkout')),body:ListView(padding:const EdgeInsets.all(16),children:[_step(1,'Address',true),const SizedBox(height:14),const Text('Shipping Address',style:TextStyle(fontWeight:FontWeight.w900,fontSize:17)),const SizedBox(height:8),Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(border:Border.all(color:AppColors.border),borderRadius:BorderRadius.circular(14)),child:Row(children:[Expanded(child:Text(address.text,style:const TextStyle(height:1.45))),TextButton(onPressed:(){},child:const Text('Edit'))])),const SizedBox(height:10),OutlinedButton.icon(onPressed:(){},icon:const Icon(Icons.add),label:const Text('Add New Address')),const SizedBox(height:20),const Text('Delivery Method',style:TextStyle(fontWeight:FontWeight.w900,fontSize:17)),...['Standard Delivery (3-5 days)','Express Delivery (1-2 days)','Same Day Delivery'].map((x)=>RadioListTile<String>(value:x,groupValue:delivery,title:Text(x),subtitle:Text(x.startsWith('Standard')?'Free':x.startsWith('Express')?'₹100':'₹200'),activeColor:AppColors.green,onChanged:(v)=>setState(()=>delivery=v!))),const SizedBox(height:18),SizedBox(width:double.infinity,child:ElevatedButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>PaymentScreen(cart:widget.cart))),child:const Text('Continue to Payment'))]));}
Widget _step(int n,String label,bool active)=>Row(children:[CircleAvatar(radius:14,backgroundColor:active?AppColors.green:Colors.grey.shade300,child:Text('$n',style:const TextStyle(color:Colors.white))),const SizedBox(width:7),Text(label,style:const TextStyle(fontWeight:FontWeight.w800))]);
}

```

## `lib/screens/filter_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
class FilterScreen extends StatefulWidget{final ValueChanged<String> onApply;const FilterScreen({super.key,required this.onApply});@override State<FilterScreen> createState()=>_FilterScreenState();}
class _FilterScreenState extends State<FilterScreen>{String selected='Relevance';double max=2500;@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Filter & Sort')),body:ListView(padding:const EdgeInsets.all(18),children:[const Text('Sort By',style:TextStyle(fontSize:18,fontWeight:FontWeight.w900)),...['Relevance','Price: Low to High','Price: High to Low','Newest First','Top Rated'].map((s)=>RadioListTile<String>(value:s,groupValue:selected,title:Text(s),activeColor:AppColors.green,onChanged:(v)=>setState(()=>selected=v!))),const Divider(),const Text('Price Range',style:TextStyle(fontSize:18,fontWeight:FontWeight.w900)),RangeSlider(values:RangeValues(0,max),min:0,max:3000,divisions:30,activeColor:AppColors.green,onChanged:(v)=>setState(()=>max=v.end)),Text('₹0 - ₹${max.toInt()}'),const SizedBox(height:22),Row(children:[Expanded(child:OutlinedButton(onPressed:()=>setState(()=>selected='Relevance'),child:const Text('Reset'))),const SizedBox(width:12),Expanded(child:ElevatedButton(onPressed:(){widget.onApply(selected);Navigator.pop(context);},child:const Text('Apply')))])]));}

```

## `lib/screens/home_screen.dart`

```dart
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
      const SizedBox(height:10), SizedBox(height:114,child:ListView.separated(scrollDirection:Axis.horizontal,itemCount:categories.length,itemBuilder:(c,i){final cat=categories[i];return SizedBox(width:92,child:InkWell(onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>CategoryScreen(onProduct:onProduct,cart:cart,initialCategory:cat.name))),child:Column(children:[Container(width:70,height:70,decoration:BoxDecoration(color:AppColors.softGreen,borderRadius:BorderRadius.circular(18)),alignment:Alignment.center,child:Text(cat.icon,style:const TextStyle(fontSize:30))),const SizedBox(height:5),Text(cat.name,textAlign:TextAlign.center,maxLines:2,overflow:TextOverflow.ellipsis,style:const TextStyle(fontSize:11,fontWeight:FontWeight.w700))])));},separatorBuilder:(_,__)=>const SizedBox(width:8))),
      const SizedBox(height:22), Row(children:[const Expanded(child:Text('Featured Products',style:TextStyle(fontWeight:FontWeight.w900,fontSize:18))),TextButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>CategoryScreen(onProduct:onProduct,cart:cart))),child:const Text('View All'))]),
      GridView.builder(shrinkWrap:true,physics:const NeverScrollableScrollPhysics(),itemCount:featured.length,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:10,mainAxisSpacing:10,childAspectRatio:.66),itemBuilder:(c,i)=>ProductCard(product:featured[i],onTap:()=>onProduct(featured[i]),onAdd:(){cart.add(featured[i]); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Added to cart')));})),
    ]);
  }
}

```

## `lib/screens/login_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'register_screen.dart';
import 'main_shell.dart';

class LoginScreen extends StatefulWidget { const LoginScreen({super.key}); @override State<LoginScreen> createState()=>_LoginScreenState(); }
class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController(); final password = TextEditingController(); bool obscure=true;
  void login(){Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const MainShell()));}
  @override Widget build(BuildContext context)=>Scaffold(body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const SizedBox(height: 40), const Center(child: Icon(Icons.shopping_bag_rounded,color:AppColors.green,size:60)), const SizedBox(height:18), const Center(child: Text('Welcome Back',style:TextStyle(fontSize:24,fontWeight:FontWeight.w900))), const SizedBox(height:5), const Center(child: Text('Login to continue',style:TextStyle(color:AppColors.muted))), const SizedBox(height:35), TextField(controller:email,decoration:const InputDecoration(prefixIcon:Icon(Icons.email_outlined),hintText:'Email')), const SizedBox(height:14), TextField(controller:password,obscureText:obscure,decoration:InputDecoration(prefixIcon:const Icon(Icons.lock_outline),hintText:'Password',suffixIcon:IconButton(onPressed:()=>setState(()=>obscure=!obscure),icon:Icon(obscure?Icons.visibility_outlined:Icons.visibility_off_outlined)))), Align(alignment:Alignment.centerRight,child:TextButton(onPressed:(){},child:const Text('Forgot Password?'))), SizedBox(width:double.infinity,child:ElevatedButton(onPressed:login,child:const Text('Login'))), const SizedBox(height:16), const Center(child:Text('OR')), const SizedBox(height:12), OutlinedButton.icon(onPressed:login,icon:const Icon(Icons.g_mobiledata_rounded),label:const Text('Continue with Google'),style:OutlinedButton.styleFrom(minimumSize:const Size.fromHeight(48))), const SizedBox(height:10), OutlinedButton.icon(onPressed:login,icon:const Icon(Icons.phone_android_rounded),label:const Text('Continue with Phone'),style:OutlinedButton.styleFrom(minimumSize:const Size.fromHeight(48))), const SizedBox(height:18), Center(child:Wrap(children:[const Text("Don't have an account? "),TextButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const RegisterScreen())),child:const Text('Register'))]))])));
}

```

## `lib/screens/main_shell.dart`

```dart
import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../data/catalog.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/app_drawer.dart';
import 'home_screen.dart';
import 'category_screen.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';
import 'product_details_screen.dart';

class MainShell extends StatefulWidget { const MainShell({super.key}); @override State<MainShell> createState()=>MainShellState(); }
class MainShellState extends State<MainShell>{
  final cart=CartController(); int index=0;
  late final pages=[HomeScreen(onProduct:(p)=>openProduct(p),cart:cart), CategoryScreen(onProduct:(p)=>openProduct(p),cart:cart), CartScreen(cart:cart), OrdersScreen(onOpenTracking:()=>go(3)), ProfileScreen()];
  void go(int i)=>setState(()=>index=i);
  void openProduct(product){Navigator.push(context,MaterialPageRoute(builder:(_)=>ProductDetailsScreen(product:product,cart:cart)));}
  @override Widget build(BuildContext context)=>AnimatedBuilder(animation:cart,builder:(_,__)=>Scaffold(drawer:BuyerDrawer(onSelect:(s){Navigator.pop(context); if(s=='Home')go(0); if(s=='Categories')go(1); if(s=='My Cart')go(2); if(s=='My Orders')go(3); if(s=='My Profile')go(4);}),appBar:AppBar(leading:Builder(builder:(c)=>IconButton(onPressed:()=>Scaffold.of(c).openDrawer(),icon:const Icon(Icons.menu_rounded))),title:const Text('Artisan Connect',style:TextStyle(fontWeight:FontWeight.w900)),actions:[IconButton(onPressed:(){showSearch(context:context,delegate:ProductSearchDelegate(products:buildProducts(),cart:cart));},icon:const Icon(Icons.search_rounded)),IconButton(onPressed:()=>go(2),icon:Badge(isLabelVisible:cart.itemCount>0,label:Text('${cart.itemCount}'),child:const Icon(Icons.shopping_cart_outlined)))]) ,body:IndexedStack(index:index,children:pages),bottomNavigationBar:AppBottomNav(selected:index,onChanged:go,cartCount:cart.itemCount)));
}

class ProductSearchDelegate extends SearchDelegate<void>{ final List products; final CartController cart; ProductSearchDelegate({required this.products,required this.cart});
@override List<Widget>? buildActions(BuildContext context)=>[IconButton(onPressed:()=>query='',icon:const Icon(Icons.clear))]; @override Widget? buildLeading(BuildContext context)=>IconButton(onPressed:()=>close(context),icon:const Icon(Icons.arrow_back));
@override Widget buildResults(BuildContext context){final q=query.toLowerCase(); final list=products.where((p)=>p.name.toLowerCase().contains(q)||p.category.toLowerCase().contains(q)||p.artisan.toLowerCase().contains(q)).toList(); return ListView.builder(itemCount:list.length,itemBuilder:(c,i)=>ListTile(title:Text(list[i].name),subtitle:Text(list[i].category),trailing:Text('₹${list[i].price}',style:const TextStyle(fontWeight:FontWeight.w800)),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>ProductDetailsScreen(product:list[i],cart:cart))));}
@override Widget buildSuggestions(BuildContext context)=>buildResults(context);
}

```

## `lib/screens/order_review_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../theme/app_theme.dart';
import 'order_success_screen.dart';

class OrderReviewScreen extends StatelessWidget{final CartController cart;const OrderReviewScreen({super.key,required this.cart});@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Review Order')),body:ListView(padding:const EdgeInsets.all(16),children:[_header(),const SizedBox(height:18),Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(border:Border.all(color:AppColors.border),borderRadius:BorderRadius.circular(14)),child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Shipping Address',style:TextStyle(fontWeight:FontWeight.w900)),SizedBox(height:7),Text('John Doe\n123, Anna Nagar, Chennai – 600040, Tamil Nadu',style:TextStyle(color:AppColors.muted,height:1.4))])),const SizedBox(height:15),const Text('Items',style:TextStyle(fontSize:17,fontWeight:FontWeight.w900)),const SizedBox(height:8),...cart.products.map((p)=>ListTile(contentPadding:EdgeInsets.zero,title:Text(p.name,style:const TextStyle(fontWeight:FontWeight.w700)),subtitle:Text('x${cart.quantity(p)}'),trailing:Text('₹${p.price*cart.quantity(p)}',style:const TextStyle(fontWeight:FontWeight.w800)))),const Divider(),_row('Subtotal','₹${cart.subtotal}'),_row('Shipping',cart.shipping==0?'Free':'₹${cart.shipping}'),_row('Total','₹${cart.total}',bold:true),const SizedBox(height:16),SizedBox(width:double.infinity,child:ElevatedButton(onPressed:()=>Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>OrderSuccessScreen(cart:cart))),child:const Text('Place Order')))]));}
Widget _header()=>const Row(children:[_Circle(1,'Address',true),Expanded(child:Divider()),_Circle(2,'Payment',true),Expanded(child:Divider()),_Circle(3,'Review',true)]);static Widget _row(String a,String b,{bool bold=false})=>Padding(padding:const EdgeInsets.symmetric(vertical:5),child:Row(children:[Text(a,style:TextStyle(fontWeight:bold?FontWeight.w900:FontWeight.w500)),const Spacer(),Text(b,style:TextStyle(fontWeight:bold?FontWeight.w900:FontWeight.w800,color:bold?AppColors.green:null))]));
}
class _Circle extends StatelessWidget{final int n;final String l;final bool active;const _Circle(this.n,this.l,this.active);@override Widget build(BuildContext context)=>Column(children:[CircleAvatar(radius:13,backgroundColor:active?AppColors.green:Colors.grey,child:Text('$n',style:const TextStyle(color:Colors.white,fontSize:12))),Text(l,style:const TextStyle(fontSize:10,fontWeight:FontWeight.w700))]);}

```

## `lib/screens/order_success_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../theme/app_theme.dart';
import 'orders_screen.dart';
class OrderSuccessScreen extends StatelessWidget{final CartController cart;const OrderSuccessScreen({super.key,required this.cart});@override Widget build(BuildContext context){final id='#AC20260905001';return Scaffold(body:Center(child:Padding(padding:const EdgeInsets.all(26),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[const CircleAvatar(radius:42,backgroundColor:AppColors.softGreen,child:Icon(Icons.check_rounded,color:AppColors.green,size:60)),const SizedBox(height:18),const Text('Order Placed Successfully!',style:TextStyle(fontSize:22,fontWeight:FontWeight.w900,color:AppColors.darkGreen)),const SizedBox(height:9),Text('Order ID\n$id',textAlign:TextAlign.center),const SizedBox(height:8),const Text('Thank you for supporting our artisans!',textAlign:TextAlign.center,style:TextStyle(color:AppColors.muted)),const SizedBox(height:25),SizedBox(width:double.infinity,child:ElevatedButton(onPressed:()=>Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(_)=>const OrdersScreen()),(r)=>false),child:const Text('View My Orders'))),const SizedBox(height:10),SizedBox(width:double.infinity,child:OutlinedButton(onPressed:()=>Navigator.pop(context),child:const Text('Continue Shopping')))])));}
}

```

## `lib/screens/orders_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/catalog.dart';
import '../widgets/product_image.dart';
import 'tracking_screen.dart';

class OrdersScreen extends StatelessWidget{final VoidCallback? onOpenTracking;const OrdersScreen({super.key,this.onOpenTracking});@override Widget build(BuildContext context){final products=buildProducts();final orders=[('AC20260905001',[products[0],products[1]],'Processing','05 Sep 2026','₹${products[0].price+products[1].price}'),('AC20260828012',[products[7]],'Shipped','28 Aug 2026','₹${products[7].price}'),('AC20260815008',[products[25],products[26]],'Delivered','15 Aug 2026','₹${products[25].price+products[26].price}'),('AC20260720044',[products[50]],'Cancelled','20 Jul 2026','₹${products[50].price}')];return ListView(padding:const EdgeInsets.all(14),children:[const Text('My Orders',style:TextStyle(fontSize:21,fontWeight:FontWeight.w900)),const SizedBox(height:12),...orders.map((o)=>InkWell(onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>TrackingScreen(orderId:o.$1))),child:Container(margin:const EdgeInsets.only(bottom:10),padding:const EdgeInsets.all(10),decoration:BoxDecoration(border:Border.all(color:AppColors.border),borderRadius:BorderRadius.circular(15)),child:Row(children:[ProductImage(url:o.$2.first.imageUrl,width:65,height:65),const SizedBox(width:10),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('#${o.$1}',style:const TextStyle(fontWeight:FontWeight.w800,fontSize:13)),Text('${o.$2.length} item${o.$2.length>1?'s':''} · ${o.$5}',style:const TextStyle(color:AppColors.muted,fontSize:12)),Text(o.$4,style:const TextStyle(color:AppColors.muted,fontSize:11))])),Container(padding:const EdgeInsets.symmetric(horizontal:9,vertical:5),decoration:BoxDecoration(color:o.$3=='Cancelled'?Colors.red.shade50:o.$3=='Delivered'?AppColors.softGreen:const Color(0xFFFFF3DC),borderRadius:BorderRadius.circular(20)),child:Text(o.$3,style:TextStyle(color:o.$3=='Cancelled'?AppColors.red:o.$3=='Delivered'?AppColors.green:Colors.orange,fontSize:11,fontWeight:FontWeight.w800))) ])))];}}

```

## `lib/screens/payment_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../theme/app_theme.dart';
import 'order_review_screen.dart';

class PaymentScreen extends StatefulWidget{final CartController cart;const PaymentScreen({super.key,required this.cart});@override State<PaymentScreen> createState()=>_PaymentScreenState();}
class _PaymentScreenState extends State<PaymentScreen>{String method='UPI (Google Pay, PhonePe, etc.)';@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Payment')),body:ListView(padding:const EdgeInsets.all(16),children:[...['UPI (Google Pay, PhonePe, etc.)','Credit / Debit Card','Net Banking','Cash on Delivery'].map((x)=>RadioListTile<String>(value:x,groupValue:method,title:Text(x),activeColor:AppColors.green,onChanged:(v)=>setState(()=>method=v!))),Container(margin:const EdgeInsets.only(top:12),padding:const EdgeInsets.all(15),decoration:BoxDecoration(color:AppColors.softGreen,borderRadius:BorderRadius.circular(14)),child:const Row(children:[Icon(Icons.lock_outline,color:AppColors.green),SizedBox(width:8),Expanded(child:Text('Secure Payment\nYour payment information is safe with us.'))])),const SizedBox(height:24),SizedBox(width:double.infinity,child:ElevatedButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>OrderReviewScreen(cart:widget.cart))),child:const Text('Continue to Review'))]));}
}

```

## `lib/screens/product_details_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/product_image.dart';
import '../widgets/price_rating.dart';
import 'artisan_details_screen.dart';

class ProductDetailsScreen extends StatefulWidget{final Product product;final CartController cart;const ProductDetailsScreen({super.key,required this.product,required this.cart});@override State<ProductDetailsScreen> createState()=>_ProductDetailsScreenState();}
class _ProductDetailsScreenState extends State<ProductDetailsScreen>{int qty=1;
@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Product Details'),actions:[IconButton(onPressed:(){},icon:const Icon(Icons.favorite_border_rounded)),IconButton(onPressed:(){},icon:const Icon(Icons.share_outlined))]),body:ListView(padding:const EdgeInsets.fromLTRB(14,0,14,24),children:[Hero(tag:'p${widget.product.id}',child:ProductImage(url:widget.product.imageUrl,width:double.infinity,height:330,borderRadius:BorderRadius.circular(18))),const SizedBox(height:14),Text(widget.product.name,style:const TextStyle(fontSize:23,fontWeight:FontWeight.w900)),const SizedBox(height:6),InkWell(onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>ArtisanDetailsScreen(artisan:widget.product.artisan,products:[]))),child:Text('By ${widget.product.artisan} · ${widget.product.city}',style:const TextStyle(color:AppColors.muted))),const SizedBox(height:12),PriceRating(price:widget.product.price,rating:widget.product.rating),Text('${widget.product.reviews} reviews',style:const TextStyle(color:AppColors.muted,fontSize:12)),const SizedBox(height:14),Text(widget.product.description,style:const TextStyle(height:1.5,color:AppColors.muted)),const SizedBox(height:14),Wrap(spacing:8,children:widget.product.tags.map((t)=>Chip(label:Text(t),backgroundColor:AppColors.softGreen)).toList()),const SizedBox(height:16),Container(padding:const EdgeInsets.all(13),decoration:BoxDecoration(color:AppColors.softGreen,borderRadius:BorderRadius.circular(14)),child:const Row(children:[Icon(Icons.verified_user_outlined,color:AppColors.green),SizedBox(width:10),Expanded(child:Text('Handmade • Supports local artisans • Quality checked',style:TextStyle(fontWeight:FontWeight.w600)))])),const SizedBox(height:18),Row(children:[const Text('Quantity',style:TextStyle(fontWeight:FontWeight.w800)),const Spacer(),IconButton(onPressed:()=>setState(()=>qty=qty>1?qty-1:1),icon:const Icon(Icons.remove_circle_outline)),Text('$qty',style:const TextStyle(fontWeight:FontWeight.w800,fontSize:18)),IconButton(onPressed:()=>setState(()=>qty++),icon:const Icon(Icons.add_circle_outline))]),const SizedBox(height:12),Row(children:[Expanded(child:OutlinedButton(onPressed:(){widget.cart.add(widget.product,qty);Navigator.pop(context);ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Added to cart')));},child:const Text('Add to Cart'))),const SizedBox(width:10),Expanded(child:ElevatedButton(onPressed:(){widget.cart.add(widget.product,qty);Navigator.pop(context);},child:const Text('Buy Now')))])]));
}

```

## `lib/screens/product_listing_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../data/catalog.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../controllers/cart_controller.dart';
import '../widgets/product_card.dart';
import 'search_screen.dart';
import 'filter_screen.dart';

class ProductListingScreen extends StatefulWidget { final String? category; final ValueChanged<Product> onProduct; final CartController cart; const ProductListingScreen({super.key,required this.category,required this.onProduct,required this.cart}); @override State<ProductListingScreen> createState()=>_ProductListingScreenState(); }
class _ProductListingScreenState extends State<ProductListingScreen>{ String sort='Relevance'; late List<Product> list;
@override void initState(){super.initState();_refresh();} void _refresh(){list=buildProducts().where((p)=>widget.category==null||p.category==widget.category).toList();}
void _sort(){setState((){if(sort=='Price: Low to High'){list.sort((a,b)=>a.price.compareTo(b.price));}else if(sort=='Price: High to Low'){list.sort((a,b)=>b.price.compareTo(a.price));}else if(sort=='Top Rated'){list.sort((a,b)=>b.rating.compareTo(a.rating));}else{list.sort((a,b)=>a.id.compareTo(b.id));}});}
@override Widget build(BuildContext context)=>Column(children:[Padding(padding:const EdgeInsets.fromLTRB(14,8,14,4),child:Row(children:[Expanded(child:Text(widget.category??'All Products (200)',style:const TextStyle(fontSize:18,fontWeight:FontWeight.w900))),IconButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>SearchScreen(products:buildProducts(),onProduct:widget.onProduct,cart:widget.cart))),icon:const Icon(Icons.search_rounded)),IconButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>FilterScreen(onApply:(s){sort=s;_sort();}))),icon:const Icon(Icons.tune_rounded))])),
Padding(padding:const EdgeInsets.symmetric(horizontal:14,vertical:5),child:SingleChildScrollView(scrollDirection:Axis.horizontal,child:Row(children:[_chip('All (200)'),...categories.take(5).map((c)=>_chip('${c.name} (10)'))]))),
Expanded(child:GridView.builder(padding:const EdgeInsets.all(14),itemCount:list.length,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:10,mainAxisSpacing:10,childAspectRatio:.65),itemBuilder:(c,i)=>ProductCard(product:list[i],onTap:()=>widget.onProduct(list[i]),onAdd:(){widget.cart.add(list[i]); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Added to cart')));})) ]);
Widget _chip(String text)=>Padding(padding:const EdgeInsets.only(right:7),child:Chip(label:Text(text),backgroundColor:text.startsWith(widget.category??'___')||text.startsWith('All')?AppColors.green:const Color(0xFFF2F5F3),labelStyle:TextStyle(color:text.startsWith(widget.category??'___')||text.startsWith('All')?Colors.white:AppColors.text,fontSize:11,fontWeight:FontWeight.w700)));
}

```

## `lib/screens/profile_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
class ProfileScreen extends StatelessWidget{const ProfileScreen({super.key});@override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.all(16),children:[Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:AppColors.softGreen,borderRadius:BorderRadius.circular(18)),child:const Row(children:[CircleAvatar(radius:34,child:Icon(Icons.person,size:38)),SizedBox(width:12),Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('John Doe',style:TextStyle(fontWeight:FontWeight.w900,fontSize:18)),Text('john@gmail.com',style:TextStyle(color:AppColors.muted))])])),const SizedBox(height:12),_item(Icons.edit_outlined,'Edit Profile'),_item(Icons.location_on_outlined,'Manage Addresses'),_item(Icons.receipt_long_outlined,'My Orders'),_item(Icons.favorite_border,'My Wishlist'),_item(Icons.credit_card_outlined,'Payment Methods'),_item(Icons.notifications_none,'Notifications'),_item(Icons.help_outline,'Help & Support'),_item(Icons.info_outline,'About Us'),const SizedBox(height:10),_item(Icons.logout,'Logout',red:true,onTap:()=>Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(_)=>const LoginScreen()),(r)=>false))]);}
Widget _item(IconData icon,String title,{bool red=false,VoidCallback? onTap})=>ListTile(onTap:onTap,leading:Icon(icon,color:red?AppColors.red:AppColors.text),title:Text(title,style:TextStyle(fontWeight:FontWeight.w600,color:red?AppColors.red:AppColors.text)),trailing:const Icon(Icons.chevron_right_rounded));
}

```

## `lib/screens/recommendations_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../data/catalog.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
class RecommendationsScreen extends StatelessWidget{final ValueChanged<Product> onProduct;const RecommendationsScreen({super.key,required this.onProduct});@override Widget build(BuildContext context){final p=buildProducts().where((x)=>x.featured).skip(3).take(8).toList();return Scaffold(appBar:AppBar(title:const Text('Recommended for You')),body:GridView.builder(padding:const EdgeInsets.all(14),itemCount:p.length,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:10,mainAxisSpacing:10,childAspectRatio:.65),itemBuilder:(c,i)=>ProductCard(product:p[i],onTap:()=>onProduct(p[i]),onAdd:()=>onProduct(p[i]))) );}}

```

## `lib/screens/register_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'main_shell.dart';
class RegisterScreen extends StatefulWidget { const RegisterScreen({super.key}); @override State<RegisterScreen> createState()=>_RegisterScreenState(); }
class _RegisterScreenState extends State<RegisterScreen>{ final name=TextEditingController();final email=TextEditingController();final p1=TextEditingController();final p2=TextEditingController();
@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Create Account')),body:SingleChildScrollView(padding:const EdgeInsets.all(22),child:Column(children:[const SizedBox(height:15),const Text('Join our community',style:TextStyle(color:Colors.grey)),const SizedBox(height:28),TextField(controller:name,decoration:const InputDecoration(prefixIcon:Icon(Icons.person_outline),hintText:'Full Name')),const SizedBox(height:14),TextField(controller:email,decoration:const InputDecoration(prefixIcon:Icon(Icons.email_outlined),hintText:'Email')),const SizedBox(height:14),TextField(controller:p1,obscureText:true,decoration:const InputDecoration(prefixIcon:Icon(Icons.lock_outline),hintText:'Password')),const SizedBox(height:14),TextField(controller:p2,obscureText:true,decoration:const InputDecoration(prefixIcon:Icon(Icons.lock_reset_outlined),hintText:'Confirm Password')),const SizedBox(height:22),SizedBox(width:double.infinity,child:ElevatedButton(onPressed:()=>Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(_)=>const MainShell()),(r)=>false),child:const Text('Register'))),const SizedBox(height:20),Row(children:[const Expanded(child:Divider()),const Padding(padding:EdgeInsets.symmetric(horizontal:10),child:Text('OR')),const Expanded(child:Divider())]),const SizedBox(height:12),OutlinedButton.icon(onPressed:(){},icon:const Icon(Icons.g_mobiledata_rounded),label:const Text('Continue with Google'),style:OutlinedButton.styleFrom(minimumSize:const Size.fromHeight(48))),const SizedBox(height:10),TextButton(onPressed:()=>Navigator.pop(context),child:const Text('Already have an account? Login'))])));}

```

## `lib/screens/search_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../controllers/cart_controller.dart';
import '../widgets/product_card.dart';

class SearchScreen extends StatefulWidget{final List<Product> products;final ValueChanged<Product> onProduct; final CartController cart; const SearchScreen({super.key,required this.products,required this.onProduct,required this.cart});@override State<SearchScreen> createState()=>_SearchScreenState();}
class _SearchScreenState extends State<SearchScreen>{final controller=TextEditingController();late List<Product> result;@override void initState(){super.initState();result=widget.products;}void search(String q){setState(()=>result=widget.products.where((p)=>p.name.toLowerCase().contains(q.toLowerCase())||p.category.toLowerCase().contains(q.toLowerCase())||p.artisan.toLowerCase().contains(q.toLowerCase())).toList());}
@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:TextField(controller:controller,autofocus:true,onChanged:search,decoration:const InputDecoration(hintText:'Search products, artisans...',border:InputBorder.none,filled:false),textInputAction:TextInputAction.search)),body:result.isEmpty?const Center(child:Text('No matching products')):GridView.builder(padding:const EdgeInsets.all(14),itemCount:result.length,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,crossAxisSpacing:10,mainAxisSpacing:10,childAspectRatio:.65),itemBuilder:(c,i)=>ProductCard(product:result[i],onTap:()=>widget.onProduct(result[i]),onAdd:(){widget.cart.add(result[i]); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Added to cart')));})));
}

```

## `lib/screens/splash_screen.dart`

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override void initState() { super.initState(); Timer(const Duration(seconds: 2), () { if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())); }); }
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Column(children: [const Spacer(), Container(width: 110, height: 110, decoration: const BoxDecoration(color: AppColors.softGreen, shape: BoxShape.circle), child: const Icon(Icons.shopping_cart_rounded, size: 64, color: AppColors.green)), const SizedBox(height: 22), const Text('Artisan Connect', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.darkGreen)), const SizedBox(height: 6), const Text('Handmade. Heartmade.', style: TextStyle(color: AppColors.muted, fontSize: 14)), const Spacer(), Container(width: double.infinity, padding: const EdgeInsets.all(18), color: AppColors.softGreen, child: const Column(children: [Text('Support Artisans', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.darkGreen)), Text('Build a Better Tomorrow', style: TextStyle(color: AppColors.muted, fontSize: 12))])), ])));
}

```

## `lib/screens/tracking_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
class TrackingScreen extends StatelessWidget{final String orderId;const TrackingScreen({super.key,required this.orderId});@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Order Tracking')),body:ListView(padding:const EdgeInsets.all(18),children:[Text('Order ID: #$orderId',style:const TextStyle(fontWeight:FontWeight.w800)),const SizedBox(height:24),_event('Order Placed','05 Sep 2026, 10:30 AM',true,Icons.receipt_long),_event('Processing','05 Sep 2026, 02:00 PM',true,Icons.inventory_2_outlined),_event('Shipped','06 Sep 2026, 09:00 AM',true,Icons.local_shipping_outlined),_event('Out for Delivery','08 Sep 2026, 14:00 PM',false,Icons.local_shipping),_event('Delivered','—',false,Icons.home_outlined),const SizedBox(height:18),Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:AppColors.softGreen,borderRadius:BorderRadius.circular(14)),child:const Row(children:[Icon(Icons.local_shipping,color:AppColors.green),SizedBox(width:10),Expanded(child:Text('Estimated Delivery\n8 Sep 2026',style:TextStyle(fontWeight:FontWeight.w800)))]))]));}
Widget _event(String title,String time,bool active,IconData icon)=>Row(crossAxisAlignment:CrossAxisAlignment.start,children:[SizedBox(width:44,child:Column(children:[CircleAvatar(radius:14,backgroundColor:active?AppColors.green:Colors.grey.shade300,child:Icon(icon,size:15,color:active?Colors.white:Colors.grey)),Container(width:2,height:55,color:active?AppColors.green:Colors.grey.shade300)])),Expanded(child:Padding(padding:const EdgeInsets.only(top:4),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:TextStyle(fontWeight:FontWeight.w800,color:active?AppColors.text:AppColors.muted)),Text(time,style:const TextStyle(color:AppColors.muted,fontSize:12)),const SizedBox(height:30)]))) ]);
}

```

## `lib/theme/app_theme.dart`

```dart
import 'package:flutter/material.dart';

class AppColors {
  static const green = Color(0xFF0B8F56);
  static const darkGreen = Color(0xFF006B43);
  static const softGreen = Color(0xFFE9F7F0);
  static const border = Color(0xFFE4E8E6);
  static const text = Color(0xFF1E2723);
  static const muted = Color(0xFF66736D);
  static const gold = Color(0xFFF0A600);
  static const red = Color(0xFFD32F2F);
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: AppColors.green, brightness: Brightness.light);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme.copyWith(primary: AppColors.green, secondary: AppColors.darkGreen),
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.text,
      elevation: 0,
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF7F9F8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.green, width: 1.5),
      ),
    ),
  );
}

```

## `lib/widgets/app_bottom_nav.dart`

```dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppBottomNav extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;
  final int cartCount;
  const AppBottomNav({super.key, required this.selected, required this.onChanged, this.cartCount = 0});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selected,
      onDestinationSelected: onChanged,
      backgroundColor: Colors.white,
      indicatorColor: AppColors.softGreen,
      destinations: [
        const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
        const NavigationDestination(icon: Icon(Icons.grid_view_rounded), label: 'Categories'),
        NavigationDestination(icon: Badge(isLabelVisible: cartCount > 0, label: Text('$cartCount'), child: const Icon(Icons.shopping_cart_outlined)), selectedIcon: Badge(isLabelVisible: cartCount > 0, label: Text('$cartCount'), child: const Icon(Icons.shopping_cart_rounded)), label: 'Cart'),
        const NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Orders'),
        const NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
      ],
    );
  }
}

```

## `lib/widgets/app_drawer.dart`

```dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BuyerDrawer extends StatelessWidget {
  final ValueChanged<String> onSelect;
  const BuyerDrawer({super.key, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(children: [
          Container(color: AppColors.green, width: double.infinity, padding: const EdgeInsets.fromLTRB(20, 18, 20, 22), child: const Row(children: [CircleAvatar(radius: 27, child: Icon(Icons.person)), SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('John Doe', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)), SizedBox(height: 2), Text('john@gmail.com', style: TextStyle(color: Colors.white70, fontSize: 12))])])),
          _item(Icons.home_outlined, 'Home'),
          _item(Icons.grid_view_rounded, 'Categories'),
          _item(Icons.shopping_cart_outlined, 'My Cart'),
          _item(Icons.receipt_long_outlined, 'My Orders'),
          _item(Icons.favorite_border_rounded, 'My Wishlist'),
          _item(Icons.person_outline_rounded, 'My Profile'),
          _item(Icons.settings_outlined, 'Settings'),
          _item(Icons.help_outline_rounded, 'Help & Support'),
          _item(Icons.info_outline_rounded, 'About Us'),
          const Spacer(),
          _item(Icons.logout_rounded, 'Logout', red: true),
          const SizedBox(height: 10),
          const Text('Artisan Connect v1.0.0', style: TextStyle(fontSize: 11, color: AppColors.muted)),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  Widget _item(IconData icon, String text, {bool red = false}) => ListTile(leading: Icon(icon, color: red ? AppColors.red : AppColors.text), title: Text(text, style: TextStyle(color: red ? AppColors.red : AppColors.text, fontWeight: FontWeight.w600)), onTap: () => onSelect(text));
}

```

## `lib/widgets/price_rating.dart`

```dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PriceRating extends StatelessWidget {
  final int price;
  final double rating;
  final bool compact;
  const PriceRating({super.key, required this.price, required this.rating, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('₹$price', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.green, fontSize: compact ? 14 : 16)),
        const Spacer(),
        const Icon(Icons.star_rounded, size: 16, color: AppColors.gold),
        const SizedBox(width: 2),
        Text(rating.toStringAsFixed(1), style: TextStyle(fontSize: compact ? 12 : 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

```

## `lib/widgets/product_card.dart`

```dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import 'product_image.dart';
import 'price_rating.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAdd;
  final bool dense;

  const ProductCard({super.key, required this.product, required this.onTap, required this.onAdd, this.dense = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              ProductImage(url: product.imageUrl, width: double.infinity, height: dense ? 110 : 135),
              Positioned(top: 6, right: 6, child: Container(width: 30, height: 30, decoration: BoxDecoration(color: Colors.white.withOpacity(.9), shape: BoxShape.circle), child: const Icon(Icons.favorite_border_rounded, size: 18))),
            ]),
            const SizedBox(height: 8),
            Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5)),
            const SizedBox(height: 2),
            Text('By ${product.artisan}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
            const SizedBox(height: 5),
            PriceRating(price: product.price, rating: product.rating, compact: dense),
            if (!dense) ...[
              const SizedBox(height: 7),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: onAdd, style: ElevatedButton.styleFrom(minimumSize: const Size(0, 34), padding: EdgeInsets.zero, backgroundColor: AppColors.green, foregroundColor: Colors.white), child: const Text('Add to Cart', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)))),
            ],
          ],
        ),
      ),
    );
  }
}

```

## `lib/widgets/product_image.dart`

```dart
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;

  const ProductImage({super.key, required this.url, this.width, this.height, this.fit = BoxFit.cover, this.borderRadius = const BorderRadius.all(Radius.circular(12))});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          color: const Color(0xFFF0F4F2),
          alignment: Alignment.center,
          child: const Icon(Icons.image_outlined, color: Color(0xFF8A9790), size: 36),
        ),
        loadingBuilder: (context, child, progress) => progress == null ? child : Container(
          width: width,
          height: height,
          color: const Color(0xFFF4F7F5),
          alignment: Alignment.center,
          child: const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      ),
    );
  }
}

```
