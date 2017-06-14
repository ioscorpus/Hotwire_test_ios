// Generated by Apple Swift version 3.0.1 (swiftlang-800.0.58.6 clang-800.0.42.1)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if defined(__has_attribute) && __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if defined(__has_feature) && __has_feature(modules)
@import ObjectiveC;
@import Foundation;
@import UIKit;
@import WebKit;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
/**
  The login environment to use when logging in.
  <ul>
    <li>
      Staging:    The staging environment
    </li>
    <li>
      Production: The production environment
    </li>
  </ul>
*/
typedef SWIFT_ENUM(NSInteger, CIDLoginEnvironment) {
  CIDLoginEnvironmentCi = 0,
  CIDLoginEnvironmentStaging = 1,
  CIDLoginEnvironmentProduction = 2,
};

@class NSError;
@class CIDCloudIdConfig;
@class CIDUser;
@class CIDProvider;
@class CIDLoginViewController;
@protocol CIDCloudIdDelegate;

/**
  The CloudId class provides the API related to logging in a user and retrieving lists
  of available providers.
  This class is the entry point for all CloudId-related operations
  within this SDK. To use this class, simply instantiate an instance of it with a provided
  \code
  CloudIdConfig
  \endcode object.
  To retrieve a list of \code
  Provider
  \endcodes, use the \code
  loadProvidersWithCallback(_:)
  \endcode method.
  To begin the login process for a particular \code
  Provider
  \endcode, simply submit that provider
  to the \code
  loginControllerForProvider(_:)
  \endcode method to retrieve a \code
  LoginViewController
  \endcode that
  can be used to log in a user.
  If you have configured a specific identity provider in the configuration object, you may
  use the \code
  loginControllerForConfiguredIdentityProvider()
  \endcode method to retrieve a
  \code
  LoginViewController
  \endcode capable of logging in a user to the configured provider.
  See the \code
  checkKeychain()
  \endcode and \code
  clearKeychain()
  \endcode methods for more information related
  to persisting logins and keychain sharing, for sharing login information across applications
  signed by the same developer.
  seealso:
  \code
  CloudIdDelegate
  \endcode
*/
SWIFT_CLASS_NAMED("CloudId")
@interface CIDCloudId : NSObject
/**
  Construct a new CloudId instance with a URL to a given CloudIdConfig file.
  seealso:
  \code
  CloudIdConfig.newInstanceWithConfigAtUrl(_:callback:)
  \endcode
  \param url The URL to the \code
  CloudIdConfig
  \endcode file

  \param callback The callback to invoke on the main thread when the configuration is loaded

*/
+ (void)newInstanceWithConfigAtUrl:(NSURL * _Nonnull)url callback:(void (^ _Nonnull)(CIDCloudId * _Nullable, NSError * _Nullable))callback;
/**
  The CloudIdConfig object that configured this CloudId instance
*/
@property (nonatomic, readonly, strong) CIDCloudIdConfig * _Nonnull config;
/**
  The CloudIdDelegate that will listen to various login-related events
*/
@property (nonatomic, weak) id <CIDCloudIdDelegate> _Nullable delegate;
/**
  Construct a new CloudId instance with a sample configuration.

  returns:
  A new \code
  CloudId
  \endcode instance
*/
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
/**
  Construct a new CloudId instance with the given configuration.

  returns:
  A new \code
  CloudId
  \endcode instance
*/
- (nonnull instancetype)initWithConfig:(CIDCloudIdConfig * _Nonnull)config OBJC_DESIGNATED_INITIALIZER;
/**
  Check the keychain for an existing user, if the configuration allows for it. This will
  inform the delegate of the current state of the keychain, allowing you to bypass the login
  process entirely.
  seealso:
  \code
  CloudIdConfig
  \endcode
*/
- (void)checkKeychainWithCallback:(void (^ _Nonnull)(CIDUser * _Nullable, CIDProvider * _Nullable, NSError * _Nullable))callback;
/**
  Clear the keychain of any existing user login information for all apps that share this keychain,
  if the configuration allows for it. The behaviour of finding no user in the keychain (after finding
  one earlier) is up to the user of this SDK. It might be the case that the user wanted to log out
  everywhere.
  seealso:
  \code
  CloudIdConfig
  \endcode
*/
- (void)clearKeychain;
/**
  Load the list of providers and inform the caller on the main thread via the given callback.
  Where the \code
  CloudId
  \endcode instance retrieves the \code
  Provider
  \endcodes is based on the \code
  CloudIdConfig
  \endcode.
  \param callback The callback to deliver the retrieved \code
  Provider
  \endcodes

*/
- (void)loadProvidersWithCallback:(void (^ _Nonnull)(NSArray<CIDProvider *> * _Nullable, NSError * _Nullable))callback;
/**
  Retrieve a login view controller for the configured identity provider. If no identity proider is configured,
  this function returns \code
  nil
  \endcode and will log an error. If the identity provider information can be parsed,
  a valid \code
  LoginViewController
  \endcode instance will be returned to you.

  returns:
  A \code
  LoginViewController
  \endcode instance, or \code
  nil
  \endcode if an error occurred.
*/
- (CIDLoginViewController * _Nullable)loginControllerForConfiguredIdentityProvider;
/**
  Retrieve a view controller capable of continuing the login process for the given provider.
  seealso:
  \code
  LoginViewController
  \endcode
  \param provider The \code
  Provider
  \endcode instance to login for


  returns:
  A \code
  LoginViewController
  \endcode that can be displayed in any manner of your choosing
*/
- (CIDLoginViewController * _Nullable)loginControllerForProvider:(CIDProvider * _Nonnull)provider;
@end


@interface CIDCloudId (SWIFT_EXTENSION(SynacorCloudId))
@end


/**
  The CloudIdConfig class represents the configuration state of any given CloudId instance. This class encapsulated
  all configurable behaviour of a \code
  CloudId
  \endcode instance, including keychain access settings, and client endpoint URL
  settings.
*/
SWIFT_CLASS_NAMED("CloudIdConfig")
@interface CIDCloudIdConfig : NSObject
/**
  Construct a new CloudIdConfig instance with a URL to a given configuration file.
  seealso:
  \code
  CloudId.newInstanceWithConfigAtUrl(_:callback:)
  \endcode
  \param url The URL of the configuarion file to load

  \param callback The callback to invoke after loading the configuration file

*/
+ (void)newInstanceWithConfigAtUrl:(NSURL * _Nonnull)url callback:(void (^ _Nonnull)(CIDCloudIdConfig * _Nullable, NSError * _Nullable))callback;
/**
  The client endpoint name
  Config key: “client”
*/
@property (nonatomic, copy) NSString * _Nonnull client;
/**
  The optional identity provider token. If this is provided,
  you may call \code
  loginControllerForIdentityProvider
  \endcode on the \code
  CloudId
  \endcode
  instance to begin logging in.
  Config key: “identity_provider”
*/
@property (nonatomic, copy) NSString * _Nullable identityProvider;
/**
  The login environment
  Config key: “login_environment”
*/
@property (nonatomic) enum CIDLoginEnvironment loginEnvironment;
/**
  The keychain service to use
  Set to \code
  nil
  \endcode to disable keychain sharing.
  Config key: “keychain_service”
*/
@property (nonatomic, copy) NSString * _Nullable keychainService;
/**
  The keychain access group to use
  It is recommended that you leave this \code
  nil
  \endcode, and let the \code
  CloudId
  \endcode instance
  instead refer to the default access group in your entitlements plist.
  Config key: “keychain_access_group”
*/
@property (nonatomic, copy) NSString * _Nullable keychainAccessGroup;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
/**
  Construct a new CloudIdConfig with the given client and providers URL.
  \param client The client endpoint name

  \param providersUrl The providers URL


  returns:
  A new \code
  CloudIdConfig
  \endcode instance
*/
- (nonnull instancetype)initWithClient:(NSString * _Nonnull)client OBJC_DESIGNATED_INITIALIZER;
/**
  Construct a new CloudIdConfig with the given client and identity token.
  \param client The client endpoint name

  \param identityProvider The identity provider


  returns:
  A new \code
  CloudIdConfig
  \endcode instance
*/
- (nonnull instancetype)initWithClient:(NSString * _Nonnull)client identityProvider:(NSString * _Nonnull)identityProvider OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithData:(NSData * _Nonnull)data;
@end


@interface CIDCloudIdConfig (SWIFT_EXTENSION(SynacorCloudId))
@end


@interface CIDCloudIdConfig (SWIFT_EXTENSION(SynacorCloudId))
@end


@interface CIDCloudIdConfig (SWIFT_EXTENSION(SynacorCloudId))
@end


@interface CIDCloudIdConfig (SWIFT_EXTENSION(SynacorCloudId)) <NSCopying>
- (id _Nonnull)copyWithZone:(struct _NSZone * _Nullable)zone;
@end


/**
  The CloudIdDelegate protocol defines methods related to events that occur within an instance of CloudId.
*/
SWIFT_PROTOCOL_NAMED("CloudIdDelegate")
@protocol CIDCloudIdDelegate
/**
  Callback invoked when the login process for a user has completed successfully.
  \param cloudId The \code
  CloudId
  \endcode instance

  \param user The \code
  User
  \endcode object that represents the successfully logged-in user

  \param provider The \code
  Provider
  \endcode instance that the user used to log in to

*/
- (void)cloudId:(CIDCloudId * _Nonnull)cloudId didLogInUser:(CIDUser * _Nonnull)user forProvider:(CIDProvider * _Nonnull)provider;
@optional
/**
  Callback invoked when a successful login has been performed, and keychain sharing is set up. This
  allows the user of the SDK to optionally store the \code
  User
  \endcode and \code
  Provider
  \endcode in the keychain. The default
  behaviour is to store the user.
  \param cloudId The \code
  CloudId
  \endcode instance

  \param user The \code
  User
  \endcode object

  \param provider The associated \code
  Provider
  \endcode object


  returns:
  \code
  true
  \endcode to store the user, \code
  false
  \endcode otherwise
*/
- (BOOL)cloudId:(CIDCloudId * _Nonnull)cloudId keychainShouldSaveUser:(CIDUser * _Nonnull)user forProvider:(CIDProvider * _Nonnull)provider;
/**
  Callback invoked when a CloudId instance encountered an error.
  \param cloudId The \code
  CloudId
  \endcode instance

  \param error The error that occurred

*/
- (void)cloudId:(CIDCloudId * _Nonnull)cloudId didEncounterError:(NSError * _Nonnull)error;
@end

@class UINavigationController;
@protocol CIDLoginViewControllerDelegate;
@class NSBundle;
@class NSCoder;

/**
  The view controller class capable of logging in a user for a given provider.
  Dismissal of this controller should be controlled via the \code
  LoginViewControllerDelegate
  \endcode.
  seealso:
  LoginViewControllerDelegate
*/
SWIFT_CLASS_NAMED("LoginViewController")
@interface CIDLoginViewController : UIViewController
/**
  The delegate of this view controller
*/
@property (nonatomic, weak) id <CIDLoginViewControllerDelegate> _Nullable delegate;
- (void)viewDidLoad;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)observeValueForKeyPath:(NSString * _Nullable)keyPath ofObject:(id _Nullable)object change:(NSDictionary<NSKeyValueChangeKey, id> * _Nullable)change context:(void * _Nullable)context;
/**
  Embed this view controller in a suitable navigation controller to give us a navigation bar.

  returns:
  A \code
  UINavigationController
  \endcode
*/
- (UINavigationController * _Nonnull)embedInNavigationController;
/**
  The Provider the login controller is attempting to log in to
*/
@property (nonatomic, readonly, strong) CIDProvider * _Nonnull provider;
/**
  Settable boolean indicating whether or not the progress bar should be hidden
*/
@property (nonatomic) BOOL progressBarHidden;
- (nonnull instancetype)initWithNibName:(NSString * _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

@class WKWebView;
@class WKNavigationAction;
@class WKNavigation;
@class WKWebViewConfiguration;
@class WKWindowFeatures;

@interface CIDLoginViewController (SWIFT_EXTENSION(SynacorCloudId)) <WKNavigationDelegate, WKUIDelegate>
- (void)webView:(WKWebView * _Nonnull)webView decidePolicyForNavigationAction:(WKNavigationAction * _Nonnull)navigationAction decisionHandler:(void (^ _Nonnull)(WKNavigationActionPolicy))decisionHandler;
- (void)webView:(WKWebView * _Nonnull)webView didFailProvisionalNavigation:(WKNavigation * _Null_unspecified)navigation withError:(NSError * _Nonnull)error;
- (WKWebView * _Nullable)webView:(WKWebView * _Nonnull)webView createWebViewWithConfiguration:(WKWebViewConfiguration * _Nonnull)configuration forNavigationAction:(WKNavigationAction * _Nonnull)navigationAction windowFeatures:(WKWindowFeatures * _Nonnull)windowFeatures;
@end


/**
  The LoginViewControllerDelegate defines methods related to the login process of the
  LoginViewController.
*/
SWIFT_PROTOCOL_NAMED("LoginViewControllerDelegate")
@protocol CIDLoginViewControllerDelegate
/**
  Callback invoked when the LoginViewController successfully logged a user in. You should
  dismiss/remove the view controller at this point.
  \param viewController The \code
  LoginViewController
  \endcode instance

*/
- (void)loginViewControllerDidCompleteLogin:(CIDLoginViewController * _Nonnull)viewController;
/**
  Callback invoked when the LoginViewController was requested to cancel the login via user interaction.
  You should dismiss/remove the view controller at this point.
  \param viewController The \code
  LoginViewController
  \endcode instance

*/
- (void)loginViewControllerDidPressCancelButton:(CIDLoginViewController * _Nonnull)viewController;
@optional
/**
  Callback invoked when the internal webview of the login view controller has its loading progress changed.
  \param viewController The \code
  LoginViewController
  \endcode instance

  \param progressPercentage The progress percentage (0.0 -> 1.0)

*/
- (void)loginViewController:(CIDLoginViewController * _Nonnull)viewController webViewProgressDidChange:(float)progressPercentage;
/**
  Callback invoked when the LoginViewController encountered an error. This error is not necessarily fatal.
  \param viewController The \code
  LoginViewController
  \endcode instance

  \param error The error that occurred

*/
- (void)loginViewController:(CIDLoginViewController * _Nonnull)viewController didEncounterError:(NSError * _Nonnull)error;
@end


@interface NSNumber (SWIFT_EXTENSION(SynacorCloudId))
@end


/**
  The Provider class represents an identity provider, which can be used to log in a user.
  This class simply encapuses a dictionary of key-value pairs that make up the metadata of
  the \code
  Provider
  \endcode. Retrieve additional fields not typed by accessing the \code
  rawDictionary
  \endcode object,
  or by deserializing the \code
  rawData
  \endcode object into a JSON string.
*/
SWIFT_CLASS_NAMED("Provider")
@interface CIDProvider : NSObject
/**
  The raw data this Provider encapsulates
*/
@property (nonatomic, readonly, copy) NSData * _Nonnull rawData;
/**
  The raw key-value pairs this Provider encapsulates
*/
@property (nonatomic, readonly, copy) NSDictionary<NSString *, id> * _Nonnull rawDictionary;
/**
  The Provider’s name
*/
@property (nonatomic, readonly, copy) NSString * _Nullable name;
/**
  The Provider’s token
*/
@property (nonatomic, readonly, copy) NSString * _Nullable token;
/**
  The Provider’s logo image URL
*/
@property (nonatomic, readonly, copy) NSURL * _Nullable logoUrl;
/**
  A boolean indicating whether or not the Provider is enabled
*/
@property (nonatomic, readonly) BOOL isEnabled;
/**
  A boolean indicating whether or not the Provider is featured
*/
@property (nonatomic, readonly) BOOL isFeatured;
- (id _Nullable)objectForKeyedSubscript:(NSString * _Nonnull)key;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface CIDProvider (SWIFT_EXTENSION(SynacorCloudId)) <NSCopying>
- (id _Nonnull)copyWithZone:(struct _NSZone * _Nullable)zone;
@end


@interface CIDProvider (SWIFT_EXTENSION(SynacorCloudId))
@end


@interface CIDProvider (SWIFT_EXTENSION(SynacorCloudId))
/**
  Construct a Provider instance from a previously serialized provider. The value passed to this
  initializer must have been returned by \code
  serializeToData()
  \endcode.
  seealso:
  \code
  serializeToData()
  \endcode
  \param data The data to construct the \code
  Provider
  \endcode from


  returns:
  A new \code
  Provider
  \endcode instance
*/
- (nullable instancetype)initWithData:(NSData * _Nonnull)data;
/**
  Serialize the Provider to data. This data can be persisted to disk, and the later used with
  the \code
  init(data:)
  \endcode initializer to reconstruct the \code
  Provider
  \endcode.
  seealso:
  \code
  init(data:)
  \endcode

  returns:
  The \code
  Provider
  \endcode, serialized to data
*/
- (NSData * _Nonnull)serializeToData;
@end


/**
  The User class represents the most recent state of a successfully logged-in user.
  This class simply encapsulates an Oauth callback URL to facilitate easy property
  access. Use \code
  userValueForKey(_:)
  \endcode to retrieve additional values that aren’t already
  typed, or simply access the \code
  rawDataUrlString
  \endcode yourself.
*/
SWIFT_CLASS_NAMED("User")
@interface CIDUser : NSObject
/**
  The raw URL string returned when logging in
*/
@property (nonatomic, readonly, copy) NSString * _Nonnull rawDataUrlString;
/**
  The user’s ID
*/
@property (nonatomic, readonly, copy) NSString * _Nullable userId;
/**
  The user’s auth z token
*/
@property (nonatomic, readonly, copy) NSString * _Nullable authZToken;
/**
  The user’s email address
*/
@property (nonatomic, readonly, copy) NSString * _Nullable email;
/**
  The user’s postal code
*/
@property (nonatomic, readonly, copy) NSString * _Nullable postalCode;
/**
  The user’s household ID
*/
@property (nonatomic, readonly, copy) NSString * _Nullable householdId;
/**
  A boolean indicating whether or not the user is the head of the household
*/
@property (nonatomic, readonly) BOOL isHeadOfHousehold;
/**
  A boolean indicating whether or not the user selected “remember me” when logging in
*/
@property (nonatomic, readonly) BOOL rememberMe;
/**
  The user’s channel lineup
*/
@property (nonatomic, readonly, copy) NSArray<NSString *> * _Nonnull channelLineup;
/**
  Retrieve a value for the given key based on the user’s query-string parameters.
  seealso:
  The subscript operates identically to this call
  \param key The key to lookup


  returns:
  The value for the given key, if it exists
*/
- (NSString * _Nullable)userValueForKey:(NSString * _Nonnull)key;
- (NSString * _Nullable)objectForKeyedSubscript:(NSString * _Nonnull)key;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface CIDUser (SWIFT_EXTENSION(SynacorCloudId)) <NSCopying>
- (id _Nonnull)copyWithZone:(struct _NSZone * _Nullable)zone;
@end


@interface CIDUser (SWIFT_EXTENSION(SynacorCloudId))
/**
  Construct a User instance from a previously serialized user. The value passed to this
  initializer must have been returned by \code
  serializeToData()
  \endcode.
  seealso:
  \code
  serializeToData()
  \endcode
  \param data The data to construct the \code
  User
  \endcode from


  returns:
  A new \code
  User
  \endcode instance
*/
- (nonnull instancetype)initWithData:(NSData * _Nonnull)data;
/**
  Serialize the User to data. This data can be persisted to disk, and the later used with
  the \code
  init(data:)
  \endcode initializer to reconstruct the \code
  User
  \endcode.
  seealso:
  \code
  init(data:)
  \endcode

  returns:
  The \code
  User
  \endcode, serialized to data
*/
- (NSData * _Nonnull)serializeToData;
@end


@interface CIDUser (SWIFT_EXTENSION(SynacorCloudId))
@end

#pragma clang diagnostic pop
