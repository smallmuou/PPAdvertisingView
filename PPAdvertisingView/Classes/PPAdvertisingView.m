/**
 * PPAdvertisingView.m
 *
 * 该类继承了广告功能，支持网络与本地图片
 *
 * MIT licence follows:
 *
 * Copyright (C) 2015 Wenva <lvyexuwenfa100@126.com>
 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is furnished
 * to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "PPAdvertisingView.h"
#import <UIImageView+WebCache.h>

#define kPageControlHeight  (20.f)
#define kAutoScrollTimeInterval (3.0f)

#pragma mark - PPAdvertisingItem
@implementation PPAdvertisingItem

+ (instancetype)itemWithTitle:(NSString* )title
                   contentURL:(NSString* )contentURL {
    return [[self alloc] initWithTitle:title contentURL:contentURL];
}

- (instancetype)initWithTitle:(NSString* )title
                   contentURL:(NSString* )contentURL {
    self = [self init];
    if (self) {
        self.title = title;
        self.contentURL = contentURL;
    }
    return self;
}

@end

#pragma mark - PPAdvertisingView
@interface PPAdvertisingView () <UIScrollViewDelegate> {
    UIScrollView*           _scrollView;
    NSMutableArray*         _itemViews;
    UITapGestureRecognizer* _tapGestureRecognize;
    NSTimer*                _scrollTimer;
    NSTimeInterval          _lastDraggingTimeInterval;
}

@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) NSInteger currentPage; //from 0
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation PPAdvertisingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _itemViews = [NSMutableArray array];
        _autoScrollTimeInterval = kAutoScrollTimeInterval;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-kPageControlHeight, self.bounds.size.width, kPageControlHeight)];
        _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_pageControl];
        
        //点击事件
        _tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
        _tapGestureRecognize.numberOfTapsRequired = 1;
        [_scrollView addGestureRecognizer:_tapGestureRecognize];
        
        //注册进入后台、前台通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
             advertisingItems:(NSArray* )advertisingItems
                  touchAction:(void(^)(PPAdvertisingItem* item))touchAction {
    self = [self initWithFrame:frame];
    if (self) {
        self.advertisingItems = advertisingItems;
        self.touchAction = touchAction;
    }
    return self;
}

- (void)applicationWillResignActiveNotification:(NSNotification* )notification {
    [_scrollTimer invalidate];
}

- (void)applicationWillEnterForegroundNotification:(NSNotification* )notification {
    self.autoScrollTimeInterval = _autoScrollTimeInterval;
}

- (void)dealloc {
    [_scrollView removeGestureRecognizer:_tapGestureRecognize];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    self.advertisingItems = _advertisingItems;
}

- (void)setTotalPage:(NSInteger)totalPage {
    _totalPage = totalPage;
    _pageControl.numberOfPages = totalPage;
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    _pageControl.currentPage = currentPage;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    self.currentPage = (_currentIndex - 1 + self.totalPage)%self.totalPage;
    
    CGFloat offsetX = currentIndex*_scrollView.bounds.size.width;
    _scrollView.contentOffset = CGPointMake(offsetX, 0);
}

- (void)setAutoScrollTimeInterval:(NSTimeInterval)autoScrollTimeInterval {
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [_scrollTimer invalidate];
    if (self.totalPage > 1 && _autoScrollTimeInterval) {
        _scrollTimer = [NSTimer timerWithTimeInterval:_autoScrollTimeInterval target:self selector:@selector(onScrollTimeOut:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_scrollTimer forMode:NSDefaultRunLoopMode];        
    }
}

- (void)onScrollTimeOut:(NSTimer* )timer {
    //拖动期间不允许自动滚动
    if (([NSDate timeIntervalSinceReferenceDate] - _lastDraggingTimeInterval) < _autoScrollTimeInterval) return;
    
    [UIView animateWithDuration:0.5f animations:^{
        self.currentIndex = (self.currentIndex+1)%(self.totalPage > 1 ? self.totalPage+2: self.totalPage);
    } completion:^(BOOL finished) {
        if (self.currentIndex == 0) {
            self.currentIndex += self.totalPage;
        } else if (self.currentIndex == self.totalPage+1) {
            self.currentIndex -= self.totalPage;
        }
    }];
}

- (void)setAdvertisingItems:(NSArray *)advertisingItems {
    _advertisingItems = advertisingItems;

    self.totalPage = [advertisingItems count];
    self.currentPage = 0;
    
    /** 头部需要插入最后一张图，尾部需要插入第一张图，因此scrollView要多出2页长度 */
    CGFloat contentWidth = (_totalPage > 1 ? _totalPage+2 : _totalPage)*self.bounds.size.width;
    
    _scrollView.contentSize = CGSizeMake(contentWidth, self.bounds.size.height);

    [self relayout];
    
    self.autoScrollTimeInterval = _autoScrollTimeInterval;
}

- (void)layoutItemViewWithIndex:(NSInteger)index item:(PPAdvertisingItem* )item{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index*_scrollView.bounds.size.width, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height)];
    if (item.imageURL) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:item.imageURL] placeholderImage:item.placeholderImage];
    } else {
        imageView.image = item.image;
    }
    [_scrollView addSubview:imageView];
    [_itemViews addObject:imageView];
}

- (void)relayout {
    //清空旧广告
    for (UIView* view in _itemViews) {
        [view removeFromSuperview];
    }
    [_itemViews removeAllObjects];
    
    //添加新的广告
    NSInteger index = 0;
    if (self.totalPage > 1) {
        [self layoutItemViewWithIndex:index item:[_advertisingItems lastObject]];
        index++;
    }
    
    for (PPAdvertisingItem* item in _advertisingItems) {
        [self layoutItemViewWithIndex:index item:item];
        index++;
    }

    if (self.totalPage > 1) {
        [self layoutItemViewWithIndex:index item:[_advertisingItems firstObject]];
        index++;
    }
    
    //默认第一张开始
    self.currentIndex = 1;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    NSInteger index = (NSInteger)(x/scrollView.bounds.size.width);
    if (index == 0) {
        index += self.totalPage;
        self.currentIndex = index;
    } else if (index == self.totalPage+1) {
        index -= self.totalPage;
        self.currentIndex = index;
    } else {
        self.currentPage = (index - 1 + self.totalPage)%self.totalPage;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _lastDraggingTimeInterval = [NSDate timeIntervalSinceReferenceDate];
    
    CGFloat x = scrollView.contentOffset.x;    
    NSInteger index = (NSInteger)(x/scrollView.bounds.size.width);
    if (self.totalPage > 1) {
        if (index == 0) {
            index += self.totalPage;
        } else if (index == self.totalPage+1) {
            index -= self.totalPage;
        }
        self.currentIndex = index;
    }
}

- (void)tapGestureRecognizer:(UIGestureRecognizer* )gestureRecognizer {
    if (_touchAction) {
        CGPoint point = [gestureRecognizer locationInView:_scrollView];
        NSInteger index = (NSInteger)(point.x/_scrollView.bounds.size.width);
        PPAdvertisingItem* item = _advertisingItems[(index-1+self.totalPage)%self.totalPage];
        _touchAction(item);
    }
}

@end
