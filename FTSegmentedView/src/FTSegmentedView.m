//  _____  _           _          _____ _          _
//  |  ___(_)_ __   __| | ___ _ _|_   _(_)_      _| | __
//  | |_  | | '_ \ / _` |/ _ \ '__|| | | \ \ /\ / / |/ /
//  |  _| | | | | | (_| |  __/ |   | | | |\ V  V /|   <
//  |_|   |_|_| |_|\__,_|\___|_|   |_| |_| \_/\_/ |_|\_\
//
//  Created by FinderTiwk on 23/10/2017.
//  Copyright © 2017 _Finder丶Tiwk. All rights reserved.
//
#import "FTSegmentedView.h"

@interface FTSegmentedView ()
@property (nonatomic,readwrite,assign) NSUInteger selectedIndex;
@property (nonatomic,weak) UIView *cursorView;
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) UIButton *selectedButton;
@end

@implementation FTSegmentedView

- (instancetype)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        [self preferences];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self preferences];
}
- (void)preferences{
    self.selectedIndex = 0;
    self.cursorHeight = 3;
    self.padding = 15;
    self.space = 0.f;
    self.titleColorForNormal = [UIColor colorWithRed:129/255.0
                                               green:129/255.0
                                                blue:129/255.0
                                               alpha:1.0];
    UIColor *defaultSelectedColor = [UIColor colorWithRed:29/255.0
                                                    green:156/255.0
                                                     blue:248/255.0
                                                    alpha:1.0];
    self.titleColorForSelected = defaultSelectedColor;
    self.cursorColor = defaultSelectedColor;
    self.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
}

- (void)setShowsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator{
    _showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
}


- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){CGPointZero,rect.size}];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    NSParameterAssert(self.items);
    NSUInteger count = self.items.count;
    NSParameterAssert(count > 0);
    CGFloat sHeight = rect.size.height;
    CGFloat itemHeght = (sHeight - 2 * self.padding);
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, itemHeght);
    NSDictionary *attrs = @{NSFontAttributeName: self.titleFont};
    NSMutableArray *buttonWidths = [NSMutableArray arrayWithCapacity:count];
    CGFloat contentWidth = 0;
    for (NSUInteger index = 0; index < count; index ++) {
        NSString *title = self.items[index];
        CGSize size = [title boundingRectWithSize:maxSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attrs
                                          context:nil].size;
        CGFloat buttonWidth = size.width + self.padding;
        [buttonWidths addObject:@(buttonWidth)];
        contentWidth += buttonWidth + self.padding;
    }
    contentWidth -= self.padding;
    CGFloat startX = self.space;
    CGFloat delta = rect.size.width - contentWidth;
    BOOL shouldAlignCenter = (self.autoAlignCenter && delta > 0);
    if (shouldAlignCenter) {
        startX = delta/2;
    }
    CGFloat centerX = 0;
    for (NSUInteger index = 0; index < count; index ++) {
        CGFloat buttonWidth = [buttonWidths[index] doubleValue];
        NSString *title = self.items[index];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(startX, self.padding, buttonWidth, itemHeght);
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(buttonDidClick:)
         forControlEvents:UIControlEventTouchUpInside];
        button.tag = index;
        button.titleLabel.font = self.titleFont;
        button.adjustsImageWhenDisabled = NO;
        [button setTitleColor:self.titleColorForNormal forState:UIControlStateNormal];
        [button setTitleColor:self.titleColorForSelected forState:UIControlStateSelected];
        [self.scrollView addSubview:button];
        if (index == self.selectedIndex) {
            CGRect cursorFrame = CGRectMake(startX, sHeight - self.cursorHeight, buttonWidth, self.cursorHeight);
            UIView *cursorView = [[UIView alloc] initWithFrame:cursorFrame];
            cursorView.backgroundColor = self.cursorColor;
            [self.scrollView addSubview:cursorView];
            self.cursorView = cursorView;
            self.selectedButton = button;
            self.selectedButton.selected = YES;
            centerX = startX + buttonWidth/2;
        }
        startX += (buttonWidth + self.padding);
    }
    if (shouldAlignCenter) {
        self.scrollView.contentSize = CGSizeMake(startX - self.padding, sHeight);
    }else{
        self.scrollView.contentSize = CGSizeMake(startX - self.padding + self.space, sHeight);
    }
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bouncesZoom = NO;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = self.showsHorizontalScrollIndicator;
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    CGPoint contentOffset = [self calculateContentOffsetFrom:centerX];
    [self.scrollView setContentOffset:contentOffset];
}

- (void)buttonDidClick:(UIButton *)sender{
    NSUInteger selectedIndex = sender.tag;
    if (selectedIndex == self.selectedIndex) {
        return;
    }
    [self setSelectedIndex:selectedIndex animation:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentViewDidSelectedAtIndex:)]) {
        [self.delegate segmentViewDidSelectedAtIndex:selectedIndex];
    }
    !self.selectCallback?:self.selectCallback(selectedIndex);
}

- (void)clickButton:(UIButton *)sender
          animation:(BOOL)animation{
    CGRect clickFrame = sender.frame;
    CGFloat x = clickFrame.origin.x;
    CGFloat y = self.cursorView.frame.origin.y;
    CGFloat width = clickFrame.size.width;
    CGPoint contentOffset = [self calculateContentOffsetFrom:(x+width/2)];
    if (animation) {
        [UIView animateWithDuration:0.2 animations:^{
            self.cursorView.frame = CGRectMake(x, y, width, self.cursorHeight);
        }];
    }else{
        self.cursorView.frame = CGRectMake(x, y, width, self.cursorHeight);
    }
    [self.scrollView setContentOffset:contentOffset animated:YES];
    self.selectedButton.selected = NO;
    sender.selected = YES;
    self.selectedButton = sender;
    self.selectedIndex = sender.tag;
}

- (void)setSelectedIndex:(NSUInteger)index
               animation:(BOOL)animation{
    if (index == self.selectedIndex) {
        return;
    }
    UIButton *clickedButton;
    for (id view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            NSUInteger tmpIndex = ((UIButton *)view).tag;
            if (tmpIndex == index) {
                clickedButton = view;
                break;
            }
        }
    }
    [self clickButton:clickedButton animation:animation];
}

- (CGPoint)calculateContentOffsetFrom:(CGFloat)centerX{
    CGFloat scrollWidth  = self.scrollView.frame.size.width;
    CGFloat contentWidth = self.scrollView.contentSize.width;
    //如果内容宽度小于等于视图宽度,起点停留在原点
    if (contentWidth < scrollWidth) {
        return CGPointZero;
    }
    CGFloat contentOffsetX = 0;
    if (contentWidth - centerX > scrollWidth/2) {
        contentOffsetX = centerX - scrollWidth/2;
    }else{
        contentOffsetX = contentWidth - scrollWidth;
    }
    if (contentOffsetX < 0) {
        contentOffsetX = 0;
    }
    return CGPointMake(contentOffsetX, 0);
}
@end
