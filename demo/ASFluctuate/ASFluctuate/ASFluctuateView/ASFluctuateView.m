//
//  ASFluctuateView.m
//  xiangshangV3
//
//  Created by shiyabing on 16/2/29.
//  Copyright © 2016年 xiangshang360. All rights reserved.
//

#import "ASFluctuateView.h"

#define ITEMHEIGHT 55
#define kDeviceWidth           [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight          [UIScreen mainScreen].bounds.size.height
#define ColorWithHex(hex,alph)  [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:(alph)]

@interface ASFluctuateView (){
    ASFluctuateViewType currentType;
    CGFloat itemsHeight;
}

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UIView *cancelView;
@property (nonatomic, strong) UIImageView *selectImgView;
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation ASFluctuateView

- (id)initWithFrame:(CGRect)frame type:(ASFluctuateViewType)type isUpToDown:(BOOL)isUpToDown screenCanUsedHeight:(CGFloat)contentHeight{
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
    if ([self.delegate respondsToSelector:@selector(fluctuateView:)]) {
        [self.delegate fluctuateView:self];
    }
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
    if (currentType == ASFluctuateViewTypeRectangle) {
        for (NSInteger i = 0; i < self.itemArray.count; i ++) {
            UILabel *divLabel = [self buildLabelWithFrame:CGRectMake(0, ITEMHEIGHT * i, kDeviceWidth, 1) bgColor:ColorWithHex(0xe3e3e3,1) textColor:nil font:nil];
            [_contentView addSubview:divLabel];
            UIButton *button = [self buildButtonWithFrame:CGRectMake(10, ITEMHEIGHT * i, kDeviceWidth - 20, ITEMHEIGHT) bgColor:[UIColor clearColor] title:self.itemArray[i] font:15 textColor:ColorWithHex(0x252c3d, 1) corner:0];
            button.tag = i;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
        }
        [self.contentView addSubview:self.selectImgView];
        self.contentView.contentSize = CGSizeMake(0, itemsHeight);
    }else if (currentType == ASFluctuateViewTypeActionSheet){
        [self setCornerRadiusWithView:self.contentView corner:10 BorderColor:nil borderWidth:0 masksToBounds:YES];
        [self setCornerRadiusWithView:self.cancelView corner:10 BorderColor:nil borderWidth:0 masksToBounds:YES];
        for (NSInteger i = 0; i < self.itemArray.count; i ++) {
            UILabel *divLabel = [self buildLabelWithFrame:CGRectMake(0, ITEMHEIGHT * i, kDeviceWidth - 20, .5) bgColor:ColorWithHex(0xe3e3e3,1) textColor:nil font:nil];
            UIButton *button = [self buildButtonWithFrame:CGRectMake(10, ITEMHEIGHT * i + .5, kDeviceWidth - 40, ITEMHEIGHT) bgColor:[UIColor clearColor] title:self.itemArray[i] font:16 textColor:ColorWithHex(0x252c3d, 1) corner:0];
            button.tag = i;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [button addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            if (i == self.itemArray.count - 1) {
                divLabel.frame = CGRectMake(0, ITEMHEIGHT * i - 9, kDeviceWidth, 1);
                button.frame = CGRectMake(10, 0, kDeviceWidth - 40, ITEMHEIGHT);
                button.titleLabel.font = [UIFont systemFontOfSize:18];
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
        _cancelView.backgroundColor = [UIColor whiteColor];
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
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.alpha = 0;
    }
    if (currentType == ASFluctuateViewTypeRectangle) {
        if (_isUpToDown) {
            _contentView.frame = CGRectMake(0, 0, self.frame.size.width, _contentHeight);
        }else{
            _contentView.frame = CGRectMake(0, KDeviceHeight, self.frame.size.width, _contentHeight);
        }
        CGRect r        = _contentView.frame;
        r.size.height   = itemsHeight >= _contentHeight ? _contentHeight : itemsHeight;
        _contentView.frame      = r;
    }else if (currentType == ASFluctuateViewTypeActionSheet) {
        _contentView.frame = CGRectMake(10, KDeviceHeight, kDeviceWidth - 20, _contentHeight - ITEMHEIGHT - 17);
        CGRect r        = _contentView.frame;
        r.size.height   = itemsHeight >= _contentHeight ? _contentHeight - ITEMHEIGHT - 17 : itemsHeight - ITEMHEIGHT - 17;
        _contentView.frame      = r;

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
    if ([self.delegate respondsToSelector:@selector(fluctuateView:content:itemIndex:)]) {
        [self.delegate fluctuateView:self content:self.contentView itemIndex:btn.tag];
    }
}

- (void)showInView:(UIView *)parentView{
    self.hidden = NO;
    [parentView addSubview:self];
    [UIView animateWithDuration:.2 animations:^{
        self.contentView.alpha = 1;
        if (_isUpToDown) {
            
        }else{
            if (currentType == ASFluctuateViewTypeRectangle) {
                if (itemsHeight >= _contentHeight) {
                    CGRect r        = self.contentView.frame;
                    r.origin.y      = KDeviceHeight - _contentHeight;
                    self.contentView.frame      = r;

                }else{
                    CGRect r        = self.contentView.frame;
                    r.origin.y      = KDeviceHeight - itemsHeight;
                    self.contentView.frame      = r;                }
            }else if (currentType == ASFluctuateViewTypeActionSheet){
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
            if (currentType == ASFluctuateViewTypeRectangle) {
                CGRect r        = self.contentView.frame;
                r.origin.y      = KDeviceHeight;
                self.contentView.frame      = r;            }else if (currentType == ASFluctuateViewTypeActionSheet){
                self.contentView.frame = CGRectMake(10, KDeviceHeight, kDeviceWidth - 20, ITEMHEIGHT * (_itemArray.count - 1));
                self.cancelView.frame = CGRectMake(10, KDeviceHeight, kDeviceWidth - 20, ITEMHEIGHT);
            }
        }
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (UILabel *)buildLabelWithFrame:(CGRect) frame bgColor:(UIColor *)bgColor textColor:(UIColor *)tColor font:(UIFont *)f
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    if (bgColor) {
        label.backgroundColor = bgColor;
    }
    label.textColor = tColor;
    label.text = @"";
    label.font = [UIFont systemFontOfSize:14];
    if (f) {
        label.font = f;
    }
    return label;
}

- (void)setCornerRadiusWithView:(UIView *)view corner:(float)corner BorderColor:(UIColor *)boederColor borderWidth:(float)borderWidth  masksToBounds:(BOOL)mask{
    if (boederColor) {
        view.layer.borderColor = boederColor.CGColor;
    }
    view.layer.borderWidth = borderWidth;
    view.layer.cornerRadius = corner;
    view.layer.masksToBounds = mask;
}

- (UIButton *)buildButtonWithFrame:(CGRect)frame bgColor:(UIColor *)bgC title:(NSString *)titleS font:(CGFloat)f textColor:(UIColor *)textC corner:(CGFloat)c{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = bgC;
    [button setTitle:titleS forState:UIControlStateNormal];
    [button setTitleColor:textC forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:f];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = c;
    
    return button;
}
@end
