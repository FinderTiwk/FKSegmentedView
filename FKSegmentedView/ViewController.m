//
//  ViewController.m
//  FTSegmentedView
//
//  Created by FinderTiwk on 07/05/2018.
//  Copyright © 2018 FinderTiwk. All rights reserved.
//

#import "ViewController.h"
#import "FKSegmentedView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet FKSegmentedView *roleSegmentedView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //纯代码
    [self codeImp];
    
    //storyboard/xib
    [self storyboardImp];
}

- (void)codeImp{
    FKSegmentedView *roleView = [[FKSegmentedView alloc] initWithFrame:self.contentView.bounds];
    [self setupSegmentView:roleView];
    [self.contentView addSubview:roleView];
}

- (void)storyboardImp{
    [self setupSegmentView:self.roleSegmentedView];
}

- (void)setupSegmentView:(FKSegmentedView *)segmentView{
    segmentView.backgroundColor = [UIColor whiteColor];
    segmentView.items = @[@"管理员",@"角色一",@"角色二",@"其它闲杂人员",@"角色008"];
    segmentView.cursorHeight = 4;
    segmentView.selectCallback = ^(NSUInteger index) {
        NSLog(@"FTSegmentedView did click at %@ item",@(index));
    };
}

@end
