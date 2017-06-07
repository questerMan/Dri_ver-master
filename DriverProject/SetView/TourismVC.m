//
//  TourismVC.m
//  DriverProject
//
//  Created by zyx on 15/9/28.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "TourismVC.h"
NSString *kCompleteRPCURL = @"webviewprogress:///complete";
@interface TourismVC ()<UIWebViewDelegate>

{
    UIWebView *msgDetailWebView;

}

@end

@implementation TourismVC

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _isdismissSelf = NO;    
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=Textlightwhite_COLOR;
    self.backView.backgroundColor=Textwhite_COLOR;

    self.backLabel.text=@"旅游热点";
    self.backLabel.text=_titlelable;
    self.backLabel.textColor=Textblack_COLOR;
    [self.backButton addTarget:self action:@selector(backViewVC) forControlEvents:UIControlEventTouchUpInside];
    self.backButtonimage.image=[UIImage imageNamed:@"common_navbar_return.png"];
    //[self.backButton setBackgroundImage:[UIImage imageNamed:@"common_navbar_return.png"] forState:UIControlStateNormal];
    [self initUI];
    
//    UISwipeGestureRecognizer *rightSwipGestureRecognizer=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backViewVC)];
//    rightSwipGestureRecognizer.direction=UISwipeGestureRecognizerDirectionRight;
//    [rightSwipGestureRecognizer setNumberOfTouchesRequired:1];
//    [self.view addGestureRecognizer:rightSwipGestureRecognizer];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
-(void)backViewVC{
    [msgDetailWebView stopLoading];
    msgDetailWebView.delegate=nil;
    //    [msgDetailWebView loadHTMLString:@"" baseURL:nil];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [msgDetailWebView removeFromSuperview];
    if(_isdismissSelf)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)initUI
{

    msgDetailWebView=[[UIWebView alloc] init];
    msgDetailWebView.delegate=self;
    [(UIScrollView *)[[msgDetailWebView subviews] objectAtIndex:0] setBounces:NO];
    //    [(UIScrollView *)[[msgDetailWebView subviews] objectAtIndex:0]setZoomScale:2];

    [msgDetailWebView setFrame:CGRectMake(0.0, 64, self.view.width,self.view.height-60 )];
    //    msgDetailWebView.opaque=YES;
    [self.view addSubview:msgDetailWebView];
    
    [self loadWebPageWithString:_urlString];

}

#pragma  mark 浏览器
-(void)goBack:(id)sender
{
    if ([msgDetailWebView canGoBack]) {
        [msgDetailWebView goBack];
    }
    //    [self checkButtonImage];//检查是否可前进后退
}
-(void)goPrev:(id)sender
{
    if ([msgDetailWebView canGoForward]) {
        [msgDetailWebView goForward];
    }
    
    //    [self checkButtonImage];//检查是否可前进后退
}


-(void)doCancel:(id)sender

{
    [msgDetailWebView stopLoading];
    /*
    if (_m_isLoadFinished) {
        
        if ([msgDetailWebView canGoBack]) {
            [msgDetailWebView reload];
        }else{
            [self loadWebPageWithString:self.urlStr];
        }
        
        errorLabel.hidden=YES;
        
    }
    else
    {
        [msgDetailWebView stopLoading];
        
    }
    [self checkButtonImage];//检查是否可前进后退
     */
}


- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    if (url.scheme.length == 0) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", [url absoluteString]]];
    }
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [msgDetailWebView loadRequest:request];
    });
    
}
-(BOOL)isLoadingCompleted{
    NSString *readyState = [msgDetailWebView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    NSLog(@"loadingState:%@",readyState);
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive)
    {
        NSString *waitForCompleteJS = [NSString stringWithFormat:   @"window.addEventListener('load',function() { "
                                       @"var iframe = document.createElement('iframe');"
                                       @"iframe.style.display = 'none';"
                                       @"iframe.src = '%@';"
                                       @"document.body.appendChild(iframe);"
                                       @"}, false);", kCompleteRPCURL];
        
        [msgDetailWebView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL complete = [readyState isEqualToString:@"complete"];
    return complete;
}




#pragma webView
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType

//开始加载的时候执行该方法。
- (void)webViewDidStartLoad:(UIWebView *)webView{

    
    
}

//加载完成的时候执行该方法。
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    


}

//加载出错的时候执行该方法。
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}


- (void)setLoadingProgress:(CGFloat)loadingProgress
{
    

    
}


@end
