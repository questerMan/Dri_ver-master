//
//  MBsMapLocationView.h
//  CCBClient
//
//  Created by lori on 12-10-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface CCBLocationModel : NSObject {
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

@protocol CCBLocationDelegate <NSObject>
@optional
- (void)onReceiveLoation:(CCBLocationModel *)locationModel;//定位信息回调
- (void)getLocationFail;//定位失败回调

@end

@interface CCBLocationUtil : NSObject<CLLocationManagerDelegate,MKReverseGeocoderDelegate,MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    NSTimer *requestTimer;
    NSInteger m_period;
    CCBLocationModel *m_locationModel;
    NSObject<CCBLocationDelegate> *m_delegate;
    CLLocation *m_curLocation;
    BOOL timeFlag;
    
    
    MKMapView *m_mapView;
}

@property (nonatomic,retain)CCBLocationModel *m_locationModel;
@property (nonatomic,assign) NSObject<CCBLocationDelegate> *m_delegate;
@property (nonatomic,retain) CLLocation *m_curLocation;



+(CCBLocationUtil *)getInstnce;
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
- (CCBLocationModel *)getLocationModel;

@end
