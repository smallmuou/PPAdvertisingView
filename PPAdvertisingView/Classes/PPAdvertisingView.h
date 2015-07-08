/**
 * PPAdvertisingView
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

#import <UIKit/UIKit.h>

#pragma mark - PPAdvertisingItem
@interface PPAdvertisingItem : NSObject

/**
 * 初始化标题和广告详情
 * 
 * @param title 标题
 * @param contentURL 详情URL
 */
+ (instancetype)itemWithTitle:(NSString* )title
                   contentURL:(NSString* )contentURL;

/** 广告标题 */
@property (nonatomic, strong) NSString* title;

/** 广告详情的URL*/
@property (nonatomic, strong) NSString* contentURL;

/** 本地广告图 */
@property (nonatomic, strong) UIImage* image;

/** 网络广告图URL */
@property (nonatomic, strong) NSString* imageURL;

/** 默认广告图, 只针对网络广告图 */
@property (nonatomic, strong) UIImage* placeholdImage;

@end


#pragma mark - PPAdvertisingView
@interface PPAdvertisingView : UIView

/**
 * 初始化
 *
 * @param frame 区域
 * @param advertisingItems 广告单元组合，由PPAdvertisingItem对象组成
 * @param touchAction 单击广告页触发动作
 */
- (instancetype)initWithFrame:(CGRect)frame
             advertisingItems:(NSArray* )advertisingItems
                  touchAction:(void(^)(PPAdvertisingItem* item))touchAction;

/** 广告内容 */
@property (nonatomic, strong) NSArray* advertisingItems;

/** 自动滚动间隔时间，0表示不自动滚动，默认3s */
@property (nonatomic, assign) NSTimeInterval autoScrollTimeInterval;

/** 单击广告页触发动作 */
@property (nonatomic, copy) void(^touchAction)(PPAdvertisingItem* item);

/** 可以通过pageControl更改其位置、颜色、形状，但不可更改页数及当前页 */
@property (nonatomic, readonly) UIPageControl* pageControl;

@end
