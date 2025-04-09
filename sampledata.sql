DECLARE @StatusActive UNIQUEIDENTIFIER = NEWID();
DECLARE @StatusInactive UNIQUEIDENTIFIER = NEWID();

DECLARE @CountryUSA UNIQUEIDENTIFIER = NEWID();
DECLARE @CountryCanada UNIQUEIDENTIFIER = NEWID();

DECLARE @AddressTypeBilling UNIQUEIDENTIFIER = NEWID();
DECLARE @AddressTypeShipping UNIQUEIDENTIFIER = NEWID();

DECLARE @CompanyAddressId UNIQUEIDENTIFIER = NEWID();
DECLARE @Company1 UNIQUEIDENTIFIER = NEWID();

DECLARE @RoleAdmin UNIQUEIDENTIFIER = NEWID();
DECLARE @RoleUser UNIQUEIDENTIFIER = NEWID();

DECLARE @User1 UNIQUEIDENTIFIER = NEWID();

DECLARE @PermissionManageUsers UNIQUEIDENTIFIER = NEWID();
DECLARE @PermissionViewReports UNIQUEIDENTIFIER = NEWID();

DECLARE @Order1 UNIQUEIDENTIFIER = NEWID();
DECLARE @ShippingAddressId UNIQUEIDENTIFIER = NEWID();
DECLARE @InvoiceAddressId UNIQUEIDENTIFIER = NEWID();

DECLARE @Invoice1 UNIQUEIDENTIFIER = NEWID();

DECLARE @CategoryElectronics UNIQUEIDENTIFIER = NEWID();
DECLARE @Product1 UNIQUEIDENTIFIER = NEWID();

DECLARE @DiscountTypePercentage UNIQUEIDENTIFIER = NEWID();
DECLARE @Discount1 UNIQUEIDENTIFIER = NEWID();

DECLARE @LogTypeInfo UNIQUEIDENTIFIER = NEWID();
DECLARE @Log1 UNIQUEIDENTIFIER = NEWID();

DECLARE @ProductImage1 UNIQUEIDENTIFIER = NEWID();

INSERT INTO Statuses (StatusId, StatusName, Description)
VALUES
  (@StatusActive, 'Active', 'Active record'),
  (@StatusInactive, 'Inactive', 'Inactive record');

INSERT INTO Countries (CountryId, CountryName, PhoneCode)
VALUES
  (@CountryUSA, 'United States', 1),
  (@CountryCanada, 'Canada', 1);

INSERT INTO AddressTypes (AddressTypeId, TypeName, Description)
VALUES
  (@AddressTypeBilling, 'Billing', 'Billing address'),
  (@AddressTypeShipping, 'Shipping', 'Shipping address');

INSERT INTO Addresses (AddressId, AddressTypeId, StreetAddress, City, State, PostalCode, CountryId, PhoneNumber, IsDefault)
VALUES
  (@CompanyAddressId, @AddressTypeBilling, '123 Business Rd', 'Business City', 'BS', '12345', @CountryUSA, '555-1234', 1),
  (@ShippingAddressId, @AddressTypeShipping, '456 Delivery Ln', 'ShipCity', 'ST', '67890', @CountryUSA, '555-5678', 1),
  (@InvoiceAddressId, @AddressTypeBilling, '789 Invoice Blvd', 'BillCity', 'BL', '54321', @CountryCanada, '555-9012', 0);

INSERT INTO Companies (CompanyId, CompanyName, TaxNumber, AddressId, Email, Website, StatusId, LogoURL)
VALUES
  (@Company1, 'Demo Company Inc.', 'TAX123456', @CompanyAddressId, 'info@democompany.com', 'http://www.democompany.com', @StatusActive, 'http://www.democompany.com/logo.png');


INSERT INTO Roles (RoleId, RoleName, Description)
VALUES
  (@RoleAdmin, 'Admin', 'Administrator role'),
  (@RoleUser, 'User', 'Regular user role');


INSERT INTO Users (UserId, CompanyId, FirstName, LastName, Email, PhoneNumber, PasswordHash, RoleId, StatusId, ProfileImageUrl)
VALUES
  (@User1, @Company1, 'John', 'Doe', 'john.doe@democompany.com', '555-0001', 'hashedpassword', @RoleAdmin, @StatusActive, 'http://www.democompany.com/users/johndoe.png');

INSERT INTO Permissions (PermissionId, PermissionName, Description)
VALUES
  (@PermissionManageUsers, 'ManageUsers', 'Permission to manage users'),
  (@PermissionViewReports, 'ViewReports', 'Permission to view reports');

INSERT INTO RolePermissions (RoleId, PermissionId)
VALUES
  (@RoleAdmin, @PermissionManageUsers),
  (@RoleAdmin, @PermissionViewReports),
  (@RoleUser, @PermissionViewReports);

INSERT INTO Orders (OrderId, UserId, StatusId, ShippingAddressId, InvoiceAddressId)
VALUES
  (@Order1, @User1, @StatusActive, @ShippingAddressId, @InvoiceAddressId);

INSERT INTO Invoices (InvoiceId, OrderId, CompanyId, InvoiceAddressId, TotalAmount, TaxAmount, Currency, StatusId)
VALUES
  (@Invoice1, @Order1, @Company1, @InvoiceAddressId, 1000.00, 100.00, 'USD', @StatusActive);

INSERT INTO Payments (PaymentId, InvoiceId, PaymentDate, Amount, Currency, TransactionReference)
VALUES
  (NEWID(), @Invoice1, GETDATE(), 1100.00, 'USD', 'TXN123456');

INSERT INTO Categories (CategoryId, CategoryName, CategoryDescription)
VALUES
  (@CategoryElectronics, 'Electronics', 'Electronic gadgets and devices');

INSERT INTO Products (ProductId, ProductName, ProductCode, Description, CategoryId, Price, Currency, StatusId, MinOrderQuantity)
VALUES
  (@Product1, 'Smartphone', 'SPH-001', 'Latest model smartphone', @CategoryElectronics, 699.99, 'USD', @StatusActive, 1);

INSERT INTO OrderItems (OrderId, ProductId, Quantity, Price, Currency)
VALUES
  (@Order1, @Product1, 2, 699.99, 'USD');

INSERT INTO ProductStocks (ProductId, StockQuantity)
VALUES
  (@Product1, 50);

INSERT INTO DiscountTypes (DiscountTypeID, DiscountTypeName)
VALUES
  (@DiscountTypePercentage, 'Percentage');

INSERT INTO Discounts (DiscountID, DiscountTypeID, DiscountValue, Description)
VALUES
  (@Discount1, @DiscountTypePercentage, 10.00, '10% off on selected items');

INSERT INTO LogTypes (LogTypeID, LogTypeName)
VALUES
  (@LogTypeInfo, 'Info');

INSERT INTO Logs (LogID, LogTypeID, UserID, LogMessage)
VALUES
  (@Log1, @LogTypeInfo, @User1, 'User logged in successfully');

INSERT INTO ProductImage (ProductImageID, ProductID, ImageURL)
VALUES
  (@ProductImage1, @Product1, 'http://www.democompany.com/products/smartphone.png');


DECLARE @Product2 UNIQUEIDENTIFIER = NEWID();
DECLARE @Product3 UNIQUEIDENTIFIER = NEWID();
DECLARE @Product4 UNIQUEIDENTIFIER = NEWID();
DECLARE @Product5 UNIQUEIDENTIFIER = NEWID();

INSERT INTO Products (ProductId, ProductName, ProductCode, Description, CategoryId, Price, Currency, StatusId, MinOrderQuantity)
VALUES
  (@Product2, 'Laptop', 'LPT-002', 'High performance laptop with modern features', @CategoryElectronics, 1299.99, 'USD', @StatusActive, 1),
  (@Product3, 'Tablet', 'TBL-003', 'Lightweight tablet with a crisp display', @CategoryElectronics, 499.99, 'USD', @StatusActive, 1),
  (@Product4, 'Smartwatch', 'SWT-004', 'Water resistant smartwatch with health tracking', @CategoryElectronics, 199.99, 'USD', @StatusActive, 1),
  (@Product5, 'Wireless Earbuds', 'WLE-005', 'Noise cancelling wireless earbuds with long battery life', @CategoryElectronics, 149.99, 'USD', @StatusActive, 1);

INSERT INTO ProductStocks (ProductId, StockQuantity)
VALUES
  (@Product2, 30),
  (@Product3, 40),
  (@Product4, 25),
  (@Product5, 100);