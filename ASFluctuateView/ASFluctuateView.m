//
//  XSFluctuateView.m
//  xiangshangV3
//
//  Created by shiyabing on 16/2/29.
//  Copyright © 2016年 xiangshang360. All rights reserved.
//

#import "XSFluctuateView.h"

#define ITEMHEIGHT 55

@interface XSFluctuateView (){
    XSFluctuateViewType currentType;
    CGFloat itemsHeight;
}

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UIView *cancelView;
@property (nonatomic, strong) UIImageView *selectImgView;
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation XSFluctuateView

- (id)initWithFrame:(CGRect)frame type:(XSFluctuateViewType)type isUpToDown:(BOOL)isUpToDown screenCanUsedHeight:(CGFloat)contentHeight{
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = 8888;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        self.frame = frame;
        currentType = type;
        _isUpToDown = isUpToDown;
        _contentHeight = contentHeight;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tap{
    DLog(@"被摸了");
    [self.delegate fluctuateView:self];
}

- (void)setItemArray:(NSArray *)itemArray{
    if (_contentView) {
        [_contentView removeFromSuperview];
        _contentView = nil;
    }
    if(_cancelView){
        [_cancelView removeFromSuperview];
    }
    _itemArray = itemArray;
    itemsHeight = ITEMHEIGHT * _itemArray.count;
    
    [self addSubview:self.contentView];
    [self creatSubViews];
}

- (void)creatSubViews{
    if (currentType == XSFluctuateViewTypeRectangle) {
        for (NSInteger i = 0; i < self.itemArray.count; i ++) {
            UILabel *divLabel = [XSHelper buildLabelWithFrame:CGRectMake(0, ITEMHEIGHT * i, kDeviceWidth, 1) bgColor:XSHLineColor textColor:nil font:nil];
            [_contentView addSubview:divLabel];
            UIButton *button = [XSHelper buildButtonWithFrame:CGRectMake(10, ITEMHEIGHT * i, kDeviceWidth - 20, ITEMHEIGHT) bgColor:Color_clearColor title:self.itemArray[i] font:15 textColor:ColorWithHex(0x252c3d, 1) corner:0];
            button.tag = i;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
        }
        [self.contentView addSubview:self.selectImgView];
        self.contentView.contentSize = CGSizeMake(0, itemsHeight);
    }else if (currentType == XSFluctuateViewTypeActionSheet){
        [XSHelper setCornerRadiusWithView:self.contentView corner:10 BorderColor:nil borderWidth:0 masksToBounds:YES];
        [XSHelper setCornerRadiusWithView:self.cancelView corner:10 BorderColor:nil borderWidth:0 masksToBounds:YES];
        for (NSInteger i = 0; i < self.itemArray.count; i ++) {
            UILabel *divLabel = [XSHelper buildLabelWithFrame:CGRectMake(0, ITEMHEIGHT * i, kDeviceWidth - 20, .5) bgColor:XSHLineColor textColor:nil font:nil];
            UIButton *button = [XSHelper buildButtonWithFrame:CGRectMake(10, ITEMHEIGHT * i + .5, kDeviceWidth - 40, ITEMHEIGHT) bgColor:Color_clearColor title:self.itemArray[i] font:16 textColor:ColorWithHex(0x252c3d, 1) corner:0];
            button.tag = i;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [button addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i == self.itemArray.count - 1) {
                divLabel.frame = CGRectMake(0, ITEMHEIGHT * i - 9, kDeviceWidth, 1);
                button.frame = CGRectMake(10, 0, kDeviceWidth - 40, ITEMHEIGHT);
                button.titleLabel.font = kFont18;
                [button setTitleColor:ColorWithHex(0x0076ff, 1) forState:UIControlStateNormal];
                [self.cancelView addSubview:button];
            }else{
                if (i != 0) {
                    [self.contentView addSubview:divLabel];
                }
                [self.contentView addSubview:button];
            }
        }
        [self addSubview:self.cancelView];
        self.contentView.contentSize = CGSizeMake(0, itemsHeight - ITEMHEIGHT);
    }
}

- (UIView *)cancelView{
    if (_cancelView == nil) {
        _cancelView = [[UIView alloc] initWithFrame:CGRectMake(10, KDeviceHeight, kDeviceWidth - 20, ITEMHEIGHT)];
        _cancelView.backgroundColor = Color_whiteColor;
    }
    return _cancelView;
}

- (UIImageView *)selectImgView{
    if (_selectImgView == nil) {
        _selectImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"finance_choose"]];
        _selectImgView.frame = CGRectMake(kDeviceWidth - 30, 35/2 + ITEMHEIGHT * self.upCurrectItem, 20, 20);
    }
    return _selectImgView;
}

- (UIScrollView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIScrollView alloc] init];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.backgroundColor = Color_whiteColor;
        _contentView.alpha = 0;
    }
    if (currentType == XSFluctuateViewTypeRectangle) {
        if (_isUpToDown) {
            _contentView.frame = CGRectMake(0, 0, kDeviceWidth, _contentHeight);
        }else{
            _contentView.frame = CGRectMake(0, KDeviceHeight, kDeviceWidth, _contentHeight);
        }
        [_contentView setHeight:itemsHeight >= _contentHeight ? _contentHeight : itemsHeight];
    }else if (currentType == XSFluctuateViewTypeActionSheet) {
        _contentView.frame = CGRectMake(10, KDeviceHeight, kDeviceWidth - 20, _contentHeight - ITEMHEIGHT - 17);
        [_contentView setHeight:itemsHeight >= _contentHeight ? _contentHeight - ITEMHEIGHT - 17 : itemsHeight - ITEMHEIGHT - 17];
    }
    
    return _contentView;
}

- (void)setUpCurrectItem:(NSInteger)upCurrectItem{
    _upCurrectItem = upCurrectItem;
    CGRect rect = CGRectMake(kDeviceWidth - 30, 35/2 + ITEMHEIGHT * self.upCurrectItem, 20, 20);
    self.selectImgView.frame = rect;
}

- (void)setDownCurrectItem:(NSInteger)downCurrectItem{
    _downCurrectItem = downCurrectItem;
    CGRect rect = CGRectMake(kDeviceWidth - 30, 35/2 + ITEMHEIGHT * self.downCurrectItem, 20, 20);
    self.selectImgView.frame = rect;
}

- (void)itemButtonClick:(UIButton *)btn{
    [self hideFluctuateView];
    [self.delegate fluctuateView:self content:self.contentView itemIndex:btn.tag];
}

- (void)showInView:(UIView *)parentView{
    self.hidden = NO;
    [parentView addSubview:self];
    [UIView animateWithDuration:.2 animations:^{
        self.contentView.alpha = 1;
        if (_isUpToDown) {
            
        }else{
            if (currentType == XSFluctuateViewTypeRectangle) {
                if (itemsHeight >= _contentHeight) {
                    [self.contentView setY:KDeviceHeight - _contentHeight];
                }else{
                    [self.contentView setY:KDeviceHeight - itemsHeight];
                }
            }else if (currentType == XSFluctuateViewTypeActionSheet){
                if (itemsHeight >= _contentHeight) {
                    self.contentView.frame = CGRectMake(10, KDeviceHeight - _contentHeight, kDeviceWidth - 20, _contentHeight - ITEMHEIGHT - 17);
                }else{
                    self.contentView.frame = CGRectMake(10, KDeviceHeight - itemsHeight - 17, kDeviceWidth - 20, itemsHeight - ITEMHEIGHT);
                }
                self.cancelView.frame = CGRectMake(10, KDeviceHeight - ITEMHEIGHT - 9, kDeviceWidth - 20, ITEMHEIGHT);
            }
        }

        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }];
}

- (void)hideFluctuateView{
    [UIView animateWithDuration:.2 animations:^{
        if (self.isUpToDown) {
            self.contentView.alpha = 0;
        }else{
            if (currentType == XSFluctuateViewTypeRectangle) {
                [self.contentView setY:KDeviceHeight];
            }else if (currentType == XSFluctuateViewTypeActionSheet){
                self.contentView.frame = CGRectMake(10, KDeviceHeight, kDeviceWidth - 20, ITEMHEIGHT * (_itemArray.count - 1));
                self.cancelView.frame = CGRectMake(10, KDeviceHeight, kDeviceWidth - 20, ITEMHEIGHT);
            }
        }
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end
