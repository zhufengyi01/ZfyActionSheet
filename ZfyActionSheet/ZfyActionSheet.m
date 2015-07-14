//
//  ZfyActionSheet.m
//  ZfyActionSheet
//
//  Created by 风之翼 on 15/4/20.
//  Copyright (c) 2015年 风之翼. All rights reserved.
//

#import "ZfyActionSheet.h"
#import "UIImage+Color.h"
//取消按钮的背景
#define CANCEL_BUTTON_COLOR                     [UIColor colorWithRed:220.0/255.00f green:220.0/255.00f blue:220.0/255.00f alpha:1]
//警告背景颜色
#define DESTRUCTIVE_BUTTON_COLOR                [UIColor colorWithRed:185/255.00f green:45/255.00f blue:39/255.00f alpha:1]
//button的背景颜色
#define OTHER_BUTTON_COLOR                      [UIColor redColor]
//弹出窗口的颜色
#define ACTIONSHEET_BACKGROUNDCOLOR            [UIColor colorWithRed:220.0/255.00f green:220.0/255.00f blue:220.0/255.00f alpha:1]
//整个窗口的颜色
#define WINDOW_COLOR                            [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.2]

#pragma  mark  按钮有关
//按钮的圆角幅度
#define CORNER_RADIUS                           0
//按钮头部的空格间距
#define BUTTON_INTERVAL_HEIGHT                  6
//按钮
#define BUTTON_HEIGHT                           40
#define BUTTON_INTERVAL_WIDTH                   0
#define BUTTON_WIDTH                            [UIScreen mainScreen].bounds.size.width
//按钮字体样式和大小
#define BUTTONTITLE_FONT                       [UIFont systemFontOfSize:16]
//按钮的变宽宽度
#define BUTTON_BORDER_WIDTH                     0.5f
//按钮边框颜色
#define BUTTON_BORDER_COLOR                     [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8].CGColor



#pragma mark  title  有关
#define TITLE_INTERVAL_HEIGHT                   0
#define TITLE_HEIGHT                            35
#define TITLE_INTERVAL_WIDTH                    0
#define TITLE_WIDTH                             [UIScreen mainScreen].bounds.size.width
#define TITLE_FONT                              [UIFont systemFontOfSize:16]
#define SHADOW_OFFSET                           CGSizeMake(0, 0.0f)
#define TITLE_NUMBER_LINES                      2

//动画执行时间
#define ANIMATE_DURATION                        0.25f

@interface ZfyActionSheet ()

@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,strong) NSString *actionTitle;
@property (nonatomic,assign) NSInteger postionIndexNumber;
@property (nonatomic,assign) BOOL isHadTitle;
@property (nonatomic,assign) BOOL isHadDestructionButton;
@property (nonatomic,assign) BOOL isHadOtherButton;
@property (nonatomic,assign) BOOL isHadCancelButton;
@property (nonatomic,assign) CGFloat ZfyActionSheetHeight;
@property (nonatomic,assign) id<ZfyActionSheetDelegate>delegate;

@end



@implementation ZfyActionSheet
-(instancetype)initWithTitle:(NSString *)title delegate:(id<ZfyActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray
{
    self=[super init];
    if (self) {
        //初始化背景
        self.frame =CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor=WINDOW_COLOR;
        self.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapGesture =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        if (delegate) {
            
            self.delegate=delegate;
        }
        [self creatButtonsWithTitle:title cancelButtonTitle:cancelButtonTitle destructionButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitlesArray];
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    
}


#pragma mark - CreatButtonAndTitle method

- (void)creatButtonsWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructionButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray
{
    //初始化
    self.isHadTitle = NO;
    self.isHadDestructionButton = NO;
    self.isHadOtherButton = NO;
    self.isHadCancelButton = NO;
     self.ZfyActionSheetHeight = 0;
     self.postionIndexNumber = 0;
    
     self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
    self.backGroundView.backgroundColor = ACTIONSHEET_BACKGROUNDCOLOR;
    
     UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackGroundView)];
    [self.backGroundView addGestureRecognizer:tapGesture];
    
    [self addSubview:self.backGroundView];
    
    if (title) {
        self.isHadTitle = YES;
        UILabel *titleLabel = [self creatTitleLabelWith:title];
        self.ZfyActionSheetHeight = self.ZfyActionSheetHeight + 2*TITLE_INTERVAL_HEIGHT+TITLE_HEIGHT;
        [self.backGroundView addSubview:titleLabel];
    }
    
    if (destructiveButtonTitle) {
        self.isHadDestructionButton = YES;
        UIButton *destructiveButton = [self creatDestructiveButtonWith:destructiveButtonTitle];
        destructiveButton.tag = self.postionIndexNumber;
        [destructiveButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.isHadTitle == YES) {
            //当有title时
            [destructiveButton setFrame:CGRectMake(destructiveButton.frame.origin.x, self.ZfyActionSheetHeight, destructiveButton.frame.size.width, destructiveButton.frame.size.height)];
            
            if (otherButtonTitlesArray && otherButtonTitlesArray.count > 0) {
                self.ZfyActionSheetHeight = self.ZfyActionSheetHeight + destructiveButton.frame.size.height+BUTTON_INTERVAL_HEIGHT/2;
            }
            else{
                self.ZfyActionSheetHeight = self.ZfyActionSheetHeight + destructiveButton.frame.size.height+BUTTON_INTERVAL_HEIGHT;
            }
        }
        else{
            //当无title时
            if (otherButtonTitlesArray && otherButtonTitlesArray.count > 0) {
                self.ZfyActionSheetHeight = self.ZfyActionSheetHeight + destructiveButton.frame.size.height+(BUTTON_INTERVAL_HEIGHT/2);
            }
            else{
                self.ZfyActionSheetHeight = self.ZfyActionSheetHeight + destructiveButton.frame.size.height+(BUTTON_INTERVAL_HEIGHT/2);
            }
        }
        [self.backGroundView addSubview:destructiveButton];
        
        self.postionIndexNumber++;
    }
    
    if (otherButtonTitlesArray) {
        if (otherButtonTitlesArray.count > 0) {
            self.isHadOtherButton = YES;
            
            //当无title与destructionButton时
            if (self.isHadTitle == NO && self.isHadDestructionButton == NO) {
                for (int i = 0; i<otherButtonTitlesArray.count; i++) {
                    UIButton *otherButton = [self creatOtherButtonWith:[otherButtonTitlesArray objectAtIndex:i] withPostion:i];
                    
                    otherButton.tag = self.postionIndexNumber;
                    [otherButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if (i != otherButtonTitlesArray.count - 1) {
                        self.ZfyActionSheetHeight = self.ZfyActionSheetHeight + otherButton.frame.size.height+(BUTTON_INTERVAL_HEIGHT/2);
                    }
                    else{
                        self.ZfyActionSheetHeight = self.ZfyActionSheetHeight + otherButton.frame.size.height+(BUTTON_INTERVAL_HEIGHT/2);
                    }
                    [self.backGroundView addSubview:otherButton];
                    self.postionIndexNumber++;
                }
            }
            
            //当有title或destructionButton时
            if (self.isHadTitle == YES || self.isHadDestructionButton == YES) {
                for (int i = 0; i<otherButtonTitlesArray.count; i++) {
                    UIButton *otherButton = [self creatOtherButtonWith:[otherButtonTitlesArray objectAtIndex:i] withPostion:i];
                    
                    otherButton.tag = self.postionIndexNumber;
                    [otherButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
                    [otherButton setFrame:CGRectMake(otherButton.frame.origin.x, self.ZfyActionSheetHeight, otherButton.frame.size.width, otherButton.frame.size.height)];
                    
                    if (i != otherButtonTitlesArray.count - 1) {
                        self.ZfyActionSheetHeight = self.ZfyActionSheetHeight + otherButton.frame.size.height+(BUTTON_INTERVAL_HEIGHT/2);
                    }
                    else{
                        self.ZfyActionSheetHeight = self.ZfyActionSheetHeight + otherButton.frame.size.height+(BUTTON_INTERVAL_HEIGHT);
                    }
                    
                    [self.backGroundView addSubview:otherButton];
                    
                    self.postionIndexNumber++;
                }
            }
        }
    }
    
    if (cancelButtonTitle) {
        self.isHadCancelButton = YES;
        
        UIButton *cancelButton = [self creatCancelButtonWith:cancelButtonTitle];
        
        cancelButton.tag = self.postionIndexNumber;
        [cancelButton addTarget:self action:@selector(clickOnButtonWith:) forControlEvents:UIControlEventTouchUpInside];
        
        //当没title destructionButton otherbuttons时
        if (self.isHadTitle == NO && self.isHadDestructionButton == NO && self.isHadOtherButton == NO) {
            self.ZfyActionSheetHeight = self.ZfyActionSheetHeight + cancelButton.frame.size.height+(2*BUTTON_INTERVAL_HEIGHT);
        }
        //当有title或destructionButton或otherbuttons时
        if (self.isHadTitle == YES || self.isHadDestructionButton == YES || self.isHadOtherButton == YES) {
            [cancelButton setFrame:CGRectMake(cancelButton.frame.origin.x, self.ZfyActionSheetHeight, cancelButton.frame.size.width, cancelButton.frame.size.height)];
            self.ZfyActionSheetHeight = self.ZfyActionSheetHeight + cancelButton.frame.size.height+BUTTON_INTERVAL_HEIGHT;
        }
        
        [self.backGroundView addSubview:cancelButton];
        self.postionIndexNumber++;
    }
    self.ZfyActionSheetHeight = self.ZfyActionSheetHeight -BUTTON_INTERVAL_HEIGHT;
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.ZfyActionSheetHeight, [UIScreen mainScreen].bounds.size.width, self.ZfyActionSheetHeight)];
    } completion:^(BOOL finished) {
    }];
}

- (UILabel *)creatTitleLabelWith:(NSString *)title
{
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_INTERVAL_WIDTH, TITLE_INTERVAL_HEIGHT, TITLE_WIDTH, TITLE_HEIGHT)];
    titlelabel.backgroundColor = [UIColor whiteColor];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.shadowColor = [UIColor blackColor];
    titlelabel.shadowOffset = SHADOW_OFFSET;
    titlelabel.font = TITLE_FONT;
    titlelabel.text = title;
    titlelabel.textColor = [UIColor blackColor];
    titlelabel.numberOfLines = TITLE_NUMBER_LINES;
    return titlelabel;
}
- (UIButton *)creatDestructiveButtonWith:(NSString *)destructiveButtonTitle
{
    UIButton *destructiveButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_INTERVAL_WIDTH, 0, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [destructiveButton setBackgroundImage:[UIImage imageWithColor:[UIColor  lightGrayColor]] forState:UIControlStateNormal];
    [destructiveButton setTitle:destructiveButtonTitle forState:UIControlStateNormal];
    destructiveButton.titleLabel.font = BUTTONTITLE_FONT;
    [destructiveButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [destructiveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    return destructiveButton;
}

- (UIButton *)creatOtherButtonWith:(NSString *)otherButtonTitle withPostion:(NSInteger )postionIndex
{
    int button_interval_height;
    //if (postionIndex==0) {
      //  button_interval_height = 0;
    //}else
    //{
        button_interval_height = BUTTON_INTERVAL_HEIGHT;
    //}
    UIButton *otherButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_INTERVAL_WIDTH, 0+ (postionIndex*(BUTTON_HEIGHT+(BUTTON_INTERVAL_HEIGHT/2))), BUTTON_WIDTH, BUTTON_HEIGHT)];
    [otherButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
    otherButton.titleLabel.font = BUTTONTITLE_FONT;
    [otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [otherButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    return otherButton;
}

- (UIButton *)creatCancelButtonWith:(NSString *)cancelButtonTitle
{
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(BUTTON_INTERVAL_WIDTH, BUTTON_INTERVAL_HEIGHT, BUTTON_WIDTH, BUTTON_HEIGHT)];
    cancelButton.backgroundColor = CANCEL_BUTTON_COLOR;
    [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    cancelButton.titleLabel.font = BUTTONTITLE_FONT;
    [cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    return cancelButton;
}

- (void)clickOnButtonWith:(UIButton *)button
{
    //红色警戒按钮
    if (self.isHadDestructionButton == YES) {
        if (self.delegate) {
            if (button.tag == 0) {
                if ([self.delegate respondsToSelector:@selector(didClickOnDestructiveButton)] == YES){
                    [self.delegate didClickOnDestructiveButton];
                }
            }
        }
    }
    
    //取消
    if (self.isHadCancelButton == YES) {
        if (self.delegate) {
            if (button.tag == self.postionIndexNumber-1) {
                if ([self.delegate respondsToSelector:@selector(didClickOnCancelButton)] == YES) {
                    [self.delegate didClickOnCancelButton];
                }
            }
        }
    }
    
    //点击了button
    if (self.delegate) {
         if ([self.delegate respondsToSelector:@selector(ZfyActionSheet:ClickedButtonAtIndex:)]) {
             [self.delegate ZfyActionSheet:self ClickedButtonAtIndex:button.tag];
        }
        
    }
    
    [self tappedCancel];
}

- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}
- (void)tappedBackGroundView
{
    //
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
