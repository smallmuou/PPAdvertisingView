# PPAdvertisingView
PPAdvertisingView是一个集成UISCrollView与UIPageControll来完成市面上通用的广告页功能.
![image](https://github.com/smallmuou/PPAdvertisingView/blob/master/PPAdvertisingView.gif)

### WHY
Github中已经能找到类似的开源代码，我为什么要再开发一个呢？主要处于一下几个原因:

* 代码比较混乱
* 耦合度太高

### Configure

##### CocoaPods
* 添加Podfile，添加`pod "PPAdvertisingView"`

##### Manual
* 拷贝PPAdvertisingView.h与PPAdvertisingView.m到你的工程中
* 引入[SDWebImage](https://github.com/rs/SDWebImage)第三方库

### USAGE
<pre>
#import "PPAdvertisingView.h"

...

NSMutableArray* items = [NSMutableArray array];

{
    PPAdvertisingItem* item = [PPAdvertisingItem itemWithTitle:@"本地图片1" contentURL:@"http://www.baidu.com"];
    item.image = [UIImage imageNamed:@"1.jpg"];
    [items addObject:item];
}

PPAdvertisingView* adView = [[PPAdvertisingView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 200) advertisingItems:items touchAction:^(PPAdvertisingItem *item) {
    NSLog(@"点击 %@", item.title);
}];

[self.view addSubview:adView];
</pre>

### LICENSE
This codes follow MIT LICENSE.



