//  _____  _           _          _____ _          _
//  |  ___(_)_ __   __| | ___ _ _|_   _(_)_      _| | __
//  | |_  | | '_ \ / _` |/ _ \ '__|| | | \ \ /\ / / |/ /
//  |  _| | | | | | (_| |  __/ |   | | | |\ V  V /|   <
//  |_|   |_|_| |_|\__,_|\___|_|   |_| |_| \_/\_/ |_|\_\
//
//  Created by FinderTiwk on 23/10/2017.
//  Copyright © 2017 _Finder丶Tiwk. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol FKSegmentedView <NSObject>
//点击了第几个按钮
- (void)segmentViewDidSelectedAtIndex:(NSUInteger)index;
@end

@interface FKSegmentedView : UIView

@property (nonatomic,readonly) NSUInteger selectedIndex;

//标题字符串数组
@property (nonatomic,strong) NSArray<NSString *> *items;

//手动控制要选中哪个标题按钮
- (void)setSelectedIndex:(NSUInteger)index
               animation:(BOOL)animation;

//标题按钮点击事件回调,代理,block二选一
@property (nonatomic,assign) id<FKSegmentedView> delegate;
@property (nonatomic,copy) void (^selectCallback)(NSUInteger index);

#pragma mark - 偏好设置
//是否显示水平滚动条,default NO
@property (nonatomic,assign) BOOL showsHorizontalScrollIndicator;
//标题字体,default PingFangSC-Regular 16
@property (nonatomic,strong) UIFont *titleFont;
//标题正常颜色,default RGBB(129,129,129)
@property (nonatomic,strong) UIColor *titleColorForNormal;
//标题选中颜色,default RGV(29,156,248)
@property (nonatomic,strong) UIColor *titleColorForSelected;

//游标颜色,default RGV(29,156,248)
@property (nonatomic,strong) UIColor *cursorColor;
//游标高度,default 3
@property (nonatomic,assign) CGFloat cursorHeight;

//如果内容没有视图宽,是否将内容居中,如果设置,将会忽略space属性
@property (nonatomic,assign) BOOL autoAlignCenter;
//左右间距,default 0,
@property (nonatomic,assign) CGFloat space;
//按钮间水平边距,default 15
@property (nonatomic,assign) CGFloat padding;
@end

