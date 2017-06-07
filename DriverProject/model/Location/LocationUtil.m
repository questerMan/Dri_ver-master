//
//  LocationUtil.m
//  DriverProject
//
//  Created by zyx on 15/10/4.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "LocationUtil.h"

@implementation LocationModel

@synthesize country,province,city,district,address,latutide,longitude;

- (void)dealloc {
    country = nil;
    province = nil;
    city = nil;
    district = nil;
    address = nil;
    [super dealloc];
}

@end

@implementation LocationUtil
@synthesize m_delegate,m_curLocation,m_locationModel;

const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
static LocationUtil *g_mapLocationView = nil;

+(LocationUtil *)getInstnce{
    if (g_mapLocationView == nil) {
        g_mapLocationView = [[LocationUtil alloc] init];
        return g_mapLocationView;
    }
    return g_mapLocationView;
}


//关闭等待时间定时器
- (void)closeTimer
{
    if (m_delegate != nil)
    {
        m_delegate = nil;
    }
    if (requestTimer != nil) {
        if ([requestTimer isValid]) {
            [requestTimer invalidate];
        }
        requestTimer=nil;
    }
    timeFlag = YES;
}

- (void)startTimer
{
    //自动刷新定时器
    timeFlag = NO;
    requestTimer = [NSTimer scheduledTimerWithTimeInterval:m_period target:self
                                                  selector:@selector(getLocation) userInfo:nil repeats:YES];
    
}

- (void)getLocation
{
    [m_mapView setShowsUserLocation:YES];
    
}

- (id)init
{
    self = [super init];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        m_period = 60;
        timeFlag = YES;
        
        m_mapView = [[MAMapView alloc] init];
        [m_mapView setHidden:YES];
        [m_mapView setMapType:MAMapTypeStandard];
        [m_mapView setDelegate:self];
        
        m_locationModel = [[LocationModel alloc] init];
        
    }
    return self;
}
#pragma MAMapViewDelegate

- (void)mapViewWillStartLocatingUser:(MAMapView *)mapView;
{


}
/*!
 @brief 在地图View停止定位后，会调用此函数
 @param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView;
{


}
/*!
 @brief 位置或者设备方向更新后，会调用此函数, 这个回调已废弃由 -(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation 来替代
 @param mapView 地图View
 @param userLocation 用户定位信息(包括位置与设备方向等数据)
 */
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
{
   // self.m_curLocation=[self bd_encrypt:userLocation.location];
    self.m_curLocation=userLocation.location;
    NSLog(@"nearby mapview didUpdateUserLocation================%f=%f",self.m_curLocation.coordinate.latitude,self.m_curLocation.coordinate.longitude);
    MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:userLocation.location.coordinate];
    geocoder.delegate = self;
    [geocoder start];
    [m_mapView setShowsUserLocation:NO];

}
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    [m_mapView setShowsUserLocation:NO];
    //定位失败 回调
    if (m_delegate != nil && [m_delegate respondsToSelector:@selector(getLocationFail)]) {
        [m_delegate getLocationFail];
    }
}
/*
#pragma mapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //    userLocation为GCJ-02火星坐标系），以下方法为将火星坐标系转为BD-09（百度坐标系），若经纬度是由CLLocationManager获得的，则获得的坐标系为WGS-84（世界标准坐标系）
    self.m_curLocation=[self bd_encrypt:userLocation.location];
    NSLog(@"nearby mapview didUpdateUserLocation================%f=%f",self.m_curLocation.coordinate.latitude,self.m_curLocation.coordinate.longitude);
    MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:userLocation.location.coordinate];
    geocoder.delegate = self;
    [geocoder start];
    [m_mapView setShowsUserLocation:NO];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    [m_mapView setShowsUserLocation:NO];
    //定位失败 回调
    if (m_delegate != nil && [m_delegate respondsToSelector:@selector(getLocationFail)]) {
        [m_delegate getLocationFail];
    }
}
*/
#pragma MKReverseGeocoderDelegate

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    [geocoder cancel];
    m_locationModel.country = nil;
    m_locationModel.province = nil;
    m_locationModel.city = nil;
    m_locationModel.district = nil;
    m_locationModel.address = nil;
    m_locationModel.latutide = -1;
    m_locationModel.longitude = -1;
    [locationManager stopUpdatingLocation];
    
    if (m_delegate != nil && [m_delegate respondsToSelector:@selector(onReceiveLoation:)]) {
        [m_delegate onReceiveLoation:m_locationModel];
    }
    
    
}
//ssy 2.1.8 定位
- (LocationModel *)getLocationModel{
    NSLog(@"m_locationModel == %@",[m_locationModel description]);
    return m_locationModel;
}
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    
    NSLog(@"============placemark.locality=%@=%@===============",placemark.locality,placemark.subLocality);
    [geocoder cancel];
    m_locationModel.country = placemark.country;
    m_locationModel.province = placemark.administrativeArea;
    m_locationModel.city = placemark.locality;
    m_locationModel.district = placemark.subLocality;
    NSMutableString *address = [[NSMutableString alloc] initWithString:@""];
    [address appendString:(placemark.administrativeArea==nil?@"":placemark.administrativeArea)];
    [address appendString:(placemark.locality==nil?@"":placemark.locality)];
    [address appendString:(placemark.subLocality==nil?@"":placemark.subLocality)];
    [address appendString:(placemark.thoroughfare==nil?@"":placemark.thoroughfare)];
    
    m_locationModel.address = address;
    [address release];
    NSLog(@"address:%@%@",address,placemark.subThoroughfare);
    m_locationModel.latutide = m_curLocation.coordinate.latitude;
    m_locationModel.longitude = m_curLocation.coordinate.longitude;
    
    if (m_delegate != nil && [m_delegate respondsToSelector:@selector(onReceiveLoation:)]) {
        [m_delegate onReceiveLoation:m_locationModel];
    }
    [locationManager stopUpdatingLocation];
    
}


- (void)setPeriod:(NSInteger)period {
    m_period = period;
}

- (void)start{
    
    if (timeFlag) {
        [self startTimer];
    }
}


- (double)curLocationX:(double)locationX curLocationY:(double)locationY curLocationX1:(double)locationX1 curLocationY1:(double)locationY1{
    double distance = -1;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue]>3.2)
    {
        CLLocation *location = [[CLLocation alloc]initWithLatitude:locationX1 longitude:locationY1];
        CLLocation *userLocation = [[CLLocation alloc]initWithLatitude:locationX longitude:locationY];
        distance = [userLocation distanceFromLocation:location];
        [location release];
        [userLocation release];
    }
    else
    {
        double distanceDegrees = sqrt(pow(locationX1 - locationX, 2) + pow(locationY1 - locationY, 2));  //x1,y1  x2,y2 两点的坐标
        distance = distanceDegrees / 0.000008983152841195214;             //两点之间的直线距离单位：米
    }
    return distance;
}

- (double)getDistanceLatutide:(double)latutide getDistanceLongitude:(double)longitude{
    double distance = [self curLocationX:m_curLocation.coordinate.latitude curLocationY:m_curLocation.coordinate.longitude curLocationX1:latutide curLocationY1:longitude];
    return distance;
}

- (double)getDistanceFromLatutide:(double)fromLatutide fromLongitude:(double)fromLongitude toLatutide:(double)toLatutide toLongitude:(double)toLongitude {
    double distance = [self curLocationX:fromLatutide curLocationY:fromLongitude
                           curLocationX1:toLatutide curLocationY1:toLongitude];
    return distance;
}

- (void)stop {
    [locationManager stopUpdatingLocation];
    [self closeTimer];
    [m_mapView setShowsUserLocation:NO];
}

- (void)dealloc{
    m_curLocation = nil;
    [m_locationModel release];
    locationManager.delegate = nil;
    [locationManager release];
    [super dealloc];
}
//将火星坐标系转为BD-09（百度坐标系）
-(CLLocation * )bd_encrypt:(CLLocation*) gcLoc
{
    double x = gcLoc.coordinate.longitude, y = gcLoc.coordinate.latitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    
    CLLocation *tmp=[[CLLocation alloc] initWithLatitude:(z * sin(theta) + 0.006) longitude:(z * cos(theta) + 0.0065)];
    
    
    return [tmp autorelease];
}


#pragma mark   获取费用

//- (void)requestPathInfo:(CLLocation *)currentLocation destinationLocation:(CLLocation *)destinationLocation
//{
//    //检索所需费用（发起驾车路径规划）
//    AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
//    navi.searchType       = AMapSearchType_NaviDrive;
//    navi.requireExtension = YES;
//    
//    /* 出发点. */
//    navi.origin = [AMapGeoPoint locationWithLatitude:currentLocation.coordinate.latitude
//                                           longitude:currentLocation.coordinate.longitude];
//    /* 目的地. */
//    navi.destination = [AMapGeoPoint locationWithLatitude:destinationLocation.coordinate.latitude
//                                                longitude:destinationLocation.coordinate.longitude];
//    
//    __weak __typeof(&*self) weakSelf = self;
//    [search searchForRequest:navi completionBlock:^(id request, id response, NSError *error) {
//        //路径规划回调结果
//        AMapNavigationSearchResponse * naviResponse = response;
//        
//        if (naviResponse.route == nil)
//        {
//            [weakSelf.locationView setInfo:@"获取路径失败"];
//            return;
//        }
//        
//        AMapPath * path = [naviResponse.route.paths firstObject];
//        [weakSelf.locationView setInfo:[NSString stringWithFormat:@"预估费用%.2f元  距离%.1f km  时间%.1f分钟", naviResponse.route.taxiCost, path.distance / 1000.f, path.duration / 60.f, nil]];
//    }];
//}




@end
