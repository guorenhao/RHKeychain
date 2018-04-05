//
//  RHKeychainModel.h
//  RHKit
//
//  Created by Abner_G on 2017/11/16.
//  Copyright © 2017年 Abner_G. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHKeychainModel : NSObject

// 用户名
@property (nonatomic, copy) NSString * account;
// 密码
@property (nonatomic, copy) NSString * password;
// idfv设备唯一标识
@property (nonatomic, copy) NSString * idfv;

/**
 快速创建对象

 @param account  用户名
 @param password 密码
 @param idfv     idfv设备唯一标识
 @return         keychain model
 */
+ (RHKeychainModel *)modelWithAccount:(NSString *)account password:(NSString *)password idfv:(NSString *)idfv;
@end
