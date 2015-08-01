//
//  ICPingyinGroupHeightLevel.h
//  ICPingyinConvert
//
//  Created by andy  on 15/8/1.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICPinyinFlag : NSObject
/**
 *  标记 a ~ b ~ c
 */
@property (nonatomic ,copy)NSString *flag;
/**
 *  标记下数组
 */
@property (nonatomic ,strong)NSArray *contents;

@end


@interface ICConvert : NSObject
/**
 *  通过一个key去数组中取出模型对应的值
 *
 *  @param array 数组源素组
 *  @param key   属性值
 *
 *  @return ICpinFlag对象
 */
+(NSArray *)convertToICPinyFlagWithArray:(NSArray *)array key:(NSString *)key;
@end
