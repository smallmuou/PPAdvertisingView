//
//  PPAdvertisingView.m
//  PPAdvertisingView
//
//  Created by StarNet on 7/8/15.
//  Copyright (c) 2015 StarNet. All rights reserved.
//

#import "PPAdvertisingView.h"

#define kPageControlHeight  (20.f)

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
    UIScrollView*   _scrollView;
    NSMutableArray* _itemViews;
}

@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) NSInteger currentPage; //from 0

@end

@implementation PPAdvertisingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _itemViews = [NSMutableArray array];
        
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

- (void)setAdvertisingItems:(NSArray *)advertisingItems {
    _advertisingItems = advertisingItems;

    self.totalPage = [advertisingItems count];
    self.currentPage = 0;
    
    /** 头部需要插入最后一张图，尾部需要插入第一张图，因此scrollView要多出2页长度 */
    CGFloat contentWidth = (_totalPage > 1 ? _totalPage+2 : _totalPage)*self.bounds.size.width;
    
    _scrollView.contentSize = CGSizeMake(contentWidth, self.bounds.size.height);

    [self relayout];
}

- (void)layoutItemViewWithIndex:(NSInteger)index item:(PPAdvertisingItem* )item{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index*_scrollView.bounds.size.width, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height)];
    imageView.image = item.image;
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
        [self scrollToIndex:index];
    }
    
    for (PPAdvertisingItem* item in _advertisingItems) {
        [self layoutItemViewWithIndex:index item:item];
        index++;
    }

    if (self.totalPage > 1) {
        [self layoutItemViewWithIndex:index item:[_advertisingItems firstObject]];
        index++;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (NSInteger)(scrollView.contentOffset.x/scrollView.bounds.size.width);
    if (self.totalPage > 1) {
        self.currentPage = (index - 1 + self.totalPage)%self.totalPage;
        if (index == 0) {
            index += self.totalPage;
            [self scrollToIndex:index];
        } else if (index == self.totalPage+1) {
            index -= self.totalPage;
            [self scrollToIndex:index];
        }
    }
}

- (void)scrollToIndex:(NSInteger)index {
    CGFloat offsetX = index*_scrollView.bounds.size.width;
    _scrollView.contentOffset = CGPointMake(offsetX, 0);
}

@end
