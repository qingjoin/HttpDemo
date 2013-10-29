//
//  ViewController.m
//  HttpDemo
//
//  Created by qingyun on 10/29/13.
//  Copyright (c) 2013 qingyun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnPress:(id)sender
{
    [self getFKjsonCountryCode];
}

- (IBAction)delegateBtnPress:(id)sender
{
    NSURL *url = nil;
    url = [NSURL URLWithString:[@"http://qa.api.mygm.sdo.com/v1/basic/countrycode" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    GLqingyunHttp *http = [GLqingyunHttp  requestWithURL:url];
    [http addRequestHeader:@"key" value:@"value"];  //设置头
    [http setValue:@"" forKey:@""];  //以key value 的方式传
    http.delegate = self;
    [http setHTTPBody:[self dataT]];    //把参数以data的方式传
    
}

//代理的方式回调
-(void)requestFinished:(NSDictionary *)request
{
    
}

-(void)requestFailed:(NSError *)error
{
    
}


/*******************************************************************************/
/*******************************************************************************/
-(NSMutableData*)dataT
{

    NSString *str = nil;
    //str = [[NSString alloc ]initWithData:[[self getPhoneInfoData] JSONData]encoding:NSUTF8StringEncoding];  //手机信息data转成string
    str = [NSString stringWithFormat:@"data=%@&deviceid=%@&type=ios",str,@"BA617491-FB6D-4B69-90B3-4CE898B0D295"];
    
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"str:%@",str);
    NSMutableData *mdata=[[NSMutableData alloc]init];
    mdata=[NSData dataWithData:data];
    return mdata;
}

-(NSMutableDictionary*)getPhoneInfoData
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    
    [data setObject:[[UIDevice currentDevice] systemName] forKey:@"systemName"];
    [data setObject:[[UIDevice currentDevice] systemVersion] forKey:@"systemVersion"];
    [data setObject:[[UIDevice currentDevice] model] forKey:@"model"];
    [data setObject:[[UIDevice currentDevice] localizedModel] forKey:@"localizedModel"];
    
    [data setObject:@"iosss" forKey:@"platform"];
    [data setObject:@"ios"  forKey:@"platformString"];
    
    [data setObject:@"BA617491-FB6D-4B69-90B3-4CE898B0D295" forKey:@"mac"];
    //NSLog(@"xxxfffss:%@",data);
    //NSLog(@"phoneInfo:%@",[[NSString alloc ]initWithData:[data JSONData] encoding:NSUTF8StringEncoding]);
    return data;
}



/*******************************************************************************/
/*******************************************************************************/
-(void)getFKjsonCountryCode
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *urlString = [NSString stringWithFormat:@"http://qa.api.mygm.sdo.com/v1/basic/countrycode"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        //post
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        NSHTTPURLResponse* urlResponse = nil;
        NSError *error = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *countryDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300)
        {
            NSLog(@"success:%@ : %@",countryDic,result);  //
        }
        else
        {
            
        }
        
    });
}

/*******************************************************************************/
/*******************************************************************************/





/*******************************************************************************/
/*******************************************************************************/
#pragma mark  get country code //异步
-(void)getFKjsonCountryCodeAsync
{
    NSString *urlString = [NSString stringWithFormat:@"http://qa.api.mygm.sdo.com/v1/basic/countrycode"];
    // 初始化请求
    NSMutableURLRequest  *request = [[NSMutableURLRequest alloc] init];
    // 设置
    [request setURL:[NSURL URLWithString:urlString]];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy]; // 设置缓存策略
    [request setTimeoutInterval:20.0]; // 设置超时
    [request setHTTPMethod:@"POST"];
    //......
    
    //    receivedData = [[NSMutableData alloc] initData: nil];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request     delegate:self];
    if (connection == nil) {
        NSLog(@"errors");
        // 创建失败
        return;
    }
}

// 收到回应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"receive the response");
    
}
// 接收数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    NSError *error = nil;
    NSDictionary *countryDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",countryDic);
}
// 数据接收完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"finishLoading");
}
// 返回错误
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}


@end
