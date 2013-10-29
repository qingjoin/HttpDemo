//
//  GLqingyunHttp.h
//  GameLive
//
//  Created by qingyun on 10/18/13.
//  Copyright (c) 2013 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GLqingyunHttpDelegate  ;


@interface GLqingyunHttp : NSObject<NSURLConnectionDelegate>
{
    NSMutableURLRequest                 *_request;
    NSString                            *dataLength;
    NSDictionary                        *_responesDic;
    
}
@property(nonatomic,assign)id<GLqingyunHttpDelegate> delegate;
@property(nonatomic,assign)NSInteger   timeOut;                             //超时
+ (id)requestWithURL:(NSURL *)newURL;                                       //url
-(void)setHTTPMethod:(NSString*)method;                                     //GET or POST
-(void)setHTTPBodyNonSyschronous:(NSData*)data;                             //异步请求
-(void)addRequestHeader:(NSString *)header value:(NSString *)value;         //头里添加参数
-(void)setValue:(id)value forKey:(NSString*)key;                            //以Key value的方式传值
-(void)setHTTPBody:(NSData*)data;                                           //传参


@end

//delegate 代理
@protocol GLqingyunHttpDelegate <NSObject>
-(void)requestFinished:(NSDictionary*)request;                             //请求结束
-(void)requestFailed:(NSError*)error;                                       //请求出错
@end


