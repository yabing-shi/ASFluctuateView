//
//  ViewController.m
//  ASFluctuate
//
//  Created by shiyabing on 16/12/14.
//  Copyright © 2016年 shiyabing. All rights reserved.
//

#import "ViewController.h"
#import "ASFluctuateView.h"

#define kDeviceWidth           [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight          [UIScreen mainScreen].bounds.size.height
#define KNavigationBarHeight   64

@interface ViewController ()<ASFluctuateViewDelegate>{
    
}
@property(nonatomic,strong)ASFluctuateView *fluctuateView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = [UIColor cyanColor];
    self.navigationItem.title = @"hah";



}
- (IBAction)upToDown:(id)sender {
    _fluctuateView = [[ASFluctuateView alloc]initWithFrame:CGRectMake(0, KNavigationBarHeight, kDeviceWidth, KDeviceHeight) type:ASFluctuateViewTypeRectangle isUpToDown:YES screenCanUsedHeight:300];
    _fluctuateView.delegate = self;
    _fluctuateView.itemArray = @[@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",];
    [_fluctuateView showInView:self.navigationController.view];
}

- (IBAction)downToUp:(id)sender {
    _fluctuateView = [[ASFluctuateView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight) type:ASFluctuateViewTypeRectangle isUpToDown:NO screenCanUsedHeight:300];
    _fluctuateView.delegate = self;
    _fluctuateView.itemArray = @[@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",];
    [_fluctuateView showInView:self.navigationController.view];

}

- (IBAction)actionSheet:(id)sender {
    _fluctuateView = [[ASFluctuateView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight) type:ASFluctuateViewTypeActionSheet isUpToDown:NO screenCanUsedHeight:300];
    _fluctuateView.delegate = self;
    _fluctuateView.itemArray = @[@"11",@"12",@"13",@"14",@"15",@"取消",];
    [_fluctuateView showInView:self.navigationController.view];

}



- (void)fluctuateView:(ASFluctuateView *)fluctuateView content:(UIView *)contentView itemIndex:(NSInteger)index;{
    //处理item点击事件
    NSLog(@"%ld",(long)index);
}


- (void)fluctuateView:(ASFluctuateView *)fluctuateView{
    [fluctuateView hideFluctuateView];
}

@end
