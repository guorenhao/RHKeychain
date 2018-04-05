//
//  RHKeychain.h
//  RHKit
//
//  Created by Abner_G on 2017/11/15.
//  Copyright © 2017年 Abner_G. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RHKeychainModel.h"

@interface RHKeychain : NSObject

/**
 初始化idfv（需要在AppDelegate里边初始化）
 
 @param service keychain
 */
+ (void)initWithService:(NSString *)service;

/**
 保存模型数据到keychain
 
 @param model   模型
 @param service keychain
 @return        是否保存成功
 */
+ (BOOL)saveModel:(RHKeychainModel *)model forService:(NSString *)service;

/**
 查询模型数据
 
 @param service keychain
 @return        模型
 */
+ (RHKeychainModel *)fetchModelWithService:(NSString *)service;

/**
 更新模型数据
 
 @param model   模型
 @param service keychain
 @return        是否更新成功
 */
+ (BOOL)updateModel:(RHKeychainModel *)model forService:(NSString *)service;

/**
 删除保存的模型数据
 
 @param service keychain
 @return        是否删除成功
 */
+ (BOOL)deleteModelWithService:(NSString *)service;

@end
