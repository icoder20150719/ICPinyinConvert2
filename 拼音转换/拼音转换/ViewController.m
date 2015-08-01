//
//  ViewController.m
//  拼音转换
//
//  Created by andy  on 15/8/1.
//  Copyright (c) 2015年 andy . All rights reserved.
//

#import "ViewController.h"
#import "NSString+pinyin.h"
#import "MyModel.h"
#import "ICConvert.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic ,strong)NSArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initData];
    [self tableView];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
#pragma mark create method
- (void)initData {
    //init
    _dataArr = [[NSMutableArray alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"name" ofType:nil];
    NSString  *str  = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray *Arr  = [NSMutableArray arrayWithArray:[str componentsSeparatedByString:@"/"]];
    for(int i = 0;i<Arr.count; i++)
    {
        MyModel *model = [MyModel new];
        model.userName = Arr[i];
        [_dataArr addObject:model];
    }
    
    /**
     *  执行时间测试
     *
     */
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    
//        _datas = [ICConvert convertToICPinyinFlagWithArray:_dataArr key:@"userName"];
    
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    NSLog(@"执行时间 = %f s",end - start);
    
    /**
     *  由于系统CFStringTransform转换方法非常耗时
     *
     *  此方法异步调用
     *
     *  @param array 包含ICPinyinFlag的一个数组
     *
     */
    [ICConvert convertToICPinyinFlagWithArray:_dataArr key:@"userName" UsingBlock:^(NSArray *array) {
//            NSLog(@"%@ 线程 ：%@",array,[NSThread currentThread]);
            _datas = array;
            [self.tableView reloadData];
        }];

    
    
    
//    [self.tableView reloadData];
}

#pragma mark   - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ICPinyinFlag *f = self.datas[section];
    return f.contents.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ICPinyinFlag *f = self.datas[section];
    return f.flag;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] ;
    }
    ICPinyinFlag * fl = self.datas[indexPath.section];
    cell.textLabel.text = fl.contents[indexPath.row];
return cell;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *arr = [NSMutableArray array];
    [self.datas enumerateObjectsUsingBlock:^(ICPinyinFlag *obj, NSUInteger idx, BOOL *stop) {
        [arr addObject:obj.flag];
    }];
    return arr;
}
@end