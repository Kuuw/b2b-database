-- =========================================
-- 1) Countries
-- =========================================
CREATE TABLE Countries (
    CountryID       INT             IDENTITY(1,1) NOT NULL,
    CountryName     VARCHAR(100)    NOT NULL,
    CountryCode     VARCHAR(10)     NOT NULL,
    CONSTRAINT PK_Countries PRIMARY KEY (CountryID),
    CONSTRAINT UQ_Countries_CountryCode UNIQUE (CountryCode)
);
GO

-- =========================================
-- 2) AddressTypes
-- =========================================
CREATE TABLE AddressTypes (
    AddressTypeID   INT             IDENTITY(1,1) NOT NULL,
    TypeName        VARCHAR(50)     NOT NULL,
    CONSTRAINT PK_AddressTypes PRIMARY KEY (AddressTypeID),
    CONSTRAINT UQ_AddressTypes_TypeName UNIQUE (TypeName)
);
GO

-- =========================================
-- 3) LogTypes
-- =========================================
CREATE TABLE LogTypes (
    LogTypeID       INT             IDENTITY(1,1) NOT NULL,
    LogTypeName     VARCHAR(50)     NOT NULL,
    CONSTRAINT PK_LogTypes PRIMARY KEY (LogTypeID),
    CONSTRAINT UQ_LogTypes_LogTypeName UNIQUE (LogTypeName)
);
GO

-- =========================================
-- 4) DiscountTypes
-- =========================================
CREATE TABLE DiscountTypes (
    DiscountTypeID      INT             IDENTITY(1,1) NOT NULL,
    DiscountTypeName    VARCHAR(50)     NOT NULL,
    CONSTRAINT PK_DiscountTypes PRIMARY KEY (DiscountTypeID),
    CONSTRAINT UQ_DiscountTypes_DiscountTypeName UNIQUE (DiscountTypeName)
);
GO

-- =========================================
-- 5) Statuses
-- =========================================
CREATE TABLE Statuses (
    StatusID    INT             IDENTITY(1,1) NOT NULL,
    StatusName  VARCHAR(50)     NOT NULL,
    CONSTRAINT PK_Statuses PRIMARY KEY (StatusID),
    CONSTRAINT UQ_Statuses_StatusName UNIQUE (StatusName)
);
GO

-- =========================================
-- 6) Roles
-- =========================================
CREATE TABLE Roles (
    RoleID      INT             IDENTITY(1,1) NOT NULL,
    RoleName    VARCHAR(50)     NOT NULL,
    CONSTRAINT PK_Roles PRIMARY KEY (RoleID),
    CONSTRAINT UQ_Roles_RoleName UNIQUE (RoleName)
);
GO

-- =========================================
-- 7) Permissions
-- =========================================
CREATE TABLE Permissions (
    PermissionID        INT             IDENTITY(1,1) NOT NULL,
    PermissionName      VARCHAR(100)    NOT NULL,
    CONSTRAINT PK_Permissions PRIMARY KEY (PermissionID),
    CONSTRAINT UQ_Permissions_PermissionName UNIQUE (PermissionName)
);
GO

-- =========================================
-- 8) RolePermissions (bridge between Roles & Permissions)
-- =========================================
CREATE TABLE RolePermissions (
    RoleID          INT NOT NULL,
    PermissionID    INT NOT NULL,
    CONSTRAINT PK_RolePermissions PRIMARY KEY (RoleID, PermissionID),
    CONSTRAINT FK_RolePermissions_RoleID FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
    CONSTRAINT FK_RolePermissions_PermissionID FOREIGN KEY (PermissionID) REFERENCES Permissions(PermissionID)
);
GO

-- =========================================
-- 9) Companies
-- =========================================
CREATE TABLE Companies (
    CompanyID       INT             IDENTITY(1,1) NOT NULL,
    CompanyName     VARCHAR(100)    NOT NULL,
    CONSTRAINT PK_Companies PRIMARY KEY (CompanyID),
    CONSTRAINT UQ_Companies_CompanyName UNIQUE (CompanyName)
);
GO

-- =========================================
-- 10) Users
-- =========================================
CREATE TABLE Users (
    UserID          INT             IDENTITY(1,1) NOT NULL,
    CompanyID       INT             NULL,
    FirstName       VARCHAR(50)     NOT NULL,
    LastName        VARCHAR(50)     NOT NULL,
    Email           VARCHAR(100)    NOT NULL,
    PasswordHash    VARCHAR(200)    NOT NULL,
    CreatedAt       DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_Users PRIMARY KEY (UserID),
    CONSTRAINT FK_Users_Companies FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID),
    CONSTRAINT UQ_Users_Email UNIQUE (Email)
);
GO

-- =========================================
-- 11) Addresses
-- =========================================
CREATE TABLE Addresses (
    AddressID       INT             IDENTITY(1,1) NOT NULL,
    AddressTypeID   INT             NOT NULL,
    CountryID       INT             NOT NULL,
    UserID          INT             NULL,
    Street          VARCHAR(100)    NOT NULL,
    City            VARCHAR(50)     NOT NULL,
    State           VARCHAR(50)     NOT NULL,
    PostalCode      VARCHAR(20)     NOT NULL,
    CONSTRAINT PK_Addresses PRIMARY KEY (AddressID),
    CONSTRAINT FK_Addresses_AddressTypeID FOREIGN KEY (AddressTypeID) REFERENCES AddressTypes(AddressTypeID),
    CONSTRAINT FK_Addresses_CountryID FOREIGN KEY (CountryID) REFERENCES Countries(CountryID),
    CONSTRAINT FK_Addresses_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO

-- =========================================
-- 12) Discounts
-- =========================================
CREATE TABLE Discounts (
    DiscountID      INT             IDENTITY(1,1) NOT NULL,
    DiscountTypeID  INT             NOT NULL,
    DiscountValue   DECIMAL(5,2)    NOT NULL,
    Description     VARCHAR(200)    NULL,
    CONSTRAINT PK_Discounts PRIMARY KEY (DiscountID),
    CONSTRAINT FK_Discounts_DiscountTypeID FOREIGN KEY (DiscountTypeID) REFERENCES DiscountTypes(DiscountTypeID)
);
GO

-- =========================================
-- 13) Categories
-- =========================================
CREATE TABLE Categories (
    CategoryID      INT             IDENTITY(1,1) NOT NULL,
    CategoryName    VARCHAR(100)    NOT NULL,
    CONSTRAINT PK_Categories PRIMARY KEY (CategoryID),
    CONSTRAINT UQ_Categories_CategoryName UNIQUE (CategoryName)
);
GO

-- =========================================
-- 14) Products
-- =========================================
CREATE TABLE Products (
    ProductID           INT             IDENTITY(1,1) NOT NULL,
    CategoryID          INT             NOT NULL,
    ProductName         VARCHAR(100)    NOT NULL,
    ProductDescription  VARCHAR(MAX)    NULL,
    Price               DECIMAL(18,2)   NOT NULL,
    CONSTRAINT PK_Products PRIMARY KEY (ProductID),
    CONSTRAINT FK_Products_CategoryID FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    CONSTRAINT UQ_Products_ProductName UNIQUE (ProductName)
);
GO

-- =========================================
-- 15) ProductStocks
-- =========================================
CREATE TABLE ProductStocks (
    ProductStockID  INT             IDENTITY(1,1) NOT NULL,
    ProductID       INT             NOT NULL,
    Quantity        INT             NOT NULL,
    LastUpdated     DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_ProductStocks PRIMARY KEY (ProductStockID),
    CONSTRAINT FK_ProductStocks_ProductID FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- =========================================
-- 16) Orders
-- =========================================
CREATE TABLE Orders (
    OrderID         INT             IDENTITY(1,1) NOT NULL,
    UserID          INT             NOT NULL,
    DiscountID      INT             NULL,
    StatusID        INT             NOT NULL,
    OrderDate       DATETIME        NOT NULL DEFAULT GETDATE(),
    TotalAmount     DECIMAL(18,2)   NOT NULL,
    CONSTRAINT PK_Orders PRIMARY KEY (OrderID),
    CONSTRAINT FK_Orders_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_Orders_DiscountID FOREIGN KEY (DiscountID) REFERENCES Discounts(DiscountID),
    CONSTRAINT FK_Orders_StatusID FOREIGN KEY (StatusID) REFERENCES Statuses(StatusID)
);
GO

-- =========================================
-- 17) OrderItems
-- =========================================
CREATE TABLE OrderItems (
    OrderItemID INT             IDENTITY(1,1) NOT NULL,
    OrderID     INT             NOT NULL,
    ProductID   INT             NOT NULL,
    Quantity    INT             NOT NULL,
    UnitPrice   DECIMAL(18,2)   NOT NULL,
    CONSTRAINT PK_OrderItems PRIMARY KEY (OrderItemID),
    CONSTRAINT FK_OrderItems_OrderID FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderItems_ProductID FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- =========================================
-- 18) Invoices
-- =========================================
CREATE TABLE Invoices (
    InvoiceID       INT             IDENTITY(1,1) NOT NULL,
    OrderID         INT             NOT NULL,
    InvoiceNumber   VARCHAR(50)     NOT NULL,
    InvoiceDate     DATETIME        NOT NULL,
    DueDate         DATETIME        NULL,
    TotalAmount     DECIMAL(18,2)   NOT NULL,
    CONSTRAINT PK_Invoices PRIMARY KEY (InvoiceID),
    CONSTRAINT UQ_Invoices_InvoiceNumber UNIQUE (InvoiceNumber),
    CONSTRAINT FK_Invoices_OrderID FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
GO

-- =========================================
-- 19) Payments
-- =========================================
CREATE TABLE Payments (
    PaymentID       INT             IDENTITY(1,1) NOT NULL,
    InvoiceID       INT             NOT NULL,
    PaymentMethod   VARCHAR(50)     NOT NULL,
    PaymentDate     DATETIME        NOT NULL,
    PaymentAmount   DECIMAL(18,2)   NOT NULL,
    CONSTRAINT PK_Payments PRIMARY KEY (PaymentID),
    CONSTRAINT FK_Payments_InvoiceID FOREIGN KEY (InvoiceID) REFERENCES Invoices(InvoiceID)
);
GO

-- =========================================
-- 20) Logs
-- =========================================
CREATE TABLE Logs (
    LogID       INT             IDENTITY(1,1) NOT NULL,
    LogTypeID   INT             NOT NULL,
    UserID      INT             NOT NULL,
    LogMessage  VARCHAR(500)    NOT NULL,
    CreatedAt   DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_Logs PRIMARY KEY (LogID),
    CONSTRAINT FK_Logs_LogTypeID FOREIGN KEY (LogTypeID) REFERENCES LogTypes(LogTypeID),
    CONSTRAINT FK_Logs_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO

-- =========================================
-- 21) ProductImage
-- =========================================
CREATE TABLE ProductImage (
    ProductImageID  INT             IDENTITY(1,1) NOT NULL,
    ProductID       INT             NOT NULL,
    ImageURL        VARCHAR(200)    NOT NULL,
    CreatedAt       DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_ProductImage PRIMARY KEY (ProductImageID),
    CONSTRAINT FK_ProductImage_ProductID FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO
