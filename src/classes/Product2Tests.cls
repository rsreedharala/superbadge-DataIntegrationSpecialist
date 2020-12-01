@isTest (seeAllData=false)
private class Product2Tests {

  /**
   * @name product2Extension_UnitTest
   * @description UnitTest for product2Extension
   **/
  @isTest static void Product2Extension_UnitTest(){

    Test.startTest();

    PageReference pageRef = Page.Product2New;
    Test.setCurrentPage(pageRef);

    Product2 prod = new Product2(name='Test',isActive=true);
    ApexPages.StandardController stdcontroller = new ApexPages.StandardController(prod);

    Product2Extension ext = new Product2Extension(stdcontroller);
    System.assertEquals(Constants.DEFAULT_ROWS, ext.productsToInsert.size());

    ext.AddRows();
    System.assertEquals(Constants.DEFAULT_ROWS * 2, ext.productsToInsert.size());

    for (Integer i = 0; i < 5; i++) {
      Product2Extension.ProductWrapper wrapper = ext.productsToInsert[i];
      Product2 prod1 = new Product2(
          Name = 'Test Product ' + i,
          IsActive = true,
          Initial_Inventory__c = 20,
          Family = Constants.PRODUCT_FAMILY[0].getValue()
      );
      wrapper.productRecord = prod1;

      PricebookEntry pbe = new PricebookEntry(
          IsActive = true,
          UnitPrice = 10
      );
      wrapper.pricebookEntryRecord = pbe;
    }

    ext.save();
    ext.GetFamilyOptions();
    ext.GetInventory();
    Test.stopTest();

    List<Product2> createdProducts = [SELECT Id FROM Product2];
    System.assertEquals(5, createdProducts.size());
  }

  @isTest static void Product2Trigger_UnitTest(){

    Test.startTest();
    Product2 p = new Product2(
        Name = 'TestProduct',
        Family = 'Side',
        IsActive = true,
        Quantity_Ordered__c = 50,
        Initial_Inventory__c = 100
    );
    insert p;

    CollaborationGroup c = new CollaborationGroup(
        Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS,
        Description = 'test',
        CollaborationType = 'Public'
    );
    insert c;

    p.Quantity_Ordered__c=96;
    update p;
    Test.stopTest();
  }
}