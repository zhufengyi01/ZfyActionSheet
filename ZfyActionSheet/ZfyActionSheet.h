//
//  ZfyActionSheet.h
//  ZfyActionSheet
//
//  Created by 风之翼 on 15/4/20.
//  Copyright (c) 2015年 风之翼. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZfyActionSheetDelegate <NSObject>

-(void)ZfyActionSheet:(id) actionSheet ClickedButtonAtIndex:(NSInteger) buttonIndex;


@optional
- (void)didClickOnDestructiveButton;

- (void)didClickOnCancelButton;


@end
@interface ZfyActionSheet : UIView

-(instancetype)initWithTitle:(NSString *) title delegate:(id<ZfyActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray;

-(void)showInView:(UIView*)view;

@end
