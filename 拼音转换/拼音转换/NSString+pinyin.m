//
//  NSString+pinyin.m
//  拼音转换
//
//  Created by andy  on 15/8/1.
//  Copyright (c) 2015年 andy . All rights reserved.
//

#import "NSString+pinyin.h"

@implementation NSString (pinyin)
-(NSString *)pinyin{
    //转换为带声调的拼音
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    return str;

}
@end
