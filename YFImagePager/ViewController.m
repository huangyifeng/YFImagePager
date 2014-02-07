//
//  ViewController.m
//  YFImagePager
//
//  Created by huang yifeng on 14-2-5.
//  Copyright (c) 2014年 aimob. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, weak)IBOutlet YFImagePager *imagePager;
@property(nonatomic, weak)IBOutlet UILabel      *textLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imagePager.imageSwitchTimeInterval = 2;
    self.imagePager.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.imagePager.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"memory waring");
}

#pragma mark - YFImagePagerDataSource

- (NSArray *)arrayOfImages:(YFImagePager *)pager
{
    UIImage *image1 = [UIImage imageNamed:@"44.png"];
    UIImage *image2 = [UIImage imageNamed:@"55.png"];
    UIImage *image3 = [UIImage imageNamed:@"66.png"];
    NSString *string1 = @"http://114.80.218.33/skin/images/map4.jpg";
    
    return [NSArray arrayWithObjects:string1, image1, image2, image3, nil];
}

- (UIViewContentMode)imagePager:(YFImagePager *)pager imageModeAtIndex:(NSInteger)index
{
    return UIViewContentModeScaleAspectFit;
}

#pragma mark - YFImagePagerDelegate

- (void)imagePager:(YFImagePager *)pager didSelectImageAtIndex:(NSInteger)index
{
    self.textLabel.text = [[NSString alloc] initWithFormat:@"Click Image At Index: %d", index];
}

@end
