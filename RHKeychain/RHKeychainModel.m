//
//  RHKeychainModel.m
//  RHKit
//
//  Created by Abner_G on 2017/11/16.
//  Copyright © 2017年 Abner_G. All rights reserved.
//

#import "RHKeychainModel.h"

@implementation RHKeychainModel

/**
 快速创建对象
 
 @param account  用户名
 @param password 密码
 @param idfv     idfv设备唯一标识
 @return         keychain model
 */
+ (RHKeychainModel *)modelWithAccount:(NSString *)account password:(NSString *)password idfv:(NSString *)idfv {
    
    RHKeychainModel * model = [[RHKeychainModel alloc] init];
    model.account = account;
    model.password = password;
    model.idfv = idfv;
    return model;
}
@end
