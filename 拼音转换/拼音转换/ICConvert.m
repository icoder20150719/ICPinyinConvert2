//
//  ICPingyinGroupHeightLevel.m
//  ICPingyinConvert
//
//  Created by andy  on 15/8/1.
//  Copyright (c) 2015年 card. All rights reserved.
//

#import "ICConvert.h"
#import <objc/runtime.h>
#import "NSString+pinyin.h"
#import "ICPinyinObject.h"

@implementation ICPinyinFlag



@end

static NSArray *flagIndex;
@implementation ICConvert

+(void)initialize
{
    flagIndex = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",
            @"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",
            @"T",@"U",@"V",@"W",@"X",@"Y",@"Z"
            ];
}
+(NSArray *)convertToICPinyFlagWithArray:(NSArray *)array key:(NSString *)key{
    /**
     *  得到所有属性值
     */
    NSMutableArray *propertyValue = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        /**
         *  封装成pinyin对象
         */
        NSString *pv =  [obj valueForKey:key];
        ICPinyinObject * pinyinobj = [[ICPinyinObject alloc]init];
        pinyinobj.pinyin = [pv pinyin];
        pinyinobj.pinyinValue = pv;
        [propertyValue addObject:pinyinobj];
    }];
    /**
     *  拼音匹配
     */
    NSMutableArray *ctns = [NSMutableArray array];
     for (int i = 0; i< flagIndex.count;i++) {
        ICPinyinFlag *flag = [[ICPinyinFlag alloc]init];
        NSString *flagStr  = flagIndex[i];
        flag.flag = flagStr;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"self.pinyin BEGINSWITH[cd] %@",flagStr];
        NSArray *array = [propertyValue filteredArrayUsingPredicate:pred];
     NSMutableArray *arr = [NSMutableArray array];
     
     [array enumerateObjectsUsingBlock:^(ICPinyinObject *obj, NSUInteger idx, BOOL *stop) {
          [arr addObject:obj.pinyinValue];
     }];
     
         flag.contents = arr;
         /**
          *  排除匹配数量为0的
          */
         if (arr.count != 0) {
             [ctns addObject:flag];
         }
     
    }
    
    return ctns;

}

@end
