//
//  DKFOASSClient.h
//  FOASSClient
//
//  Created by Denys Kotelovych on 26.07.13.
//  Copyright (c) 2013 DKSoftware. All rights reserved.
//

#import "AFHTTPClient.h"

typedef enum {
  DKFOASSMessageSingleTypeThis,
  DKFOASSMessageSingleTypeThat,
  DKFOASSMessageSingleTypeEverything,
  DKFOASSMessageSingleTypeEveryone,
  DKFOASSMessageSingleTypePink,
  DKFOASSMessageSingleTypeLife,
  DKFOASSMessageSingleTypeThanks,
  DKFOASSMessageSingleTypeFlying
} DKFOASSMessageSingleType;

typedef enum {
  DKFOASSMessageDoubleTypeOff,
  DKFOASSMessageDoubleTypeYou,
  DKFOASSMessageDoubleTypeChainsaw,
  DKFOASSMessageDoubleTypeOutside,
  DKFOASSMessageDoubleTypeDonut,
  DKFOASSMessageDoubleTypeShakespeare,
  DKFOASSMessageDoubleTypeLinus,
  DKFOASSMessageDoubleTypeKing
} DKFOASSMessageDoubleType;

@class FOASSMessage;

@interface FOASSClient : AFHTTPClient

+ (instancetype)sharedInstance;

- (void)getMessageWithSingleType:(DKFOASSMessageSingleType)type
                    receiverName:(NSString *)receiverName
                      senderName:(NSString *)senderName
                         success:(void(^)(FOASSMessage *message))success
                         failure:(void(^)(NSError *error))failure;

- (void)getMessageWithDoubleType:(DKFOASSMessageDoubleType)type
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

NSArray *FOASSAllSingleTypes();
NSArray *FOASSAllDoubleTypes();

NSString *FOASSStringTypeFromSingleType(DKFOASSMessageSingleType type);
NSString *FOASSStringTypeFromDoubleType(DKFOASSMessageDoubleType type);
