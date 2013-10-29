//
//  GLqingyunHttp.m
//  GameLive
//
//  Created by qingyun on 10/18/13.
//  Copyright (c) 2013 qingyun. All rights reserved.
//

#import "GLqingyunHttp.h"
static NSMutableURLRequest *urlRequest = nil;
static GLqingyunHttp *glHttp = nil;

@implementation GLqingyunHttp
@synthesize delegate;
@synthesize timeOut;

+(id)requestWithURL:(NSURL *)newURL
{
    @synchronized(self)
    {
        if(glHttp == nil)
        {
            glHttp = [[super allocWithZone:NULL]init];
            urlRequest  = [[NSMutableURLRequest alloc] init];
            [urlRequest setURL:newURL];
        }
    }
    return glHttp;
}

-(void)setHTTPMethod:(NSString *)method
{
    [urlRequest setHTTPMethod:method];
}

- (void)addRequestHeader:(NSString *)header value:(NSString *)value
{
    [urlRequest setValue:value forHTTPHeaderField:header];
    
}

-(void)setValue:(id)value forKey:(NSString*)key
{
    [urlRequest setValue:value forKey:key];
}

#pragma mark  get country code //同步请求放到线程里。防止阻塞
-(void)setHTTPBody:(NSData*)data;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dataLength = [NSString stringWithFormat:@"%d", [data length]];
        [urlRequest setHTTPBody:data];
        [self setDefault];
        
        NSHTTPURLResponse* urlResponse = nil;
        NSError *error = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300)
        {
            NSLog(@"12:%@",result);
            [self.delegate requestFinished:_responesDic];
            //[self setDidFinishSelector:@selector(requestFinished:)];
            //[self performSelector:[self didFinishSelector] withObject:result];
            //[self performSelector:@selector(requestFinished:) withObject:result];
            //[self didFinishSelector];
            //[self didFinishSelector];
            
        }
        else
        {
            //[self didFailSelector];
        }

    });
}

#pragma mark  get country code //异步
-(void)setHTTPBodyNonSyschronous:(NSData*)data;
{
    dataLength = [NSString stringWithFormat:@"%d", [data length]];
    [urlRequest setHTTPBody:data];
    [self setDefault]; //一些默认设置
    [urlRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy]; // 设置缓存策略
    [urlRequest setTimeoutInterval:timeOut]; // 设置超时

//    NSError *error = nil;
//    NSHTTPURLResponse* urlResponse = nil;
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest     delegate:self];
      //NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest     delegate:self];
    if (connection == nil)
    {
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
    _responesDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"fff:%@",_responesDic);
    [self.delegate requestFinished:_responesDic];
    
}
// 数据接收完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finishLoading");
}
// 返回错误
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.delegate requestFailed:error];
    NSLog(@"Connection failed: %@", error);
}
 



-(void)setDefault
{
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:dataLength forHTTPHeaderField:@"Content-Length"];
    if(timeOut==0)
    {
        timeOut = 20;  //默认设置20超时
    }
    
}



@end
