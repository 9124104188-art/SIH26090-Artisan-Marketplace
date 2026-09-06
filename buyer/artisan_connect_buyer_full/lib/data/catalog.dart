import 'package:flutter/material.dart';

import '../models/product.dart';

class CategoryInfo {
  final String name;
  final IconData icon;
  final String imageUrl;
  const CategoryInfo(this.name, this.icon, this.imageUrl);
}

const defaultCategoryImageUrl =
    'https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=800&q=80';

CategoryInfo? categoryByName(String? name) {
  if (name == null || name.isEmpty) return null;
  for (final category in categories) {
    if (category.name == name) return category;
  }
  return null;
}

String categoryImageFor(String? name) {
  final match = categoryByName(name);
  return match?.imageUrl ?? defaultCategoryImageUrl;
}

const _productImagePool = <String, List<String>>{
  'Home Decor': [
    'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1484154218962-a197022b5858?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80',
  ],
  'Handicrafts': [
    'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=800&q=80',
  ],
  'Textiles': [
    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=800&q=80',
  ],
  'Jewellery': [
    'https://images.unsplash.com/photo-1617038220319-276d3cfab638?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1583394838336-acd977736f90?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1617038220319-276d3cfab638?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1535632787350-4e68ef0ac584?auto=format&fit=crop&w=800&q=80',
  ],
  'Paintings': [
    'https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1515405295579-ba7b45403062?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1513364776144-60967b0f800f?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1515405295579-ba7b45403062?auto=format&fit=crop&w=800&q=80',
  ],
  'Pottery': [
    'https://images.unsplash.com/photo-1493106641515-6b5631de4bb9?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1610701596061-2ecf227e85b2?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1523413651479-597eb2da0ad6?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=800&q=80',
  ],
  'Wooden Crafts': [
    'https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1484154218962-a197022b5853?auto=format&fit=crop&w=800&q=80',
  ],
  'Bamboo Products': [
    'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1523413651479-597eb2da0ad6?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=800&q=80',
  ],
  'Metal Crafts': [
    'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1484154218962-a197022b5858?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=800&q=80',
  ],
  'Stone Crafts': [
    'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1484154218962-a197022b5858?auto=format&fit=crop&w=800&q=80',
  ],
  'Leather Products': [
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=800&q=80',
  ],
  'Organic & Natural': [
    'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1515377905703-c4788e51af15?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=800&q=80',
  ],
  'Toys & Games': [
    'https://images.unsplash.com/photo-1511512578047-dfb367046420?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1516627145497-ae6968895b74?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1558060370-d644479cb6f7?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1516627145497-ae6968895b74?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1511512578047-dfb367046420?auto=format&fit=crop&w=800&q=80',
  ],
  'Wall Hangings': [
    'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1484154218962-a197022b5858?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=800&q=80',
  ],
  'Festive Items': [
    'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80',
  ],
  'Kitchen & Dining': [
    'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1484154218962-a197022b5858?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=800&q=80',
  ],
  'Personal Care': [
    'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1515377905703-c4788e51af15?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?auto=format&fit=crop&w=800&q=80',
  ],
  'Clothing & Apparel': [
    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=800&q=80',
  ],
  'Bags & Accessories': [
    'https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=800&q=80',
  ],
  'Stationery': [
    'https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1521587760476-6c12a4b040da?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1497366754035-f200968a6e72?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1455390582262-044cdead277a?auto=format&fit=crop&w=800&q=80',
  ],
};

String productImageFor(String category, String productName, int index) {
  final categoryImages = _productImagePool[category] ?? const <String>[];
  if (categoryImages.isNotEmpty) {
    return categoryImages[index % categoryImages.length];
  }
  final seed = [
    category,
    productName,
    (index + 1).toString(),
  ].join('-').toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  return 'https://picsum.photos/seed/${Uri.encodeComponent(seed)}/800/1000';
}

const categories = <CategoryInfo>[
  CategoryInfo('Home Decor', Icons.home_outlined,
      'https://images.unsplash.com/photo-1618220179428-22790b461013'),
  CategoryInfo('Handicrafts', Icons.handyman_outlined,
      'https://images.unsplash.com/photo-1602523961358-f9f03dd557db'),
  CategoryInfo('Textiles', Icons.checkroom_outlined,
      'https://images.unsplash.com/photo-1610030469983-98e550d6193c?auto=format&fit=crop&w=800&q=80'),
  CategoryInfo('Jewellery', Icons.diamond_outlined,
      'https://images.unsplash.com/photo-1611652022419-a9419f74343d'),
  CategoryInfo('Paintings', Icons.brush_outlined,
      'https://images.unsplash.com/photo-1577083552431-6e5fd01988a5'),
  CategoryInfo('Pottery', Icons.inventory_2_outlined,
      'https://images.unsplash.com/photo-1493106641515-6b5631de4bb9'),
  CategoryInfo('Wooden Crafts', Icons.park_outlined,
      'https://images.unsplash.com/photo-1599940824399-b87987ceb72a'),
  CategoryInfo('Bamboo Products', Icons.forest_outlined,
      'https://images.unsplash.com/photo-1523413651479-597eb2da0ad6'),
  CategoryInfo('Metal Crafts', Icons.precision_manufacturing_outlined,
      'https://images.unsplash.com/photo-1601058268499-e52658d8e1b5'),
  CategoryInfo('Stone Crafts', Icons.terrain_outlined,
      'https://images.unsplash.com/photo-1561214115-7c3c7c7e7f9a'),
  CategoryInfo('Leather Products', Icons.shopping_bag_outlined,
      'https://images.unsplash.com/photo-1553062407-98eeb64c6a62'),
  CategoryInfo('Organic & Natural', Icons.eco_outlined,
      'https://images.unsplash.com/photo-1556228578-8c89e6adf883'),
  CategoryInfo('Toys & Games', Icons.toys_outlined,
      'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1'),
  CategoryInfo('Wall Hangings', Icons.wallpaper_outlined,
      'https://images.unsplash.com/photo-1586023492125-27b2c045efd7'),
  CategoryInfo('Festive Items', Icons.celebration_outlined,
      'https://images.unsplash.com/photo-1604608672516-f1e9a7e3190f'),
  CategoryInfo('Kitchen & Dining', Icons.kitchen_outlined,
      'https://images.unsplash.com/photo-1556911220-e15b29be8c8f'),
  CategoryInfo('Personal Care', Icons.spa_outlined,
      'https://images.unsplash.com/photo-1608571423902-eed4a5ad8108'),
  CategoryInfo('Clothing & Apparel', Icons.local_mall_outlined,
      'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80'),
  CategoryInfo('Bags & Accessories', Icons.shopping_bag_outlined,
      'https://images.unsplash.com/photo-1584917865442-de89df76afd3'),
  CategoryInfo('Stationery', Icons.menu_book_outlined,
      'https://images.unsplash.com/photo-1455390582262-044cdead277a'),
];

const _names = <String, List<String>>{
  'Home Decor': [
    'Terracotta Lamp',
    'Wooden Wall Shelf',
    'Decorative Mirror',
    'Clay Flower Vase',
    'Macrame Table Accent',
    'Brass Diya Set',
    'Candle Holder',
    'Ceramic Plant Pot',
    'Wooden Table Clock',
    'Bamboo Lampshade'
  ],
  'Handicrafts': [
    'Wooden Elephant',
    'Palm Leaf Basket',
    'Warli Figurine',
    'Handmade Tribal Mask',
    'Carved Peacock',
    'Paper Mache Doll',
    'Palm Leaf Fan',
    'Cane Craft Box',
    'Miniature Bull',
    'Handmade Bird Pair'
  ],
  'Textiles': [
    'Cotton Saree',
    'Handloom Stole',
    'Block Print Dupatta',
    'Ikat Cushion Cover',
    'Khadi Scarf',
    'Embroidered Shawl',
    'Tie Dye Fabric',
    'Cotton Table Runner',
    'Handwoven Bedsheet',
    'Silk Wall Textile'
  ],
  'Jewellery': [
    'Beaded Necklace',
    'Terracotta Earrings',
    'Brass Jhumka',
    'Silver Oxidised Ring',
    'Thread Bracelet',
    'Kundan Pendant',
    'Tribal Choker',
    'Pearl Hair Pin',
    'Wooden Earrings',
    'Handmade Anklet'
  ],
  'Paintings': [
    'Painted Canvas',
    'Madhubani Art',
    'Tanjore Miniature',
    'Warli Painting',
    'Floral Folk Art',
    'Village Landscape',
    'Abstract Folk Frame',
    'Mandala Art',
    'Gond Painting',
    'Nature Wall Art'
  ],
  'Pottery': [
    'Terracotta Vase',
    'Clay Serving Bowl',
    'Handmade Mug',
    'Earthen Diya Set',
    'Planter Pot',
    'Clay Water Bottle',
    'Pottery Plate',
    'Ceramic Kettle',
    'Mini Kulhad Set',
    'Decorative Urli'
  ],
  'Wooden Crafts': [
    'Carved Trinket Box',
    'Wooden Bowl',
    'Wooden Wall Clock',
    'Carved Pen Stand',
    'Wooden Horse',
    'Wooden Owl',
    'Wooden Peacock',
    'Puzzle Toy',
    'Serving Tray',
    'Carved Photo Frame'
  ],
  'Bamboo Products': [
    'Bamboo Pen Stand',
    'Bamboo Basket',
    'Bamboo Lamp',
    'Bamboo Tray',
    'Bamboo Bottle',
    'Bamboo Storage Box',
    'Bamboo Plant Stand',
    'Bamboo Wind Chime',
    'Bamboo Organizer',
    'Bamboo Serving Set'
  ],
  'Metal Crafts': [
    'Brass Lamp',
    'Brass Bell',
    'Copper Bottle',
    'Metal Wall Art',
    'Brass Ganesha',
    'Handmade Tumbler',
    'Bronze Figurine',
    'Metal Diya',
    'Brass Tray',
    'Decorative Horse'
  ],
  'Stone Crafts': [
    'Stone Buddha',
    'Soapstone Bowl',
    'Marble Inlay Coaster',
    'Granite Mortar',
    'Carved Stone Elephant',
    'Stone Lamp',
    'Mini Stone Ganesha',
    'Pebble Photo Stand',
    'Stone Candle Holder',
    'Carved Stone Plate'
  ],
  'Leather Products': [
    'Leather Wallet',
    'Leather Belt',
    'Leather Journal',
    'Leather Sling Bag',
    'Leather Pouch',
    'Leather Passport Cover',
    'Leather Card Holder',
    'Leather Keychain',
    'Leather Tote',
    'Leather Spectacle Case'
  ],
  'Organic & Natural': [
    'Organic Soap Set',
    'Herbal Bath Powder',
    'Natural Incense',
    'Neem Comb',
    'Coconut Shell Bowl',
    'Handmade Lip Balm',
    'Aloe Face Bar',
    'Herbal Shampoo Bar',
    'Natural Candle',
    'Rose Bath Salt'
  ],
  'Toys & Games': [
    'Wooden Toy Car',
    'Stacking Rings',
    'Wooden Puzzle',
    'Cloth Doll',
    'Pull Along Duck',
    'Spinning Top',
    'Wooden Blocks',
    'Finger Puppet Set',
    'Traditional Board Game',
    'Handmade Rattle'
  ],
  'Wall Hangings': [
    'Macrame Hanging',
    'Jute Wall Art',
    'Cotton Tassel Decor',
    'Bamboo Wall Fan',
    'Embroidered Hoop',
    'Mirror Wall Hanging',
    'Dream Catcher',
    'Woven Tapestry',
    'Shell Wall Decor',
    'Beaded Toran'
  ],
  'Festive Items': [
    'Decorative Diya',
    'Festival Toran',
    'Clay Ganesha',
    'Puja Thali',
    'Brass Bell Set',
    'Rangoli Stencil',
    'Festive Lantern',
    'Handmade Incense Stand',
    'Decorative Kalash',
    'Flower Garland'
  ],
  'Kitchen & Dining': [
    'Kitchen Bowl Set',
    'Spice Box',
    'Wooden Spoon Set',
    'Serving Tray',
    'Clay Casserole',
    'Coconut Ladle',
    'Masala Box',
    'Wooden Chopping Board',
    'Ceramic Dinner Set',
    'Handmade Strainer'
  ],
  'Personal Care': [
    'Herbal Soap',
    'Bamboo Toothbrush',
    'Natural Scrub',
    'Handmade Comb',
    'Lip Balm Set',
    'Bath Salt Jar',
    'Rose Water',
    'Herbal Hair Oil',
    'Face Pack',
    'Natural Loofah'
  ],
  'Clothing & Apparel': [
    'Handloom Saree',
    'Cotton Kurta',
    'Embroidered Dupatta',
    'Linen Shirt',
    'Block Print Skirt',
    'Handmade Scarf',
    'Cotton Dress',
    'Ikat Shirt',
    'Traditional Shawl',
    'Printed Stole'
  ],
  'Bags & Accessories': [
    'Jute Handbag',
    'Canvas Tote',
    'Bamboo Clutch',
    'Handwoven Sling Bag',
    'Embroidered Purse',
    'Leather Pouch Bag',
    'Jute Backpack',
    'Cotton Tote',
    'Tribal Shoulder Bag',
    'Handmade Coin Purse'
  ],
  'Stationery': [
    'Handmade Notebook',
    'Recycled Journal',
    'Bamboo Pen Set',
    'Art Sketchbook',
    'Handmade Greeting Cards',
    'Leather Diary',
    'Craft Paper Pack',
    'Wooden Bookmark',
    'Calligraphy Set',
    'Mini Desk Organizer'
  ],
};

const _artisans = <String>[
  'Ramesh Crafts',
  'Lakshmi Handicrafts',
  'Green Weaves',
  'Clay Creations',
  'Metal Artisans',
  'ColorStrokes',
  'Bamboo Hub',
  'Stone Crafts',
  'Leather Works',
  'Nature Care',
  'Toy Makers',
  'Knot Studio',
  'Kitchen Crafts',
  'Eco Bags',
  'Traditional Arts'
];
const _cities = <String>[
  'Thanjavur',
  'Madurai',
  'Kanchipuram',
  'Coimbatore',
  'Jaipur',
  'Mysuru',
  'Kolkata',
  'Varanasi'
];

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
        description:
            'Handmade ${names[i].toLowerCase()} crafted by skilled artisans. Made with care using traditional techniques and quality materials.',
        imageUrl: productImageFor(category.name, names[i], i),
        tags: [category.name, 'Handmade', 'Local', 'Artisan'],
        featured: id <= 20 || id % 13 == 0,
      ));
      id++;
    }
  }
  return result;
}
