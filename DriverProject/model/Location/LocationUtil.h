//
//  LocationUtil.h
//  DriverProject
//
//  Created by zyx on 15/10/4.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AMapNaviKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchObj.h>

#import <AMapSearchKit/AMapSearchAPI.h>

@interface LocationModel : NSObject {
    NSString *country;
    NSString *province;
    NSString *city;
    NSString *district;
    NSString *address;
    double latutide;
    double longitude;
}
@property(nonatomic,retain) NSString *country;
@property(nonatomic,retain) NSString *province;
@property(nonatomic,retain) NSString *city;
@property(nonatomic,retain) NSString *district;
@property(nonatomic,retain) NSString *address;
@property(nonatomic) double latutide;
@property(nonatomic) double longitude;

@end

@protocol LocationDelegate <NSObject>
@optional
- (void)onReceiveLoation:(LocationModel *)locationModel;//定位信息回调
- (void)getLocationFail;//定位失败回调

@end

@interface LocationUtil : NSObject<CLLocationManagerDelegate,MKReverseGeocoderDelegate,MAMapViewDelegate>
{
    CLLocationManager *locationManager;
    NSTimer *requestTimer;
    NSInteger m_period;
    LocationModel *m_locationModel;
    NSObject<LocationDelegate> *m_delegate;
    CLLocation *m_curLocation;
    BOOL timeFlag;
    
    
    MAMapView *m_mapView;
}

@property (nonatomic,retain)LocationModel *m_locationModel;
@property (nonatomic,assign) NSObject<LocationDelegate> *m_delegate;
@property (nonatomic,retain) CLLocation *m_curLocation;


@property (nonatomic, retain) AMapSearchAPI *search;


+(LocationUtil *)getInstnce;
//设置定位时间周期
- (void)setPeriod:(NSInteger)period;
//开启定位
- (void)start;
//关闭定位
- (void)stop;
//获取当前位置到指定经纬度的距离
- (double)getDistanceLatutide:(double)latutide getDistanceLongitude:(double)longitude;
//获取两点之间的距离
- (double)getDistanceFromLatutide:(double)fromLatutide fromLongitude:(double)fromLongitude toLatutide:(double)toLatutide toLongitude:(double)toLongitude ;
//获取位置信息
- (void)getLocation;
- (LocationModel *)getLocationModel;

@end
