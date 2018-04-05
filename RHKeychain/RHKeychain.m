//
//  RHKeychain.m
//  RHKit
//
//  Created by Abner_G on 2017/11/15.
//  Copyright © 2017年 Abner_G. All rights reserved.
//

#import "RHKeychain.h"
#import <Security/Security.h>

@implementation RHKeychain

#pragma mark - public

/**
 初始化idfv（需要在AppDelegate里边初始化）
 
 @param service keychain
 */
+ (void)initWithService:(NSString *)service {
    
    RHKeychainModel * model = [self fetchModelWithService:service];
    if (!model) {
        
        NSString * uuidStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString * uuid = [uuidStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        model = [RHKeychainModel modelWithAccount:@"" password:@"" idfv:[uuid lowercaseString]];
        [self saveModel:model forService:service];
    } else {
        
        if (model.account.length == 0) {
            
            model.account = @"";
        }
        if (model.password.length == 0) {
            
            model.password = @"";
        }
        if (model.idfv.length == 0) {
            
            NSString * uuidStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            NSString * uuid = [uuidStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
            model.idfv = [uuid lowercaseString];
        }
        [self updateModel:model forService:service];
    }
}

/**
 保存模型数据到keychain

 @param model   模型
 @param service keychain
 @return        是否保存成功
 */
+ (BOOL)saveModel:(RHKeychainModel *)model forService:(NSString *)service {
    
    if (![self transformModel:model]) {
        
        return NO;
    }
    return [self saveData:[self transformModel:model] service:service];
}

/**
 查询模型数据

 @param service keychain
 @return        模型
 */
+ (RHKeychainModel *)fetchModelWithService:(NSString *)service {
    
    NSString * result = [self fetchWithService:service];
    return [self transformString:result];
}

/**
 更新模型数据

 @param model   模型
 @param service keychain
 @return        是否更新成功
 */
+ (BOOL)updateModel:(RHKeychainModel *)model forService:(NSString *)service {
    
    if (![self transformModel:model]) {
        
        return NO;
    }
    return [self updateData:[self transformModel:model] service:service];
}

/**
 删除保存的模型数据

 @param service keychain
 @return        是否删除成功
 */
+ (BOOL)deleteModelWithService:(NSString *)service {
    
    return [self deleteWithService:service];
}


#pragma mark - private

+ (NSMutableDictionary *)keychainQueryWithService:(NSString *)service {
    
    NSMutableDictionary * keychain = [[NSMutableDictionary alloc] init];
    [keychain setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [keychain setObject:service forKey:(__bridge id)kSecAttrService];
    [keychain setObject:service forKey:(__bridge id)kSecAttrAccount];
    return keychain;
}

+ (NSString *)transformModel:(RHKeychainModel *)model {
    
    if (model.account.length ==0 && model.password.length == 0 && model.idfv.length == 0) {
        
        return nil;
    }
    if (!model.account) {
        
        model.account = @"";
    }
    if (!model.password) {
        
        model.password = @"";
    }
    if (!model.idfv) {
        
        model.idfv = @"";
    }
    return [NSString stringWithFormat:@"%@&%@&%@", model.account, model.password, model.idfv];
}

+ (RHKeychainModel *)transformString:(NSString *)result {
    
    NSArray * dataArr = [result componentsSeparatedByString:@"&"];
    if (dataArr.count >= 3) {
        
        RHKeychainModel * model = [RHKeychainModel modelWithAccount:dataArr[0] password:dataArr[1] idfv:dataArr[2]];
        return model;
    }
    return nil;
}

+ (BOOL)saveData:(id)data service:(NSString *)service {
    
    NSMutableDictionary * keychain = [self keychainQueryWithService:service];
    SecItemDelete((CFDictionaryRef)keychain);
    [keychain setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    OSStatus status = SecItemAdd((CFDictionaryRef)keychain, NULL);
    if (status == noErr) {
        
        return YES;
    }
    return NO;
}

+ (id)fetchWithService:(NSString *)service {
    
    id result;
    NSMutableDictionary * keychain = [self keychainQueryWithService:service];
    [keychain setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychain setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)keychain, (CFTypeRef *)&keyData);
    if (status == noErr) {

        @try {

            result = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *exception) {

            NSLog(@"不存在数据");
        }
        @finally {

        }
    }
    if (keyData) {

        CFRelease(keyData);
    }
    return result;
}

+ (BOOL)updateData:(id)data service:(NSString *)service {
    
    NSMutableDictionary * oldKeychain = [self keychainQueryWithService:service];
    if (!oldKeychain) {
        
        return NO;
    }
    
    NSMutableDictionary * newKeychain = [[NSMutableDictionary alloc] init];
    [newKeychain setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    OSStatus status = SecItemUpdate((CFDictionaryRef)oldKeychain,
                                    (CFDictionaryRef)newKeychain);
    if (status == errSecSuccess) {
        
        return YES;
    }
    return NO;
}

+ (BOOL)deleteWithService:(NSString *)service {
    
    NSMutableDictionary * keychain = [self keychainQueryWithService:service];
    OSStatus status = SecItemDelete((CFDictionaryRef)keychain);
    if (status == noErr) {
        
        return YES;
    }
    return NO;
}


@end
