curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install node

cat > package.json <<EOF
{
    "name": "schema-builder",
    "version": "1.0.0",
    "dependencies": {
      "serialize-error": "^11.0.3"
    },
    "devDependencies": {
      "webpack": "^5.89.0",
      "webpack-cli": "^5.1.4",
      "babel-loader": "^9.1.3",
      "path-browserify": "^1.0.1",
      "crypto-browserify": "3.12.0",
      "stream-browserify":"^3.0.0",
      "https-browserify":"^1.0.0",
      "os-browserify":"^0.3.0",
      "browserify-zlib":"^0.2.0",
      "util":"^0.12.5",
      "url":"^0.11.3",
      "stream-http":"^3.2.0",
      "assert":"^2.1.0",
      "@google-cloud/bigquery":"^7.3.0",
      "fs":"^0.0.1-security",
      "querystring-es3":"^0.2.1",
      "net-browserify":"^0.2.4",
      "process":"^0.11.10",
      "buffer":"^6.0.3",
      "graphql":"^16.8.1",
      "@graphql-tools/schema":"^9.0.0",
      "node-cloudflare-r2":"0.1.5"
    },
    "private": true,
    "type": "module",
    "main": "index.js"
}
EOF

npm install

cat > schema_builder.js <<EOF
import { BigQuery } from "@google-cloud/bigquery";
import { GraphQLSchema, 
  GraphQLObjectType,
  GraphQLString, 
  GraphQLInt, 
  GraphQLBoolean,
  introspectionFromSchema,
  buildSchema,
  graphqlSync } from "graphql";
import fs from 'fs';
import path from 'path';
import { serializeError } from "serialize-error";
import { mergeSchemas } from '@graphql-tools/schema';
import { R2 } from 'node-cloudflare-r2';

async function main() {
  const options = {
    keyFilename: "key.json",
    projectId: "$1",
    datasetId: "$2",
  };

  const bigquery = new BigQuery(options);
  // const storage = new Storage({
  //   projectId: options.projectId,
  //   keyFilename: "storage_admin_key.json",
  // });

  const r2 = new R2({
      accountId: "$4",
      accessKeyId: "$5",
      secretAccessKey: "$6",
  });

  const bucket = r2.bucket("$3");
  // const bucket = r2.bucket("schemas");

  function getTableMetadata(table) {
    async function getTM(table) {
      const metadata = await table.getMetadata();
      return metadata;
    }
    return getTM(table);
  }

  async function uploadFile(filename) {
    
    // var generationMatchPrecondition = 0

    // const local_options = {
    //   destination: fileName,
    //   // Optional:
    //   // Set a generation-match precondition to avoid potential race conditions
    //   // and data corruptions. The request to upload is aborted if the object's
    //   // generation number does not match your precondition. For a destination
    //   // object that does not yet exist, set the ifGenerationMatch precondition to 0
    //   // If the destination object already exists in your bucket, set instead a
    //   // generation-match precondition using its generation number.
    //   preconditionOpts: {ifGenerationMatch: generationMatchPrecondition},
    // };

    // await storage.bucket(options.bucket_name).upload(fileName, local_options);

    // Set your bucket's public URL
    // bucket.provideBucketPublicUrl('https://pub-xxxxxxxxxxxxxxxxxxxxxxxxx.r2.dev');

    // console.log(await bucket.exists());
    // true

    const upload = await bucket.uploadFile(filename, filename, {}, "application/json");
  }

  function parseType(field) {
    switch (field.type) {
      case "STRING":
        return GraphQLString;
      case "INTEGER":
        return GraphQLInt;
      case "BOOLEAN":
        return GraphQLBoolean;
      case "FLOAT":
        return GraphQLFloat;
      case "TIMESTAMP":
        return GraphQLString;
      case "DATE":
        return GraphQLString;
      case "TIME":
        return GraphQLString;
      case "DATETIME":
        return GraphQLString;
      case "GEOGRAPHY":
        return GraphQLString;
      case "NUMERIC":
        return GraphQLInt;
      default:
        return GraphQLString;
    }
  }

  async function getRegularSchema() {
    var regularFiles = fromDir('./', '.graphql');
    var adminFiles = fromDir('./', '.admin.graphql');
    regularFiles = regularFiles.filter( x => !new Set(adminFiles).has(x) );
    
    var combined = "";

    for(let x = 0; x < regularFiles.length; x++) {
      const data = fs.readFileSync(regularFiles[x],{ encoding: 'utf8', flag: 'r' });
      combined += data;
    }
    return buildSchema(combined);
  }

  async function getAdminSchema() {
    var adminFiles = fromDir('./', '.admin.graphql');
    
    var combined = "";

    for(let x = 0; x < adminFiles.length; x++) {
      const data = fs.readFileSync(adminFiles[x],{ encoding: 'utf8', flag: 'r' });
      combined += data;
      if (fs.existsSync(adminFiles[x].replace('.admin.graphql', '.graphql'))) {
        const regData = fs.readFileSync(adminFiles[x].replace('.admin.graphql', '.graphql'),{ encoding: 'utf8', flag: 'r' });
        combined += regData;
      }
    }
    var additionalSchemas = [
      "/Query.graphql",
      "/Setting.graphql",
      "/Weight.graphql",
      "/Cart.graphql",
      "/Date.graphql",
      "/Price.graphql",
      "/DateTime.graphql",
      "/Country.graphql",
      "/Province.graphql",
      "/Status.graphql",
      "/ShippingSetting.graphql",
      "/StoreSetting.graphql",
    ];
    for(let x = 0; x < additionalSchemas.length; x++) {
      var file = fromDir('./', additionalSchemas[x])[0];
      console.log(file)
      const data = fs.readFileSync(file,{ encoding: 'utf8', flag: 'r' });
      combined += data;
    }
    return buildSchema(combined);
  }

  async function fetchSchemas() {
    // const [tables] = await bigquery.dataset(options.datasetId).getTables();

    // var tableList = [];
    var graphqlObjects = [];
    // for (var table of tables) {
    //   var tableMetadata = await getTableMetadata(table);
    //   tableList.push(tableMetadata);
    // }

    // for (var metadata of tableList) {
    //   var fields = {};
    //   metadata[0].schema.fields.forEach((field) => {
    //     fields[field.name] = {
    //       type: parseType(field.type),
    //       description: field.description,
    //     };
    //   });

    //   var types = [];
    //   types.push( new GraphQLObjectType({
    //     name: metadata[0].tableReference.tableId,
    //     fields: fields,
    //   }));

    //   var graphqlSchema = new GraphQLSchema({
    //     query: new GraphQLObjectType({
    //       name: 'Query',
    //       fields: {
    //         _dummy: { type: GraphQLString }
    //       }
    //     }),
    //     types: types
    //   });

    //   graphqlObjects.push(
    //     graphqlSchema
    //   );
    // }



    return graphqlObjects;
  }

  function fromDir(startPath, filter) {

      // console.log('Starting from dir '+startPath+'/');

      if (!fs.existsSync(startPath)) {
          console.log("no dir ", startPath);
          return;
      }

      var foundList = [];
      var files = fs.readdirSync(startPath);
      for (var i = 0; i < files.length; i++) {
          var filename = path.join(startPath, files[i]);
          var stat = fs.lstatSync(filename);
          if (stat.isDirectory()) {
              fromDir(filename, filter).forEach((item) => {
                foundList.push(item);
              }); //recurse
          } else if (filename.endsWith(filter)) {
              foundList.push(filename);
          };
      };
      return foundList;
  };

  async function query() {
    // var schemas = await fetchSchemas();
    
    // const storage = new Storage();
    // const mergedSchema = mergeSchemas({
    //   schemas: schemas
    // })
    // const schema_json = introspectionFromSchema(mergedSchema);

    const regularFileName = 'graphql_schema.json';
    const adminFileName = 'graphql_admin_schema.json';

    const schema_json = introspectionFromSchema(await getRegularSchema());
    const admin_schema_json = introspectionFromSchema(await getAdminSchema());

    let json = JSON.stringify(schema_json);
    // console.log(json);

    let admin_json = JSON.stringify(admin_schema_json);
    // console.log(admin_json);

    await fs.writeFile(regularFileName, json,{ flush:true }, (err) => {
      err && console.error(err)
    });
    fs.readFile(regularFileName, 'utf8', async (err, data) => {
      if (err) {
        console.error(err)
        return
      }
      await uploadFile(regularFileName);
    });



    await fs.writeFile(adminFileName, admin_json,{ flush:true }, (err) => {
      err && console.error(err)
    });
    fs.readFile(adminFileName, 'utf8', async (err, data) => {
      if (err) {
        console.error(err)
        return
      }
      await uploadFile(adminFileName);
    });
  }

  try {
    await query();
  } catch (err) {
    const responseError = serializeError(err);
    console.error(responseError);
  }
}
main(...process.argv.slice(2));
EOF

cat PaypalSetting.admin.graphql <<EOF
extend type Setting { paypalPaymentStatus: Int paypalClientId: String paypalClientSecret: String paypalWebhookSecret: String paypalPaymentIntent: String }
EOF
cat PaypalSetting.graphql <<EOF
extend type Setting { paypalDislayName: String paypalEnvironment: String }
EOF
cat BestSeller.admin.graphql <<EOF
extend type Product { soldQty: Int } extend type Query { bestSellers: [Product] }
EOF
cat Status.graphql <<EOF
""" Represents a payment status. """ type PaymentStatus { name: String code: String badge: String progress: String } """ Represents a shipment status. """ type ShipmentStatus { name: String code: String badge: String progress: String } extend type Query { shipmentStatusList: [ShipmentStatus] paymentStatusList: [PaymentStatus] }
EOF
cat Order.graphql <<EOF
""" Represents an Order Address. """ type OrderAddress implements Address { orderAddressId: Int! uuid: String! fullName: String postcode: String telephone: String country: Country province: Province city: String address1: String address2: String } """ Represents an Order Item. """ type OrderItem { orderItemId: ID! uuid: String! orderId: ID! productId: ID! productSku: String! productName: String thumbnail: String productWeight: Weight! productPrice: Price! productPriceInclTax: Price! qty: Int! finalPrice: Price! finalPriceInclTax: Price! taxPercent: Float! taxAmount: Price! discountAmount: Price! subTotal: Price! total: Price! variantGroupId: Int variantOptions: String productCustomOptions: String productUrl: String } """ Represents an Order. """ type Order implements ShoppingCart { orderId: ID! uuid: String! orderNumber: String! items: [OrderItem] shippingAddress: OrderAddress billingAddress: OrderAddress currency: String! customerId: Int customerGroupId: Int customerEmail: String customerFullName: String userIp: String userId: String status: Int! coupon: String shippingFeeExclTax: Price! shippingFeeInclTax: Price! discountAmount: Price! subTotal: Price! subTotalInclTax: Price! totalQty: Int! totalWeight: Weight! taxAmount: Price! grandTotal: Price! shippingMethod: String shippingMethodName: String shipmentStatus: ShipmentStatus paymentMethod: String paymentMethodName: String paymentStatus: PaymentStatus shippingNote: String createdAt: Date! updatedAt: String! activities: [Activity] shipment: Shipment } """ Represents an Order Activity. """ type Activity { orderActivityId: Int! comment: String customerNotified: Int! createdAt: DateTime updatedAt: DateTime } """ Represents a Shipment. """ type Shipment { shipmentId: Int! uuid: String! carrier: String trackingNumber: String createdAt: DateTime! updatedAt: DateTime } """ Retrieve an list of order. """ type OrderCollection { items: [Order] currentPage: Int! total: Int! currentFilters: [Filter] } extend type Customer { orders: [Order] } extend type Query { order(uuid: String!): Order }
EOF
cat Order.admin.graphql <<EOF
extend type Order { customerUrl: String editUrl: String! createShipmentApi: String! } extend type Shipment { updateShipmentApi: String! } extend type Query { orders(filters: [FilterInput]): OrderCollection }
EOF
cat Carrier.admin.graphql <<EOF
""" The `Carrier` type defines the shipping carrier. """ type Carrier { name: String! code: String! trackingUrl: String } extend type Query { carriers: [Carrier] }
EOF
cat PaymentTransaction.admin.graphql <<EOF
""" Represents a payment transaction """ type PaymentTransaction { paymentTransactionId: Int! uuid: String! transactionId: String! transactionType: String! amount: Price! parentTransactionId: String! paymentAction: String! additionalInformation: String! createdAt: String! } extend type Order { paymentTransactions: [PaymentTransaction] }
EOF
cat StoreSetting.graphql <<EOF
extend type Setting { storeDescription: String storeLanguage: String storeCurrency: String storeTimeZone: String storePhoneNumber: String storeEmail: String storeCountry: String storeAddress: String storeCity: String storeProvince: String storePostalCode: String }
EOF
cat Setting.graphql <<EOF
""" Single store setting """ type Setting { storeName: String } extend type Query { setting: Setting }
EOF
cat ShippingSetting.graphql <<EOF
extend type Setting { allowedCountries: [String] weightUnit: String }
EOF
cat AdminUser.admin.graphql <<EOF
""" Retrieves a single admin user by ID """ type AdminUser { adminUserId: Int! uuid: String! status: Int! email: String! fullName: String! } """ Retrieves a collection of admin users """ type AdminUserCollection { items: [AdminUser] currentPage: Int! total: Int! currentFilters: [Filter] } extend type Query { adminUser(id: Int): AdminUser currentAdminUser: AdminUser adminUsers(filters: [FilterInput]): AdminUserCollection }
EOF
cat Cart.graphql <<EOF
""" Shopping Cart interface """ interface ShoppingCart { currency: String! customerId: Int customerGroupId: Int customerEmail: String customerFullName: String userIp: String userId: String status: Int! coupon: String shippingFeeExclTax: Price! shippingFeeInclTax: Price! discountAmount: Price! subTotal: Price! totalQty: Int! totalWeight: Weight! taxAmount: Price! grandTotal: Price! shippingMethod: String shippingMethodName: String shippingAddress: Address paymentMethod: String paymentMethodName: String billingAddress: Address shippingNote: String } """ Shopping Cart Item interface """ interface ShoppingCartItem { productId: ID! productSku: String! productName: String thumbnail: String productWeight: Weight! productPrice: Price! productPriceInclTax: Price! qty: Int! finalPrice: Price! finalPriceInclTax: Price! taxPercent: Float! taxAmount: Price! discountAmount: Price! total: Price! variantGroupId: Int variantOptions: String productCustomOptions: String productUrl: String! } """ Address interface """ interface Address { fullName: String postcode: String telephone: String country: Country province: Province city: String address1: String address2: String } """ Represent a Cart Address """ type CartAddress implements Address { cartAddressId: Int! uuid: String! fullName: String postcode: String telephone: String country: Country province: Province city: String address1: String address2: String } """ Represent a Cart Item """ type CartItem implements ShoppingCartItem { cartItemId: ID uuid: String! cartId: ID! removeApi: String! productId: ID! productSku: String! productName: String thumbnail: String productWeight: Weight! productPrice: Price! productPriceInclTax: Price! qty: Int! finalPrice: Price! finalPriceInclTax: Price! taxPercent: Float! taxAmount: Price! discountAmount: Price! subTotal: Price! total: Price! variantGroupId: Int variantOptions: String productCustomOptions: String productUrl: String! errors: [String!] } """ Represent a Cart """ type Cart implements ShoppingCart { cartId: ID! uuid: String! items: [CartItem] shippingAddress: CartAddress billingAddress: CartAddress currency: String! customerId: Int customerGroupId: Int customerEmail: String customerFullName: String userIp: String userId: String status: Int! coupon: String shippingFeeExclTax: Price! shippingFeeInclTax: Price! discountAmount: Price! subTotal: Price! subTotalInclTax: Price! totalQty: Int! totalWeight: Weight! taxAmount: Price! grandTotal: Price! shippingMethod: String shippingMethodName: String paymentMethod: String paymentMethodName: String shippingNote: String addItemApi: String! addPaymentMethodApi: String! addShippingMethodApi: String! addContactInfoApi: String! addAddressApi: String! } extend type Query { cart(id: String): Cart }
EOF
cat Date.graphql <<EOF
""" A date field. """ type Date { value: String text: String }
EOF
cat Price.graphql <<EOF
""" Represents a price value. """ type Price { value: Float! currency(currency: String): String! text(currency: String): String! }
EOF
cat Checkout.graphql <<EOF
""" Represents a checkout object in the store. """ type Checkout { cartId: String! } extend type Query { checkout: Checkout! }
EOF
cat ShippingZone.graphql <<EOF
""" Represents a shipping method. """ type ShippingMethodByZone { methodId: Int! zoneId: Int! uuid: String! name: String! cost: Price isEnabled: Boolean! calculateApi: String conditionType: String max: Float min: Float updateApi: String! } """ Represents a shipping zone. """ type ShippingZone { shipping_zone_id: Int! uuid: String! name: String! country: Country! provinces: [Province] methods: [ShippingMethodByZone] updateApi: String! addMethodApi: String! removeMethodApi: String! } extend type Query { shippingZones: [ShippingZone] shippingZone(id: String!): ShippingZone }
EOF
cat ShippingMethod.graphql <<EOF
""" Represents a shipping method. """ type ShippingMethod { shippingMethodId: Int! uuid: String! name: String! } extend type Query { shippingMethods: [ShippingMethod] }
EOF
cat Weight.graphql <<EOF
""" Represents a weight value. """ type Weight { value: Float! unit: String! text: String! }
EOF
cat Customer.admin.graphql <<EOF
extend type Customer { editUrl: String! updateApi: String! deleteApi: String! } """ Return a collection of customers """ type CustomerCollection { items: [Customer] currentPage: Int! total: Int! currentFilters: [Filter] } extend type Query { customer(id: String): Customer customers(filters: [FilterInput]): CustomerCollection }
EOF
cat Customer.graphql <<EOF
""" Represents a customer """ type Customer { customerId: Int! uuid: String! status: Int! email: String! fullName: String! createdAt: Date! } extend type Query { currentCustomer: Customer }
EOF
cat CustomerSetting.graphql <<EOF
extend type Setting { customerAddressSchema: JSON }
EOF
cat CustomerGroup.admin.graphql <<EOF
extend type CustomerGroup { editUrl: String! customers: [Customer] } """ Represents a collection of customer groups """ type CustomerGroupCollection { items: [CustomerGroup] currentPage: Int! total: Int! currentFilters: [Filter] } extend type Query { customerGroup: CustomerGroup customerGroups: CustomerGroupCollection }
EOF
cat CustomerGroup.graphql <<EOF
""" Represents a customer group. """ type CustomerGroup { customerGroupId: Int! groupName: String! } extend type Customer { group: CustomerGroup }
EOF
cat StripeSetting.graphql <<EOF
extend type Setting { stripePaymentStatus: Int stripeDislayName: String stripePublishableKey: String }
EOF
cat StripeSetting.admin.graphql <<EOF
extend type Setting { stripeSecretKey: String stripeEndpointSecret: String }
EOF
cat TaxSetting.admin.graphql <<EOF
extend type Setting { defaultProductTaxClassId: Int defaultShippingTaxClassId: Int baseCalculationAddress: String }
EOF
cat TaxSetting.graphql <<EOF
extend type Setting { displayCatalogPriceIncludeTax: Boolean displayCheckoutPriceIncludeTax: Boolean }
EOF
cat TaxClass.admin.graphql <<EOF
""" Represents a tax rate. """ type TaxRate { taxRateId: Int! taxClassId: Int! uuid: String! name: String! rate: Float! isCompound: Boolean! country: String! province: String! postcode: String! priority: Int! updateApi: String! deleteApi: String! } """ Represents a tax class. """ type TaxClass { taxClassId: Int! uuid: String! name: String! rates: [TaxRate] addRateApi: String! } """ Returns a collection of tax classes. """ type TaxClassCollection { items: [TaxClass] currentPage: Int! total: Int! currentFilters: [Filter] } extend type Query { taxClasses: TaxClassCollection taxClass(id: String!): TaxClass }
EOF
cat Coupon.admin.graphql <<EOF
""" Represents a coupon """ type Coupon { couponId: Int uuid: String! status: Int! description: String! discountAmount: Float! freeShipping: Int! discountType: String! coupon: String! usedTime: Int targetProducts: TargetProducts condition: OrderCondition userCondition: UserCondition buyxGety: [ByXGetY] maxUsesTimePerCoupon: Int maxUsesTimePerCustomer: Int startDate: DateTime endDate: DateTime editUrl: String! updateApi: String! deleteApi: String! } """ Represents a signle product used in the condition of a coupon. """ type MatchProductFilter { key: String! operator: String! value: JSON qty: String } """ Represents the target products of a coupon. """ type TargetProducts { maxQty: String products: [MatchProductFilter] } """ Represents the condition of a coupon. """ type OrderCondition { orderTotal: String orderQty: String requiredProducts: [MatchProductFilter] } """ Represents the buy x get y condition of a coupon. """ type ByXGetY { sku: String! buyQty: String getQty: String maxY: String discount: String } """ Represents the user condition of a coupon. """ type UserCondition { groups: [String] emails: String purchased: String } """ Returns a collection of coupons """ type CouponCollection { items: [Coupon] currentPage: Int! total: Int! currentFilters: [Filter] } extend type Query { coupon(id: Int): Coupon coupons(filters: [FilterInput]): CouponCollection }
EOF
cat Coupon.graphql <<EOF
scalar JSON extend type Cart { applyCouponApi: String! }
EOF
cat Query.graphql <<EOF
""" The root query type, represents all of the entry points into our object graph. """ type Query { hello: String! }
EOF
cat Attribute.graphql <<EOF
""" Represents a single attribute option """ type AttributeOption { attributeOptionId: ID! uuid: String! optionText: String! } """ Represents a single attribute """ type Attribute { attributeId: ID! uuid: String! attributeCode: String! attributeName: String! type: String! isRequired: Int! displayOnFrontend: Int! sortOrder: Int! isFilterable: Int! options: [AttributeOption] } extend type Query { attribute(id: Int): Attribute }
EOF
cat Attribute.admin.graphql <<EOF
""" Represents a single attribute group """ type AttributeGroup { attributeGroupId: ID! uuid: String! groupName: String! updateApi: String! attributes: [Attribute] } extend type Attribute { groups: [AttributeGroup] editUrl: String! updateApi: String! deleteApi: String! } """ Represents a collection of attributes """ type AttributeCollection { items: [Attribute] currentPage: Int! total: Int! currentFilters: [Filter] } """ Represents a collection of attribute groups """ type AttributeGroupCollection { items: [AttributeGroup] currentPage: Int! total: Int! currentFilters: [Filter] } extend type Query { attributes(filters: [FilterInput]): AttributeCollection attributeGroups(filters: [FilterInput]): AttributeGroupCollection }
EOF
cat FeaturedProduct.graphql <<EOF
extend type Query { featuredProducts(limit: Int): [Product] }
EOF
cat Collection.graphql <<EOF
""" The `Collection` type represents a product collection. """ type Collection { collectionId: ID! uuid: String! name: String! description: String code: String! products(filters: [FilterInput]): ProductCollection } """ Returns a collection of product collection. """ type CollectionCollection { items: [Collection] currentPage: Int! total: Int! currentFilters: [Filter] } extend type Product { collections: [Collection], } extend type Query { collections(filters: [FilterInput]): CollectionCollection collection(code: String): Collection }
EOF
cat Collection.admin.graphql <<EOF
extend type Collection { editUrl: String addProductUrl: String updateApi: String! deleteApi: String! } extend type Product { removeFromCollectionUrl: String }
EOF
cat ProductPrice.graphql <<EOF
""" Represents a price for a product. """ type ProductPrice { regular: Price! special: Price! } extend type Product { price: ProductPrice! }
EOF
cat ProductImage.graphql <<EOF
""" The `Image` type represents a Product image. """ type Image { id: ID! uuid: String! alt: String url: String listing: String single: String thumb: String origin: String } extend type Product { image: Image gallery: [Image] }
EOF
cat Product.admin.graphql <<EOF
extend type Product { editUrl: String updateApi: String! deleteApi: String! }
EOF
cat CustomOption.graphql <<EOF
""" Represents a product option """ type Option { optionId: ID! optionName: String! optionType: String! isRequired: Boolean! values: [OptionValue] } """ Represents a product option value """ type OptionValue { valueId: ID! value: String! extraPrice: Price! } extend type Product { options: [Option] }
EOF
cat Product.graphql <<EOF
""" Represents a product. """ type Product { productId: Int! uuid: String! name: String! status: Int! sku: String! weight: Weight! taxClass: Int description: String urlKey: String metaTitle: String metaDescription: String metaKeywords: String variantGroupId: ID visibility: Int groupId: ID url: String } """ Returns a collection of products. """ type ProductCollection { items: [Product] currentPage: Int! total: Int! currentFilters: [Filter] } extend type Query { product(id: ID): Product products(filters: [FilterInput]): ProductCollection }
EOF
cat ProductAttribute.graphql <<EOF
""" The ProductAttributeIndex object defines the attribute index for a product. """ type ProductAttributeIndex { attributeId: ID! attributeName: String! attributeCode: String! optionId: Int optionText: String } extend type Product { attributeIndex: [ProductAttributeIndex] attributes: [Attribute] }
EOF
cat Variant.graphql <<EOF
""" Represents a product variant attribute """ type VariantAttribute { attributeId: Int! attributeCode: String! attributeName: String! options: [VariantAttributeOption] } """ Represents a product variant attribute option """ type VariantAttributeOption { optionId: Int! optionText: String! productId: Int } """ Represents a product variant attribute index """ type VariantAttributeIndex { attributeId: ID! attributeCode: String! optionId: Int! optionText: String! } """ Represents a product variant """ type Variant { id: String! product: Product! attributes: [VariantAttributeIndex]! removeUrl: String! } """ Represents a product variant group """ type VariantGroup { variantGroupId: Int! variantAttributes: [VariantAttribute]! items: [Variant] addItemApi: String! } extend type Product { variantGroup: VariantGroup }
EOF
cat Inventory.admin.graphql <<EOF
extend type Inventory { qty: Int! }
EOF
cat Inventory.graphql <<EOF
""" The `Inventory` type represents a product's inventory information. """ type Inventory { isInStock: Boolean! stockAvailability: Boolean! manageStock: Boolean! } extend type Product { inventory: Inventory! }
EOF
cat Category.admin.graphql <<EOF
extend type Category { editUrl: String updateApi: String! deleteApi: String! addProductUrl: String } extend type Product { removeFromCategoryUrl: String }
EOF
cat Category.graphql <<EOF
""" The `Category` type represents a category object. """ type Category { categoryId: ID! uuid: String! name: String! status: Int! includeInNav: Int! description: String urlKey: String metaTitle: String metaDescription: String metaKeywords: String image: CategoryImage products(filters: [FilterInput]): ProductCollection children: [Category] parent: Category path: [Category] url: String availableAttributes: [FilterAttribute] priceRange: PriceRange } """ The `CategoryImage` type represents a category image object. """ type CategoryImage { alt: String! url: String! } """ The `FilterInput` type represents a filter input object. """ input FilterInput { key: String! operation: String! value: String } """ The `Filter` type represents a filter object. """ type Filter { key: String! operation: String! value: String! } """ The `FilterOption` type represents a filter option object. """ type FilterOption { optionId: Int! optionText: String! } """ The `FilterAttribute` type represents a filter attribute object. """ type FilterAttribute { attributeName: String! attributeCode: String! attributeId: Int! options: [FilterOption] } """ Returns a collection of categories. """ type CategoryCollection { items: [Category] currentPage: Int! total: Int! currentFilters: [Filter] } type PriceRange { min: Float! max: Float! } extend type Product { category: Category, } extend type Query { categories(filters: [FilterInput]): CategoryCollection category(id: Int): Category }
EOF
cat CODSetting.graphql <<EOF
extend type Setting { codPaymentStatus: Int codDislayName: String }
EOF
cat DateTime.graphql <<EOF
""" A DateTime is a string with a timezone. """ type DateTime { value: String timezone: String text(format: String): String }
EOF
cat Url.graphql <<EOF
""" A query parameter for a URL """ input UrlParam { key: String! value: String! } extend type Query { url(routeId: String!, params: [UrlParam]): String! }
EOF
cat Province.graphql <<EOF
""" The `Province` type represents a province/state. """ type Province { name: String! code: String! countryCode: String! } extend type Query { provinces(countries: [String]): [Province] }
EOF
cat Currency.graphql <<EOF
""" A currency """ type Currency { name: String! code: String! } extend type Query { currencies: [Currency]! }
EOF
cat Country.graphql <<EOF
""" The `Country` type represents a country. """ type Country { name: String! code: String! provinces: [Province] } extend type Query { countries(countries: [String]): [Country] allowedCountries: [Country] }
EOF
cat Timezone.graphql <<EOF
""" A timezone """ type Timezone { name: String! code: String! } extend type Query { timezones: [Timezone]! }
EOF
cat ThemeConfig.graphql <<EOF
""" Represents a link html tag. """ type Link { href: String! text: String! title: String rel: String target: String type: String media: String hrefLang: String sizes: String as: String crossOrigin: String referrerPolicy: String integrity: String } """ Represents a meta html tag. """ type Meta { name: String content: String charSet: String property: String itemProp: String itemType: String itemID: String httpEquiv: String lang: String } """ Represents a script html tag. """ type Script { src: String type: String async: Boolean defer: Boolean crossOrigin: String integrity: String noModule: String nonce: String } """ Represents a base html tag. """ type Base { href: String target: String } """ Represents a logo. """ type Logo { src: String alt: String width: String height: String } """ Represents a nav head tag. """ type HeadTag { links: [Link] metas: [Meta] scripts: [Script] base: Base } """ Represents a base theme config. """ type ThemeConfig { logo: Logo headTags: HeadTag copyRight: String } extend type Query { themeConfig: ThemeConfig }
EOF
cat Menu.graphql <<EOF
""" Represents a menu item """ type MenuItem { name: String! url: String! children: [MenuItem] } """ Represents a menu """ type Menu { items: [MenuItem] } extend type Query { menu: Menu }
EOF
cat CmsPage.graphql <<EOF
""" Lookup CMS page by ID """ type CmsPage { cmsPageId: Int uuid: String! layout: String! status: Int! urlKey: String! name: String! content: String! metaTitle: String metaKeywords: String metaDescription: String url: String! editUrl: String! updateApi: String! deleteApi: String! } """ Return a collection of CMS pages """ type CmsPageCollection { items: [CmsPage] currentPage: Int! total: Int! currentFilters: [Filter] } extend type Query { cmsPage(id: Int): CmsPage cmsPages(filters: [FilterInput]): CmsPageCollection }
EOF
cat PageInfo.graphql <<EOF
""" Represents a breadcrumb information. """ type Breadcrumb { url: String! title: String! } """ Represents a page information. """ type PageInfo { url: String! title: String! description: String!, breadcrumbs: [Breadcrumb!] } extend type Query { pageInfo: PageInfo }
EOF


# ls -al
printf '%s' "$GOOGLE_CREDENTIALS" > key.json
# printf '%s' "$STORAGE_ADMIN_CREDENTIALS" > storage_admin_key.json
node schema_builder.js

cat <<EOF
{
  "res": "test"
}
EOF