//
//  ViewController.h
//  HttpDemo
//
//  Created by qingyun on 10/29/13.
//  Copyright (c) 2013 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLqingyunHttp.h"

@interface ViewController : UIViewController<GLqingyunHttpDelegate>
- (IBAction)btnPress:(id)sender;
- (IBAction)delegateBtnPress:(id)sender;

@end
