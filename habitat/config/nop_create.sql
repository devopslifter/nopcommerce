USE [master]
GO
/****** Object:  Database [nop]    Script Date: 11/14/2018 10:13:41 AM ******/
CREATE DATABASE [nop]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'nop', FILENAME = N'C:\hab\svc\sqlserver\data\nop.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'nop_log', FILENAME = N'C:\hab\svc\sqlserver\data\nop_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [nop] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [nop].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [nop] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [nop] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [nop] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [nop] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [nop] SET ARITHABORT OFF 
GO
ALTER DATABASE [nop] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [nop] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [nop] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [nop] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [nop] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [nop] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [nop] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [nop] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [nop] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [nop] SET  ENABLE_BROKER 
GO
ALTER DATABASE [nop] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [nop] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [nop] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [nop] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [nop] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [nop] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [nop] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [nop] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [nop] SET  MULTI_USER 
GO
ALTER DATABASE [nop] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [nop] SET DB_CHAINING OFF 
GO
ALTER DATABASE [nop] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [nop] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [nop] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [nop] SET QUERY_STORE = OFF
GO
USE [nop]
GO
/****** Object:  UserDefinedFunction [dbo].[nop_getnotnullnotempty]    Script Date: 11/14/2018 10:13:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[nop_getnotnullnotempty]
(
    @p1 nvarchar(max) = null, 
    @p2 nvarchar(max) = null
)
RETURNS nvarchar(max)
AS
BEGIN
    IF @p1 IS NULL
        return @p2
    IF @p1 =''
        return @p2

    return @p1
END
GO
/****** Object:  UserDefinedFunction [dbo].[nop_getprimarykey_indexname]    Script Date: 11/14/2018 10:13:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[nop_getprimarykey_indexname]
(
    @table_name nvarchar(1000) = null
)
RETURNS nvarchar(1000)
AS
BEGIN
	DECLARE @index_name nvarchar(1000)

    SELECT @index_name = i.name
	FROM sys.tables AS tbl
	INNER JOIN sys.indexes AS i ON (i.index_id > 0 and i.is_hypothetical = 0) AND (i.object_id=tbl.object_id)
	WHERE (i.is_unique=1 and i.is_disabled=0) and (tbl.name=@table_name)

    RETURN @index_name
END
GO
/****** Object:  UserDefinedFunction [dbo].[nop_padright]    Script Date: 11/14/2018 10:13:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[nop_padright]
(
    @source INT, 
    @symbol NVARCHAR(MAX), 
    @length INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    RETURN RIGHT(REPLICATE(@symbol, @length)+ RTRIM(CAST(@source AS NVARCHAR(MAX))), @length)
END
GO
/****** Object:  UserDefinedFunction [dbo].[nop_splitstring_to_table]    Script Date: 11/14/2018 10:13:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[nop_splitstring_to_table]
(
    @string NVARCHAR(MAX),
    @delimiter CHAR(1)
)
RETURNS @output TABLE(
    data NVARCHAR(MAX)
)
BEGIN
    DECLARE @start INT, @end INT
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string)

    WHILE @start < LEN(@string) + 1 BEGIN
        IF @end = 0 
            SET @end = LEN(@string) + 1

        INSERT INTO @output (data) 
        VALUES(SUBSTRING(@string, @start, @end - @start))
        SET @start = @end + 1
        SET @end = CHARINDEX(@delimiter, @string, @start)
    END
    RETURN
END
GO
/****** Object:  Table [dbo].[AclRecord]    Script Date: 11/14/2018 10:13:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AclRecord](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EntityId] [int] NOT NULL,
	[EntityName] [nvarchar](400) NOT NULL,
	[CustomerRoleId] [int] NOT NULL,
 CONSTRAINT [PK_AclRecord] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ActivityLog]    Script Date: 11/14/2018 10:13:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActivityLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ActivityLogTypeId] [int] NOT NULL,
	[EntityId] [int] NULL,
	[EntityName] [nvarchar](400) NULL,
	[CustomerId] [int] NOT NULL,
	[Comment] [nvarchar](max) NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
	[IpAddress] [nvarchar](200) NULL,
 CONSTRAINT [PK_ActivityLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ActivityLogType]    Script Date: 11/14/2018 10:13:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActivityLogType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SystemKeyword] [nvarchar](100) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Enabled] [bit] NOT NULL,
 CONSTRAINT [PK_ActivityLogType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Address]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Address](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](max) NULL,
	[LastName] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[Company] [nvarchar](max) NULL,
	[CountryId] [int] NULL,
	[StateProvinceId] [int] NULL,
	[County] [nvarchar](max) NULL,
	[City] [nvarchar](max) NULL,
	[Address1] [nvarchar](max) NULL,
	[Address2] [nvarchar](max) NULL,
	[ZipPostalCode] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[FaxNumber] [nvarchar](max) NULL,
	[CustomAttributes] [nvarchar](max) NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AddressAttribute]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AddressAttribute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[IsRequired] [bit] NOT NULL,
	[AttributeControlTypeId] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_AddressAttribute] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AddressAttributeValue]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AddressAttributeValue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AddressAttributeId] [int] NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[IsPreSelected] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_AddressAttributeValue] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Affiliate]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Affiliate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[AddressId] [int] NOT NULL,
	[AdminComment] [nvarchar](max) NULL,
	[FriendlyUrlName] [nvarchar](max) NULL,
	[Deleted] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_Affiliate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BackInStockSubscription]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BackInStockSubscription](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StoreId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_BackInStockSubscription] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BlogComment]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BlogComment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[CommentText] [nvarchar](max) NULL,
	[IsApproved] [bit] NOT NULL,
	[StoreId] [int] NOT NULL,
	[BlogPostId] [int] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_BlogComment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BlogPost]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BlogPost](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LanguageId] [int] NOT NULL,
	[Title] [nvarchar](max) NOT NULL,
	[Body] [nvarchar](max) NOT NULL,
	[BodyOverview] [nvarchar](max) NULL,
	[AllowComments] [bit] NOT NULL,
	[Tags] [nvarchar](max) NULL,
	[StartDateUtc] [datetime2](7) NULL,
	[EndDateUtc] [datetime2](7) NULL,
	[MetaKeywords] [nvarchar](400) NULL,
	[MetaDescription] [nvarchar](max) NULL,
	[MetaTitle] [nvarchar](400) NULL,
	[LimitedToStores] [bit] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_BlogPost] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Campaign]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Campaign](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Subject] [nvarchar](max) NOT NULL,
	[Body] [nvarchar](max) NOT NULL,
	[StoreId] [int] NOT NULL,
	[CustomerRoleId] [int] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
	[DontSendBeforeDateUtc] [datetime2](7) NULL,
 CONSTRAINT [PK_Campaign] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[CategoryTemplateId] [int] NOT NULL,
	[MetaKeywords] [nvarchar](400) NULL,
	[MetaDescription] [nvarchar](max) NULL,
	[MetaTitle] [nvarchar](400) NULL,
	[ParentCategoryId] [int] NOT NULL,
	[PictureId] [int] NOT NULL,
	[PageSize] [int] NOT NULL,
	[AllowCustomersToSelectPageSize] [bit] NOT NULL,
	[PageSizeOptions] [nvarchar](200) NULL,
	[PriceRanges] [nvarchar](400) NULL,
	[ShowOnHomePage] [bit] NOT NULL,
	[IncludeInTopMenu] [bit] NOT NULL,
	[SubjectToAcl] [bit] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
	[Published] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
	[UpdatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CategoryTemplate]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CategoryTemplate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[ViewPath] [nvarchar](400) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_CategoryTemplate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CheckoutAttribute]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CheckoutAttribute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[TextPrompt] [nvarchar](max) NULL,
	[IsRequired] [bit] NOT NULL,
	[ShippableProductRequired] [bit] NOT NULL,
	[IsTaxExempt] [bit] NOT NULL,
	[TaxCategoryId] [int] NOT NULL,
	[AttributeControlTypeId] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
	[ValidationMinLength] [int] NULL,
	[ValidationMaxLength] [int] NULL,
	[ValidationFileAllowedExtensions] [nvarchar](max) NULL,
	[ValidationFileMaximumSize] [int] NULL,
	[DefaultValue] [nvarchar](max) NULL,
	[ConditionAttributeXml] [nvarchar](max) NULL,
 CONSTRAINT [PK_CheckoutAttribute] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CheckoutAttributeValue]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CheckoutAttributeValue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CheckoutAttributeId] [int] NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[ColorSquaresRgb] [nvarchar](100) NULL,
	[PriceAdjustment] [decimal](18, 4) NOT NULL,
	[WeightAdjustment] [decimal](18, 4) NOT NULL,
	[IsPreSelected] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_CheckoutAttributeValue] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Country]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[AllowsBilling] [bit] NOT NULL,
	[AllowsShipping] [bit] NOT NULL,
	[TwoLetterIsoCode] [nvarchar](2) NULL,
	[ThreeLetterIsoCode] [nvarchar](3) NULL,
	[NumericIsoCode] [int] NOT NULL,
	[SubjectToVat] [bit] NOT NULL,
	[Published] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CrossSellProduct]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CrossSellProduct](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId1] [int] NOT NULL,
	[ProductId2] [int] NOT NULL,
 CONSTRAINT [PK_CrossSellProduct] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Currency]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Currency](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[CurrencyCode] [nvarchar](5) NOT NULL,
	[Rate] [decimal](18, 4) NOT NULL,
	[DisplayLocale] [nvarchar](50) NULL,
	[CustomFormatting] [nvarchar](50) NULL,
	[LimitedToStores] [bit] NOT NULL,
	[Published] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
	[UpdatedOnUtc] [datetime2](7) NOT NULL,
	[RoundingTypeId] [int] NOT NULL,
 CONSTRAINT [PK_Currency] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerGuid] [uniqueidentifier] NOT NULL,
	[Username] [nvarchar](1000) NULL,
	[Email] [nvarchar](1000) NULL,
	[EmailToRevalidate] [nvarchar](1000) NULL,
	[AdminComment] [nvarchar](max) NULL,
	[IsTaxExempt] [bit] NOT NULL,
	[AffiliateId] [int] NOT NULL,
	[VendorId] [int] NOT NULL,
	[HasShoppingCartItems] [bit] NOT NULL,
	[RequireReLogin] [bit] NOT NULL,
	[FailedLoginAttempts] [int] NOT NULL,
	[CannotLoginUntilDateUtc] [datetime2](7) NULL,
	[Active] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[IsSystemAccount] [bit] NOT NULL,
	[SystemName] [nvarchar](400) NULL,
	[LastIpAddress] [nvarchar](max) NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
	[LastLoginDateUtc] [datetime2](7) NULL,
	[LastActivityDateUtc] [datetime2](7) NOT NULL,
	[RegisteredInStoreId] [int] NOT NULL,
	[BillingAddress_Id] [int] NULL,
	[ShippingAddress_Id] [int] NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer_CustomerRole_Mapping]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer_CustomerRole_Mapping](
	[Customer_Id] [int] NOT NULL,
	[CustomerRole_Id] [int] NOT NULL,
 CONSTRAINT [PK_Customer_CustomerRole_Mapping] PRIMARY KEY CLUSTERED 
(
	[Customer_Id] ASC,
	[CustomerRole_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomerAddresses]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerAddresses](
	[Customer_Id] [int] NOT NULL,
	[Address_Id] [int] NOT NULL,
 CONSTRAINT [PK_CustomerAddresses] PRIMARY KEY CLUSTERED 
(
	[Customer_Id] ASC,
	[Address_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomerAttribute]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerAttribute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[IsRequired] [bit] NOT NULL,
	[AttributeControlTypeId] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_CustomerAttribute] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomerAttributeValue]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerAttributeValue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerAttributeId] [int] NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[IsPreSelected] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_CustomerAttributeValue] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomerPassword]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerPassword](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[Password] [nvarchar](max) NULL,
	[PasswordFormatId] [int] NOT NULL,
	[PasswordSalt] [nvarchar](max) NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_CustomerPassword] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomerRole]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerRole](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[FreeShipping] [bit] NOT NULL,
	[TaxExempt] [bit] NOT NULL,
	[Active] [bit] NOT NULL,
	[IsSystemRole] [bit] NOT NULL,
	[SystemName] [nvarchar](255) NULL,
	[EnablePasswordLifetime] [bit] NOT NULL,
	[OverrideTaxDisplayType] [bit] NOT NULL,
	[DefaultTaxDisplayTypeId] [int] NOT NULL,
	[PurchasedWithProductId] [int] NOT NULL,
 CONSTRAINT [PK_CustomerRole] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeliveryDate]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeliveryDate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_DeliveryDate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Discount]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Discount](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[DiscountTypeId] [int] NOT NULL,
	[UsePercentage] [bit] NOT NULL,
	[DiscountPercentage] [decimal](18, 4) NOT NULL,
	[DiscountAmount] [decimal](18, 4) NOT NULL,
	[MaximumDiscountAmount] [decimal](18, 4) NULL,
	[StartDateUtc] [datetime2](7) NULL,
	[EndDateUtc] [datetime2](7) NULL,
	[RequiresCouponCode] [bit] NOT NULL,
	[CouponCode] [nvarchar](100) NULL,
	[IsCumulative] [bit] NOT NULL,
	[DiscountLimitationId] [int] NOT NULL,
	[LimitationTimes] [int] NOT NULL,
	[MaximumDiscountedQuantity] [int] NULL,
	[AppliedToSubCategories] [bit] NOT NULL,
 CONSTRAINT [PK_Discount] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Discount_AppliedToCategories]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Discount_AppliedToCategories](
	[Discount_Id] [int] NOT NULL,
	[Category_Id] [int] NOT NULL,
 CONSTRAINT [PK_Discount_AppliedToCategories] PRIMARY KEY CLUSTERED 
(
	[Discount_Id] ASC,
	[Category_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Discount_AppliedToManufacturers]    Script Date: 11/14/2018 10:13:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Discount_AppliedToManufacturers](
	[Discount_Id] [int] NOT NULL,
	[Manufacturer_Id] [int] NOT NULL,
 CONSTRAINT [PK_Discount_AppliedToManufacturers] PRIMARY KEY CLUSTERED 
(
	[Discount_Id] ASC,
	[Manufacturer_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Discount_AppliedToProducts]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Discount_AppliedToProducts](
	[Discount_Id] [int] NOT NULL,
	[Product_Id] [int] NOT NULL,
 CONSTRAINT [PK_Discount_AppliedToProducts] PRIMARY KEY CLUSTERED 
(
	[Discount_Id] ASC,
	[Product_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DiscountRequirement]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DiscountRequirement](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DiscountId] [int] NOT NULL,
	[DiscountRequirementRuleSystemName] [nvarchar](max) NULL,
	[ParentId] [int] NULL,
	[InteractionTypeId] [int] NULL,
	[IsGroup] [bit] NOT NULL,
 CONSTRAINT [PK_DiscountRequirement] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DiscountUsageHistory]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DiscountUsageHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DiscountId] [int] NOT NULL,
	[OrderId] [int] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_DiscountUsageHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Download]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Download](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DownloadGuid] [uniqueidentifier] NOT NULL,
	[UseDownloadUrl] [bit] NOT NULL,
	[DownloadUrl] [nvarchar](max) NULL,
	[DownloadBinary] [varbinary](max) NULL,
	[ContentType] [nvarchar](max) NULL,
	[Filename] [nvarchar](max) NULL,
	[Extension] [nvarchar](max) NULL,
	[IsNew] [bit] NOT NULL,
 CONSTRAINT [PK_Download] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmailAccount]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailAccount](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Email] [nvarchar](255) NOT NULL,
	[DisplayName] [nvarchar](255) NULL,
	[Host] [nvarchar](255) NOT NULL,
	[Port] [int] NOT NULL,
	[Username] [nvarchar](255) NOT NULL,
	[Password] [nvarchar](255) NOT NULL,
	[EnableSsl] [bit] NOT NULL,
	[UseDefaultCredentials] [bit] NOT NULL,
 CONSTRAINT [PK_EmailAccount] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExternalAuthenticationRecord]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExternalAuthenticationRecord](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[Email] [nvarchar](max) NULL,
	[ExternalIdentifier] [nvarchar](max) NULL,
	[ExternalDisplayIdentifier] [nvarchar](max) NULL,
	[OAuthToken] [nvarchar](max) NULL,
	[OAuthAccessToken] [nvarchar](max) NULL,
	[ProviderSystemName] [nvarchar](max) NULL,
 CONSTRAINT [PK_ExternalAuthenticationRecord] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Forums_Forum]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Forums_Forum](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ForumGroupId] [int] NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[NumTopics] [int] NOT NULL,
	[NumPosts] [int] NOT NULL,
	[LastTopicId] [int] NOT NULL,
	[LastPostId] [int] NOT NULL,
	[LastPostCustomerId] [int] NOT NULL,
	[LastPostTime] [datetime2](7) NULL,
	[DisplayOrder] [int] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
	[UpdatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Forums_Forum] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Forums_Group]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Forums_Group](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
	[UpdatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Forums_Group] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Forums_Post]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Forums_Post](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TopicId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[IPAddress] [nvarchar](100) NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
	[UpdatedOnUtc] [datetime2](7) NOT NULL,
	[VoteCount] [int] NOT NULL,
 CONSTRAINT [PK_Forums_Post] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Forums_PostVote]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Forums_PostVote](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ForumPostId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[IsUp] [bit] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Forums_PostVote] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Forums_PrivateMessage]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Forums_PrivateMessage](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StoreId] [int] NOT NULL,
	[FromCustomerId] [int] NOT NULL,
	[ToCustomerId] [int] NOT NULL,
	[Subject] [nvarchar](450) NOT NULL,
	[Text] [nvarchar](max) NOT NULL,
	[IsRead] [bit] NOT NULL,
	[IsDeletedByAuthor] [bit] NOT NULL,
	[IsDeletedByRecipient] [bit] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Forums_PrivateMessage] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Forums_Subscription]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Forums_Subscription](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SubscriptionGuid] [uniqueidentifier] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[ForumId] [int] NOT NULL,
	[TopicId] [int] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Forums_Subscription] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Forums_Topic]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Forums_Topic](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ForumId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[TopicTypeId] [int] NOT NULL,
	[Subject] [nvarchar](450) NOT NULL,
	[NumPosts] [int] NOT NULL,
	[Views] [int] NOT NULL,
	[LastPostId] [int] NOT NULL,
	[LastPostCustomerId] [int] NOT NULL,
	[LastPostTime] [datetime2](7) NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
	[UpdatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Forums_Topic] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GdprConsent]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GdprConsent](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[IsRequired] [bit] NOT NULL,
	[RequiredMessage] [nvarchar](max) NULL,
	[DisplayDuringRegistration] [bit] NOT NULL,
	[DisplayOnCustomerInfoPage] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_GdprConsent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GdprLog]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GdprLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[ConsentId] [int] NOT NULL,
	[CustomerInfo] [nvarchar](max) NULL,
	[RequestTypeId] [int] NOT NULL,
	[RequestDetails] [nvarchar](max) NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_GdprLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GenericAttribute]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GenericAttribute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EntityId] [int] NOT NULL,
	[KeyGroup] [nvarchar](400) NOT NULL,
	[Key] [nvarchar](400) NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
	[StoreId] [int] NOT NULL,
 CONSTRAINT [PK_GenericAttribute] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GiftCard]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GiftCard](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PurchasedWithOrderItemId] [int] NULL,
	[GiftCardTypeId] [int] NOT NULL,
	[Amount] [decimal](18, 4) NOT NULL,
	[IsGiftCardActivated] [bit] NOT NULL,
	[GiftCardCouponCode] [nvarchar](max) NULL,
	[RecipientName] [nvarchar](max) NULL,
	[RecipientEmail] [nvarchar](max) NULL,
	[SenderName] [nvarchar](max) NULL,
	[SenderEmail] [nvarchar](max) NULL,
	[Message] [nvarchar](max) NULL,
	[IsRecipientNotified] [bit] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_GiftCard] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GiftCardUsageHistory]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GiftCardUsageHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GiftCardId] [int] NOT NULL,
	[UsedWithOrderId] [int] NOT NULL,
	[UsedValue] [decimal](18, 4) NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_GiftCardUsageHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Language]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Language](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[LanguageCulture] [nvarchar](20) NOT NULL,
	[UniqueSeoCode] [nvarchar](2) NULL,
	[FlagImageFileName] [nvarchar](50) NULL,
	[Rtl] [bit] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
	[DefaultCurrencyId] [int] NOT NULL,
	[Published] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_Language] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LocaleStringResource]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LocaleStringResource](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LanguageId] [int] NOT NULL,
	[ResourceName] [nvarchar](200) NOT NULL,
	[ResourceValue] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_LocaleStringResource] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LocalizedProperty]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LocalizedProperty](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EntityId] [int] NOT NULL,
	[LanguageId] [int] NOT NULL,
	[LocaleKeyGroup] [nvarchar](400) NOT NULL,
	[LocaleKey] [nvarchar](400) NOT NULL,
	[LocaleValue] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_LocalizedProperty] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Log]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Log](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LogLevelId] [int] NOT NULL,
	[ShortMessage] [nvarchar](max) NOT NULL,
	[FullMessage] [nvarchar](max) NULL,
	[IpAddress] [nvarchar](200) NULL,
	[CustomerId] [int] NULL,
	[PageUrl] [nvarchar](max) NULL,
	[ReferrerUrl] [nvarchar](max) NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Log] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Manufacturer]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Manufacturer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ManufacturerTemplateId] [int] NOT NULL,
	[MetaKeywords] [nvarchar](400) NULL,
	[MetaDescription] [nvarchar](max) NULL,
	[MetaTitle] [nvarchar](400) NULL,
	[PictureId] [int] NOT NULL,
	[PageSize] [int] NOT NULL,
	[AllowCustomersToSelectPageSize] [bit] NOT NULL,
	[PageSizeOptions] [nvarchar](200) NULL,
	[PriceRanges] [nvarchar](400) NULL,
	[SubjectToAcl] [bit] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
	[Published] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
	[UpdatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Manufacturer] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ManufacturerTemplate]    Script Date: 11/14/2018 10:13:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ManufacturerTemplate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[ViewPath] [nvarchar](400) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_ManufacturerTemplate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MeasureDimension]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MeasureDimension](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[SystemKeyword] [nvarchar](100) NOT NULL,
	[Ratio] [decimal](18, 8) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_MeasureDimension] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MeasureWeight]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MeasureWeight](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[SystemKeyword] [nvarchar](100) NOT NULL,
	[Ratio] [decimal](18, 8) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_MeasureWeight] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MessageTemplate]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MessageTemplate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[BccEmailAddresses] [nvarchar](200) NULL,
	[Subject] [nvarchar](1000) NULL,
	[Body] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[DelayBeforeSend] [int] NULL,
	[DelayPeriodId] [int] NOT NULL,
	[AttachedDownloadId] [int] NOT NULL,
	[EmailAccountId] [int] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
 CONSTRAINT [PK_MessageTemplate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[News]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[News](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LanguageId] [int] NOT NULL,
	[Title] [nvarchar](max) NOT NULL,
	[Short] [nvarchar](max) NOT NULL,
	[Full] [nvarchar](max) NOT NULL,
	[Published] [bit] NOT NULL,
	[StartDateUtc] [datetime2](7) NULL,
	[EndDateUtc] [datetime2](7) NULL,
	[AllowComments] [bit] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
	[MetaKeywords] [nvarchar](400) NULL,
	[MetaDescription] [nvarchar](max) NULL,
	[MetaTitle] [nvarchar](400) NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_News] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewsComment]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsComment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CommentTitle] [nvarchar](max) NULL,
	[CommentText] [nvarchar](max) NULL,
	[NewsItemId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[IsApproved] [bit] NOT NULL,
	[StoreId] [int] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_NewsComment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NewsLetterSubscription]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NewsLetterSubscription](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NewsLetterSubscriptionGuid] [uniqueidentifier] NOT NULL,
	[Email] [nvarchar](255) NOT NULL,
	[Active] [bit] NOT NULL,
	[StoreId] [int] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_NewsLetterSubscription] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderGuid] [uniqueidentifier] NOT NULL,
	[StoreId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[BillingAddressId] [int] NOT NULL,
	[ShippingAddressId] [int] NULL,
	[PickupAddressId] [int] NULL,
	[PickUpInStore] [bit] NOT NULL,
	[OrderStatusId] [int] NOT NULL,
	[ShippingStatusId] [int] NOT NULL,
	[PaymentStatusId] [int] NOT NULL,
	[PaymentMethodSystemName] [nvarchar](max) NULL,
	[CustomerCurrencyCode] [nvarchar](max) NULL,
	[CurrencyRate] [decimal](18, 8) NOT NULL,
	[CustomerTaxDisplayTypeId] [int] NOT NULL,
	[VatNumber] [nvarchar](max) NULL,
	[OrderSubtotalInclTax] [decimal](18, 4) NOT NULL,
	[OrderSubtotalExclTax] [decimal](18, 4) NOT NULL,
	[OrderSubTotalDiscountInclTax] [decimal](18, 4) NOT NULL,
	[OrderSubTotalDiscountExclTax] [decimal](18, 4) NOT NULL,
	[OrderShippingInclTax] [decimal](18, 4) NOT NULL,
	[OrderShippingExclTax] [decimal](18, 4) NOT NULL,
	[PaymentMethodAdditionalFeeInclTax] [decimal](18, 4) NOT NULL,
	[PaymentMethodAdditionalFeeExclTax] [decimal](18, 4) NOT NULL,
	[TaxRates] [nvarchar](max) NULL,
	[OrderTax] [decimal](18, 4) NOT NULL,
	[OrderDiscount] [decimal](18, 4) NOT NULL,
	[OrderTotal] [decimal](18, 4) NOT NULL,
	[RefundedAmount] [decimal](18, 4) NOT NULL,
	[RewardPointsHistoryEntryId] [int] NULL,
	[CheckoutAttributeDescription] [nvarchar](max) NULL,
	[CheckoutAttributesXml] [nvarchar](max) NULL,
	[CustomerLanguageId] [int] NOT NULL,
	[AffiliateId] [int] NOT NULL,
	[CustomerIp] [nvarchar](max) NULL,
	[AllowStoringCreditCardNumber] [bit] NOT NULL,
	[CardType] [nvarchar](max) NULL,
	[CardName] [nvarchar](max) NULL,
	[CardNumber] [nvarchar](max) NULL,
	[MaskedCreditCardNumber] [nvarchar](max) NULL,
	[CardCvv2] [nvarchar](max) NULL,
	[CardExpirationMonth] [nvarchar](max) NULL,
	[CardExpirationYear] [nvarchar](max) NULL,
	[AuthorizationTransactionId] [nvarchar](max) NULL,
	[AuthorizationTransactionCode] [nvarchar](max) NULL,
	[AuthorizationTransactionResult] [nvarchar](max) NULL,
	[CaptureTransactionId] [nvarchar](max) NULL,
	[CaptureTransactionResult] [nvarchar](max) NULL,
	[SubscriptionTransactionId] [nvarchar](max) NULL,
	[PaidDateUtc] [datetime2](7) NULL,
	[ShippingMethod] [nvarchar](max) NULL,
	[ShippingRateComputationMethodSystemName] [nvarchar](max) NULL,
	[CustomValuesXml] [nvarchar](max) NULL,
	[Deleted] [bit] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
	[CustomOrderNumber] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderItem]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderItem](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderItemGuid] [uniqueidentifier] NOT NULL,
	[OrderId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPriceInclTax] [decimal](18, 4) NOT NULL,
	[UnitPriceExclTax] [decimal](18, 4) NOT NULL,
	[PriceInclTax] [decimal](18, 4) NOT NULL,
	[PriceExclTax] [decimal](18, 4) NOT NULL,
	[DiscountAmountInclTax] [decimal](18, 4) NOT NULL,
	[DiscountAmountExclTax] [decimal](18, 4) NOT NULL,
	[OriginalProductCost] [decimal](18, 4) NOT NULL,
	[AttributeDescription] [nvarchar](max) NULL,
	[AttributesXml] [nvarchar](max) NULL,
	[DownloadCount] [int] NOT NULL,
	[IsDownloadActivated] [bit] NOT NULL,
	[LicenseDownloadId] [int] NULL,
	[ItemWeight] [decimal](18, 4) NULL,
	[RentalStartDateUtc] [datetime2](7) NULL,
	[RentalEndDateUtc] [datetime2](7) NULL,
 CONSTRAINT [PK_OrderItem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderNote]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderNote](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[Note] [nvarchar](max) NOT NULL,
	[DownloadId] [int] NOT NULL,
	[DisplayToCustomer] [bit] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_OrderNote] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PermissionRecord]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermissionRecord](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[SystemName] [nvarchar](255) NOT NULL,
	[Category] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_PermissionRecord] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PermissionRecord_Role_Mapping]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermissionRecord_Role_Mapping](
	[PermissionRecord_Id] [int] NOT NULL,
	[CustomerRole_Id] [int] NOT NULL,
 CONSTRAINT [PK_PermissionRecord_Role_Mapping] PRIMARY KEY CLUSTERED 
(
	[PermissionRecord_Id] ASC,
	[CustomerRole_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Picture]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Picture](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MimeType] [nvarchar](40) NOT NULL,
	[SeoFilename] [nvarchar](300) NULL,
	[AltAttribute] [nvarchar](max) NULL,
	[TitleAttribute] [nvarchar](max) NULL,
	[IsNew] [bit] NOT NULL,
 CONSTRAINT [PK_Picture] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PictureBinary]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PictureBinary](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BinaryData] [varbinary](max) NULL,
	[PictureId] [int] NOT NULL,
 CONSTRAINT [PK_PictureBinary] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Poll]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Poll](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LanguageId] [int] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[SystemKeyword] [nvarchar](max) NULL,
	[Published] [bit] NOT NULL,
	[ShowOnHomePage] [bit] NOT NULL,
	[AllowGuestsToVote] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
	[StartDateUtc] [datetime2](7) NULL,
	[EndDateUtc] [datetime2](7) NULL,
 CONSTRAINT [PK_Poll] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PollAnswer]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PollAnswer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PollId] [int] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[NumberOfVotes] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_PollAnswer] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PollVotingRecord]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PollVotingRecord](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PollAnswerId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_PollVotingRecord] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PredefinedProductAttributeValue]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PredefinedProductAttributeValue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductAttributeId] [int] NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[PriceAdjustment] [decimal](18, 4) NOT NULL,
	[PriceAdjustmentUsePercentage] [bit] NOT NULL,
	[WeightAdjustment] [decimal](18, 4) NOT NULL,
	[Cost] [decimal](18, 4) NOT NULL,
	[IsPreSelected] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_PredefinedProductAttributeValue] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductTypeId] [int] NOT NULL,
	[ParentGroupedProductId] [int] NOT NULL,
	[VisibleIndividually] [bit] NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[ShortDescription] [nvarchar](max) NULL,
	[FullDescription] [nvarchar](max) NULL,
	[AdminComment] [nvarchar](max) NULL,
	[ProductTemplateId] [int] NOT NULL,
	[VendorId] [int] NOT NULL,
	[ShowOnHomePage] [bit] NOT NULL,
	[MetaKeywords] [nvarchar](400) NULL,
	[MetaDescription] [nvarchar](max) NULL,
	[MetaTitle] [nvarchar](400) NULL,
	[AllowCustomerReviews] [bit] NOT NULL,
	[ApprovedRatingSum] [int] NOT NULL,
	[NotApprovedRatingSum] [int] NOT NULL,
	[ApprovedTotalReviews] [int] NOT NULL,
	[NotApprovedTotalReviews] [int] NOT NULL,
	[SubjectToAcl] [bit] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
	[Sku] [nvarchar](400) NULL,
	[ManufacturerPartNumber] [nvarchar](400) NULL,
	[Gtin] [nvarchar](400) NULL,
	[IsGiftCard] [bit] NOT NULL,
	[GiftCardTypeId] [int] NOT NULL,
	[OverriddenGiftCardAmount] [decimal](18, 4) NULL,
	[RequireOtherProducts] [bit] NOT NULL,
	[RequiredProductIds] [nvarchar](1000) NULL,
	[AutomaticallyAddRequiredProducts] [bit] NOT NULL,
	[IsDownload] [bit] NOT NULL,
	[DownloadId] [int] NOT NULL,
	[UnlimitedDownloads] [bit] NOT NULL,
	[MaxNumberOfDownloads] [int] NOT NULL,
	[DownloadExpirationDays] [int] NULL,
	[DownloadActivationTypeId] [int] NOT NULL,
	[HasSampleDownload] [bit] NOT NULL,
	[SampleDownloadId] [int] NOT NULL,
	[HasUserAgreement] [bit] NOT NULL,
	[UserAgreementText] [nvarchar](max) NULL,
	[IsRecurring] [bit] NOT NULL,
	[RecurringCycleLength] [int] NOT NULL,
	[RecurringCyclePeriodId] [int] NOT NULL,
	[RecurringTotalCycles] [int] NOT NULL,
	[IsRental] [bit] NOT NULL,
	[RentalPriceLength] [int] NOT NULL,
	[RentalPricePeriodId] [int] NOT NULL,
	[IsShipEnabled] [bit] NOT NULL,
	[IsFreeShipping] [bit] NOT NULL,
	[ShipSeparately] [bit] NOT NULL,
	[AdditionalShippingCharge] [decimal](18, 4) NOT NULL,
	[DeliveryDateId] [int] NOT NULL,
	[IsTaxExempt] [bit] NOT NULL,
	[TaxCategoryId] [int] NOT NULL,
	[IsTelecommunicationsOrBroadcastingOrElectronicServices] [bit] NOT NULL,
	[ManageInventoryMethodId] [int] NOT NULL,
	[ProductAvailabilityRangeId] [int] NOT NULL,
	[UseMultipleWarehouses] [bit] NOT NULL,
	[WarehouseId] [int] NOT NULL,
	[StockQuantity] [int] NOT NULL,
	[DisplayStockAvailability] [bit] NOT NULL,
	[DisplayStockQuantity] [bit] NOT NULL,
	[MinStockQuantity] [int] NOT NULL,
	[LowStockActivityId] [int] NOT NULL,
	[NotifyAdminForQuantityBelow] [int] NOT NULL,
	[BackorderModeId] [int] NOT NULL,
	[AllowBackInStockSubscriptions] [bit] NOT NULL,
	[OrderMinimumQuantity] [int] NOT NULL,
	[OrderMaximumQuantity] [int] NOT NULL,
	[AllowedQuantities] [nvarchar](1000) NULL,
	[AllowAddingOnlyExistingAttributeCombinations] [bit] NOT NULL,
	[NotReturnable] [bit] NOT NULL,
	[DisableBuyButton] [bit] NOT NULL,
	[DisableWishlistButton] [bit] NOT NULL,
	[AvailableForPreOrder] [bit] NOT NULL,
	[PreOrderAvailabilityStartDateTimeUtc] [datetime2](7) NULL,
	[CallForPrice] [bit] NOT NULL,
	[Price] [decimal](18, 4) NOT NULL,
	[OldPrice] [decimal](18, 4) NOT NULL,
	[ProductCost] [decimal](18, 4) NOT NULL,
	[CustomerEntersPrice] [bit] NOT NULL,
	[MinimumCustomerEnteredPrice] [decimal](18, 4) NOT NULL,
	[MaximumCustomerEnteredPrice] [decimal](18, 4) NOT NULL,
	[BasepriceEnabled] [bit] NOT NULL,
	[BasepriceAmount] [decimal](18, 4) NOT NULL,
	[BasepriceUnitId] [int] NOT NULL,
	[BasepriceBaseAmount] [decimal](18, 4) NOT NULL,
	[BasepriceBaseUnitId] [int] NOT NULL,
	[MarkAsNew] [bit] NOT NULL,
	[MarkAsNewStartDateTimeUtc] [datetime2](7) NULL,
	[MarkAsNewEndDateTimeUtc] [datetime2](7) NULL,
	[HasTierPrices] [bit] NOT NULL,
	[HasDiscountsApplied] [bit] NOT NULL,
	[Weight] [decimal](18, 4) NOT NULL,
	[Length] [decimal](18, 4) NOT NULL,
	[Width] [decimal](18, 4) NOT NULL,
	[Height] [decimal](18, 4) NOT NULL,
	[AvailableStartDateTimeUtc] [datetime2](7) NULL,
	[AvailableEndDateTimeUtc] [datetime2](7) NULL,
	[DisplayOrder] [int] NOT NULL,
	[Published] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
	[UpdatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product_Category_Mapping]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product_Category_Mapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[IsFeaturedProduct] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_Product_Category_Mapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product_Manufacturer_Mapping]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product_Manufacturer_Mapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[ManufacturerId] [int] NOT NULL,
	[IsFeaturedProduct] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_Product_Manufacturer_Mapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product_Picture_Mapping]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product_Picture_Mapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[PictureId] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_Product_Picture_Mapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product_ProductAttribute_Mapping]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product_ProductAttribute_Mapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[ProductAttributeId] [int] NOT NULL,
	[TextPrompt] [nvarchar](max) NULL,
	[IsRequired] [bit] NOT NULL,
	[AttributeControlTypeId] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[ValidationMinLength] [int] NULL,
	[ValidationMaxLength] [int] NULL,
	[ValidationFileAllowedExtensions] [nvarchar](max) NULL,
	[ValidationFileMaximumSize] [int] NULL,
	[DefaultValue] [nvarchar](max) NULL,
	[ConditionAttributeXml] [nvarchar](max) NULL,
 CONSTRAINT [PK_Product_ProductAttribute_Mapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product_ProductTag_Mapping]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product_ProductTag_Mapping](
	[Product_Id] [int] NOT NULL,
	[ProductTag_Id] [int] NOT NULL,
 CONSTRAINT [PK_Product_ProductTag_Mapping] PRIMARY KEY CLUSTERED 
(
	[Product_Id] ASC,
	[ProductTag_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product_SpecificationAttribute_Mapping]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product_SpecificationAttribute_Mapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[AttributeTypeId] [int] NOT NULL,
	[SpecificationAttributeOptionId] [int] NOT NULL,
	[CustomValue] [nvarchar](4000) NULL,
	[AllowFiltering] [bit] NOT NULL,
	[ShowOnProductPage] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_Product_SpecificationAttribute_Mapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductAttribute]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductAttribute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_ProductAttribute] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductAttributeCombination]    Script Date: 11/14/2018 10:13:44 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductAttributeCombination](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[AttributesXml] [nvarchar](max) NULL,
	[StockQuantity] [int] NOT NULL,
	[AllowOutOfStockOrders] [bit] NOT NULL,
	[Sku] [nvarchar](400) NULL,
	[ManufacturerPartNumber] [nvarchar](400) NULL,
	[Gtin] [nvarchar](400) NULL,
	[OverriddenPrice] [decimal](18, 4) NULL,
	[NotifyAdminForQuantityBelow] [int] NOT NULL,
	[PictureId] [int] NOT NULL,
 CONSTRAINT [PK_ProductAttributeCombination] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductAttributeValue]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductAttributeValue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductAttributeMappingId] [int] NOT NULL,
	[AttributeValueTypeId] [int] NOT NULL,
	[AssociatedProductId] [int] NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[ColorSquaresRgb] [nvarchar](100) NULL,
	[ImageSquaresPictureId] [int] NOT NULL,
	[PriceAdjustment] [decimal](18, 4) NOT NULL,
	[PriceAdjustmentUsePercentage] [bit] NOT NULL,
	[WeightAdjustment] [decimal](18, 4) NOT NULL,
	[Cost] [decimal](18, 4) NOT NULL,
	[CustomerEntersQty] [bit] NOT NULL,
	[Quantity] [int] NOT NULL,
	[IsPreSelected] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[PictureId] [int] NOT NULL,
 CONSTRAINT [PK_ProductAttributeValue] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductAvailabilityRange]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductAvailabilityRange](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_ProductAvailabilityRange] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductReview]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductReview](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[StoreId] [int] NOT NULL,
	[IsApproved] [bit] NOT NULL,
	[Title] [nvarchar](max) NULL,
	[ReviewText] [nvarchar](max) NULL,
	[ReplyText] [nvarchar](max) NULL,
	[CustomerNotifiedOfReply] [bit] NOT NULL,
	[Rating] [int] NOT NULL,
	[HelpfulYesTotal] [int] NOT NULL,
	[HelpfulNoTotal] [int] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_ProductReview] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductReview_ReviewType_Mapping]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductReview_ReviewType_Mapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductReviewId] [int] NOT NULL,
	[ReviewTypeId] [int] NOT NULL,
	[Rating] [int] NOT NULL,
 CONSTRAINT [PK_ProductReview_ReviewType_Mapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductReviewHelpfulness]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductReviewHelpfulness](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductReviewId] [int] NOT NULL,
	[WasHelpful] [bit] NOT NULL,
	[CustomerId] [int] NOT NULL,
 CONSTRAINT [PK_ProductReviewHelpfulness] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductTag]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductTag](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
 CONSTRAINT [PK_ProductTag] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductTemplate]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductTemplate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[ViewPath] [nvarchar](400) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[IgnoredProductTypes] [nvarchar](max) NULL,
 CONSTRAINT [PK_ProductTemplate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductWarehouseInventory]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductWarehouseInventory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[WarehouseId] [int] NOT NULL,
	[StockQuantity] [int] NOT NULL,
	[ReservedQuantity] [int] NOT NULL,
 CONSTRAINT [PK_ProductWarehouseInventory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QueuedEmail]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QueuedEmail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PriorityId] [int] NOT NULL,
	[From] [nvarchar](500) NOT NULL,
	[FromName] [nvarchar](500) NULL,
	[To] [nvarchar](500) NOT NULL,
	[ToName] [nvarchar](500) NULL,
	[ReplyTo] [nvarchar](500) NULL,
	[ReplyToName] [nvarchar](500) NULL,
	[CC] [nvarchar](500) NULL,
	[Bcc] [nvarchar](500) NULL,
	[Subject] [nvarchar](1000) NULL,
	[Body] [nvarchar](max) NULL,
	[AttachmentFilePath] [nvarchar](max) NULL,
	[AttachmentFileName] [nvarchar](max) NULL,
	[AttachedDownloadId] [int] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
	[DontSendBeforeDateUtc] [datetime2](7) NULL,
	[SentTries] [int] NOT NULL,
	[SentOnUtc] [datetime2](7) NULL,
	[EmailAccountId] [int] NOT NULL,
 CONSTRAINT [PK_QueuedEmail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RecurringPayment]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RecurringPayment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CycleLength] [int] NOT NULL,
	[CyclePeriodId] [int] NOT NULL,
	[TotalCycles] [int] NOT NULL,
	[StartDateUtc] [datetime2](7) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[LastPaymentFailed] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[InitialOrderId] [int] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_RecurringPayment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RecurringPaymentHistory]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RecurringPaymentHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RecurringPaymentId] [int] NOT NULL,
	[OrderId] [int] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_RecurringPaymentHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RelatedProduct]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RelatedProduct](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId1] [int] NOT NULL,
	[ProductId2] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_RelatedProduct] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReturnRequest]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReturnRequest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomNumber] [nvarchar](max) NULL,
	[StoreId] [int] NOT NULL,
	[OrderItemId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[ReasonForReturn] [nvarchar](max) NOT NULL,
	[RequestedAction] [nvarchar](max) NOT NULL,
	[CustomerComments] [nvarchar](max) NULL,
	[UploadedFileId] [int] NOT NULL,
	[StaffNotes] [nvarchar](max) NULL,
	[ReturnRequestStatusId] [int] NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
	[UpdatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_ReturnRequest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReturnRequestAction]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReturnRequestAction](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_ReturnRequestAction] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReturnRequestReason]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReturnRequestReason](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_ReturnRequestReason] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReviewType]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReviewType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[Description] [nvarchar](400) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[VisibleToAllCustomers] [bit] NOT NULL,
	[IsRequired] [bit] NOT NULL,
 CONSTRAINT [PK_ReviewType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RewardPointsHistory]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RewardPointsHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[StoreId] [int] NOT NULL,
	[Points] [int] NOT NULL,
	[PointsBalance] [int] NULL,
	[UsedAmount] [decimal](18, 4) NOT NULL,
	[Message] [nvarchar](max) NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
	[EndDateUtc] [datetime2](7) NULL,
	[ValidPoints] [int] NULL,
 CONSTRAINT [PK_RewardPointsHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ScheduleTask]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScheduleTask](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Seconds] [int] NOT NULL,
	[Type] [nvarchar](max) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[StopOnError] [bit] NOT NULL,
	[LastStartUtc] [datetime2](7) NULL,
	[LastEndUtc] [datetime2](7) NULL,
	[LastSuccessUtc] [datetime2](7) NULL,
 CONSTRAINT [PK_ScheduleTask] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SearchTerm]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SearchTerm](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Keyword] [nvarchar](max) NULL,
	[StoreId] [int] NOT NULL,
	[Count] [int] NOT NULL,
 CONSTRAINT [PK_SearchTerm] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Setting]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Setting](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Value] [nvarchar](2000) NOT NULL,
	[StoreId] [int] NOT NULL,
 CONSTRAINT [PK_Setting] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Shipment]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Shipment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[TrackingNumber] [nvarchar](max) NULL,
	[TotalWeight] [decimal](18, 4) NULL,
	[ShippedDateUtc] [datetime2](7) NULL,
	[DeliveryDateUtc] [datetime2](7) NULL,
	[AdminComment] [nvarchar](max) NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Shipment] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShipmentItem]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShipmentItem](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ShipmentId] [int] NOT NULL,
	[OrderItemId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[WarehouseId] [int] NOT NULL,
 CONSTRAINT [PK_ShipmentItem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingByWeightByTotalRecord]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingByWeightByTotalRecord](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StoreId] [int] NOT NULL,
	[WarehouseId] [int] NOT NULL,
	[CountryId] [int] NOT NULL,
	[StateProvinceId] [int] NOT NULL,
	[Zip] [nvarchar](400) NULL,
	[ShippingMethodId] [int] NOT NULL,
	[WeightFrom] [decimal](18, 2) NOT NULL,
	[WeightTo] [decimal](18, 2) NOT NULL,
	[OrderSubtotalFrom] [decimal](18, 2) NOT NULL,
	[OrderSubtotalTo] [decimal](18, 2) NOT NULL,
	[AdditionalFixedCost] [decimal](18, 2) NOT NULL,
	[PercentageRateOfSubtotal] [decimal](18, 2) NOT NULL,
	[RatePerWeightUnit] [decimal](18, 2) NOT NULL,
	[LowerWeightLimit] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_ShippingByWeightByTotalRecord] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingMethod]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingMethod](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_ShippingMethod] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShippingMethodRestrictions]    Script Date: 11/14/2018 10:13:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShippingMethodRestrictions](
	[ShippingMethod_Id] [int] NOT NULL,
	[Country_Id] [int] NOT NULL,
 CONSTRAINT [PK_ShippingMethodRestrictions] PRIMARY KEY CLUSTERED 
(
	[ShippingMethod_Id] ASC,
	[Country_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShoppingCartItem]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShoppingCartItem](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StoreId] [int] NOT NULL,
	[ShoppingCartTypeId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[AttributesXml] [nvarchar](max) NULL,
	[CustomerEnteredPrice] [decimal](18, 4) NOT NULL,
	[Quantity] [int] NOT NULL,
	[RentalStartDateUtc] [datetime2](7) NULL,
	[RentalEndDateUtc] [datetime2](7) NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
	[UpdatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_ShoppingCartItem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpecificationAttribute]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpecificationAttribute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_SpecificationAttribute] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SpecificationAttributeOption]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpecificationAttributeOption](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SpecificationAttributeId] [int] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[ColorSquaresRgb] [nvarchar](100) NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_SpecificationAttributeOption] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StateProvince]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StateProvince](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CountryId] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Abbreviation] [nvarchar](100) NULL,
	[Published] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_StateProvince] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StockQuantityHistory]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StockQuantityHistory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[QuantityAdjustment] [int] NOT NULL,
	[StockQuantity] [int] NOT NULL,
	[Message] [nvarchar](max) NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
	[ProductId] [int] NOT NULL,
	[CombinationId] [int] NULL,
	[WarehouseId] [int] NULL,
 CONSTRAINT [PK_StockQuantityHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Store]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Store](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[Url] [nvarchar](400) NOT NULL,
	[SslEnabled] [bit] NOT NULL,
	[Hosts] [nvarchar](1000) NULL,
	[DefaultLanguageId] [int] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[CompanyName] [nvarchar](1000) NULL,
	[CompanyAddress] [nvarchar](1000) NULL,
	[CompanyPhoneNumber] [nvarchar](1000) NULL,
	[CompanyVat] [nvarchar](1000) NULL,
 CONSTRAINT [PK_Store] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StoreMapping]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StoreMapping](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EntityId] [int] NOT NULL,
	[EntityName] [nvarchar](400) NOT NULL,
	[StoreId] [int] NOT NULL,
 CONSTRAINT [PK_StoreMapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StorePickupPoint]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StorePickupPoint](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[AddressId] [int] NOT NULL,
	[PickupFee] [decimal](18, 4) NOT NULL,
	[OpeningHours] [nvarchar](max) NULL,
	[DisplayOrder] [int] NOT NULL,
	[StoreId] [int] NOT NULL,
 CONSTRAINT [PK_StorePickupPoint] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TaxCategory]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaxCategory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_TaxCategory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TaxRate]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaxRate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StoreId] [int] NOT NULL,
	[TaxCategoryId] [int] NOT NULL,
	[CountryId] [int] NOT NULL,
	[StateProvinceId] [int] NOT NULL,
	[Zip] [nvarchar](max) NULL,
	[Percentage] [decimal](18, 4) NOT NULL,
 CONSTRAINT [PK_TaxRate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TierPrice]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TierPrice](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NOT NULL,
	[StoreId] [int] NOT NULL,
	[CustomerRoleId] [int] NULL,
	[Quantity] [int] NOT NULL,
	[Price] [decimal](18, 4) NOT NULL,
	[StartDateTimeUtc] [datetime2](7) NULL,
	[EndDateTimeUtc] [datetime2](7) NULL,
 CONSTRAINT [PK_TierPrice] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Topic]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Topic](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SystemName] [nvarchar](max) NULL,
	[IncludeInSitemap] [bit] NOT NULL,
	[IncludeInTopMenu] [bit] NOT NULL,
	[IncludeInFooterColumn1] [bit] NOT NULL,
	[IncludeInFooterColumn2] [bit] NOT NULL,
	[IncludeInFooterColumn3] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[AccessibleWhenStoreClosed] [bit] NOT NULL,
	[IsPasswordProtected] [bit] NOT NULL,
	[Password] [nvarchar](max) NULL,
	[Title] [nvarchar](max) NOT NULL,
	[Body] [nvarchar](max) NULL,
	[Published] [bit] NOT NULL,
	[TopicTemplateId] [int] NOT NULL,
	[MetaKeywords] [nvarchar](max) NULL,
	[MetaDescription] [nvarchar](max) NULL,
	[MetaTitle] [nvarchar](max) NULL,
	[SubjectToAcl] [bit] NOT NULL,
	[LimitedToStores] [bit] NOT NULL,
 CONSTRAINT [PK_Topic] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TopicTemplate]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TopicTemplate](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[ViewPath] [nvarchar](400) NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_TopicTemplate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UrlRecord]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UrlRecord](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EntityId] [int] NOT NULL,
	[EntityName] [nvarchar](400) NOT NULL,
	[Slug] [nvarchar](400) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[LanguageId] [int] NOT NULL,
 CONSTRAINT [PK_UrlRecord] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Vendor]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vendor](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[Email] [nvarchar](400) NULL,
	[Description] [nvarchar](max) NULL,
	[PictureId] [int] NOT NULL,
	[AddressId] [int] NOT NULL,
	[AdminComment] [nvarchar](max) NULL,
	[Active] [bit] NOT NULL,
	[Deleted] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[MetaKeywords] [nvarchar](400) NULL,
	[MetaDescription] [nvarchar](max) NULL,
	[MetaTitle] [nvarchar](400) NULL,
	[PageSize] [int] NOT NULL,
	[AllowCustomersToSelectPageSize] [bit] NOT NULL,
	[PageSizeOptions] [nvarchar](200) NULL,
 CONSTRAINT [PK_Vendor] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VendorAttribute]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendorAttribute](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[IsRequired] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[AttributeControlTypeId] [int] NOT NULL,
 CONSTRAINT [PK_VendorAttribute] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VendorAttributeValue]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendorAttributeValue](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[IsPreSelected] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[VendorAttributeId] [int] NOT NULL,
 CONSTRAINT [PK_VendorAttributeValue] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VendorNote]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendorNote](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[VendorId] [int] NOT NULL,
	[Note] [nvarchar](max) NOT NULL,
	[CreatedOnUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_VendorNote] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Warehouse]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Warehouse](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](400) NOT NULL,
	[AdminComment] [nvarchar](max) NULL,
	[AddressId] [int] NOT NULL,
 CONSTRAINT [PK_Warehouse] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX_AclRecord_CustomerRoleId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_AclRecord_CustomerRoleId] ON [dbo].[AclRecord]
(
	[CustomerRoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_AclRecord_EntityId_EntityName]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_AclRecord_EntityId_EntityName] ON [dbo].[AclRecord]
(
	[EntityId] ASC,
	[EntityName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ActivityLog_ActivityLogTypeId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ActivityLog_ActivityLogTypeId] ON [dbo].[ActivityLog]
(
	[ActivityLogTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ActivityLog_CreatedOnUtc]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ActivityLog_CreatedOnUtc] ON [dbo].[ActivityLog]
(
	[CreatedOnUtc] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ActivityLog_CustomerId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ActivityLog_CustomerId] ON [dbo].[ActivityLog]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Address_CountryId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Address_CountryId] ON [dbo].[Address]
(
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Address_StateProvinceId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Address_StateProvinceId] ON [dbo].[Address]
(
	[StateProvinceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_AddressAttributeValue_AddressAttributeId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_AddressAttributeValue_AddressAttributeId] ON [dbo].[AddressAttributeValue]
(
	[AddressAttributeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Affiliate_AddressId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Affiliate_AddressId] ON [dbo].[Affiliate]
(
	[AddressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_BackInStockSubscription_CustomerId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_BackInStockSubscription_CustomerId] ON [dbo].[BackInStockSubscription]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_BackInStockSubscription_ProductId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_BackInStockSubscription_ProductId] ON [dbo].[BackInStockSubscription]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_BlogComment_BlogPostId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_BlogComment_BlogPostId] ON [dbo].[BlogComment]
(
	[BlogPostId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_BlogComment_CustomerId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_BlogComment_CustomerId] ON [dbo].[BlogComment]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_BlogComment_StoreId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_BlogComment_StoreId] ON [dbo].[BlogComment]
(
	[StoreId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_BlogPost_LanguageId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_BlogPost_LanguageId] ON [dbo].[BlogPost]
(
	[LanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Category_Deleted_Extended]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Category_Deleted_Extended] ON [dbo].[Category]
(
	[Deleted] ASC
)
INCLUDE ( 	[Id],
	[Name],
	[SubjectToAcl],
	[LimitedToStores],
	[Published]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Category_DisplayOrder]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Category_DisplayOrder] ON [dbo].[Category]
(
	[DisplayOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Category_LimitedToStores]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Category_LimitedToStores] ON [dbo].[Category]
(
	[LimitedToStores] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Category_ParentCategoryId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Category_ParentCategoryId] ON [dbo].[Category]
(
	[ParentCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Category_SubjectToAcl]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Category_SubjectToAcl] ON [dbo].[Category]
(
	[SubjectToAcl] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CheckoutAttributeValue_CheckoutAttributeId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_CheckoutAttributeValue_CheckoutAttributeId] ON [dbo].[CheckoutAttributeValue]
(
	[CheckoutAttributeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Country_DisplayOrder]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Country_DisplayOrder] ON [dbo].[Country]
(
	[DisplayOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Currency_DisplayOrder]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Currency_DisplayOrder] ON [dbo].[Currency]
(
	[DisplayOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Customer_BillingAddress_Id]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Customer_BillingAddress_Id] ON [dbo].[Customer]
(
	[BillingAddress_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Customer_CreatedOnUtc]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Customer_CreatedOnUtc] ON [dbo].[Customer]
(
	[CreatedOnUtc] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Customer_CustomerGuid]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Customer_CustomerGuid] ON [dbo].[Customer]
(
	[CustomerGuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Customer_Email]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Customer_Email] ON [dbo].[Customer]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Customer_ShippingAddress_Id]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Customer_ShippingAddress_Id] ON [dbo].[Customer]
(
	[ShippingAddress_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Customer_SystemName]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Customer_SystemName] ON [dbo].[Customer]
(
	[SystemName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Customer_Username]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Customer_Username] ON [dbo].[Customer]
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Customer_CustomerRole_Mapping_Customer_Id]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Customer_CustomerRole_Mapping_Customer_Id] ON [dbo].[Customer_CustomerRole_Mapping]
(
	[Customer_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Customer_CustomerRole_Mapping_CustomerRole_Id]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Customer_CustomerRole_Mapping_CustomerRole_Id] ON [dbo].[Customer_CustomerRole_Mapping]
(
	[CustomerRole_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CustomerAddresses_Address_Id]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_CustomerAddresses_Address_Id] ON [dbo].[CustomerAddresses]
(
	[Address_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CustomerAttributeValue_CustomerAttributeId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_CustomerAttributeValue_CustomerAttributeId] ON [dbo].[CustomerAttributeValue]
(
	[CustomerAttributeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CustomerPassword_CustomerId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_CustomerPassword_CustomerId] ON [dbo].[CustomerPassword]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Discount_AppliedToCategories_Category_Id]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Discount_AppliedToCategories_Category_Id] ON [dbo].[Discount_AppliedToCategories]
(
	[Category_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Discount_AppliedToManufacturers_Manufacturer_Id]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Discount_AppliedToManufacturers_Manufacturer_Id] ON [dbo].[Discount_AppliedToManufacturers]
(
	[Manufacturer_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Discount_AppliedToProducts_Product_Id]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Discount_AppliedToProducts_Product_Id] ON [dbo].[Discount_AppliedToProducts]
(
	[Product_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DiscountRequirement_DiscountId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_DiscountRequirement_DiscountId] ON [dbo].[DiscountRequirement]
(
	[DiscountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DiscountRequirement_ParentId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_DiscountRequirement_ParentId] ON [dbo].[DiscountRequirement]
(
	[ParentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DiscountUsageHistory_DiscountId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_DiscountUsageHistory_DiscountId] ON [dbo].[DiscountUsageHistory]
(
	[DiscountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_DiscountUsageHistory_OrderId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_DiscountUsageHistory_OrderId] ON [dbo].[DiscountUsageHistory]
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ExternalAuthenticationRecord_CustomerId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ExternalAuthenticationRecord_CustomerId] ON [dbo].[ExternalAuthenticationRecord]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Forums_Forum_DisplayOrder]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Forums_Forum_DisplayOrder] ON [dbo].[Forums_Forum]
(
	[DisplayOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Forums_Forum_ForumGroupId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Forums_Forum_ForumGroupId] ON [dbo].[Forums_Forum]
(
	[ForumGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Forums_Group_DisplayOrder]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Forums_Group_DisplayOrder] ON [dbo].[Forums_Group]
(
	[DisplayOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Forums_Post_CustomerId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Forums_Post_CustomerId] ON [dbo].[Forums_Post]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Forums_Post_TopicId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Forums_Post_TopicId] ON [dbo].[Forums_Post]
(
	[TopicId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Forums_PostVote_ForumPostId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Forums_PostVote_ForumPostId] ON [dbo].[Forums_PostVote]
(
	[ForumPostId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Forums_PrivateMessage_FromCustomerId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Forums_PrivateMessage_FromCustomerId] ON [dbo].[Forums_PrivateMessage]
(
	[FromCustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Forums_PrivateMessage_ToCustomerId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Forums_PrivateMessage_ToCustomerId] ON [dbo].[Forums_PrivateMessage]
(
	[ToCustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Forums_Subscription_CustomerId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Forums_Subscription_CustomerId] ON [dbo].[Forums_Subscription]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Forums_Subscription_ForumId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Forums_Subscription_ForumId] ON [dbo].[Forums_Subscription]
(
	[ForumId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Forums_Subscription_TopicId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Forums_Subscription_TopicId] ON [dbo].[Forums_Subscription]
(
	[TopicId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Forums_Topic_CustomerId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Forums_Topic_CustomerId] ON [dbo].[Forums_Topic]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Forums_Topic_ForumId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Forums_Topic_ForumId] ON [dbo].[Forums_Topic]
(
	[ForumId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_GenericAttribute_EntityId_and_KeyGroup]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_GenericAttribute_EntityId_and_KeyGroup] ON [dbo].[GenericAttribute]
(
	[EntityId] ASC,
	[KeyGroup] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_GiftCard_PurchasedWithOrderItemId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_GiftCard_PurchasedWithOrderItemId] ON [dbo].[GiftCard]
(
	[PurchasedWithOrderItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_GiftCardUsageHistory_GiftCardId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_GiftCardUsageHistory_GiftCardId] ON [dbo].[GiftCardUsageHistory]
(
	[GiftCardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_GiftCardUsageHistory_UsedWithOrderId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_GiftCardUsageHistory_UsedWithOrderId] ON [dbo].[GiftCardUsageHistory]
(
	[UsedWithOrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Language_DisplayOrder]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Language_DisplayOrder] ON [dbo].[Language]
(
	[DisplayOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_LocaleStringResource]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_LocaleStringResource] ON [dbo].[LocaleStringResource]
(
	[ResourceName] ASC,
	[LanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_LocaleStringResource_LanguageId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_LocaleStringResource_LanguageId] ON [dbo].[LocaleStringResource]
(
	[LanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_LocalizedProperty_LanguageId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_LocalizedProperty_LanguageId] ON [dbo].[LocalizedProperty]
(
	[LanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Log_CreatedOnUtc]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Log_CreatedOnUtc] ON [dbo].[Log]
(
	[CreatedOnUtc] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Log_CustomerId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Log_CustomerId] ON [dbo].[Log]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Manufacturer_DisplayOrder]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Manufacturer_DisplayOrder] ON [dbo].[Manufacturer]
(
	[DisplayOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Manufacturer_LimitedToStores]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Manufacturer_LimitedToStores] ON [dbo].[Manufacturer]
(
	[LimitedToStores] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Manufacturer_SubjectToAcl]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Manufacturer_SubjectToAcl] ON [dbo].[Manufacturer]
(
	[SubjectToAcl] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_News_LanguageId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_News_LanguageId] ON [dbo].[News]
(
	[LanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_NewsComment_CustomerId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_NewsComment_CustomerId] ON [dbo].[NewsComment]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_NewsComment_NewsItemId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_NewsComment_NewsItemId] ON [dbo].[NewsComment]
(
	[NewsItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_NewsComment_StoreId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_NewsComment_StoreId] ON [dbo].[NewsComment]
(
	[StoreId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_NewsletterSubscription_Email_StoreId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_NewsletterSubscription_Email_StoreId] ON [dbo].[NewsLetterSubscription]
(
	[Email] ASC,
	[StoreId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Order_BillingAddressId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Order_BillingAddressId] ON [dbo].[Order]
(
	[BillingAddressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Order_CreatedOnUtc]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Order_CreatedOnUtc] ON [dbo].[Order]
(
	[CreatedOnUtc] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Order_CustomerId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Order_CustomerId] ON [dbo].[Order]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Order_PickupAddressId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Order_PickupAddressId] ON [dbo].[Order]
(
	[PickupAddressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Order_RewardPointsHistoryEntryId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Order_RewardPointsHistoryEntryId] ON [dbo].[Order]
(
	[RewardPointsHistoryEntryId] ASC
)
WHERE ([RewardPointsHistoryEntryId] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Order_ShippingAddressId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Order_ShippingAddressId] ON [dbo].[Order]
(
	[ShippingAddressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrderItem_OrderId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_OrderItem_OrderId] ON [dbo].[OrderItem]
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrderItem_ProductId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_OrderItem_ProductId] ON [dbo].[OrderItem]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrderNote_OrderId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_OrderNote_OrderId] ON [dbo].[OrderNote]
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PermissionRecord_Role_Mapping_CustomerRole_Id]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_PermissionRecord_Role_Mapping_CustomerRole_Id] ON [dbo].[PermissionRecord_Role_Mapping]
(
	[CustomerRole_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PictureBinary_PictureId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_PictureBinary_PictureId] ON [dbo].[PictureBinary]
(
	[PictureId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Poll_LanguageId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Poll_LanguageId] ON [dbo].[Poll]
(
	[LanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PollAnswer_PollId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_PollAnswer_PollId] ON [dbo].[PollAnswer]
(
	[PollId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PollVotingRecord_CustomerId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_PollVotingRecord_CustomerId] ON [dbo].[PollVotingRecord]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PollVotingRecord_PollAnswerId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_PollVotingRecord_PollAnswerId] ON [dbo].[PollVotingRecord]
(
	[PollAnswerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PredefinedProductAttributeValue_ProductAttributeId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_PredefinedProductAttributeValue_ProductAttributeId] ON [dbo].[PredefinedProductAttributeValue]
(
	[ProductAttributeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_GetLowStockProducts]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_GetLowStockProducts] ON [dbo].[Product]
(
	[Deleted] ASC,
	[VendorId] ASC,
	[ProductTypeId] ASC,
	[ManageInventoryMethodId] ASC,
	[MinStockQuantity] ASC,
	[UseMultipleWarehouses] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_Delete_Id]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_Delete_Id] ON [dbo].[Product]
(
	[Deleted] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_Deleted_and_Published]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_Deleted_and_Published] ON [dbo].[Product]
(
	[Published] ASC,
	[Deleted] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_LimitedToStores]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_LimitedToStores] ON [dbo].[Product]
(
	[LimitedToStores] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_ParentGroupedProductId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_ParentGroupedProductId] ON [dbo].[Product]
(
	[ParentGroupedProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_PriceDatesEtc]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_PriceDatesEtc] ON [dbo].[Product]
(
	[Price] ASC,
	[AvailableStartDateTimeUtc] ASC,
	[AvailableEndDateTimeUtc] ASC,
	[Published] ASC,
	[Deleted] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_Published]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_Published] ON [dbo].[Product]
(
	[Published] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_ShowOnHomepage]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_ShowOnHomepage] ON [dbo].[Product]
(
	[ShowOnHomePage] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_SubjectToAcl]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_SubjectToAcl] ON [dbo].[Product]
(
	[SubjectToAcl] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_VisibleIndividually]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_VisibleIndividually] ON [dbo].[Product]
(
	[VisibleIndividually] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_VisibleIndividually_Published_Deleted_Extended]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_VisibleIndividually_Published_Deleted_Extended] ON [dbo].[Product]
(
	[VisibleIndividually] ASC,
	[Published] ASC,
	[Deleted] ASC
)
INCLUDE ( 	[Id],
	[AvailableStartDateTimeUtc],
	[AvailableEndDateTimeUtc]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PCM_Product_and_Category]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_PCM_Product_and_Category] ON [dbo].[Product_Category_Mapping]
(
	[CategoryId] ASC,
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PCM_ProductId_Extended]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_PCM_ProductId_Extended] ON [dbo].[Product_Category_Mapping]
(
	[ProductId] ASC,
	[IsFeaturedProduct] ASC
)
INCLUDE ( 	[CategoryId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_Category_Mapping_CategoryId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_Category_Mapping_CategoryId] ON [dbo].[Product_Category_Mapping]
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_Category_Mapping_IsFeaturedProduct]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_Category_Mapping_IsFeaturedProduct] ON [dbo].[Product_Category_Mapping]
(
	[IsFeaturedProduct] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_Category_Mapping_ProductId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_Category_Mapping_ProductId] ON [dbo].[Product_Category_Mapping]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PMM_Product_and_Manufacturer]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_PMM_Product_and_Manufacturer] ON [dbo].[Product_Manufacturer_Mapping]
(
	[ManufacturerId] ASC,
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PMM_ProductId_Extended]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_PMM_ProductId_Extended] ON [dbo].[Product_Manufacturer_Mapping]
(
	[ProductId] ASC,
	[IsFeaturedProduct] ASC
)
INCLUDE ( 	[ManufacturerId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_Manufacturer_Mapping_IsFeaturedProduct]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_Manufacturer_Mapping_IsFeaturedProduct] ON [dbo].[Product_Manufacturer_Mapping]
(
	[IsFeaturedProduct] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_Manufacturer_Mapping_ManufacturerId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_Manufacturer_Mapping_ManufacturerId] ON [dbo].[Product_Manufacturer_Mapping]
(
	[ManufacturerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_Manufacturer_Mapping_ProductId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_Manufacturer_Mapping_ProductId] ON [dbo].[Product_Manufacturer_Mapping]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_Picture_Mapping_PictureId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_Picture_Mapping_PictureId] ON [dbo].[Product_Picture_Mapping]
(
	[PictureId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_Picture_Mapping_ProductId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_Picture_Mapping_ProductId] ON [dbo].[Product_Picture_Mapping]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_ProductAttribute_Mapping_ProductAttributeId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_ProductAttribute_Mapping_ProductAttributeId] ON [dbo].[Product_ProductAttribute_Mapping]
(
	[ProductAttributeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_ProductAttribute_Mapping_ProductId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_ProductAttribute_Mapping_ProductId] ON [dbo].[Product_ProductAttribute_Mapping]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_ProductAttribute_Mapping_ProductId_DisplayOrder]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_ProductAttribute_Mapping_ProductId_DisplayOrder] ON [dbo].[Product_ProductAttribute_Mapping]
(
	[ProductId] ASC,
	[DisplayOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_ProductTag_Mapping_ProductTag_Id]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_ProductTag_Mapping_ProductTag_Id] ON [dbo].[Product_ProductTag_Mapping]
(
	[ProductTag_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_SpecificationAttribute_Mapping_ProductId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_SpecificationAttribute_Mapping_ProductId] ON [dbo].[Product_SpecificationAttribute_Mapping]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Product_SpecificationAttribute_Mapping_SpecificationAttributeOptionId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Product_SpecificationAttribute_Mapping_SpecificationAttributeOptionId] ON [dbo].[Product_SpecificationAttribute_Mapping]
(
	[SpecificationAttributeOptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PSAM_AllowFiltering]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_PSAM_AllowFiltering] ON [dbo].[Product_SpecificationAttribute_Mapping]
(
	[AllowFiltering] ASC
)
INCLUDE ( 	[ProductId],
	[SpecificationAttributeOptionId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_PSAM_SpecificationAttributeOptionId_AllowFiltering]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_PSAM_SpecificationAttributeOptionId_AllowFiltering] ON [dbo].[Product_SpecificationAttribute_Mapping]
(
	[SpecificationAttributeOptionId] ASC,
	[AllowFiltering] ASC
)
INCLUDE ( 	[ProductId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProductAttributeCombination_ProductId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ProductAttributeCombination_ProductId] ON [dbo].[ProductAttributeCombination]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProductAttributeValue_ProductAttributeMappingId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ProductAttributeValue_ProductAttributeMappingId] ON [dbo].[ProductAttributeValue]
(
	[ProductAttributeMappingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProductAttributeValue_ProductAttributeMappingId_DisplayOrder]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ProductAttributeValue_ProductAttributeMappingId_DisplayOrder] ON [dbo].[ProductAttributeValue]
(
	[ProductAttributeMappingId] ASC,
	[DisplayOrder] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProductReview_CustomerId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ProductReview_CustomerId] ON [dbo].[ProductReview]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProductReview_ProductId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ProductReview_ProductId] ON [dbo].[ProductReview]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProductReview_StoreId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ProductReview_StoreId] ON [dbo].[ProductReview]
(
	[StoreId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProductReview_ReviewType_Mapping_ProductReviewId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ProductReview_ReviewType_Mapping_ProductReviewId] ON [dbo].[ProductReview_ReviewType_Mapping]
(
	[ProductReviewId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProductReview_ReviewType_Mapping_ReviewTypeId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ProductReview_ReviewType_Mapping_ReviewTypeId] ON [dbo].[ProductReview_ReviewType_Mapping]
(
	[ReviewTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProductReviewHelpfulness_ProductReviewId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ProductReviewHelpfulness_ProductReviewId] ON [dbo].[ProductReviewHelpfulness]
(
	[ProductReviewId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_ProductTag_Name]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ProductTag_Name] ON [dbo].[ProductTag]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProductWarehouseInventory_ProductId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ProductWarehouseInventory_ProductId] ON [dbo].[ProductWarehouseInventory]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ProductWarehouseInventory_WarehouseId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ProductWarehouseInventory_WarehouseId] ON [dbo].[ProductWarehouseInventory]
(
	[WarehouseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_QueuedEmail_CreatedOnUtc]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_QueuedEmail_CreatedOnUtc] ON [dbo].[QueuedEmail]
(
	[CreatedOnUtc] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_QueuedEmail_EmailAccountId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_QueuedEmail_EmailAccountId] ON [dbo].[QueuedEmail]
(
	[EmailAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_QueuedEmail_SentOnUtc_DontSendBeforeDateUtc_Extended]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_QueuedEmail_SentOnUtc_DontSendBeforeDateUtc_Extended] ON [dbo].[QueuedEmail]
(
	[SentOnUtc] ASC,
	[DontSendBeforeDateUtc] ASC
)
INCLUDE ( 	[SentTries]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_RecurringPayment_InitialOrderId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_RecurringPayment_InitialOrderId] ON [dbo].[RecurringPayment]
(
	[InitialOrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_RecurringPaymentHistory_RecurringPaymentId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_RecurringPaymentHistory_RecurringPaymentId] ON [dbo].[RecurringPaymentHistory]
(
	[RecurringPaymentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_RelatedProduct_ProductId1]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_RelatedProduct_ProductId1] ON [dbo].[RelatedProduct]
(
	[ProductId1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ReturnRequest_CustomerId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ReturnRequest_CustomerId] ON [dbo].[ReturnRequest]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_RewardPointsHistory_CustomerId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_RewardPointsHistory_CustomerId] ON [dbo].[RewardPointsHistory]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Shipment_OrderId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_Shipment_OrderId] ON [dbo].[Shipment]
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ShipmentItem_ShipmentId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ShipmentItem_ShipmentId] ON [dbo].[ShipmentItem]
(
	[ShipmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ShippingMethodRestrictions_Country_Id]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ShippingMethodRestrictions_Country_Id] ON [dbo].[ShippingMethodRestrictions]
(
	[Country_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ShoppingCartItem_CustomerId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ShoppingCartItem_CustomerId] ON [dbo].[ShoppingCartItem]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ShoppingCartItem_ProductId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ShoppingCartItem_ProductId] ON [dbo].[ShoppingCartItem]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ShoppingCartItem_ShoppingCartTypeId_CustomerId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_ShoppingCartItem_ShoppingCartTypeId_CustomerId] ON [dbo].[ShoppingCartItem]
(
	[ShoppingCartTypeId] ASC,
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_SpecificationAttributeOption_SpecificationAttributeId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_SpecificationAttributeOption_SpecificationAttributeId] ON [dbo].[SpecificationAttributeOption]
(
	[SpecificationAttributeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StateProvince_CountryId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_StateProvince_CountryId] ON [dbo].[StateProvince]
(
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StockQuantityHistory_ProductId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_StockQuantityHistory_ProductId] ON [dbo].[StockQuantityHistory]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_StoreMapping_EntityId_EntityName]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_StoreMapping_EntityId_EntityName] ON [dbo].[StoreMapping]
(
	[EntityId] ASC,
	[EntityName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_StoreMapping_StoreId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_StoreMapping_StoreId] ON [dbo].[StoreMapping]
(
	[StoreId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TierPrice_CustomerRoleId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_TierPrice_CustomerRoleId] ON [dbo].[TierPrice]
(
	[CustomerRoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_TierPrice_ProductId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_TierPrice_ProductId] ON [dbo].[TierPrice]
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UrlRecord_Custom_1]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_UrlRecord_Custom_1] ON [dbo].[UrlRecord]
(
	[EntityId] ASC,
	[EntityName] ASC,
	[LanguageId] ASC,
	[IsActive] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UrlRecord_Slug]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_UrlRecord_Slug] ON [dbo].[UrlRecord]
(
	[Slug] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_VendorAttributeValue_VendorAttributeId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_VendorAttributeValue_VendorAttributeId] ON [dbo].[VendorAttributeValue]
(
	[VendorAttributeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_VendorNote_VendorId]    Script Date: 11/14/2018 10:13:46 AM ******/
CREATE NONCLUSTERED INDEX [IX_VendorNote_VendorId] ON [dbo].[VendorNote]
(
	[VendorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AclRecord]  WITH CHECK ADD  CONSTRAINT [FK_AclRecord_CustomerRole_CustomerRoleId] FOREIGN KEY([CustomerRoleId])
REFERENCES [dbo].[CustomerRole] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AclRecord] CHECK CONSTRAINT [FK_AclRecord_CustomerRole_CustomerRoleId]
GO
ALTER TABLE [dbo].[ActivityLog]  WITH CHECK ADD  CONSTRAINT [FK_ActivityLog_ActivityLogType_ActivityLogTypeId] FOREIGN KEY([ActivityLogTypeId])
REFERENCES [dbo].[ActivityLogType] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ActivityLog] CHECK CONSTRAINT [FK_ActivityLog_ActivityLogType_ActivityLogTypeId]
GO
ALTER TABLE [dbo].[ActivityLog]  WITH CHECK ADD  CONSTRAINT [FK_ActivityLog_Customer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ActivityLog] CHECK CONSTRAINT [FK_ActivityLog_Customer_CustomerId]
GO
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([Id])
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [FK_Address_Country_CountryId]
GO
ALTER TABLE [dbo].[Address]  WITH CHECK ADD  CONSTRAINT [FK_Address_StateProvince_StateProvinceId] FOREIGN KEY([StateProvinceId])
REFERENCES [dbo].[StateProvince] ([Id])
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [FK_Address_StateProvince_StateProvinceId]
GO
ALTER TABLE [dbo].[AddressAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_AddressAttributeValue_AddressAttribute_AddressAttributeId] FOREIGN KEY([AddressAttributeId])
REFERENCES [dbo].[AddressAttribute] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AddressAttributeValue] CHECK CONSTRAINT [FK_AddressAttributeValue_AddressAttribute_AddressAttributeId]
GO
ALTER TABLE [dbo].[Affiliate]  WITH CHECK ADD  CONSTRAINT [FK_Affiliate_Address_AddressId] FOREIGN KEY([AddressId])
REFERENCES [dbo].[Address] ([Id])
GO
ALTER TABLE [dbo].[Affiliate] CHECK CONSTRAINT [FK_Affiliate_Address_AddressId]
GO
ALTER TABLE [dbo].[BackInStockSubscription]  WITH CHECK ADD  CONSTRAINT [FK_BackInStockSubscription_Customer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BackInStockSubscription] CHECK CONSTRAINT [FK_BackInStockSubscription_Customer_CustomerId]
GO
ALTER TABLE [dbo].[BackInStockSubscription]  WITH CHECK ADD  CONSTRAINT [FK_BackInStockSubscription_Product_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BackInStockSubscription] CHECK CONSTRAINT [FK_BackInStockSubscription_Product_ProductId]
GO
ALTER TABLE [dbo].[BlogComment]  WITH CHECK ADD  CONSTRAINT [FK_BlogComment_BlogPost_BlogPostId] FOREIGN KEY([BlogPostId])
REFERENCES [dbo].[BlogPost] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BlogComment] CHECK CONSTRAINT [FK_BlogComment_BlogPost_BlogPostId]
GO
ALTER TABLE [dbo].[BlogComment]  WITH CHECK ADD  CONSTRAINT [FK_BlogComment_Customer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BlogComment] CHECK CONSTRAINT [FK_BlogComment_Customer_CustomerId]
GO
ALTER TABLE [dbo].[BlogComment]  WITH CHECK ADD  CONSTRAINT [FK_BlogComment_Store_StoreId] FOREIGN KEY([StoreId])
REFERENCES [dbo].[Store] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BlogComment] CHECK CONSTRAINT [FK_BlogComment_Store_StoreId]
GO
ALTER TABLE [dbo].[BlogPost]  WITH CHECK ADD  CONSTRAINT [FK_BlogPost_Language_LanguageId] FOREIGN KEY([LanguageId])
REFERENCES [dbo].[Language] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[BlogPost] CHECK CONSTRAINT [FK_BlogPost_Language_LanguageId]
GO
ALTER TABLE [dbo].[CheckoutAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_CheckoutAttributeValue_CheckoutAttribute_CheckoutAttributeId] FOREIGN KEY([CheckoutAttributeId])
REFERENCES [dbo].[CheckoutAttribute] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CheckoutAttributeValue] CHECK CONSTRAINT [FK_CheckoutAttributeValue_CheckoutAttribute_CheckoutAttributeId]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_Address_BillingAddress_Id] FOREIGN KEY([BillingAddress_Id])
REFERENCES [dbo].[Address] ([Id])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_Address_BillingAddress_Id]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Customer_Address_ShippingAddress_Id] FOREIGN KEY([ShippingAddress_Id])
REFERENCES [dbo].[Address] ([Id])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Customer_Address_ShippingAddress_Id]
GO
ALTER TABLE [dbo].[Customer_CustomerRole_Mapping]  WITH CHECK ADD  CONSTRAINT [FK_Customer_CustomerRole_Mapping_Customer_Customer_Id] FOREIGN KEY([Customer_Id])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Customer_CustomerRole_Mapping] CHECK CONSTRAINT [FK_Customer_CustomerRole_Mapping_Customer_Customer_Id]
GO
ALTER TABLE [dbo].[Customer_CustomerRole_Mapping]  WITH CHECK ADD  CONSTRAINT [FK_Customer_CustomerRole_Mapping_CustomerRole_CustomerRole_Id] FOREIGN KEY([CustomerRole_Id])
REFERENCES [dbo].[CustomerRole] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Customer_CustomerRole_Mapping] CHECK CONSTRAINT [FK_Customer_CustomerRole_Mapping_CustomerRole_CustomerRole_Id]
GO
ALTER TABLE [dbo].[CustomerAddresses]  WITH CHECK ADD  CONSTRAINT [FK_CustomerAddresses_Address_Address_Id] FOREIGN KEY([Address_Id])
REFERENCES [dbo].[Address] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CustomerAddresses] CHECK CONSTRAINT [FK_CustomerAddresses_Address_Address_Id]
GO
ALTER TABLE [dbo].[CustomerAddresses]  WITH CHECK ADD  CONSTRAINT [FK_CustomerAddresses_Customer_Customer_Id] FOREIGN KEY([Customer_Id])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CustomerAddresses] CHECK CONSTRAINT [FK_CustomerAddresses_Customer_Customer_Id]
GO
ALTER TABLE [dbo].[CustomerAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_CustomerAttributeValue_CustomerAttribute_CustomerAttributeId] FOREIGN KEY([CustomerAttributeId])
REFERENCES [dbo].[CustomerAttribute] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CustomerAttributeValue] CHECK CONSTRAINT [FK_CustomerAttributeValue_CustomerAttribute_CustomerAttributeId]
GO
ALTER TABLE [dbo].[CustomerPassword]  WITH CHECK ADD  CONSTRAINT [FK_CustomerPassword_Customer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CustomerPassword] CHECK CONSTRAINT [FK_CustomerPassword_Customer_CustomerId]
GO
ALTER TABLE [dbo].[Discount_AppliedToCategories]  WITH CHECK ADD  CONSTRAINT [FK_Discount_AppliedToCategories_Category_Category_Id] FOREIGN KEY([Category_Id])
REFERENCES [dbo].[Category] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Discount_AppliedToCategories] CHECK CONSTRAINT [FK_Discount_AppliedToCategories_Category_Category_Id]
GO
ALTER TABLE [dbo].[Discount_AppliedToCategories]  WITH CHECK ADD  CONSTRAINT [FK_Discount_AppliedToCategories_Discount_Discount_Id] FOREIGN KEY([Discount_Id])
REFERENCES [dbo].[Discount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Discount_AppliedToCategories] CHECK CONSTRAINT [FK_Discount_AppliedToCategories_Discount_Discount_Id]
GO
ALTER TABLE [dbo].[Discount_AppliedToManufacturers]  WITH CHECK ADD  CONSTRAINT [FK_Discount_AppliedToManufacturers_Discount_Discount_Id] FOREIGN KEY([Discount_Id])
REFERENCES [dbo].[Discount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Discount_AppliedToManufacturers] CHECK CONSTRAINT [FK_Discount_AppliedToManufacturers_Discount_Discount_Id]
GO
ALTER TABLE [dbo].[Discount_AppliedToManufacturers]  WITH CHECK ADD  CONSTRAINT [FK_Discount_AppliedToManufacturers_Manufacturer_Manufacturer_Id] FOREIGN KEY([Manufacturer_Id])
REFERENCES [dbo].[Manufacturer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Discount_AppliedToManufacturers] CHECK CONSTRAINT [FK_Discount_AppliedToManufacturers_Manufacturer_Manufacturer_Id]
GO
ALTER TABLE [dbo].[Discount_AppliedToProducts]  WITH CHECK ADD  CONSTRAINT [FK_Discount_AppliedToProducts_Discount_Discount_Id] FOREIGN KEY([Discount_Id])
REFERENCES [dbo].[Discount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Discount_AppliedToProducts] CHECK CONSTRAINT [FK_Discount_AppliedToProducts_Discount_Discount_Id]
GO
ALTER TABLE [dbo].[Discount_AppliedToProducts]  WITH CHECK ADD  CONSTRAINT [FK_Discount_AppliedToProducts_Product_Product_Id] FOREIGN KEY([Product_Id])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Discount_AppliedToProducts] CHECK CONSTRAINT [FK_Discount_AppliedToProducts_Product_Product_Id]
GO
ALTER TABLE [dbo].[DiscountRequirement]  WITH CHECK ADD  CONSTRAINT [FK_DiscountRequirement_Discount_DiscountId] FOREIGN KEY([DiscountId])
REFERENCES [dbo].[Discount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DiscountRequirement] CHECK CONSTRAINT [FK_DiscountRequirement_Discount_DiscountId]
GO
ALTER TABLE [dbo].[DiscountRequirement]  WITH CHECK ADD  CONSTRAINT [FK_DiscountRequirement_DiscountRequirement_ParentId] FOREIGN KEY([ParentId])
REFERENCES [dbo].[DiscountRequirement] ([Id])
GO
ALTER TABLE [dbo].[DiscountRequirement] CHECK CONSTRAINT [FK_DiscountRequirement_DiscountRequirement_ParentId]
GO
ALTER TABLE [dbo].[DiscountUsageHistory]  WITH CHECK ADD  CONSTRAINT [FK_DiscountUsageHistory_Discount_DiscountId] FOREIGN KEY([DiscountId])
REFERENCES [dbo].[Discount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DiscountUsageHistory] CHECK CONSTRAINT [FK_DiscountUsageHistory_Discount_DiscountId]
GO
ALTER TABLE [dbo].[DiscountUsageHistory]  WITH CHECK ADD  CONSTRAINT [FK_DiscountUsageHistory_Order_OrderId] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Order] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DiscountUsageHistory] CHECK CONSTRAINT [FK_DiscountUsageHistory_Order_OrderId]
GO
ALTER TABLE [dbo].[ExternalAuthenticationRecord]  WITH CHECK ADD  CONSTRAINT [FK_ExternalAuthenticationRecord_Customer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ExternalAuthenticationRecord] CHECK CONSTRAINT [FK_ExternalAuthenticationRecord_Customer_CustomerId]
GO
ALTER TABLE [dbo].[Forums_Forum]  WITH CHECK ADD  CONSTRAINT [FK_Forums_Forum_Forums_Group_ForumGroupId] FOREIGN KEY([ForumGroupId])
REFERENCES [dbo].[Forums_Group] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Forums_Forum] CHECK CONSTRAINT [FK_Forums_Forum_Forums_Group_ForumGroupId]
GO
ALTER TABLE [dbo].[Forums_Post]  WITH CHECK ADD  CONSTRAINT [FK_Forums_Post_Customer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
GO
ALTER TABLE [dbo].[Forums_Post] CHECK CONSTRAINT [FK_Forums_Post_Customer_CustomerId]
GO
ALTER TABLE [dbo].[Forums_Post]  WITH CHECK ADD  CONSTRAINT [FK_Forums_Post_Forums_Topic_TopicId] FOREIGN KEY([TopicId])
REFERENCES [dbo].[Forums_Topic] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Forums_Post] CHECK CONSTRAINT [FK_Forums_Post_Forums_Topic_TopicId]
GO
ALTER TABLE [dbo].[Forums_PostVote]  WITH CHECK ADD  CONSTRAINT [FK_Forums_PostVote_Forums_Post_ForumPostId] FOREIGN KEY([ForumPostId])
REFERENCES [dbo].[Forums_Post] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Forums_PostVote] CHECK CONSTRAINT [FK_Forums_PostVote_Forums_Post_ForumPostId]
GO
ALTER TABLE [dbo].[Forums_PrivateMessage]  WITH CHECK ADD  CONSTRAINT [FK_Forums_PrivateMessage_Customer_FromCustomerId] FOREIGN KEY([FromCustomerId])
REFERENCES [dbo].[Customer] ([Id])
GO
ALTER TABLE [dbo].[Forums_PrivateMessage] CHECK CONSTRAINT [FK_Forums_PrivateMessage_Customer_FromCustomerId]
GO
ALTER TABLE [dbo].[Forums_PrivateMessage]  WITH CHECK ADD  CONSTRAINT [FK_Forums_PrivateMessage_Customer_ToCustomerId] FOREIGN KEY([ToCustomerId])
REFERENCES [dbo].[Customer] ([Id])
GO
ALTER TABLE [dbo].[Forums_PrivateMessage] CHECK CONSTRAINT [FK_Forums_PrivateMessage_Customer_ToCustomerId]
GO
ALTER TABLE [dbo].[Forums_Subscription]  WITH CHECK ADD  CONSTRAINT [FK_Forums_Subscription_Customer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
GO
ALTER TABLE [dbo].[Forums_Subscription] CHECK CONSTRAINT [FK_Forums_Subscription_Customer_CustomerId]
GO
ALTER TABLE [dbo].[Forums_Topic]  WITH CHECK ADD  CONSTRAINT [FK_Forums_Topic_Customer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
GO
ALTER TABLE [dbo].[Forums_Topic] CHECK CONSTRAINT [FK_Forums_Topic_Customer_CustomerId]
GO
ALTER TABLE [dbo].[Forums_Topic]  WITH CHECK ADD  CONSTRAINT [FK_Forums_Topic_Forums_Forum_ForumId] FOREIGN KEY([ForumId])
REFERENCES [dbo].[Forums_Forum] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Forums_Topic] CHECK CONSTRAINT [FK_Forums_Topic_Forums_Forum_ForumId]
GO
ALTER TABLE [dbo].[GiftCard]  WITH CHECK ADD  CONSTRAINT [FK_GiftCard_OrderItem_PurchasedWithOrderItemId] FOREIGN KEY([PurchasedWithOrderItemId])
REFERENCES [dbo].[OrderItem] ([Id])
GO
ALTER TABLE [dbo].[GiftCard] CHECK CONSTRAINT [FK_GiftCard_OrderItem_PurchasedWithOrderItemId]
GO
ALTER TABLE [dbo].[GiftCardUsageHistory]  WITH CHECK ADD  CONSTRAINT [FK_GiftCardUsageHistory_GiftCard_GiftCardId] FOREIGN KEY([GiftCardId])
REFERENCES [dbo].[GiftCard] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[GiftCardUsageHistory] CHECK CONSTRAINT [FK_GiftCardUsageHistory_GiftCard_GiftCardId]
GO
ALTER TABLE [dbo].[GiftCardUsageHistory]  WITH CHECK ADD  CONSTRAINT [FK_GiftCardUsageHistory_Order_UsedWithOrderId] FOREIGN KEY([UsedWithOrderId])
REFERENCES [dbo].[Order] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[GiftCardUsageHistory] CHECK CONSTRAINT [FK_GiftCardUsageHistory_Order_UsedWithOrderId]
GO
ALTER TABLE [dbo].[LocaleStringResource]  WITH CHECK ADD  CONSTRAINT [FK_LocaleStringResource_Language_LanguageId] FOREIGN KEY([LanguageId])
REFERENCES [dbo].[Language] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[LocaleStringResource] CHECK CONSTRAINT [FK_LocaleStringResource_Language_LanguageId]
GO
ALTER TABLE [dbo].[LocalizedProperty]  WITH CHECK ADD  CONSTRAINT [FK_LocalizedProperty_Language_LanguageId] FOREIGN KEY([LanguageId])
REFERENCES [dbo].[Language] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[LocalizedProperty] CHECK CONSTRAINT [FK_LocalizedProperty_Language_LanguageId]
GO
ALTER TABLE [dbo].[Log]  WITH CHECK ADD  CONSTRAINT [FK_Log_Customer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Log] CHECK CONSTRAINT [FK_Log_Customer_CustomerId]
GO
ALTER TABLE [dbo].[News]  WITH CHECK ADD  CONSTRAINT [FK_News_Language_LanguageId] FOREIGN KEY([LanguageId])
REFERENCES [dbo].[Language] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[News] CHECK CONSTRAINT [FK_News_Language_LanguageId]
GO
ALTER TABLE [dbo].[NewsComment]  WITH CHECK ADD  CONSTRAINT [FK_NewsComment_Customer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NewsComment] CHECK CONSTRAINT [FK_NewsComment_Customer_CustomerId]
GO
ALTER TABLE [dbo].[NewsComment]  WITH CHECK ADD  CONSTRAINT [FK_NewsComment_News_NewsItemId] FOREIGN KEY([NewsItemId])
REFERENCES [dbo].[News] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NewsComment] CHECK CONSTRAINT [FK_NewsComment_News_NewsItemId]
GO
ALTER TABLE [dbo].[NewsComment]  WITH CHECK ADD  CONSTRAINT [FK_NewsComment_Store_StoreId] FOREIGN KEY([StoreId])
REFERENCES [dbo].[Store] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[NewsComment] CHECK CONSTRAINT [FK_NewsComment_Store_StoreId]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Address_BillingAddressId] FOREIGN KEY([BillingAddressId])
REFERENCES [dbo].[Address] ([Id])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Address_BillingAddressId]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Address_PickupAddressId] FOREIGN KEY([PickupAddressId])
REFERENCES [dbo].[Address] ([Id])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Address_PickupAddressId]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Address_ShippingAddressId] FOREIGN KEY([ShippingAddressId])
REFERENCES [dbo].[Address] ([Id])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Address_ShippingAddressId]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Customer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Customer_CustomerId]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_RewardPointsHistory_RewardPointsHistoryEntryId] FOREIGN KEY([RewardPointsHistoryEntryId])
REFERENCES [dbo].[RewardPointsHistory] ([Id])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_RewardPointsHistory_RewardPointsHistoryEntryId]
GO
ALTER TABLE [dbo].[OrderItem]  WITH CHECK ADD  CONSTRAINT [FK_OrderItem_Order_OrderId] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Order] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OrderItem] CHECK CONSTRAINT [FK_OrderItem_Order_OrderId]
GO
ALTER TABLE [dbo].[OrderItem]  WITH CHECK ADD  CONSTRAINT [FK_OrderItem_Product_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OrderItem] CHECK CONSTRAINT [FK_OrderItem_Product_ProductId]
GO
ALTER TABLE [dbo].[OrderNote]  WITH CHECK ADD  CONSTRAINT [FK_OrderNote_Order_OrderId] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Order] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OrderNote] CHECK CONSTRAINT [FK_OrderNote_Order_OrderId]
GO
ALTER TABLE [dbo].[PermissionRecord_Role_Mapping]  WITH CHECK ADD  CONSTRAINT [FK_PermissionRecord_Role_Mapping_CustomerRole_CustomerRole_Id] FOREIGN KEY([CustomerRole_Id])
REFERENCES [dbo].[CustomerRole] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PermissionRecord_Role_Mapping] CHECK CONSTRAINT [FK_PermissionRecord_Role_Mapping_CustomerRole_CustomerRole_Id]
GO
ALTER TABLE [dbo].[PermissionRecord_Role_Mapping]  WITH CHECK ADD  CONSTRAINT [FK_PermissionRecord_Role_Mapping_PermissionRecord_PermissionRecord_Id] FOREIGN KEY([PermissionRecord_Id])
REFERENCES [dbo].[PermissionRecord] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PermissionRecord_Role_Mapping] CHECK CONSTRAINT [FK_PermissionRecord_Role_Mapping_PermissionRecord_PermissionRecord_Id]
GO
ALTER TABLE [dbo].[PictureBinary]  WITH CHECK ADD  CONSTRAINT [FK_PictureBinary_Picture_PictureId] FOREIGN KEY([PictureId])
REFERENCES [dbo].[Picture] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PictureBinary] CHECK CONSTRAINT [FK_PictureBinary_Picture_PictureId]
GO
ALTER TABLE [dbo].[Poll]  WITH CHECK ADD  CONSTRAINT [FK_Poll_Language_LanguageId] FOREIGN KEY([LanguageId])
REFERENCES [dbo].[Language] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Poll] CHECK CONSTRAINT [FK_Poll_Language_LanguageId]
GO
ALTER TABLE [dbo].[PollAnswer]  WITH CHECK ADD  CONSTRAINT [FK_PollAnswer_Poll_PollId] FOREIGN KEY([PollId])
REFERENCES [dbo].[Poll] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PollAnswer] CHECK CONSTRAINT [FK_PollAnswer_Poll_PollId]
GO
ALTER TABLE [dbo].[PollVotingRecord]  WITH CHECK ADD  CONSTRAINT [FK_PollVotingRecord_Customer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PollVotingRecord] CHECK CONSTRAINT [FK_PollVotingRecord_Customer_CustomerId]
GO
ALTER TABLE [dbo].[PollVotingRecord]  WITH CHECK ADD  CONSTRAINT [FK_PollVotingRecord_PollAnswer_PollAnswerId] FOREIGN KEY([PollAnswerId])
REFERENCES [dbo].[PollAnswer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PollVotingRecord] CHECK CONSTRAINT [FK_PollVotingRecord_PollAnswer_PollAnswerId]
GO
ALTER TABLE [dbo].[PredefinedProductAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_PredefinedProductAttributeValue_ProductAttribute_ProductAttributeId] FOREIGN KEY([ProductAttributeId])
REFERENCES [dbo].[ProductAttribute] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[PredefinedProductAttributeValue] CHECK CONSTRAINT [FK_PredefinedProductAttributeValue_ProductAttribute_ProductAttributeId]
GO
ALTER TABLE [dbo].[Product_Category_Mapping]  WITH CHECK ADD  CONSTRAINT [FK_Product_Category_Mapping_Category_CategoryId] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Category] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_Category_Mapping] CHECK CONSTRAINT [FK_Product_Category_Mapping_Category_CategoryId]
GO
ALTER TABLE [dbo].[Product_Category_Mapping]  WITH CHECK ADD  CONSTRAINT [FK_Product_Category_Mapping_Product_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_Category_Mapping] CHECK CONSTRAINT [FK_Product_Category_Mapping_Product_ProductId]
GO
ALTER TABLE [dbo].[Product_Manufacturer_Mapping]  WITH CHECK ADD  CONSTRAINT [FK_Product_Manufacturer_Mapping_Manufacturer_ManufacturerId] FOREIGN KEY([ManufacturerId])
REFERENCES [dbo].[Manufacturer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_Manufacturer_Mapping] CHECK CONSTRAINT [FK_Product_Manufacturer_Mapping_Manufacturer_ManufacturerId]
GO
ALTER TABLE [dbo].[Product_Manufacturer_Mapping]  WITH CHECK ADD  CONSTRAINT [FK_Product_Manufacturer_Mapping_Product_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_Manufacturer_Mapping] CHECK CONSTRAINT [FK_Product_Manufacturer_Mapping_Product_ProductId]
GO
ALTER TABLE [dbo].[Product_Picture_Mapping]  WITH CHECK ADD  CONSTRAINT [FK_Product_Picture_Mapping_Picture_PictureId] FOREIGN KEY([PictureId])
REFERENCES [dbo].[Picture] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_Picture_Mapping] CHECK CONSTRAINT [FK_Product_Picture_Mapping_Picture_PictureId]
GO
ALTER TABLE [dbo].[Product_Picture_Mapping]  WITH CHECK ADD  CONSTRAINT [FK_Product_Picture_Mapping_Product_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_Picture_Mapping] CHECK CONSTRAINT [FK_Product_Picture_Mapping_Product_ProductId]
GO
ALTER TABLE [dbo].[Product_ProductAttribute_Mapping]  WITH CHECK ADD  CONSTRAINT [FK_Product_ProductAttribute_Mapping_Product_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_ProductAttribute_Mapping] CHECK CONSTRAINT [FK_Product_ProductAttribute_Mapping_Product_ProductId]
GO
ALTER TABLE [dbo].[Product_ProductAttribute_Mapping]  WITH CHECK ADD  CONSTRAINT [FK_Product_ProductAttribute_Mapping_ProductAttribute_ProductAttributeId] FOREIGN KEY([ProductAttributeId])
REFERENCES [dbo].[ProductAttribute] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_ProductAttribute_Mapping] CHECK CONSTRAINT [FK_Product_ProductAttribute_Mapping_ProductAttribute_ProductAttributeId]
GO
ALTER TABLE [dbo].[Product_ProductTag_Mapping]  WITH CHECK ADD  CONSTRAINT [FK_Product_ProductTag_Mapping_Product_Product_Id] FOREIGN KEY([Product_Id])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_ProductTag_Mapping] CHECK CONSTRAINT [FK_Product_ProductTag_Mapping_Product_Product_Id]
GO
ALTER TABLE [dbo].[Product_ProductTag_Mapping]  WITH CHECK ADD  CONSTRAINT [FK_Product_ProductTag_Mapping_ProductTag_ProductTag_Id] FOREIGN KEY([ProductTag_Id])
REFERENCES [dbo].[ProductTag] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_ProductTag_Mapping] CHECK CONSTRAINT [FK_Product_ProductTag_Mapping_ProductTag_ProductTag_Id]
GO
ALTER TABLE [dbo].[Product_SpecificationAttribute_Mapping]  WITH CHECK ADD  CONSTRAINT [FK_Product_SpecificationAttribute_Mapping_Product_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_SpecificationAttribute_Mapping] CHECK CONSTRAINT [FK_Product_SpecificationAttribute_Mapping_Product_ProductId]
GO
ALTER TABLE [dbo].[Product_SpecificationAttribute_Mapping]  WITH CHECK ADD  CONSTRAINT [FK_Product_SpecificationAttribute_Mapping_SpecificationAttributeOption_SpecificationAttributeOptionId] FOREIGN KEY([SpecificationAttributeOptionId])
REFERENCES [dbo].[SpecificationAttributeOption] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Product_SpecificationAttribute_Mapping] CHECK CONSTRAINT [FK_Product_SpecificationAttribute_Mapping_SpecificationAttributeOption_SpecificationAttributeOptionId]
GO
ALTER TABLE [dbo].[ProductAttributeCombination]  WITH CHECK ADD  CONSTRAINT [FK_ProductAttributeCombination_Product_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductAttributeCombination] CHECK CONSTRAINT [FK_ProductAttributeCombination_Product_ProductId]
GO
ALTER TABLE [dbo].[ProductAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_ProductAttributeValue_Product_ProductAttribute_Mapping_ProductAttributeMappingId] FOREIGN KEY([ProductAttributeMappingId])
REFERENCES [dbo].[Product_ProductAttribute_Mapping] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductAttributeValue] CHECK CONSTRAINT [FK_ProductAttributeValue_Product_ProductAttribute_Mapping_ProductAttributeMappingId]
GO
ALTER TABLE [dbo].[ProductReview]  WITH CHECK ADD  CONSTRAINT [FK_ProductReview_Customer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductReview] CHECK CONSTRAINT [FK_ProductReview_Customer_CustomerId]
GO
ALTER TABLE [dbo].[ProductReview]  WITH CHECK ADD  CONSTRAINT [FK_ProductReview_Product_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductReview] CHECK CONSTRAINT [FK_ProductReview_Product_ProductId]
GO
ALTER TABLE [dbo].[ProductReview]  WITH CHECK ADD  CONSTRAINT [FK_ProductReview_Store_StoreId] FOREIGN KEY([StoreId])
REFERENCES [dbo].[Store] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductReview] CHECK CONSTRAINT [FK_ProductReview_Store_StoreId]
GO
ALTER TABLE [dbo].[ProductReview_ReviewType_Mapping]  WITH CHECK ADD  CONSTRAINT [FK_ProductReview_ReviewType_Mapping_ProductReview_ProductReviewId] FOREIGN KEY([ProductReviewId])
REFERENCES [dbo].[ProductReview] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductReview_ReviewType_Mapping] CHECK CONSTRAINT [FK_ProductReview_ReviewType_Mapping_ProductReview_ProductReviewId]
GO
ALTER TABLE [dbo].[ProductReview_ReviewType_Mapping]  WITH CHECK ADD  CONSTRAINT [FK_ProductReview_ReviewType_Mapping_ReviewType_ReviewTypeId] FOREIGN KEY([ReviewTypeId])
REFERENCES [dbo].[ReviewType] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductReview_ReviewType_Mapping] CHECK CONSTRAINT [FK_ProductReview_ReviewType_Mapping_ReviewType_ReviewTypeId]
GO
ALTER TABLE [dbo].[ProductReviewHelpfulness]  WITH CHECK ADD  CONSTRAINT [FK_ProductReviewHelpfulness_ProductReview_ProductReviewId] FOREIGN KEY([ProductReviewId])
REFERENCES [dbo].[ProductReview] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductReviewHelpfulness] CHECK CONSTRAINT [FK_ProductReviewHelpfulness_ProductReview_ProductReviewId]
GO
ALTER TABLE [dbo].[ProductWarehouseInventory]  WITH CHECK ADD  CONSTRAINT [FK_ProductWarehouseInventory_Product_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductWarehouseInventory] CHECK CONSTRAINT [FK_ProductWarehouseInventory_Product_ProductId]
GO
ALTER TABLE [dbo].[ProductWarehouseInventory]  WITH CHECK ADD  CONSTRAINT [FK_ProductWarehouseInventory_Warehouse_WarehouseId] FOREIGN KEY([WarehouseId])
REFERENCES [dbo].[Warehouse] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductWarehouseInventory] CHECK CONSTRAINT [FK_ProductWarehouseInventory_Warehouse_WarehouseId]
GO
ALTER TABLE [dbo].[QueuedEmail]  WITH CHECK ADD  CONSTRAINT [FK_QueuedEmail_EmailAccount_EmailAccountId] FOREIGN KEY([EmailAccountId])
REFERENCES [dbo].[EmailAccount] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[QueuedEmail] CHECK CONSTRAINT [FK_QueuedEmail_EmailAccount_EmailAccountId]
GO
ALTER TABLE [dbo].[RecurringPayment]  WITH CHECK ADD  CONSTRAINT [FK_RecurringPayment_Order_InitialOrderId] FOREIGN KEY([InitialOrderId])
REFERENCES [dbo].[Order] ([Id])
GO
ALTER TABLE [dbo].[RecurringPayment] CHECK CONSTRAINT [FK_RecurringPayment_Order_InitialOrderId]
GO
ALTER TABLE [dbo].[RecurringPaymentHistory]  WITH CHECK ADD  CONSTRAINT [FK_RecurringPaymentHistory_RecurringPayment_RecurringPaymentId] FOREIGN KEY([RecurringPaymentId])
REFERENCES [dbo].[RecurringPayment] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RecurringPaymentHistory] CHECK CONSTRAINT [FK_RecurringPaymentHistory_RecurringPayment_RecurringPaymentId]
GO
ALTER TABLE [dbo].[ReturnRequest]  WITH CHECK ADD  CONSTRAINT [FK_ReturnRequest_Customer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ReturnRequest] CHECK CONSTRAINT [FK_ReturnRequest_Customer_CustomerId]
GO
ALTER TABLE [dbo].[RewardPointsHistory]  WITH CHECK ADD  CONSTRAINT [FK_RewardPointsHistory_Customer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[RewardPointsHistory] CHECK CONSTRAINT [FK_RewardPointsHistory_Customer_CustomerId]
GO
ALTER TABLE [dbo].[Shipment]  WITH CHECK ADD  CONSTRAINT [FK_Shipment_Order_OrderId] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Order] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Shipment] CHECK CONSTRAINT [FK_Shipment_Order_OrderId]
GO
ALTER TABLE [dbo].[ShipmentItem]  WITH CHECK ADD  CONSTRAINT [FK_ShipmentItem_Shipment_ShipmentId] FOREIGN KEY([ShipmentId])
REFERENCES [dbo].[Shipment] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ShipmentItem] CHECK CONSTRAINT [FK_ShipmentItem_Shipment_ShipmentId]
GO
ALTER TABLE [dbo].[ShippingMethodRestrictions]  WITH CHECK ADD  CONSTRAINT [FK_ShippingMethodRestrictions_Country_Country_Id] FOREIGN KEY([Country_Id])
REFERENCES [dbo].[Country] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ShippingMethodRestrictions] CHECK CONSTRAINT [FK_ShippingMethodRestrictions_Country_Country_Id]
GO
ALTER TABLE [dbo].[ShippingMethodRestrictions]  WITH CHECK ADD  CONSTRAINT [FK_ShippingMethodRestrictions_ShippingMethod_ShippingMethod_Id] FOREIGN KEY([ShippingMethod_Id])
REFERENCES [dbo].[ShippingMethod] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ShippingMethodRestrictions] CHECK CONSTRAINT [FK_ShippingMethodRestrictions_ShippingMethod_ShippingMethod_Id]
GO
ALTER TABLE [dbo].[ShoppingCartItem]  WITH CHECK ADD  CONSTRAINT [FK_ShoppingCartItem_Customer_CustomerId] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ShoppingCartItem] CHECK CONSTRAINT [FK_ShoppingCartItem_Customer_CustomerId]
GO
ALTER TABLE [dbo].[ShoppingCartItem]  WITH CHECK ADD  CONSTRAINT [FK_ShoppingCartItem_Product_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ShoppingCartItem] CHECK CONSTRAINT [FK_ShoppingCartItem_Product_ProductId]
GO
ALTER TABLE [dbo].[SpecificationAttributeOption]  WITH CHECK ADD  CONSTRAINT [FK_SpecificationAttributeOption_SpecificationAttribute_SpecificationAttributeId] FOREIGN KEY([SpecificationAttributeId])
REFERENCES [dbo].[SpecificationAttribute] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SpecificationAttributeOption] CHECK CONSTRAINT [FK_SpecificationAttributeOption_SpecificationAttribute_SpecificationAttributeId]
GO
ALTER TABLE [dbo].[StateProvince]  WITH CHECK ADD  CONSTRAINT [FK_StateProvince_Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[StateProvince] CHECK CONSTRAINT [FK_StateProvince_Country_CountryId]
GO
ALTER TABLE [dbo].[StockQuantityHistory]  WITH CHECK ADD  CONSTRAINT [FK_StockQuantityHistory_Product_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[StockQuantityHistory] CHECK CONSTRAINT [FK_StockQuantityHistory_Product_ProductId]
GO
ALTER TABLE [dbo].[StoreMapping]  WITH CHECK ADD  CONSTRAINT [FK_StoreMapping_Store_StoreId] FOREIGN KEY([StoreId])
REFERENCES [dbo].[Store] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[StoreMapping] CHECK CONSTRAINT [FK_StoreMapping_Store_StoreId]
GO
ALTER TABLE [dbo].[TierPrice]  WITH CHECK ADD  CONSTRAINT [FK_TierPrice_CustomerRole_CustomerRoleId] FOREIGN KEY([CustomerRoleId])
REFERENCES [dbo].[CustomerRole] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TierPrice] CHECK CONSTRAINT [FK_TierPrice_CustomerRole_CustomerRoleId]
GO
ALTER TABLE [dbo].[TierPrice]  WITH CHECK ADD  CONSTRAINT [FK_TierPrice_Product_ProductId] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Product] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TierPrice] CHECK CONSTRAINT [FK_TierPrice_Product_ProductId]
GO
ALTER TABLE [dbo].[VendorAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_VendorAttributeValue_VendorAttribute_VendorAttributeId] FOREIGN KEY([VendorAttributeId])
REFERENCES [dbo].[VendorAttribute] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VendorAttributeValue] CHECK CONSTRAINT [FK_VendorAttributeValue_VendorAttribute_VendorAttributeId]
GO
ALTER TABLE [dbo].[VendorNote]  WITH CHECK ADD  CONSTRAINT [FK_VendorNote_Vendor_VendorId] FOREIGN KEY([VendorId])
REFERENCES [dbo].[Vendor] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[VendorNote] CHECK CONSTRAINT [FK_VendorNote_Vendor_VendorId]
GO
/****** Object:  StoredProcedure [dbo].[CategoryLoadAllPaged]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CategoryLoadAllPaged]
(
    @ShowHidden         BIT = 0,
    @Name               NVARCHAR(MAX) = NULL,
    @StoreId            INT = 0,
    @CustomerRoleIds	NVARCHAR(MAX) = NULL,
    @PageIndex			INT = 0,
	@PageSize			INT = 2147483644,
    @TotalRecords		INT = NULL OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON

    --filter by customer role IDs (access control list)
	SET @CustomerRoleIds = ISNULL(@CustomerRoleIds, '')
	CREATE TABLE #FilteredCustomerRoleIds
	(
		CustomerRoleId INT NOT NULL
	)
	INSERT INTO #FilteredCustomerRoleIds (CustomerRoleId)
	SELECT CAST(data AS INT) FROM [nop_splitstring_to_table](@CustomerRoleIds, ',')
	DECLARE @FilteredCustomerRoleIdsCount INT = (SELECT COUNT(1) FROM #FilteredCustomerRoleIds)

    --ordered categories
    CREATE TABLE #OrderedCategoryIds
	(
		[Id] int IDENTITY (1, 1) NOT NULL,
		[CategoryId] int NOT NULL
	)
    
    --get max length of DisplayOrder and Id columns (used for padding Order column)
    DECLARE @lengthId INT = (SELECT LEN(MAX(Id)) FROM [Category])
    DECLARE @lengthOrder INT = (SELECT LEN(MAX(DisplayOrder)) FROM [Category])

    --get category tree
    ;WITH [CategoryTree]
    AS (SELECT [Category].[Id] AS [Id], dbo.[nop_padright] ([Category].[DisplayOrder], '0', @lengthOrder) + '-' + dbo.[nop_padright] ([Category].[Id], '0', @lengthId) AS [Order]
        FROM [Category] WHERE [Category].[ParentCategoryId] = 0
        UNION ALL
        SELECT [Category].[Id] AS [Id], [CategoryTree].[Order] + '|' + dbo.[nop_padright] ([Category].[DisplayOrder], '0', @lengthOrder) + '-' + dbo.[nop_padright] ([Category].[Id], '0', @lengthId) AS [Order]
        FROM [Category]
        INNER JOIN [CategoryTree] ON [CategoryTree].[Id] = [Category].[ParentCategoryId])
    INSERT INTO #OrderedCategoryIds ([CategoryId])
    SELECT [Category].[Id]
    FROM [CategoryTree]
    RIGHT JOIN [Category] ON [CategoryTree].[Id] = [Category].[Id]

    --filter results
    WHERE [Category].[Deleted] = 0
    AND (@ShowHidden = 1 OR [Category].[Published] = 1)
    AND (@Name IS NULL OR @Name = '' OR [Category].[Name] LIKE ('%' + @Name + '%'))
    AND (@ShowHidden = 1 OR @FilteredCustomerRoleIdsCount  = 0 OR [Category].[SubjectToAcl] = 0
        OR EXISTS (SELECT 1 FROM #FilteredCustomerRoleIds [roles] WHERE [roles].[CustomerRoleId] IN
            (SELECT [acl].[CustomerRoleId] FROM [AclRecord] acl WITH (NOLOCK) WHERE [acl].[EntityId] = [Category].[Id] AND [acl].[EntityName] = 'Category')
        )
    )
    AND (@StoreId = 0 OR [Category].[LimitedToStores] = 0
        OR EXISTS (SELECT 1 FROM [StoreMapping] sm WITH (NOLOCK)
			WHERE [sm].[EntityId] = [Category].[Id] AND [sm].[EntityName] = 'Category' AND [sm].[StoreId] = @StoreId
		)
    )
    ORDER BY ISNULL([CategoryTree].[Order], 1)

    --total records
    SET @TotalRecords = @@ROWCOUNT

    --paging
    SELECT [Category].* FROM #OrderedCategoryIds AS [Result] INNER JOIN [Category] ON [Result].[CategoryId] = [Category].[Id]
    WHERE ([Result].[Id] > @PageSize * @PageIndex AND [Result].[Id] <= @PageSize * (@PageIndex + 1))
    ORDER BY [Result].[Id]

    DROP TABLE #FilteredCustomerRoleIds
    DROP TABLE #OrderedCategoryIds
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteGuests]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteGuests]
(
	@OnlyWithoutShoppingCart bit = 1,
	@CreatedFromUtc datetime,
	@CreatedToUtc datetime,
	@TotalRecordsDeleted int = null OUTPUT
)
AS
BEGIN
	CREATE TABLE #tmp_guests (CustomerId int)
		
	INSERT #tmp_guests (CustomerId)
	SELECT [Id] FROM [Customer] c with (NOLOCK)
	WHERE
	--created from
	((@CreatedFromUtc is null) OR (c.[CreatedOnUtc] > @CreatedFromUtc))
	AND
	--created to
	((@CreatedToUtc is null) OR (c.[CreatedOnUtc] < @CreatedToUtc))
	AND
	--shopping cart items
	((@OnlyWithoutShoppingCart=0) OR (NOT EXISTS(SELECT 1 FROM [ShoppingCartItem] sci with (NOLOCK) inner join [Customer] with (NOLOCK) on sci.[CustomerId]=c.[Id])))
	AND
	--guests only
	(EXISTS(SELECT 1 FROM [Customer_CustomerRole_Mapping] ccrm with (NOLOCK) inner join [Customer] with (NOLOCK) on ccrm.[Customer_Id]=c.[Id] inner join [CustomerRole] cr with (NOLOCK) on cr.[Id]=ccrm.[CustomerRole_Id] WHERE cr.[SystemName] = N'Guests'))
	AND
	--no orders
	(NOT EXISTS(SELECT 1 FROM [Order] o with (NOLOCK) inner join [Customer] with (NOLOCK) on o.[CustomerId]=c.[Id]))
	AND
	--no blog comments
	(NOT EXISTS(SELECT 1 FROM [BlogComment] bc with (NOLOCK) inner join [Customer] with (NOLOCK) on bc.[CustomerId]=c.[Id]))
	AND
	--no news comments
	(NOT EXISTS(SELECT 1 FROM [NewsComment] nc  with (NOLOCK)inner join [Customer] with (NOLOCK) on nc.[CustomerId]=c.[Id]))
	AND
	--no product reviews
	(NOT EXISTS(SELECT 1 FROM [ProductReview] pr with (NOLOCK) inner join [Customer] with (NOLOCK) on pr.[CustomerId]=c.[Id]))
	AND
	--no product reviews helpfulness
	(NOT EXISTS(SELECT 1 FROM [ProductReviewHelpfulness] prh with (NOLOCK) inner join [Customer] with (NOLOCK) on prh.[CustomerId]=c.[Id]))
	AND
	--no poll voting
	(NOT EXISTS(SELECT 1 FROM [PollVotingRecord] pvr with (NOLOCK) inner join [Customer] with (NOLOCK) on pvr.[CustomerId]=c.[Id]))
	AND
	--no forum topics 
	(NOT EXISTS(SELECT 1 FROM [Forums_Topic] ft with (NOLOCK) inner join [Customer] with (NOLOCK) on ft.[CustomerId]=c.[Id]))
	AND
	--no forum posts 
	(NOT EXISTS(SELECT 1 FROM [Forums_Post] fp with (NOLOCK) inner join [Customer] with (NOLOCK) on fp.[CustomerId]=c.[Id]))
	AND
	--no system accounts
	(c.IsSystemAccount = 0)
	
	--delete guests
	DELETE [Customer]
	WHERE [Id] IN (SELECT [CustomerId] FROM #tmp_guests)
	
	--delete attributes
	DELETE [GenericAttribute]
	WHERE ([EntityId] IN (SELECT [CustomerId] FROM #tmp_guests))
	AND
	([KeyGroup] = N'Customer')
	
	--total records
	SELECT @TotalRecordsDeleted = COUNT(1) FROM #tmp_guests
	
	DROP TABLE #tmp_guests
END
GO
/****** Object:  StoredProcedure [dbo].[FullText_Disable]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FullText_Disable]
AS
BEGIN
	EXEC('
	--drop indexes
	IF EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = object_id(''[Product]''))
		DROP FULLTEXT INDEX ON [Product]
	')

	EXEC('
	IF EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = object_id(''[LocalizedProperty]''))
		DROP FULLTEXT INDEX ON [LocalizedProperty]
	')

	EXEC('
	IF EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = object_id(''[ProductTag]''))
		DROP FULLTEXT INDEX ON [ProductTag]
	')

	--drop catalog
	EXEC('
	IF EXISTS (SELECT 1 FROM sys.fulltext_catalogs WHERE [name] = ''nopCommerceFullTextCatalog'')
		DROP FULLTEXT CATALOG [nopCommerceFullTextCatalog]
	')
END
GO
/****** Object:  StoredProcedure [dbo].[FullText_Enable]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FullText_Enable]
AS
BEGIN
	--create catalog
	EXEC('
	IF NOT EXISTS (SELECT 1 FROM sys.fulltext_catalogs WHERE [name] = ''nopCommerceFullTextCatalog'')
		CREATE FULLTEXT CATALOG [nopCommerceFullTextCatalog] AS DEFAULT')
	
	--create indexes
	DECLARE @create_index_text nvarchar(4000)
	SET @create_index_text = '
	IF NOT EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = object_id(''[Product]''))
		CREATE FULLTEXT INDEX ON [Product]([Name], [ShortDescription], [FullDescription])
		KEY INDEX [' + dbo.[nop_getprimarykey_indexname] ('Product') +  '] ON [nopCommerceFullTextCatalog] WITH CHANGE_TRACKING AUTO'
	EXEC(@create_index_text)
	
	SET @create_index_text = '
	IF NOT EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = object_id(''[LocalizedProperty]''))
		CREATE FULLTEXT INDEX ON [LocalizedProperty]([LocaleValue])
		KEY INDEX [' + dbo.[nop_getprimarykey_indexname] ('LocalizedProperty') +  '] ON [nopCommerceFullTextCatalog] WITH CHANGE_TRACKING AUTO'
	EXEC(@create_index_text)

	SET @create_index_text = '
	IF NOT EXISTS (SELECT 1 FROM sys.fulltext_indexes WHERE object_id = object_id(''[ProductTag]''))
		CREATE FULLTEXT INDEX ON [ProductTag]([Name])
		KEY INDEX [' + dbo.[nop_getprimarykey_indexname] ('ProductTag') +  '] ON [nopCommerceFullTextCatalog] WITH CHANGE_TRACKING AUTO'
	EXEC(@create_index_text)
END
GO
/****** Object:  StoredProcedure [dbo].[FullText_IsSupported]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FullText_IsSupported]
AS
BEGIN	
	EXEC('
	SELECT CASE SERVERPROPERTY(''IsFullTextInstalled'')
	WHEN 1 THEN 
		CASE DatabaseProperty (DB_NAME(DB_ID()), ''IsFulltextEnabled'')
		WHEN 1 THEN 1
		ELSE 0
		END
	ELSE 0
	END as Value')
END
GO
/****** Object:  StoredProcedure [dbo].[LanguagePackImport]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LanguagePackImport]
(
	@LanguageId int,
	@XmlPackage xml,
	@UpdateExistingResources bit
)
AS
BEGIN
	IF EXISTS(SELECT * FROM [Language] WHERE [Id] = @LanguageId)
	BEGIN
		CREATE TABLE #LocaleStringResourceTmp
			(
				[LanguageId] [int] NOT NULL,
				[ResourceName] [nvarchar](200) NOT NULL,
				[ResourceValue] [nvarchar](MAX) NOT NULL
			)

		INSERT INTO #LocaleStringResourceTmp (LanguageId, ResourceName, ResourceValue)
		SELECT	@LanguageId, nref.value('@Name', 'nvarchar(200)'), nref.value('Value[1]', 'nvarchar(MAX)')
		FROM	@XmlPackage.nodes('//Language/LocaleResource') AS R(nref)

		DECLARE @ResourceName nvarchar(200)
		DECLARE @ResourceValue nvarchar(MAX)
		DECLARE cur_localeresource CURSOR FOR
		SELECT LanguageId, ResourceName, ResourceValue
		FROM #LocaleStringResourceTmp
		OPEN cur_localeresource
		FETCH NEXT FROM cur_localeresource INTO @LanguageId, @ResourceName, @ResourceValue
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF (EXISTS (SELECT 1 FROM [LocaleStringResource] WHERE LanguageId=@LanguageId AND ResourceName=@ResourceName))
			BEGIN
				IF (@UpdateExistingResources = 1)
				BEGIN
					UPDATE [LocaleStringResource]
					SET [ResourceValue]=@ResourceValue
					WHERE LanguageId=@LanguageId AND ResourceName=@ResourceName
				END
			END
			ELSE 
			BEGIN
				INSERT INTO [LocaleStringResource]
				(
					[LanguageId],
					[ResourceName],
					[ResourceValue]
				)
				VALUES
				(
					@LanguageId,
					@ResourceName,
					@ResourceValue
				)
			END
			
			
			FETCH NEXT FROM cur_localeresource INTO @LanguageId, @ResourceName, @ResourceValue
			END
		CLOSE cur_localeresource
		DEALLOCATE cur_localeresource

		DROP TABLE #LocaleStringResourceTmp
	END
END
GO
/****** Object:  StoredProcedure [dbo].[ProductLoadAllPaged]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProductLoadAllPaged]
(
	@CategoryIds		nvarchar(MAX) = null,	--a list of category IDs (comma-separated list). e.g. 1,2,3
	@ManufacturerId		int = 0,
	@StoreId			int = 0,
	@VendorId			int = 0,
	@WarehouseId		int = 0,
	@ProductTypeId		int = null, --product type identifier, null - load all products
	@VisibleIndividuallyOnly bit = 0, 	--0 - load all products , 1 - "visible indivially" only
	@MarkedAsNewOnly	bit = 0, 	--0 - load all products , 1 - "marked as new" only
	@ProductTagId		int = 0,
	@FeaturedProducts	bit = null,	--0 featured only , 1 not featured only, null - load all products
	@PriceMin			decimal(18, 4) = null,
	@PriceMax			decimal(18, 4) = null,
	@Keywords			nvarchar(4000) = null,
	@SearchDescriptions bit = 0, --a value indicating whether to search by a specified "keyword" in product descriptions
	@SearchManufacturerPartNumber bit = 0, -- a value indicating whether to search by a specified "keyword" in manufacturer part number
	@SearchSku			bit = 0, --a value indicating whether to search by a specified "keyword" in product SKU
	@SearchProductTags  bit = 0, --a value indicating whether to search by a specified "keyword" in product tags
	@UseFullTextSearch  bit = 0,
	@FullTextMode		int = 0, --0 - using CONTAINS with <prefix_term>, 5 - using CONTAINS and OR with <prefix_term>, 10 - using CONTAINS and AND with <prefix_term>
	@FilteredSpecs		nvarchar(MAX) = null,	--filter by specification attribute options (comma-separated list of IDs). e.g. 14,15,16
	@LanguageId			int = 0,
	@OrderBy			int = 0, --0 - position, 5 - Name: A to Z, 6 - Name: Z to A, 10 - Price: Low to High, 11 - Price: High to Low, 15 - creation date
	@AllowedCustomerRoleIds	nvarchar(MAX) = null,	--a list of customer role IDs (comma-separated list) for which a product should be shown (if a subjet to ACL)
	@PageIndex			int = 0, 
	@PageSize			int = 2147483644,
	@ShowHidden			bit = 0,
	@OverridePublished	bit = null, --null - process "Published" property according to "showHidden" parameter, true - load only "Published" products, false - load only "Unpublished" products
	@LoadFilterableSpecificationAttributeOptionIds bit = 0, --a value indicating whether we should load the specification attribute option identifiers applied to loaded products (all pages)
	@FilterableSpecificationAttributeOptionIds nvarchar(MAX) = null OUTPUT, --the specification attribute option identifiers applied to loaded products (all pages). returned as a comma separated list of identifiers
	@TotalRecords		int = null OUTPUT
)
AS
BEGIN
	
	/* Products that filtered by keywords */
	CREATE TABLE #KeywordProducts
	(
		[ProductId] int NOT NULL
	)

	DECLARE
		@SearchKeywords bit,
		@OriginalKeywords nvarchar(4000),
		@sql nvarchar(max),
		@sql_orderby nvarchar(max)

	SET NOCOUNT ON
	
	--filter by keywords
	SET @Keywords = isnull(@Keywords, '')
	SET @Keywords = rtrim(ltrim(@Keywords))
	SET @OriginalKeywords = @Keywords
	IF ISNULL(@Keywords, '') != ''
	BEGIN
		SET @SearchKeywords = 1
		
		IF @UseFullTextSearch = 1
		BEGIN
			--remove wrong chars (' ")
			SET @Keywords = REPLACE(@Keywords, '''', '')
			SET @Keywords = REPLACE(@Keywords, '"', '')
			
			--full-text search
			IF @FullTextMode = 0 
			BEGIN
				--0 - using CONTAINS with <prefix_term>
				SET @Keywords = ' "' + @Keywords + '*" '
			END
			ELSE
			BEGIN
				--5 - using CONTAINS and OR with <prefix_term>
				--10 - using CONTAINS and AND with <prefix_term>

				--clean multiple spaces
				WHILE CHARINDEX('  ', @Keywords) > 0 
					SET @Keywords = REPLACE(@Keywords, '  ', ' ')

				DECLARE @concat_term nvarchar(100)				
				IF @FullTextMode = 5 --5 - using CONTAINS and OR with <prefix_term>
				BEGIN
					SET @concat_term = 'OR'
				END 
				IF @FullTextMode = 10 --10 - using CONTAINS and AND with <prefix_term>
				BEGIN
					SET @concat_term = 'AND'
				END

				--now let's build search string
				declare @fulltext_keywords nvarchar(4000)
				set @fulltext_keywords = N''
				declare @index int		
		
				set @index = CHARINDEX(' ', @Keywords, 0)

				-- if index = 0, then only one field was passed
				IF(@index = 0)
					set @fulltext_keywords = ' "' + @Keywords + '*" '
				ELSE
				BEGIN		
					DECLARE @first BIT
					SET  @first = 1			
					WHILE @index > 0
					BEGIN
						IF (@first = 0)
							SET @fulltext_keywords = @fulltext_keywords + ' ' + @concat_term + ' '
						ELSE
							SET @first = 0

						SET @fulltext_keywords = @fulltext_keywords + '"' + SUBSTRING(@Keywords, 1, @index - 1) + '*"'					
						SET @Keywords = SUBSTRING(@Keywords, @index + 1, LEN(@Keywords) - @index)						
						SET @index = CHARINDEX(' ', @Keywords, 0)
					end
					
					-- add the last field
					IF LEN(@fulltext_keywords) > 0
						SET @fulltext_keywords = @fulltext_keywords + ' ' + @concat_term + ' ' + '"' + SUBSTRING(@Keywords, 1, LEN(@Keywords)) + '*"'	
				END
				SET @Keywords = @fulltext_keywords
			END
		END
		ELSE
		BEGIN
			--usual search by PATINDEX
			SET @Keywords = '%' + @Keywords + '%'
		END
		--PRINT @Keywords

		--product name
		SET @sql = '
		INSERT INTO #KeywordProducts ([ProductId])
		SELECT p.Id
		FROM Product p with (NOLOCK)
		WHERE '
		IF @UseFullTextSearch = 1
			SET @sql = @sql + 'CONTAINS(p.[Name], @Keywords) '
		ELSE
			SET @sql = @sql + 'PATINDEX(@Keywords, p.[Name]) > 0 '


		--localized product name
		SET @sql = @sql + '
		UNION
		SELECT lp.EntityId
		FROM LocalizedProperty lp with (NOLOCK)
		WHERE
			lp.LocaleKeyGroup = N''Product''
			AND lp.LanguageId = ' + ISNULL(CAST(@LanguageId AS nvarchar(max)), '0') + '
			AND lp.LocaleKey = N''Name'''
		IF @UseFullTextSearch = 1
			SET @sql = @sql + ' AND CONTAINS(lp.[LocaleValue], @Keywords) '
		ELSE
			SET @sql = @sql + ' AND PATINDEX(@Keywords, lp.[LocaleValue]) > 0 '
	

		IF @SearchDescriptions = 1
		BEGIN
			--product short description
			SET @sql = @sql + '
			UNION
			SELECT p.Id
			FROM Product p with (NOLOCK)
			WHERE '
			IF @UseFullTextSearch = 1
				SET @sql = @sql + 'CONTAINS(p.[ShortDescription], @Keywords) '
			ELSE
				SET @sql = @sql + 'PATINDEX(@Keywords, p.[ShortDescription]) > 0 '


			--product full description
			SET @sql = @sql + '
			UNION
			SELECT p.Id
			FROM Product p with (NOLOCK)
			WHERE '
			IF @UseFullTextSearch = 1
				SET @sql = @sql + 'CONTAINS(p.[FullDescription], @Keywords) '
			ELSE
				SET @sql = @sql + 'PATINDEX(@Keywords, p.[FullDescription]) > 0 '



			--localized product short description
			SET @sql = @sql + '
			UNION
			SELECT lp.EntityId
			FROM LocalizedProperty lp with (NOLOCK)
			WHERE
				lp.LocaleKeyGroup = N''Product''
				AND lp.LanguageId = ' + ISNULL(CAST(@LanguageId AS nvarchar(max)), '0') + '
				AND lp.LocaleKey = N''ShortDescription'''
			IF @UseFullTextSearch = 1
				SET @sql = @sql + ' AND CONTAINS(lp.[LocaleValue], @Keywords) '
			ELSE
				SET @sql = @sql + ' AND PATINDEX(@Keywords, lp.[LocaleValue]) > 0 '
				

			--localized product full description
			SET @sql = @sql + '
			UNION
			SELECT lp.EntityId
			FROM LocalizedProperty lp with (NOLOCK)
			WHERE
				lp.LocaleKeyGroup = N''Product''
				AND lp.LanguageId = ' + ISNULL(CAST(@LanguageId AS nvarchar(max)), '0') + '
				AND lp.LocaleKey = N''FullDescription'''
			IF @UseFullTextSearch = 1
				SET @sql = @sql + ' AND CONTAINS(lp.[LocaleValue], @Keywords) '
			ELSE
				SET @sql = @sql + ' AND PATINDEX(@Keywords, lp.[LocaleValue]) > 0 '
		END

		--manufacturer part number (exact match)
		IF @SearchManufacturerPartNumber = 1
		BEGIN
			SET @sql = @sql + '
			UNION
			SELECT p.Id
			FROM Product p with (NOLOCK)
			WHERE p.[ManufacturerPartNumber] = @OriginalKeywords '
		END

		--SKU (exact match)
		IF @SearchSku = 1
		BEGIN
			SET @sql = @sql + '
			UNION
			SELECT p.Id
			FROM Product p with (NOLOCK)
			WHERE p.[Sku] = @OriginalKeywords '
		END

		IF @SearchProductTags = 1
		BEGIN
			--product tags (exact match)
			SET @sql = @sql + '
			UNION
			SELECT pptm.Product_Id
			FROM Product_ProductTag_Mapping pptm with(NOLOCK) INNER JOIN ProductTag pt with(NOLOCK) ON pt.Id = pptm.ProductTag_Id
			WHERE pt.[Name] = @OriginalKeywords '

			--localized product tags
			SET @sql = @sql + '
			UNION
			SELECT pptm.Product_Id
			FROM LocalizedProperty lp with (NOLOCK) INNER JOIN Product_ProductTag_Mapping pptm with(NOLOCK) ON lp.EntityId = pptm.ProductTag_Id
			WHERE
				lp.LocaleKeyGroup = N''ProductTag''
				AND lp.LanguageId = ' + ISNULL(CAST(@LanguageId AS nvarchar(max)), '0') + '
				AND lp.LocaleKey = N''Name''
				AND lp.[LocaleValue] = @OriginalKeywords '
		END

		--PRINT (@sql)
		EXEC sp_executesql @sql, N'@Keywords nvarchar(4000), @OriginalKeywords nvarchar(4000)', @Keywords, @OriginalKeywords

	END
	ELSE
	BEGIN
		SET @SearchKeywords = 0
	END

	--filter by category IDs
	SET @CategoryIds = isnull(@CategoryIds, '')	
	CREATE TABLE #FilteredCategoryIds
	(
		CategoryId int not null
	)
	INSERT INTO #FilteredCategoryIds (CategoryId)
	SELECT CAST(data as int) FROM [nop_splitstring_to_table](@CategoryIds, ',')	
	DECLARE @CategoryIdsCount int	
	SET @CategoryIdsCount = (SELECT COUNT(1) FROM #FilteredCategoryIds)

	--filter by customer role IDs (access control list)
	SET @AllowedCustomerRoleIds = isnull(@AllowedCustomerRoleIds, '')	
	CREATE TABLE #FilteredCustomerRoleIds
	(
		CustomerRoleId int not null
	)
	INSERT INTO #FilteredCustomerRoleIds (CustomerRoleId)
	SELECT CAST(data as int) FROM [nop_splitstring_to_table](@AllowedCustomerRoleIds, ',')
	DECLARE @FilteredCustomerRoleIdsCount int	
	SET @FilteredCustomerRoleIdsCount = (SELECT COUNT(1) FROM #FilteredCustomerRoleIds)
	
	--paging
	DECLARE @PageLowerBound int
	DECLARE @PageUpperBound int
	DECLARE @RowsToReturn int
	SET @RowsToReturn = @PageSize * (@PageIndex + 1)	
	SET @PageLowerBound = @PageSize * @PageIndex
	SET @PageUpperBound = @PageLowerBound + @PageSize + 1
	
	CREATE TABLE #DisplayOrderTmp 
	(
		[Id] int IDENTITY (1, 1) NOT NULL,
		[ProductId] int NOT NULL
	)

	SET @sql = '
	SELECT p.Id
	FROM
		Product p with (NOLOCK)'
	
	IF @CategoryIdsCount > 0
	BEGIN
		SET @sql = @sql + '
		INNER JOIN Product_Category_Mapping pcm with (NOLOCK)
			ON p.Id = pcm.ProductId'
	END
	
	IF @ManufacturerId > 0
	BEGIN
		SET @sql = @sql + '
		INNER JOIN Product_Manufacturer_Mapping pmm with (NOLOCK)
			ON p.Id = pmm.ProductId'
	END
	
	IF ISNULL(@ProductTagId, 0) != 0
	BEGIN
		SET @sql = @sql + '
		INNER JOIN Product_ProductTag_Mapping pptm with (NOLOCK)
			ON p.Id = pptm.Product_Id'
	END
	
	--searching by keywords
	IF @SearchKeywords = 1
	BEGIN
		SET @sql = @sql + '
		JOIN #KeywordProducts kp
			ON  p.Id = kp.ProductId'
	END
	
	SET @sql = @sql + '
	WHERE
		p.Deleted = 0'
	
	--filter by category
	IF @CategoryIdsCount > 0
	BEGIN
		SET @sql = @sql + '
		AND pcm.CategoryId IN ('
		
		SET @sql = @sql + + CAST(@CategoryIds AS nvarchar(max))

		SET @sql = @sql + ')'

		IF @FeaturedProducts IS NOT NULL
		BEGIN
			SET @sql = @sql + '
		AND pcm.IsFeaturedProduct = ' + CAST(@FeaturedProducts AS nvarchar(max))
		END
	END
	
	--filter by manufacturer
	IF @ManufacturerId > 0
	BEGIN
		SET @sql = @sql + '
		AND pmm.ManufacturerId = ' + CAST(@ManufacturerId AS nvarchar(max))
		
		IF @FeaturedProducts IS NOT NULL
		BEGIN
			SET @sql = @sql + '
		AND pmm.IsFeaturedProduct = ' + CAST(@FeaturedProducts AS nvarchar(max))
		END
	END
	
	--filter by vendor
	IF @VendorId > 0
	BEGIN
		SET @sql = @sql + '
		AND p.VendorId = ' + CAST(@VendorId AS nvarchar(max))
	END
	
	--filter by warehouse
	IF @WarehouseId > 0
	BEGIN
		--we should also ensure that 'ManageInventoryMethodId' is set to 'ManageStock' (1)
		--but we skip it in order to prevent hard-coded values (e.g. 1) and for better performance
		SET @sql = @sql + '
		AND  
			(
				(p.UseMultipleWarehouses = 0 AND
					p.WarehouseId = ' + CAST(@WarehouseId AS nvarchar(max)) + ')
				OR
				(p.UseMultipleWarehouses > 0 AND
					EXISTS (SELECT 1 FROM ProductWarehouseInventory [pwi]
					WHERE [pwi].WarehouseId = ' + CAST(@WarehouseId AS nvarchar(max)) + ' AND [pwi].ProductId = p.Id))
			)'
	END
	
	--filter by product type
	IF @ProductTypeId is not null
	BEGIN
		SET @sql = @sql + '
		AND p.ProductTypeId = ' + CAST(@ProductTypeId AS nvarchar(max))
	END
	
	--filter by "visible individually"
	IF @VisibleIndividuallyOnly = 1
	BEGIN
		SET @sql = @sql + '
		AND p.VisibleIndividually = 1'
	END
	
	--filter by "marked as new"
	IF @MarkedAsNewOnly = 1
	BEGIN
		SET @sql = @sql + '
		AND p.MarkAsNew = 1
		AND (getutcdate() BETWEEN ISNULL(p.MarkAsNewStartDateTimeUtc, ''1/1/1900'') and ISNULL(p.MarkAsNewEndDateTimeUtc, ''1/1/2999''))'
	END
	
	--filter by product tag
	IF ISNULL(@ProductTagId, 0) != 0
	BEGIN
		SET @sql = @sql + '
		AND pptm.ProductTag_Id = ' + CAST(@ProductTagId AS nvarchar(max))
	END
	
	--"Published" property
	IF (@OverridePublished is null)
	BEGIN
		--process according to "showHidden"
		IF @ShowHidden = 0
		BEGIN
			SET @sql = @sql + '
			AND p.Published = 1'
		END
	END
	ELSE IF (@OverridePublished = 1)
	BEGIN
		--published only
		SET @sql = @sql + '
		AND p.Published = 1'
	END
	ELSE IF (@OverridePublished = 0)
	BEGIN
		--unpublished only
		SET @sql = @sql + '
		AND p.Published = 0'
	END
	
	--show hidden
	IF @ShowHidden = 0
	BEGIN
		SET @sql = @sql + '
		AND p.Deleted = 0
		AND (getutcdate() BETWEEN ISNULL(p.AvailableStartDateTimeUtc, ''1/1/1900'') and ISNULL(p.AvailableEndDateTimeUtc, ''1/1/2999''))'
	END
	
	--min price
	IF @PriceMin is not null
	BEGIN
		SET @sql = @sql + '
		AND (p.Price >= ' + CAST(@PriceMin AS nvarchar(max)) + ')'
	END
	
	--max price
	IF @PriceMax is not null
	BEGIN
		SET @sql = @sql + '
		AND (p.Price <= ' + CAST(@PriceMax AS nvarchar(max)) + ')'
	END
	
	--show hidden and ACL
	IF  @ShowHidden = 0 and @FilteredCustomerRoleIdsCount > 0
	BEGIN
		SET @sql = @sql + '
		AND (p.SubjectToAcl = 0 OR EXISTS (
			SELECT 1 FROM #FilteredCustomerRoleIds [fcr]
			WHERE
				[fcr].CustomerRoleId IN (
					SELECT [acl].CustomerRoleId
					FROM [AclRecord] acl with (NOLOCK)
					WHERE [acl].EntityId = p.Id AND [acl].EntityName = ''Product''
				)
			))'
	END
	
	--filter by store
	IF @StoreId > 0
	BEGIN
		SET @sql = @sql + '
		AND (p.LimitedToStores = 0 OR EXISTS (
			SELECT 1 FROM [StoreMapping] sm with (NOLOCK)
			WHERE [sm].EntityId = p.Id AND [sm].EntityName = ''Product'' and [sm].StoreId=' + CAST(@StoreId AS nvarchar(max)) + '
			))'
	END
	
    --prepare filterable specification attribute option identifier (if requested)
    IF @LoadFilterableSpecificationAttributeOptionIds = 1
	BEGIN		
		CREATE TABLE #FilterableSpecs 
		(
			[SpecificationAttributeOptionId] int NOT NULL
		)
        DECLARE @sql_filterableSpecs nvarchar(max)
        SET @sql_filterableSpecs = '
	        INSERT INTO #FilterableSpecs ([SpecificationAttributeOptionId])
	        SELECT DISTINCT [psam].SpecificationAttributeOptionId
	        FROM [Product_SpecificationAttribute_Mapping] [psam] WITH (NOLOCK)
	            WHERE [psam].[AllowFiltering] = 1
	            AND [psam].[ProductId] IN (' + @sql + ')'

        EXEC sp_executesql @sql_filterableSpecs

		--build comma separated list of filterable identifiers
		SELECT @FilterableSpecificationAttributeOptionIds = COALESCE(@FilterableSpecificationAttributeOptionIds + ',' , '') + CAST(SpecificationAttributeOptionId as nvarchar(4000))
		FROM #FilterableSpecs

		DROP TABLE #FilterableSpecs
 	END

	--filter by specification attribution options
	SET @FilteredSpecs = isnull(@FilteredSpecs, '')	
	CREATE TABLE #FilteredSpecs
	(
		SpecificationAttributeOptionId int not null
	)
	INSERT INTO #FilteredSpecs (SpecificationAttributeOptionId)
	SELECT CAST(data as int) FROM [nop_splitstring_to_table](@FilteredSpecs, ',') 

    CREATE TABLE #FilteredSpecsWithAttributes
	(
        SpecificationAttributeId int not null,
		SpecificationAttributeOptionId int not null
	)
	INSERT INTO #FilteredSpecsWithAttributes (SpecificationAttributeId, SpecificationAttributeOptionId)
	SELECT sao.SpecificationAttributeId, fs.SpecificationAttributeOptionId
    FROM #FilteredSpecs fs INNER JOIN SpecificationAttributeOption sao ON sao.Id = fs.SpecificationAttributeOptionId
    ORDER BY sao.SpecificationAttributeId 

    DECLARE @SpecAttributesCount int	
	SET @SpecAttributesCount = (SELECT COUNT(1) FROM #FilteredSpecsWithAttributes)
	IF @SpecAttributesCount > 0
	BEGIN
		--do it for each specified specification option
		DECLARE @SpecificationAttributeOptionId int
        DECLARE @SpecificationAttributeId int
        DECLARE @LastSpecificationAttributeId int
        SET @LastSpecificationAttributeId = 0
		DECLARE cur_SpecificationAttributeOption CURSOR FOR
		SELECT SpecificationAttributeId, SpecificationAttributeOptionId
		FROM #FilteredSpecsWithAttributes

		OPEN cur_SpecificationAttributeOption
        FOREACH:
            FETCH NEXT FROM cur_SpecificationAttributeOption INTO @SpecificationAttributeId, @SpecificationAttributeOptionId
            IF (@LastSpecificationAttributeId <> 0 AND @SpecificationAttributeId <> @LastSpecificationAttributeId OR @@FETCH_STATUS <> 0) 
			    SET @sql = @sql + '
        AND p.Id in (select psam.ProductId from [Product_SpecificationAttribute_Mapping] psam with (NOLOCK) where psam.AllowFiltering = 1 and psam.SpecificationAttributeOptionId IN (SELECT SpecificationAttributeOptionId FROM #FilteredSpecsWithAttributes WHERE SpecificationAttributeId = ' + CAST(@LastSpecificationAttributeId AS nvarchar(max)) + '))'
            SET @LastSpecificationAttributeId = @SpecificationAttributeId
		IF @@FETCH_STATUS = 0 GOTO FOREACH
		CLOSE cur_SpecificationAttributeOption
		DEALLOCATE cur_SpecificationAttributeOption
	END

	--sorting
	SET @sql_orderby = ''	
	IF @OrderBy = 5 /* Name: A to Z */
		SET @sql_orderby = ' p.[Name] ASC'
	ELSE IF @OrderBy = 6 /* Name: Z to A */
		SET @sql_orderby = ' p.[Name] DESC'
	ELSE IF @OrderBy = 10 /* Price: Low to High */
		SET @sql_orderby = ' p.[Price] ASC'
	ELSE IF @OrderBy = 11 /* Price: High to Low */
		SET @sql_orderby = ' p.[Price] DESC'
	ELSE IF @OrderBy = 15 /* creation date */
		SET @sql_orderby = ' p.[CreatedOnUtc] DESC'
	ELSE /* default sorting, 0 (position) */
	BEGIN
		--category position (display order)
		IF @CategoryIdsCount > 0 SET @sql_orderby = ' pcm.DisplayOrder ASC'
		
		--manufacturer position (display order)
		IF @ManufacturerId > 0
		BEGIN
			IF LEN(@sql_orderby) > 0 SET @sql_orderby = @sql_orderby + ', '
			SET @sql_orderby = @sql_orderby + ' pmm.DisplayOrder ASC'
		END
		
		--name
		IF LEN(@sql_orderby) > 0 SET @sql_orderby = @sql_orderby + ', '
		SET @sql_orderby = @sql_orderby + ' p.[Name] ASC'
	END
	
	SET @sql = @sql + '
	ORDER BY' + @sql_orderby
	
    SET @sql = '
    INSERT INTO #DisplayOrderTmp ([ProductId])' + @sql

	--PRINT (@sql)
	EXEC sp_executesql @sql

	DROP TABLE #FilteredCategoryIds
	DROP TABLE #FilteredSpecs
    DROP TABLE #FilteredSpecsWithAttributes
	DROP TABLE #FilteredCustomerRoleIds
	DROP TABLE #KeywordProducts

	CREATE TABLE #PageIndex 
	(
		[IndexId] int IDENTITY (1, 1) NOT NULL,
		[ProductId] int NOT NULL
	)
	INSERT INTO #PageIndex ([ProductId])
	SELECT ProductId
	FROM #DisplayOrderTmp
	GROUP BY ProductId
	ORDER BY min([Id])

	--total records
	SET @TotalRecords = @@rowcount
	
	DROP TABLE #DisplayOrderTmp

	--return products
	SELECT TOP (@RowsToReturn)
		p.*
	FROM
		#PageIndex [pi]
		INNER JOIN Product p with (NOLOCK) on p.Id = [pi].[ProductId]
	WHERE
		[pi].IndexId > @PageLowerBound AND 
		[pi].IndexId < @PageUpperBound
	ORDER BY
		[pi].IndexId
	
	DROP TABLE #PageIndex
END
GO
/****** Object:  StoredProcedure [dbo].[ProductTagCountLoadAll]    Script Date: 11/14/2018 10:13:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProductTagCountLoadAll]
(
	@StoreId int
)
AS
BEGIN
	SET NOCOUNT ON
	
	SELECT pt.Id as [ProductTagId], COUNT(p.Id) as [ProductCount]
	FROM ProductTag pt with (NOLOCK)
	LEFT JOIN Product_ProductTag_Mapping pptm with (NOLOCK) ON pt.[Id] = pptm.[ProductTag_Id]
	LEFT JOIN Product p with (NOLOCK) ON pptm.[Product_Id] = p.[Id]
	WHERE
		p.[Deleted] = 0
		AND p.Published = 1
		AND (@StoreId = 0 or (p.LimitedToStores = 0 OR EXISTS (
			SELECT 1 FROM [StoreMapping] sm with (NOLOCK)
			WHERE [sm].EntityId = p.Id AND [sm].EntityName = 'Product' and [sm].StoreId=@StoreId
			)))
	GROUP BY pt.Id
	ORDER BY pt.Id
END
GO
USE [master]
GO
ALTER DATABASE [nop] SET  READ_WRITE 
GO
