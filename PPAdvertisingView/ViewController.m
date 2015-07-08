//
//  ViewController.m
//  PPAdvertisingView
//
//  Created by StarNet on 7/8/15.
//  Copyright (c) 2015 StarNet. All rights reserved.
//

#import "ViewController.h"
#import "PPAdvertisingView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray* items = [NSMutableArray array];
    {
        PPAdvertisingItem* item = [PPAdvertisingItem itemWithTitle:@"title 1" contentURL:@"http://www.baidu.com"];
        item.image = [UIImage imageNamed:@"1.jpg"];
        item.imageURL = @"http://img02.tooopen.com/images/20141231/sy_78327074576.jpg";
        item.placeholderImage = [UIImage imageNamed:@"default.gif"];
        [items addObject:item];
    }
    
    {
        PPAdvertisingItem* item = [PPAdvertisingItem itemWithTitle:@"title 2" contentURL:@"http://www.baidu.com"];
        item.image = [UIImage imageNamed:@"2.jpg"];
        item.placeholderImage = [UIImage imageNamed:@"default.gif"];
        item.imageURL = @"http://img02.tooopen.com/images/20150703/tooopen_sy_132841336778.jpg";
        [items addObject:item];
    }
    
    {
        PPAdvertisingItem* item = [PPAdvertisingItem itemWithTitle:@"title 3" contentURL:@"http://www.baidu.com"];
        item.image = [UIImage imageNamed:@"3.jpg"];
        item.placeholderImage = [UIImage imageNamed:@"default.gif"];
        item.imageURL = @"http://img02.tooopen.com/images/20150703/tooopen_sy_132841942385.jpg";
        [items addObject:item];
    }
    
    {
        PPAdvertisingItem* item = [PPAdvertisingItem itemWithTitle:@"title 4" contentURL:@"http://www.baidu.com"];
        item.image = [UIImage imageNamed:@"4.jpg"];
        item.placeholderImage = [UIImage imageNamed:@"default.gif"];
        item.imageURL = @"http://img02.tooopen.com/images/20150703/tooopen_sy_132839665724.jpg";
        [items addObject:item];
    }
    
    PPAdvertisingView* adView = [[PPAdvertisingView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 200) advertisingItems:items touchAction:^(PPAdvertisingItem *item) {
        NSLog(@"Touch %@", item.title);
    }];
    
    [self.view addSubview:adView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
