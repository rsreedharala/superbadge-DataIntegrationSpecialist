/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
 **/
public class TestDataFactory {

  /**
   * @name constructCollaborationGroup
   * @description
   **/
  public static CollaborationGroup ConstructCollaborationGroup(){
    CollaborationGroup cgroup = new CollaborationGroup(
    	Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS,
        CanHaveGuests = false,
        CollaborationType = 'Public',
        IsArchived = false,
        IsAutoArchiveDisabled = false
    );
    return cgroup;
  }

  /**
   * @name CreateProducts
   * @description constructs a List of Product2 records for unit tests
   **/
  public static List<Product2> constructProducts(Integer cnt){
    List<Product2> products = new List<Product2>();
    for (Integer i = 0; i < cnt; i++) {
      products.add(new Product2(
          Name = 'Product ' + i,
          Family = Constants.PRODUCT_FAMILY[Math.mod(i, Constants.PRODUCT_FAMILY.size())].getValue(),
          Initial_Inventory__c = 10,
          IsActive = true
      ));
    }
    return products;
  }

  /**
   * @name CreatePricebookEntries
   * @description constructs a List of PricebookEntry records for unit tests
   **/
  public static List<PricebookEntry> constructPricebookEntries(List<Product2> productList){
    List<PricebookEntry> pbes = new List<PricebookEntry>();
    for (Product2 product: productList) {
      pbes.add(new PricebookEntry(
          Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID,
          Product2Id = product.Id,
          IsActive = true,
          UnitPrice = 10
      ));
    }
    return pbes;
  }

  /**
   * @name CreateAccounts
   * @description constructs a List of Account records for unit tests
   **/
  public static List<Account> constructAccounts(Integer cnt){
    List<Account> accounts = new List<Account>();
    for (Integer i = 0; i < cnt; i++) {
      accounts.add(new Account(Name = 'Account ' + i));
    }
    return accounts;
  }

  /**
   * @name CreateContacts
   * @description constructs a List of Contacxt records for unit tests
   **/
  public static List<Contact> constructContacts(Integer cnt, List<Account> accts){
    List<Contact> contacts = new List<Contact>();
    for (Integer i = 0; i < cnt; i++) {
      contacts.add(new Contact(LastName = 'Contact ' + i, AccountId = accts[Math.mod(i, accts.size())].Id));
    }

    return contacts;
  }

  /**
   * @name CreateOrders
   * @description constructs a List of Order records for unit tests
   **/
  public static List<Order> constructOrders(Integer cnt, List<Account> accts){
    List<Order> orders = new List<Order>();

    for (Integer i = 0; i < cnt; i++) {
      orders.add(new Order(
          Name = 'Order ' + i,
          AccountId = accts[Math.mod(i, accts.size())].Id,
          EffectiveDate = Date.today(),
          Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID,
          Status = Constants.DRAFT_ORDER_STATUS
      ));
    }

    return orders;
  }

  /**
   * @name CreateOrderItems
   * @description constructs a List of OrderItem records for unit tests
   **/
  public static List<OrderItem> constructOrderItems(Integer cnt, List<Pricebookentry> pbes, List<Order> ords){
    List<OrderItem> orderItems = new List<OrderItem>();

    for (Integer i = 0; i < cnt; i++) {
      orderItems.add(new OrderItem(
          OrderId = ords[Math.mod(i, ords.size())].Id,
          PriceBookEntryId = pbes[Math.mod(i, pbes.size())].Id,
          Quantity = Constants.DEFAULT_ROWS,
          UnitPrice = 10
      ));
    }

    return orderItems;
  }

  public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered){
    Integer sumQuantity = Integer.valueOf(originalProduct.Quantity_Ordered__c) + qtyOrdered;
    System.assertEquals(updatedProduct.Quantity_Ordered__c, sumQuantity);
  }

  /**
   * @name SetupTestData
   * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
   **/
  public static void InsertTestData(Integer cnt){
    insert constructCollaborationGroup();

    List<Product2> products = constructProducts(cnt);
    insert products;

    List<PricebookEntry> pbes = constructPricebookEntries(products);
    insert pbes;

    List<Account> accounts = constructAccounts(cnt);
    insert accounts;
    insert constructContacts(cnt, accounts);

    List<Order> orders = constructOrders(cnt, accounts);
    insert orders;

    insert constructOrderItems(cnt, pbes, orders);
  }
}