//
//  DKFOASSClient.h
//  FOASSClient
//
//  Created by Denys Kotelovych on 26.07.13.
//  Copyright (c) 2013 DKSoftware. All rights reserved.
//

#import "AFHTTPClient.h"

typedef enum {
  FOASSMessageSingleTypeThis,
  FOASSMessageSingleTypeThat,
  FOASSMessageSingleTypeEverything,
  FOASSMessageSingleTypeEveryone,
  FOASSMessageSingleTypePink,
  FOASSMessageSingleTypeLife,
  FOASSMessageSingleTypeThanks,
  FOASSMessageSingleTypeFlying
} FOASSMessageSingleType;

typedef enum {
  FOASSMessageDoubleTypeOff,
  FOASSMessageDoubleTypeYou,
  FOASSMessageDoubleTypeChainsaw,
  FOASSMessageDoubleTypeOutside,
  FOASSMessageDoubleTypeDonut,
  FOASSMessageDoubleTypeShakespeare,
  FOASSMessageDoubleTypeLinus,
  FOASSMessageDoubleTypeKing
} FOASSMessageDoubleType;

@class FOASSMessage;

@interface FOASSClient : AFHTTPClient

+ (instancetype)sharedInstance;

- (void)getMessageWithDoubleType:(FOASSMessageDoubleType)type
                    receiverName:(NSString *)receiverName
                      senderName:(NSString *)senderName
                         success:(void(^)(FOASSMessage *message))success
                         failure:(void(^)(NSError *error))failure;

- (void)getMessageWithSingleType:(FOASSMessageSingleType)type
                      senderName:(NSString *)senderName
                         success:(void(^)(FOASSMessage *message))success
                         failure:(void(^)(NSError *error))failure;

- (void)getMessageWithType:(NSString *)type
              receiverName:(NSString *)receiverName
                senderName:(NSString *)senderName
                   success:(void(^)(FOASSMessage *message))success
                   failure:(void(^)(NSError *error))failure;

@end

@interface FOASSMessage : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *subtitle;

@end

NSArray *FOASSGetAllSingleTypes();
NSArray *FOASSGetAllDoubleTypes();

NSString *FOASSStringTypeFromSingleType(FOASSMessageSingleType type);
NSString *FOASSStringTypeFromDoubleType(FOASSMessageDoubleType type);
