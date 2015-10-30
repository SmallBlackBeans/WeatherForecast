//
//  CityManageViewController.m
//  天气
//
//  海内存知己,我叫叶良辰
//
//  Created by 韩小醋 on 15-10-21.
//  Copyright (c) 2015年 hanxiaocu. All rights reserved.
//

#define kKeyName @"name"
#define kKeyParentName @"parentname"
#define kKeyCode @"code"

#import "CityManageViewController.h"
#import "CitysViewController.h"
#import "CityManagerCell.h"
#import "CityModel.h"
#import "AllWeatherModel.h"
#import <CoreLocation/CoreLocation.h>

@interface CityManageViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>

@property (nonatomic, strong) UITableView    *tableView;

@property (nonatomic, strong) AppDelegate    *appDelegate;

/**
 *  定位
 */
@property (nonatomic, strong) CLLocationManager *locationManager;
/**
 *  地理编码
 */
@property (nonatomic, strong) CLGeocoder        *geoceder;

/**
 *  定位到的当前城市名
 */
@property (nonatomic, strong) UILabel           *currentCityName;
/**
 *  定位开关
 */
@property (nonatomic, strong) UISwitch          *locationSwitch;

@end

@implementation CityManageViewController

#pragma mark - 视图加载
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _appDelegate = [UIApplication sharedApplication].delegate;
    self.navigationItem.title = @"城市列表";
    
    [AppDelegate parseData];
    [self createUI];
    
}
#pragma mark - 视图将要出现的时候
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [AppDelegate parseData];
    [_tableView reloadData];
}

#pragma mark - 懒加载
#pragma mark 懒加载locationManager
- (CLLocationManager *)locationManager
{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 10000;
        
        // iOS8需要添加如下代码
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            [_locationManager requestAlwaysAuthorization]; // 请求一直定位
            [_locationManager requestWhenInUseAuthorization]; // 请求在使用中定位
        }
        
    }
    return _locationManager;
}
#pragma mark 懒加载geoceder
- (CLGeocoder *)geoceder{
    if (_geoceder == nil) {
        _geoceder = [[CLGeocoder alloc]init];
    }
    return _geoceder;
}

#pragma mark - 搭建UI界面
- (void)createUI
{
    [self createAddBtn];
    [self createTableView];
}
#pragma mark  创建添加按钮
- (void)createAddBtn{
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushCitysViewController)];
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editButtonClick:)];
    
    self.navigationItem.rightBarButtonItems = @[addItem,editItem];
}
// 点击添加，跳转到城市选择控制器
- (void)pushCitysViewController
{
    if (![self judgeCitysCountWhetherEXCessive]) {
        [self.navigationController pushViewController:[[CitysViewController alloc] init] animated:YES];
    }
}
// 点击编辑按钮
- (void)editButtonClick:(UIBarButtonItem *)item
{
    if ([item.title isEqualToString:@"编辑"]) {
        [item setTitle:@"完成"];
    }
    else
    {
        [item setTitle:@"编辑"];
    }
    [_tableView setEditing:!_tableView.editing animated:YES];
}

// 判断城市数量是否超标
- (BOOL)judgeCitysCountWhetherEXCessive
{
    NSArray *cityArray = [NSArray arrayWithContentsOfFile:kChosenCitysPath];
    if (cityArray.count < 10) {
        return NO;
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"如果要添加城市请先删除一个城市" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
        return YES;
    }
}
#pragma mark 创建UITableView
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:SCREEN_BOUNDS style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"CityManagerCell" bundle:nil] forCellReuseIdentifier:[CityManagerCell identifier]];
    
    [self.view addSubview:_tableView];
    
    [self createTableHeaderView];
}
#pragma mark 创建 定位的开关视图
- (void)createTableHeaderView{
    UIButton *headerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    
    [headerButton addTarget:self action:@selector(headerViewBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加定位的图片
    UIImageView *locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 15, 20)];
    locationIcon.image = [UIImage imageNamed:@"locationIcon"];
    [headerButton addSubview:locationIcon];
    
    //显示当前城市名
    _currentCityName = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, 200, 20)];
    if (_appDelegate.currentCityModel) {
        _currentCityName.text = _appDelegate.currentCityModel.name;
    }else
    {
        _currentCityName.text = @"自动定位";
    }
    _currentCityName.font = FONT(18);
    [headerButton addSubview:_currentCityName];
    
    // 定位开关
    _locationSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 10, 50, 20)];
    _locationSwitch.on = _appDelegate.currentCityModel != nil;
    [_locationSwitch addTarget:self action:@selector(changeLocationSwith:) forControlEvents:UIControlEventValueChanged];
    [headerButton addSubview:_locationSwitch];
    
    // 添加底线
    [UIView createHorizontalLineWithOrigin:CGPointMake(10, 49) lineLength:SCREEN_WIDTH - 10 lineColor:COLOR_LIGHTGRAYCOLOR toView:headerButton];
    
    _tableView.tableHeaderView = headerButton;
}
// 点击tableVHeaderView跳转到定位到的城市
- (void)headerViewBtnClick{
    if (_appDelegate.currentCityModel) {
        if ([_delegate respondsToSelector:@selector(cityManagerVCPopToLocationCity)]) {
            [_delegate cityManagerVCPopToLocationCity];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [XCView showAlertViewWithMessage:@"请打开定位" target:self];
    }
}
#pragma mark 改变定位开关
- (void)changeLocationSwith:(UISwitch *)sender
{
    if (sender.isOn) {
        if ([CLLocationManager locationServicesEnabled]) {
            [self.locationManager startUpdatingLocation];
//            [XCView showHUDWithText:@"正在定位..." toView:self.view];
        }
        else{
            // 如果定位服务不可用，提醒用户，检查设置和网络
            
            [UIAlertController showAlertViewWithMessage:@"请确定网络连接是否可用或在设置中应用的定位权限是否打开" target:self handler:^{
                sender.on = NO;
            }];
            [self.locationManager stopUpdatingLocation];
            self.locationManager = nil;
        }
    }else
    {
        _currentCityName.text = @"自动定位";
        
        // 如果当前城市列表中有该定位的城市，则不需要删除城市天气信息
        BOOL isExist = NO;
        for (CityModel *cityModel in _appDelegate.cityArray) {
            if ([cityModel.code isEqualToString:_appDelegate.currentCityModel.code]) {
                isExist = YES;
                break;
            }
        }
        if (!isExist) {
            [AppDelegate removeAllWeatherModelByCityId:_appDelegate.currentCityModel.code];
        }
        
        NSLog(@"CityManagerController -- weatherArrayCount -- %d",(int)_appDelegate.weatherArray.count);
        
        _appDelegate.currentCityModel = nil;
        
        [self.locationManager stopUpdatingLocation];
        _locationManager = nil;
    }
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _appDelegate.cityArray.count;
}
#pragma mark UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityManagerCell *cell = [CityManagerCell cellWithTableView:tableView];
    cell.model = _appDelegate.cityArray[indexPath.row];
    return cell;
}
#pragma mark cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
#pragma mark 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_delegate respondsToSelector:@selector(changeCurrentChooseCity:)]) {
        [_delegate changeCurrentChooseCity:indexPath.row];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark cell的移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //修改数据源数组内容
    CityModel *model = _appDelegate.cityArray[sourceIndexPath.row];
    
    if(sourceIndexPath.row > destinationIndexPath.row)
    {
        [_appDelegate.cityArray insertObject:model atIndex:destinationIndexPath.row];
        [_appDelegate.cityArray removeObjectAtIndex:sourceIndexPath.row+1];
    }
    else
    {
        [_appDelegate.cityArray insertObject:model atIndex:destinationIndexPath.row+1];
        [_appDelegate.cityArray removeObjectAtIndex:sourceIndexPath.row];
    }
    
    [AppDelegate saveData];
    
}
#pragma mark 点击cell的删除按钮
//删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityModel *model = _appDelegate.cityArray[indexPath.row];
    
    // 删除城市信息之前，先删除对应的天气信息
    if (![model.code isEqualToString:_appDelegate.currentCityModel.code]) {
        [AppDelegate removeAllWeatherModelByCityId:model.code];
    }
    
    NSLog(@"CityManagerController -- weatherArrayCount -- %d",(int)_appDelegate.weatherArray.count);
    
    [_appDelegate.cityArray removeObjectAtIndex:indexPath.row];
    
    
    
    [tableView reloadData];
    [AppDelegate saveData];
}

#pragma mark -  CLLocationManager 的代理
#pragma mark 定位成功，返回当前位置
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (!self.locationSwitch.on) {
        [_locationManager stopUpdatingLocation];
        _locationManager = nil;
    }
    [XCView showHUDWithText:@"正在定位..." toView:self.view];
    CLLocation *location = [locations firstObject];
    
    NSLog(@"经度--%f,纬度--%f",location.coordinate.longitude,location.coordinate.latitude);
    
    if (location) {
        // 反地理编码
        [self.geoceder
         reverseGeocodeLocation:location completionHandler:^(NSArray * placemarks, NSError * error) {
            
            if (error || placemarks.count == 0) {
                [UIAlertController showAlertViewWithMessage:@"定位失败" target:self handler:^{
                    _locationSwitch.on = NO;
                    // 隐藏加载视图
                    [XCView hideAllHUDFromView:self.view];
                }];
            }
            else
            {
                CLPlacemark *placemark = [placemarks firstObject];
                NSLog(@"placemarkName -- %@,placemarkLocality -- %@,placemarkCountry -- %@",placemark.name,placemark.locality,placemark.country);
                
                if(placemark.locality != nil){
                    // 搜索该城市
                    [[AFHTTPRequestOperationManager manager] GET:kSearchCity parameters:@{@"p0" : placemark.locality} success:^(AFHTTPRequestOperation *  operation, id  responseObject) {
                        // 隐藏加载视图
                        [XCView hideAllHUDFromView:self.view];
                        
                        NSDictionary *city = [responseObject[@"reply"] lastObject];
                        CityModel *model = [[CityModel alloc] init];
                        [model setValuesForKeysWithDictionary:city];
                        
                        NSLog(@"city -- %@",model);
                        
                        model.parentname = [model.parentname componentsSeparatedByString:@" "][1];
                        
                        _currentCityName.text = model.name;
                        
                        // 得到城市后，添加到城市列表中
                        [self addLocationCityToCityArrayWithCityModel:model];
                        
                    } failure:^(AFHTTPRequestOperation *  operation, NSError *  error) {
                        // 隐藏加载视图
                        [XCView hideAllHUDFromView:self.view];
                        
                        _locationSwitch.on = NO;
                        [XCView showAlertViewWithMessage:@"定位失败，请检查网络" target:self];
                        
                        NSLog(@"error -- %@",error.localizedDescription);
                    }];
                }else
                {
                    [UIAlertController showAlertViewWithMessage:@"定位失败" target:self handler:^{
                        _locationSwitch.on = NO;
                        // 隐藏加载视图
                        [XCView hideAllHUDFromView:self.view];
                    }];
                }
            }
        }];
    }
    
}
#pragma mark - 添加城市到当前城市数组
- (void)addLocationCityToCityArrayWithCityModel:(CityModel *)model
{
    _appDelegate.currentCityModel = model;
    
    // 加载城市天气
    BOOL isExist = NO;
    for (AllWeatherModel *allModel in _appDelegate.weatherArray) {
        if ([allModel.cityid isEqualToString:model.code]) {
            isExist = YES;
            break;
        }
    }
    
    if (!isExist) {
        [HXCTool sendAFNetworkGet:kWeather parameters:@{@"cityIds" : model.code} success:^(id responseObject) {
            
            
            NSArray *value = responseObject[@"value"];
            NSLog(@"value -- %@",value);
            
            for (NSDictionary *cityWeather in value) {
                
                AllWeatherModel *weatherModel = [[AllWeatherModel alloc] init];
                [weatherModel setValuesForKeysWithDictionary:cityWeather];
                
                [AppDelegate removeAllWeatherModelByCityId:model.code];
                
                [_appDelegate.weatherArray addObject:weatherModel];
                
                NSLog(@"CityManagerController -- weatherArrayCount -- %d",(int)_appDelegate.weatherArray.count);
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"CityManagerViewController -- error -- %@",error.localizedDescription);
            
        }];
    }else
    {
        
        
        NSLog(@"CityManagerController -- weatherArrayCount -- %d",(int)_appDelegate.weatherArray.count);
    }
}
@end
