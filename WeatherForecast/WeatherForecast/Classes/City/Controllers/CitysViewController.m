//
//  CitysViewController.m
//  天气
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

//代表当前section是否是展开
#define kIsExpand @"isExpand"
//当前section对应的数组
#define kCityArray @"cityArray"

#import "CitysViewController.h"
#import "CityModel.h"

@interface CitysViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSMutableArray       *_cityArray;
    UITableView          *_tableView;
    UISearchBar          *_searchBar;
}

@end

@implementation CitysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_WHITECOLOR;
    
    self.navigationItem.title =@"添加城市";
    
    [self parserData];
    [self createUI];
}

#pragma mark - 解析数据
- (void)parserData{
    NSArray *citysArray = [NSMutableArray  arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"citys" ofType:@"plist"]];
    _cityArray = [NSMutableArray arrayWithCapacity:0];
    for (NSArray *citys in citysArray) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *city in citys) {
            CityModel *model = [[CityModel alloc] init];
            [model setValuesForKeysWithDictionary:city];
            [array addObject:model];
        }
        
        /**
         *  将每组数据封装成字典，实现关闭和打开分组的效果，默认为关闭状态
         */
        NSMutableDictionary *dict = [@{kCityArray : array ,kIsExpand : @(NO)} mutableCopy];
        [_cityArray addObject:dict];

        
    }
    
//    NSLog(@"cityArray -- %@",_cityArray);
}

#pragma mark - 创建界面
- (void)createUI{
    [self createTableView];
    [self createSearchBar];
}
#pragma mark 创建tableView
- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:SCREEN_BOUNDS style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
#pragma mark 创建searchBar
- (void)createSearchBar
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    _searchBar.placeholder = @"输入城市名";
    _searchBar.delegate = self;
    _tableView.tableHeaderView = _searchBar;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
#pragma mark 组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cityArray.count;
}
#pragma mark 每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableDictionary *dict = _cityArray[section];
    if ([dict[kIsExpand] boolValue]) {
        return [dict[kCityArray] count];
    }
    else
        return 0;
}
#pragma mark UITableViewCell
static NSString *cellId = @"cityCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSArray *sectionArray = _cityArray[indexPath.section][kCityArray];
//    NSLog(@"%@",[sectionArray[indexPath.row] name]);
    cell.textLabel.text = [sectionArray[indexPath.row] name];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
#pragma mark cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
#pragma mark cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *cityArray = [NSMutableArray arrayWithContentsOfFile:kChosenCitysPath];
    if (cityArray == nil) {
        cityArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    CityModel *model = _cityArray[indexPath.section][kCityArray][indexPath.row];
    NSDictionary *city = @{@"name" : model.name , @"parentname": model.parentname, @"code" : model.code};
    
    BOOL isExists = NO;
    for (NSDictionary *dict in cityArray) {
        if ([dict[@"code"] isEqualToString:city[@"code"]]) {
            isExists = YES;
            break;
        }
    }
    // 如果该城市没有添加过，则添加
    if (!isExists) {
        [cityArray addObject:city];
        
        BOOL ret = [cityArray writeToFile:kChosenCitysPath atomically:YES];
        NSLog(@"ret -- %d",ret);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark headerView的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

#pragma mark headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    NSArray *sectionArray = _cityArray[section][kCityArray];
    NSString *title = [NSString stringWithFormat:@"%@ %d个市区", [sectionArray[0] parentname],(int)sectionArray.count];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:title];
    
    NSRange range = [title rangeOfString:@" "];
    
    // 省份名称黑色20号，省份下城市个数暗灰色14号
    [attributeString addAttributes:@{NSFontAttributeName : FONT(20),NSForegroundColorAttributeName : [UIColor blueColor]} range:NSMakeRange(0, range.location)];
    [attributeString addAttributes:@{NSFontAttributeName : FONT(14),NSForegroundColorAttributeName : COLOR_LIGHTGRAYCOLOR} range:NSMakeRange(range.location + range.length, title.length - range.location - 1)];
    
    UIButton *btn = [XCView createButtonWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 39) title:title target:self action:@selector(changeExpandSection:) backgroundColor:COLOR_WHITECOLOR];

    [btn setAttributedTitle:attributeString forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    btn.tag = section;
    [view addSubview:btn];
    
    // 分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 39, SCREEN_WIDTH - 10, 1)];
    line.backgroundColor = COLOR_LIGHTGRAYCOLOR;
    [view addSubview:line];
    
    return view;
}
//改变展开的section
- (void)changeExpandSection:(UIButton *)btn
{
    NSInteger section = btn.tag;
    NSMutableDictionary *dict = _cityArray[section];
    BOOL isExpand = [dict[kIsExpand] boolValue];
    [dict setValue:@(!isExpand) forKey:kIsExpand];
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma mark - UISearchBarDelegate
#pragma mark 开始输入搜索内容
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar becomeFirstResponder];
    [searchBar setShowsCancelButton:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO];
    [searchBar resignFirstResponder];
    [searchBar setText:@""];
    [self parserData];
    [_tableView reloadData];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    if (searchBar.text.length == 0) {
        [self parserData];
        [_tableView reloadData];
    }
    else
    {
        //显示加载视图
        [XCView showHUDWithText:@"正在搜索..." toView:self.view];
        // 从网络加载数据
        [[AFHTTPRequestOperationManager manager] GET:kSearchCity parameters:@{@"p0" : searchBar.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // 隐藏加载视图
            [XCView hideHUDFromView:self.view];
            
            NSDictionary *city = [responseObject[@"reply"] lastObject];
            CityModel *model = [[CityModel alloc] init];
            [model setValuesForKeysWithDictionary:city];
            
            NSLog(@"city -- %@",model);
            
            model.parentname = [model.parentname componentsSeparatedByString:@" "][1];
            
            [_cityArray removeAllObjects];
            [_cityArray addObject:[@{kCityArray : [NSArray arrayWithObjects:model, nil] , kIsExpand : @(YES) } mutableCopy]];
            
            [_tableView reloadData];
            
        } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
            // 隐藏加载视图
            [XCView hideHUDFromView:self.view];
            NSLog(@"error -- %@",error.localizedDescription);
        }];
    }
}
@end
