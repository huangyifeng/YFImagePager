//
//  YFImagePager.h
//  TestNaviController
//
//  Created by huang yifeng on 14-2-5.
//  Copyright (c) 2014年 aimob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YFImagePager;
@protocol YFImagePagerDataSource <NSObject>

@required
- (NSArray *)arrayOfImages:(YFImagePager *)pager;

@optional
- (UIViewContentMode)imagePager:(YFImagePager *)pager imageModeAtIndex:(NSInteger)index;


@end

//===============================================

@protocol YFImagePagerDelegate <NSObject>

- (void)imagePager:(YFImagePager *)pager didSelectImageAtIndex:(NSInteger)index;

@end

//===============================================

@interface YFImagePager : UIView <UIScrollViewDelegate>

@property(nonatomic, weak)IBOutlet id<YFImagePagerDataSource> dataSource;
@property(nonatomic, weak)IBOutlet id<YFImagePagerDelegate>   delegate;

@property(nonatomic, assign)NSTimeInterval imageSwitchTimeInterval;

@property(nonatomic, strong)UIPageControl *pageControl;

- (void)reloadData;
- (void)scrollToPageIndex:(NSInteger)pageIndex;
- (void)scrollToPageIndex:(NSInteger)pageIndex animated:(BOOL)animated;

@end
