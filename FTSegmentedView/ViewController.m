//
//  ViewController.m
//  FTSegmentedView
//
//  Created by FinderTiwk on 07/05/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import "ViewController.h"
#import "FTSegmentedView.h"

@interface ViewController ()

@property (nonatomic,assign) FTSegmentedView *roleSegmentedView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat x = 20;
    CGFloat y = 100;
    CGFloat w = size.width - 2*x;
    CGFloat h = 60;
    CGRect frame = (CGRect){CGPointMake(x, y),CGSizeMake(w, h)};
    FTSegmentedView *roleView = [[FTSegmentedView alloc] initWithFrame:frame];
    roleView.backgroundColor = [UIColor whiteColor];
    
    roleView.items = @[@"管理员",@"角色一",@"角色二",@"其它闲杂人员",@"角色008"];
    roleView.cursorHeight = 4;
    roleView.selectCallback = ^(NSUInteger index) {
        NSLog(@"FTSegmentedView did click at %@ item",@(index));
    };
    [self.view addSubview:roleView];
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
