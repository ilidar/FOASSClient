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

- (void)getMessageWithSingleType:(DKFOASSMessageSingleType)type
                    receiverName:(NSString *)receiverName
                      senderName:(NSString *)senderName
                         success:(void (^)(FOASSMessage *))success
                         failure:(void (^)(NSError *))failure {
  
  [self getMessageWithType:FOASSStringTypeFromSingleType(type)
              receiverName:receiverName
                senderName:senderName
                   success:success
                   failure:failure];
}

- (void)getMessageWithDoubleType:(DKFOASSMessageDoubleType)type
                      senderName:(NSString *)senderName
                         success:(void(^)(FOASSMessage *message))success
                         failure:(void(^)(NSError *error))failure {
  
  [self getMessageWithType:FOASSStringTypeFromDoubleType(type)
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

NSArray *FOASSAllSingleTypes() {
  return @[
    FOASSStringTypeFromSingleType(DKFOASSMessageSingleTypeThis),
    FOASSStringTypeFromSingleType(DKFOASSMessageSingleTypeThat),
    FOASSStringTypeFromSingleType(DKFOASSMessageSingleTypeEverything),
    FOASSStringTypeFromSingleType(DKFOASSMessageSingleTypeEveryone),
    FOASSStringTypeFromSingleType(DKFOASSMessageSingleTypePink),
    FOASSStringTypeFromSingleType(DKFOASSMessageSingleTypeLife),
    FOASSStringTypeFromSingleType(DKFOASSMessageSingleTypeThanks),
    FOASSStringTypeFromSingleType(DKFOASSMessageSingleTypeFlying)
  ];
}

NSArray *FOASSAllDoubleTypes() {
  return @[
    FOASSStringTypeFromSingleType(DKFOASSMessageDoubleTypeOff),
    FOASSStringTypeFromSingleType(DKFOASSMessageDoubleTypeYou),
    FOASSStringTypeFromSingleType(DKFOASSMessageDoubleTypeChainsaw),
    FOASSStringTypeFromSingleType(DKFOASSMessageDoubleTypeOutside),
    FOASSStringTypeFromSingleType(DKFOASSMessageDoubleTypeDonut),
    FOASSStringTypeFromSingleType(DKFOASSMessageDoubleTypeShakespeare),
    FOASSStringTypeFromSingleType(DKFOASSMessageDoubleTypeLinus),
    FOASSStringTypeFromSingleType(DKFOASSMessageDoubleTypeKing)
  ];
}

NSString *FOASSStringTypeFromSingleType(DKFOASSMessageSingleType type) {
  switch (type) {
    case DKFOASSMessageSingleTypeThis:       return @"this";
    case DKFOASSMessageSingleTypeThat:       return @"that";
    case DKFOASSMessageSingleTypeEverything: return @"everything";
    case DKFOASSMessageSingleTypeEveryone:   return @"everyone";
    case DKFOASSMessageSingleTypePink:       return @"pink";
    case DKFOASSMessageSingleTypeLife:       return @"life";
    case DKFOASSMessageSingleTypeThanks:     return @"thanks";
    case DKFOASSMessageSingleTypeFlying:     return @"flying";
  }
  
  return nil;
}

NSString *FOASSStringTypeFromDoubleType(DKFOASSMessageDoubleType type) {
  switch (type) {
    case DKFOASSMessageDoubleTypeOff:         return @"off";
    case DKFOASSMessageDoubleTypeYou:         return @"you";
    case DKFOASSMessageDoubleTypeChainsaw:    return @"chainsaw";
    case DKFOASSMessageDoubleTypeOutside:     return @"outside";
    case DKFOASSMessageDoubleTypeDonut:       return @"donut";
    case DKFOASSMessageDoubleTypeShakespeare: return @"shakespeare";
    case DKFOASSMessageDoubleTypeLinus:       return @"linus";
    case DKFOASSMessageDoubleTypeKing:        return @"king";
  }
  
  return nil;
}
