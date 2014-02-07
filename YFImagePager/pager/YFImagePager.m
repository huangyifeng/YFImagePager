//
//  YFImagePager.m
//  TestNaviController
//
//  Created by huang yifeng on 14-2-5.
//  Copyright (c) 2014年 aimob. All rights reserved.
//

#import "YFImagePager.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kPageControlHeight  30

@interface YFImagePager ()

//view
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)NSMutableArray *arrayOfImageView;

//model
@property(nonatomic, strong)NSTimer *switchTimer;
@property(nonatomic, strong)NSArray *imageData;


- (void)initViewComponent;
- (void)loadData;
- (void)startImageSwitchTimer;
- (void)fireImageSwitchTimer:(NSTimer *)timer;
- (void)imageTapHandler:(UITapGestureRecognizer *)tap;

@end


@implementation YFImagePager

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self initViewComponent];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        [self initViewComponent];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self loadData];
}

#pragma mark - override

- (void)layoutSubviews
{
    CGSize thisSize = self.bounds.size;
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize =  CGSizeMake(thisSize.width * self.imageData.count, thisSize.height);
    
    CGRect pageControlFrame = CGRectMake(0, thisSize.height - kPageControlHeight, thisSize.width, kPageControlHeight);
    self.pageControl.frame = pageControlFrame;
    
    for (NSInteger index = 0, count = self.arrayOfImageView.count; index < count; index++)
    {
        UIImageView *imageView = [self.arrayOfImageView objectAtIndex:index];
        imageView.frame = CGRectMake(thisSize.width * index, 0, thisSize.width, thisSize.height);
    }
}

#pragma mark - private

- (void)initViewComponent
{
    //init scrollView
    if (!self.scrollView)
    {
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
    }
    
    //init pageControl
    if (!self.pageControl)
    {
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.userInteractionEnabled = NO;
        [self addSubview:self.pageControl];
    }
    
    //init imageViews
    if (!self.arrayOfImageView)
    {
        self.arrayOfImageView = [[NSMutableArray alloc] init];
    }

    NSInteger imageViewCount = self.arrayOfImageView.count;
    NSInteger dataCount = self.imageData.count;
    if (dataCount < imageViewCount)
    {
        for (NSInteger index = 0, count = imageViewCount - dataCount; index < count; index ++)
        {
            [self.arrayOfImageView removeLastObject];
        }
    }
    else
    {
        for (NSInteger index = 0, count = dataCount - imageViewCount; index < count; index ++)
        {
            UIImageView *imageView = [[UIImageView alloc] init];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapHandler:)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:tap];
            
            [self.scrollView addSubview:imageView];
            [self.arrayOfImageView addObject:imageView];
        }
    }

    //set control
    self.pageControl.numberOfPages = dataCount;
    self.pageControl.currentPage = 0;
    for (NSInteger index = 0; index < dataCount; index++)
    {
        UIImageView *imageView = [self.arrayOfImageView objectAtIndex:index];
        imageView.tag = index;
        imageView.clipsToBounds = YES;
        if ([self.dataSource respondsToSelector:@selector(imagePager:imageModeAtIndex:)])
        {
            imageView.contentMode = [self.dataSource imagePager:self imageModeAtIndex:index];
        }
        NSObject *imageObj = [self.imageData objectAtIndex:index];
        if ([imageObj isKindOfClass:[UIImage class]])
        {
            [imageView setImage:(UIImage *)imageObj];
        }
        else if ([imageObj isKindOfClass:[NSString class]])
        {
            NSURL *imageURL = [NSURL URLWithString:(NSString *)imageObj];
            if (imageURL)
            {
                [imageView setImageWithURL:imageURL];
            }
        }
        
        
        
    }
}

- (void)loadData
{
    if ([self.dataSource respondsToSelector:@selector(arrayOfImages:)])
    {
        self.imageData = [self.dataSource arrayOfImages:self];
    }
    
    [self initViewComponent];
    [self setNeedsLayout];
}

- (void)fireImageSwitchTimer:(NSTimer *)timer
{
    NSInteger nextPageIndex = self.pageControl.currentPage + 1;
    NSInteger pageCount = self.imageData.count;
    NSInteger scrollToIndex = (nextPageIndex + pageCount) % pageCount;
    
    [self scrollToPageIndex:scrollToIndex];
}

- (void)startImageSwitchTimer
{
    if (self.switchTimer.isValid)
    {
        [self.switchTimer invalidate];
    }
    
    if (0 < self.imageSwitchTimeInterval && 0 < self.imageData.count)
    {
        self.switchTimer = [NSTimer scheduledTimerWithTimeInterval:self.imageSwitchTimeInterval
                                                            target:self
                                                          selector:@selector(fireImageSwitchTimer:)
                                                          userInfo:nil
                                                           repeats:YES];
    }
}

- (void)imageTapHandler:(UITapGestureRecognizer *)tap
{
    UIView *imageView = [tap view];
    if ([self.delegate respondsToSelector:@selector(imagePager:didSelectImageAtIndex:)])
    {
        [self.delegate imagePager:self didSelectImageAtIndex:imageView.tag];
    }
}

#pragma mark - public

- (void)reloadData
{
    [self loadData];
}

- (void)scrollToPageIndex:(NSInteger)pageIndex
{
    [self scrollToPageIndex:pageIndex animated:YES];
}

- (void)scrollToPageIndex:(NSInteger)pageIndex animated:(BOOL)animated
{
    if ( 0 <= pageIndex && pageIndex < self.imageData.count)
    {
        CGSize thisSize = self.frame.size;
        CGRect scrollTo = CGRectMake(pageIndex * thisSize.width, 0, thisSize.width, thisSize.height);
        [self.scrollView scrollRectToVisible:scrollTo animated:animated];
        self.pageControl.currentPage = pageIndex;
    }
}

#pragma mark - getter & setter

- (void)setImageSwitchTimeInterval:(NSTimeInterval)imageSwitchTimeInterval
{
    if (_imageSwitchTimeInterval != imageSwitchTimeInterval)
    {
        _imageSwitchTimeInterval = imageSwitchTimeInterval;
        [self startImageSwitchTimer];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentIndex = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    self.pageControl.currentPage = currentIndex;
    [self startImageSwitchTimer];
}

@end
