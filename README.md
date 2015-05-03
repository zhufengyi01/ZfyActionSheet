# ZfyActionSheet
一个类似于系统的actionsheet的控件，使用起来非常方便
导入 #import "ZfyActionSheet.h"
遵守ZfyActionSheetDelegate 协议

在需要的地方
    ZfyActionSheet *zfy =[[ZfyActionSheet alloc]initWithTitle:@"确定删除" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删了" otherButtonTitles:@[@"不删除",@"等下再说"]];
    zfy.tag=100;
    [zfy showInView:self.view];

协议的代理方法
-(void)ZfyActionSheet:(ZfyActionSheet *)actionSheet ClickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionSheet =====%ld  buttonIndex =====%ld",actionSheet.tag,buttonIndex);
}
