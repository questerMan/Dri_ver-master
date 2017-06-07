//
//  MBsMapLocationView.m
//  CCBClient
//
//  Created by lori on 12-10-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCBLocationUtil.h"

@implementation CCBLocationModel

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

@implementation CCBLocationUtil
@synthesize m_delegate,m_curLocation,m_locationModel;

const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
static CCBLocationUtil *g_mapLocationView = nil;

+(CCBLocationUtil *)getInstnce{
    if (g_mapLocationView == nil) {
        g_mapLocationView = [[CCBLocationUtil alloc] init];
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
       locationManager.pausesLocationUpdatesAutomatically=NO;////该模式是抵抗ios在后台杀死程序设置，iOS会根据当前手机使用状况会自动关闭某些应用程序的后台刷新，该语句申明不能够被暂停，但是不一定iOS系统在性能不佳的情况下强制结束应用刷新
        m_period = 60;
        timeFlag = YES;
        
        m_mapView = [[MKMapView alloc] init];
        
        [m_mapView setMapType:MKMapTypeStandard];
        [m_mapView setDelegate:self];
        
        m_locationModel = [[CCBLocationModel alloc] init];
        
    }
    return self;
}

#pragma mapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    userLocation为GCJ-02火星坐标系），以下方法为将火星坐标系转为BD-09（百度坐标系），若经纬度是由CLLocationManager获得的，则获得的坐标系为WGS-84（世界标准坐标系）
   // self.m_curLocation=[self bd_encrypt:userLocation.location];
    self.m_curLocation=[[CLLocation alloc] initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    
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
- (CCBLocationModel *)getLocationModel{
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
    //NSLog(@"address:%@%@",address,placemark.subThoroughfare);
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
@end
