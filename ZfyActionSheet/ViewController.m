//
//  ViewController.m
//  ZfyActionSheet
//
//  Created by 风之翼 on 15/4/20.
//  Copyright (c) 2015年 风之翼. All rights reserved.
//

#import "ViewController.h"
#import "ZfyActionSheet.h"
@interface ViewController ()<ZfyActionSheetDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor=[UIColor redColor];
    btn.frame=CGRectMake(60, 200,200,40);
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

-(void)btnClick
{
    
    ZfyActionSheet *zfy =[[ZfyActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"还是删掉" destructiveButtonTitle:@"不敢删" otherButtonTitles:@[@"不删除",@"等下再说",@"哈哈",@"哈哈"]];
    zfy.tag=100;
    [zfy showInView:self.view];
}
-(void)ZfyActionSheet:(ZfyActionSheet *)actionSheet ClickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionSheet =====%ld  buttonIndex =====%ld",actionSheet.tag,buttonIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
