#import "OKActivity.h"
#import "NSString+FormatWithArray.h"

@interface OKActivity ()
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDictionary *dict;

@property (readonly) UIImage *_activityImage;

@property (strong, nonatomic) UIApplication *application;
@property (strong, nonatomic) NSString *activityCommand;
@property (strong, nonatomic) NSDictionary *activityArguments;

@end

@implementation OKActivity

- (instancetype)initWithDictionary:(NSDictionary *)dict
                              name: (NSString *)name
                       application:(UIApplication *)application {
    if (self = [super init]) {
        self.name = name;
        self.dict = dict;
        self.application = application;
    }
    return self;
}

- (BOOL)isAvailableForCommand:(NSString *)command arguments:(NSDictionary *)args {
    if (!self.dict[command]) { return NO; }

    NSString *urlString = self.dict[command];
    for (NSString *key in args) {
        NSString *handlebarKey = [NSString stringWithFormat:@"{%@}", key];
        urlString = [urlString stringByReplacingOccurrencesOfString:handlebarKey withString:args[key]];
    }

    return [self.application canOpenURL:[NSURL URLWithString:urlString]];
}

#pragma mark - UIActivity methods
+ (UIActivityCategory)activityCategory {
    return UIActivityCategoryAction;
}

- (NSString *)activityTitle {
    return self.name;
}

- (NSString *)activityType {
    return self.name;
}

- (UIImage *)_activityImage {
    return [UIImage imageNamed:self.name];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    if (activityItems.count != 2) return;

    self.activityCommand = [activityItems firstObject];
    self.activityArguments = [activityItems lastObject];
}

- (void)performActivity {
    if (!self.dict[self.activityCommand]) { return; }

    NSString *urlString = self.dict[self.activityCommand];
    NSMutableArray *optionals = [NSMutableArray array];
    for (NSString *key in self.activityArguments) {
        NSString *handlebarKey = [NSString stringWithFormat:@"{%@}", key];

        NSString *optionalParam = self.dict[@"optional"][key];
        if (optionalParam) {
            NSString *optionalString = [optionalParam stringByReplacingOccurrencesOfString:handlebarKey
                                                                                withString:self.activityArguments[key]];
            [optionals addObject:optionalString];
        } else {
            urlString = [urlString stringByReplacingOccurrencesOfString:handlebarKey withString:self.activityArguments[key]];
        }
    }
    urlString = [urlString stringByAppendingString:[optionals componentsJoinedByString:@""]];
    
    NSURL *url = [NSURL URLWithString:urlString];
    [self.application openURL:url];
}

@end
