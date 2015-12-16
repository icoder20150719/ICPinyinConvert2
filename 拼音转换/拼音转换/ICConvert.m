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
    /**
     *  初始化索引拼音
     */
    flagIndex = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",
            @"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",
            @"T",@"U",@"V",@"W",@"X",@"Y",@"Z"
            ];
}
+(NSArray *)convertToICPinyinFlagWithArray:(NSArray *)array key:(NSString *)key{
    /**
     *  得到所有属性值
     */
    NSMutableArray *propertyValue = [NSMutableArray array];
   CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
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
    
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    
    NSLog(@"获得中文转拼音执行时间 = %f",end - start);
    
    
    CFAbsoluteTime start2 = CFAbsoluteTimeGetCurrent();
    /**
     *  拼音匹配
     */
    NSMutableArray *ctns = [NSMutableArray array];
     for (int i = 0; i< flagIndex.count;i++) {
        ICPinyinFlag *flag = [[ICPinyinFlag alloc]init];
        NSString *flagStr  = flagIndex[i];
        flag.flag = flagStr;
         /**
          *  设置过滤器
          */
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"self.pinyin BEGINSWITH[cd] %@",flagStr];
         /**
          *  过滤数组
          */
        NSArray *array = [propertyValue filteredArrayUsingPredicate:pred];
         /**
          *  已经匹配过的移除
          */
         [propertyValue removeObjectsInArray:array];
         
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
    
    //匹配不是以拼音开头的eg：数字、特殊字符
//    NSLog(@"%@",propertyValue);
    
    ICPinyinFlag *numberFlag = [[ICPinyinFlag alloc]init];
    numberFlag.flag = @"#";
    NSMutableArray *arr = [NSMutableArray array];
    //其他不是拼音的全部分组到“#”里面
    [propertyValue enumerateObjectsUsingBlock:^(ICPinyinObject *obj, NSUInteger idx, BOOL *stop) {
        [arr addObject:obj.pinyinValue];
    }];
    
    numberFlag.contents = arr;
    [ctns addObject:numberFlag];
    
    CFAbsoluteTime end2 = CFAbsoluteTimeGetCurrent();
    NSLog(@" 匹配时间 = %f s",end2 - start2);
    
    return ctns;

}

+(void)convertToICPinyinFlagWithArray:(NSArray *)array key:(NSString *)key UsingBlock:(convertResultBlock)resultBlock{
   
    /**
     *  开辟一个串行对列
     */
     const char *queueName = "myqueue";
    dispatch_async(dispatch_queue_create(queueName, DISPATCH_QUEUE_SERIAL), ^{
        NSLog(@"%@",[NSThread currentThread]);
        
       NSArray *arr =  [self convertToICPinyinFlagWithArray:array key:key];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (resultBlock) {
                resultBlock(arr);
            }
        }) ;
        
    });

}

@end
