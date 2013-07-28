//
//  DKFOASSClient.m
//  FOASSClient
//
//  Created by Denys Kotelovych on 26.07.13.
//  Copyright (c) 2013 DKSoftware. All rights reserved.
//

#import "FOASSClient.h"
#import "AFJSONRequestOperation.h"

static NSString * const sBaseURL = @"http://www.foaas.com/";

@interface NSMutableString (PathComponents)

- (void)appendPathComponent:(NSString *)component;

@end

@implementation NSMutableString (PathComponents)

- (void)appendPathComponent:(NSString *)component {
  if (component) {
    [self appendFormat:@"%@/", component];
  }
}

@end

@implementation FOASSClient

+ (instancetype)sharedInstance {
  static dispatch_once_t onceToken;
  static FOASSClient *sSharedInstance = nil;
  
  dispatch_once(&onceToken, ^{
      sSharedInstance = [[FOASSClient alloc] initWithBaseURL:[NSURL URLWithString:sBaseURL]];
  });
  
  return sSharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (self) {
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
  }
  return self;
}

- (void)getMessageWithDoubleType:(FOASSMessageDoubleType)type
                    receiverName:(NSString *)receiverName
                      senderName:(NSString *)senderName
                         success:(void (^)(FOASSMessage *))success
                         failure:(void (^)(NSError *))failure {
  
  [self getMessageWithType:FOASSStringTypeFromDoubleType(type)
              receiverName:receiverName
                senderName:senderName
                   success:success
                   failure:failure];
}

- (void)getMessageWithSingleType:(FOASSMessageSingleType)type
                      senderName:(NSString *)senderName
                         success:(void(^)(FOASSMessage *message))success
                         failure:(void(^)(NSError *error))failure {
  
  [self getMessageWithType:FOASSStringTypeFromSingleType(type)
              receiverName:nil
                senderName:senderName
                   success:success
                   failure:failure];
}

- (void)getMessageWithType:(NSString *)type
              receiverName:(NSString *)receiverName
                senderName:(NSString *)senderName
                   success:(void(^)(FOASSMessage *message))success
                   failure:(void(^)(NSError *error))failure {
  
  NSMutableString *path = [NSMutableString stringWithCapacity:42];
  
  [path appendPathComponent:type];
  [path appendPathComponent:receiverName];
  [path appendPathComponent:senderName];
  
  id afSuccess = ^(AFHTTPRequestOperation *operation, NSDictionary *response) {
    FOASSMessage *message = [[FOASSMessage alloc] init];
    message.message  = response[@"message"];
    message.subtitle = response[@"subtitle"];
    success(message);
  };
  
  id afFailure = ^(AFHTTPRequestOperation *operation, NSError *error) {
    failure(error);
  };
  
  [[FOASSClient sharedInstance] getPath:path parameters:nil success:afSuccess failure:afFailure];
}

@end

@implementation FOASSMessage

@end

NSArray *FOASSGetAllSingleTypes() {
  return @[
    FOASSStringTypeFromSingleType(FOASSMessageSingleTypeThis),
    FOASSStringTypeFromSingleType(FOASSMessageSingleTypeThat),
    FOASSStringTypeFromSingleType(FOASSMessageSingleTypeEverything),
    FOASSStringTypeFromSingleType(FOASSMessageSingleTypeEveryone),
    FOASSStringTypeFromSingleType(FOASSMessageSingleTypePink),
    FOASSStringTypeFromSingleType(FOASSMessageSingleTypeLife),
    FOASSStringTypeFromSingleType(FOASSMessageSingleTypeThanks),
    FOASSStringTypeFromSingleType(FOASSMessageSingleTypeFlying)
  ];
}

NSArray *FOASSGetAllDoubleTypes() {
  return @[
    FOASSStringTypeFromDoubleType(FOASSMessageDoubleTypeOff),
    FOASSStringTypeFromDoubleType(FOASSMessageDoubleTypeYou),
    FOASSStringTypeFromDoubleType(FOASSMessageDoubleTypeChainsaw),
    FOASSStringTypeFromDoubleType(FOASSMessageDoubleTypeOutside),
    FOASSStringTypeFromDoubleType(FOASSMessageDoubleTypeDonut),
    FOASSStringTypeFromDoubleType(FOASSMessageDoubleTypeShakespeare),
    FOASSStringTypeFromDoubleType(FOASSMessageDoubleTypeLinus),
    FOASSStringTypeFromDoubleType(FOASSMessageDoubleTypeKing)
  ];
}

NSString *FOASSStringTypeFromSingleType(FOASSMessageSingleType type) {
  switch (type) {
    case FOASSMessageSingleTypeThis:       return @"this";
    case FOASSMessageSingleTypeThat:       return @"that";
    case FOASSMessageSingleTypeEverything: return @"everything";
    case FOASSMessageSingleTypeEveryone:   return @"everyone";
    case FOASSMessageSingleTypePink:       return @"pink";
    case FOASSMessageSingleTypeLife:       return @"life";
    case FOASSMessageSingleTypeThanks:     return @"thanks";
    case FOASSMessageSingleTypeFlying:     return @"flying";
  }
  
  return nil;
}

NSString *FOASSStringTypeFromDoubleType(FOASSMessageDoubleType type) {
  switch (type) {
    case FOASSMessageDoubleTypeOff:         return @"off";
    case FOASSMessageDoubleTypeYou:         return @"you";
    case FOASSMessageDoubleTypeChainsaw:    return @"chainsaw";
    case FOASSMessageDoubleTypeOutside:     return @"outside";
    case FOASSMessageDoubleTypeDonut:       return @"donut";
    case FOASSMessageDoubleTypeShakespeare: return @"shakespeare";
    case FOASSMessageDoubleTypeLinus:       return @"linus";
    case FOASSMessageDoubleTypeKing:        return @"king";
  }
  
  return nil;
}
