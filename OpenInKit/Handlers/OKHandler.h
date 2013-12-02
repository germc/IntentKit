NSString *(^urlEncode)(NSString *);

/** `OKHandler` is the base class for shared groups of behavior for a class of third-party applications. You cannot use the `OKHandler` class directly. It instead defines the common interface and behavioral structure for all its subclasses.

 ## Subclassing Notes

 If you are defining URL schemes for a new discrete class of third-party applications (such as "web browsers" or "mapping applications", you may want to create your own `OKHandler` subclass.
 
 - Create a directory to store plist and image files, and add it to the project in Xcode. Select "Create folder reference for any added folders" when adding it, and then confirm the entire folder is included in the "Copy Bundle Resources" phase of the `OpenInKit` target.
 
 - Override directoryName with the name of your folder.
 
 - All custom methods you create that perform actions should ultimately return a UIActivityController created by calling performCommand:withArguments:. */
@interface OKHandler : NSObject

/** This method is a no-op by default. You should override it in your custom subclass.
    @return A NSString with the name of a directory inside the resource path where all of the subclass's resources may be found. */
+ (NSString *)directoryName;

/**
Opens a third-party application to perform some task.
 
 If there is only one application installed that can respond to that command, it will open that app with the correct URL.
 Otherwise, it will create a `UIActivityViewController` to prompt the user to pick an app.

 @param command The name of a command to perform, corresponding with keys in each application's plist.
 @param args The dictionary of arguments used to construct a URL based on the templates defined for each URL scheme.
 @return If the user should be prompted to select an application, returns a `UIActivityViewController` to present modally. Otherwise nil. */
- (UIActivityViewController *)performCommand:(NSString *)command withArguments:(NSDictionary *)args;

@end