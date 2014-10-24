//
//  message1ViewController.m
//  E-FixComputer
//
//  Created by administrator on 13-11-29.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "message1ViewController.h"
#import "ToolKit.h"
#import "publicMethod.h"
#import "ASIFormDataRequest.h"
#import "User.h"
#import "personCenter1ViewController.h"

@interface message1ViewController ()

@end

@implementation message1ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    messageApp = [publicMethod Add_appDelegate];
    
    //导航条，返回按钮，标题
    [publicMethod addNavigationBar:self];
    [publicMethod addBackButton:self action:@selector(backToPersentCenter)];
    [publicMethod addTitleOnNavigationBar:self titleContent:messageApp.loginuser.username];

    self.tabBarController.tabBar.hidden = YES;
    self.notaddress.enabled = NO;

    //定义一个视图放头像，目的是为了实现一个视图跳转的效果
    self.headView=[[UIView alloc]initWithFrame:CGRectMake(110, 60, 100, 100)];
    [self.headView.layer setCornerRadius:48];
    self.headView.layer.masksToBounds=YES;
    self.headView.layer.borderWidth=2;
    self.headView.layer.borderColor=[[UIColor whiteColor]CGColor];
    
    //设置确定按钮
    UIButton *loginbutton = [[UIButton alloc]init];
    loginbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginbutton.frame = CGRectMake(80, 380, 210, 30);
    loginbutton.backgroundColor = [UIColor colorWithRed:36/255.0 green:169/255.0 blue:225/255.0 alpha:1];
    loginbutton.titleLabel.textColor = [UIColor whiteColor];
    loginbutton.layer.cornerRadius = 5;
    [loginbutton setTitle:@"确定" forState:UIControlStateNormal];
    [loginbutton addTarget:self action:@selector(logIn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginbutton];
    
    
    //定义一个按钮和点击执行的方法，用按钮覆盖整个视图
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 30, 100, 100)];
    button.backgroundColor=[UIColor clearColor];
    //按钮加在定义的视图上
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:button];
    //定义的试图加载整个视图上
    [self.view addSubview:self.headView];
    
    //视图加载的同时加载图片
    [self loadImage];
    //加载信息
    self.phone.text=self.givenUser.phone;
    self.address.text=self.givenUser.address;
    self.email.text=self.givenUser.email;
}

//加载图片，先从沙盒加载，再从数据库加载图片
-(void)loadImage{
    
    NSMutableString *saveName=[NSMutableString stringWithString:@"head.png"];
//    [saveName deleteCharactersInRange:NSMakeRange(0, 5)];
    NSArray *segments=[NSArray arrayWithObjects:NSHomeDirectory(),@"Documents",saveName,nil];
    NSString *fullPath =[NSString pathWithComponents:segments];
    NSFileManager *file=[NSFileManager defaultManager];
    if([file fileExistsAtPath:fullPath isDirectory:NO])
    {
        NSData *sandData=[NSData dataWithContentsOfFile:fullPath];
        self.headImage=[UIImage imageWithData:sandData];
        
        NSData *myImage=UIImagePNGRepresentation(self.headImage);
        self.headImage=[UIImage imageWithData:myImage];
    }
    else
    {
        NSString *strurl = [NSString stringWithFormat:@"%@/%@",HOST_PORTRAIT,self.givenUser.portrait];
        strurl=[strurl stringByRemovingPercentEncoding];
        NSURL *url=[NSURL URLWithString:strurl];
        NSData *data=[NSData dataWithContentsOfURL:url];
        if (data != nil) {
            self.headImage=[UIImage imageWithData:data];
            NSData *myImage=UIImagePNGRepresentation(self.headImage);
            self.headImage=[UIImage imageWithData:myImage];
        }
        else{
            self.headImage = [UIImage imageNamed:@"u=1143936939,1211141726&fm=21&gp=0.jpg"];
        }
        
    }
    
    if (self.headImage != nil) {
        CGSize imagesize =self.headImage.size;
        imagesize.height= 100;
        imagesize.width =100;
        //对图片大小进行压缩
        self.chooseImage =[self imageWithImage:self.headImage scaledToSize:imagesize];
        
//        [self saveImage:self.headImage];
        self.headView.layer.contents=(id)[self.headImage CGImage];
    }
    else{
        
    }
}

//保存图片（本地保存）
- (void) saveImage:(UIImage *)currentImage
{
    if (currentImage == nil) {
        return;
    }
    NSString *saveName=@"head.png";
//    NSMutableString *saveName=[NSMutableString stringWithString:@"head.png"];
//    [saveName deleteCharactersInRange:NSMakeRange(0, 5)];
    NSArray *segments=[NSArray arrayWithObjects:NSHomeDirectory(),@"Documents",saveName,nil];
    NSString *fullPath =[NSString pathWithComponents:segments];
    NSData *imageData = UIImagePNGRepresentation(currentImage);
    NSFileManager *file=[NSFileManager defaultManager];
    if(![file fileExistsAtPath:fullPath isDirectory:NO])
    {
        if([file createFileAtPath:fullPath contents:imageData attributes:nil])
            NSLog(@"yes");
        else
            NSLog(@"no");
    }
}

//删除图片（本地删除）
- (void)deleteImage
{
    NSMutableString *saveName=[NSMutableString stringWithString:@"head.png"];
//    [saveName deleteCharactersInRange:NSMakeRange(0, 5)];
    NSArray *segments=[NSArray arrayWithObjects:NSHomeDirectory(),@"Documents",saveName,nil];
    NSString *fullPath =[NSString pathWithComponents:segments];
    NSFileManager *file=[NSFileManager defaultManager];
    if([file fileExistsAtPath:fullPath isDirectory:NO])
    {
        if([file removeItemAtPath:fullPath error:Nil])
            NSLog(@"yes");
        else
            NSLog(@"no");
    }
}


//以下3个方法实现图片缩小再上传
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:^{}];
    self.chooseImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGSize imagesize =self.chooseImage.size;
    imagesize.height= 100;
    imagesize.width =100;
    self.chooseImage=[self imageWithImage:self.chooseImage scaledToSize:imagesize];
    self.headView.layer.contents=(id)[self.chooseImage CGImage];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newSize);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return newImage;
}


//返回按钮执行的操作
- (void)backToPersentCenter{
    [self.navigationController popViewControllerAnimated:YES];
}

//定义按钮执行的操作，有相机可以拍照
-(void)click
{
    UIActionSheet *sheet;
    sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"从相册选择" destructiveButtonTitle:nil otherButtonTitles:@"取消",@"拍照", nil];
    sheet.tag = 255;
    [sheet showInView:self.view];
}

//点击UIActionSheet执行的操作
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255)
    {
        NSUInteger sourceType = 0;
        switch (buttonIndex)
        {
            case 0:
                return;
            case 1:
            {
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                sourceType = UIImagePickerControllerSourceTypeCamera;}
                else{
                NSLog(@"模拟器不支持拍照");
                }
               
            }
            break;
            case 2:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
        }
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate =self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}


//判断email格式
-(BOOL)validateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//判断手机格式是否正确
- (BOOL)checkTel:(NSString *)str{
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    if ([str length] != 0) {
        
        if (!isMatch) {
        
            return NO;
        }
     
   }
   return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requestFinished:(ASIHTTPRequest *)request{
        if(request.tag==3){
            [self deleteImage];
//            NSString* imageurl=[request responseString];
            NSString* httpimage=[NSString stringWithFormat:@"user_portrait/%@.png",self.givenUser.userid];
//            httpimage=[httpimage stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            self.givenUser.phone=self.phone.text;
            self.givenUser.email=self.email.text;
            self.givenUser.address=self.address.text;
            self.givenUser.portrait=httpimage;
//            [self saveImage:self.chooseImage];
            messageApp.loginuser=self.givenUser;
            [NSKeyedArchiver archiveRootObject:messageApp.loginuser toFile:[self dataFilePath]];
            NSString *strURL=[NSString stringWithFormat:@"%@user/update",HOST];
            NSURL *url=[NSURL URLWithString:strURL];
            ASIFormDataRequest *formRequest=[[ASIFormDataRequest alloc]initWithURL:url];
            [formRequest setPostValue:self.givenUser.userid forKey:@"userid"];
            [formRequest setPostValue:self.phone.text forKey:@"phone"];
            [formRequest setPostValue:self.email.text forKey:@"email"];
            [formRequest setPostValue:self.givenUser.portrait forKey:@"portrait"];
            [formRequest setPostValue:self.address.text forKey:@"address"];
            [formRequest setRequestMethod:@"POST"];
            [formRequest startSynchronous];
            [self deleteImage];
            [self saveImage:self.chooseImage];
            
            personCenter1ViewController *View1 = [[personCenter1ViewController alloc]initWithNibName:@"personCenter1ViewController" bundle:Nil];
            [self.navigationController pushViewController:View1 animated:YES];
            //            NSLog(@"yes");
            UIAlertView *elert1=[[UIAlertView alloc]initWithTitle:@"提示" message:@"修改成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [elert1 show];

        }
}

-(NSString *)dataFilePath{
        NSArray *segments=[NSArray arrayWithObjects:NSHomeDirectory(),@"Documents",@"login.plist",nil];
        return [NSString pathWithComponents:segments];
}


//以下方法用来去键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)TextField_DidEndOnExit:(id)sender {
    [sender resignFirstResponder];
}

- (void)logIn{
    //手机格式正不正确
    if (![self checkTel:self.phone.text]||![self validateEmail:self.email.text]) {
        UIAlertView *elert1=[[UIAlertView alloc]initWithTitle:@"提示" message:@"邮箱和手机输入错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [elert1 show];
    }
    else{
        
        if ([self.chooseImage isEqual:self.headImage]){
            self.givenUser.phone=self.phone.text;
            self.givenUser.email=self.email.text;
            self.givenUser.address=self.address.text;
            
            messageApp.loginuser=self.givenUser;
            NSDictionary *dic=[NSDictionary
                               dictionaryWithObjectsAndKeys:messageApp.loginuser.phone,@"phone",messageApp.loginuser.email,@"email",messageApp.loginuser.address,@"address",nil];
            [NSKeyedArchiver archiveRootObject:dic toFile:[self dataFilePath]];
            NSString *strURL=[NSString stringWithFormat:@"%@user/update",HOST];
            NSURL *url=[NSURL URLWithString:strURL];
            ASIFormDataRequest *formRequest=[[ASIFormDataRequest alloc]initWithURL:url];
            [formRequest setPostValue:self.givenUser.userid forKey:@"userid"];
            [formRequest setPostValue:self.phone.text forKey:@"phone"];
            [formRequest setPostValue:self.email.text forKey:@"email"];
            [formRequest setPostValue:self.givenUser.portrait forKey:@"portrait"];
            [formRequest setPostValue:self.address.text forKey:@"address"];
            [formRequest setRequestMethod:@"POST"];
            [formRequest startSynchronous];
//            if([[formRequest responseString]isEqualToString:@"success"])
//                NSLog(@"succeed");
//            else if([[formRequest responseString]isEqualToString:@"failed"])
//                NSLog(@"failed");
        }
        
        NSData *imageData=[[NSData alloc]init];
        NSString *saveimage=[NSString stringWithFormat:@"%@saveImage.php",HOST_PORTRAIT];
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:saveimage]];
        
        request.tag=3;
        
        [request addRequestHeader:@"Content-Type" value:@"binary/octet-stream"];
        if (UIImagePNGRepresentation(self.chooseImage))
        {
            //返回为png图像。
            imageData = UIImagePNGRepresentation(self.chooseImage);
            
        }
        else
        {
            //返回为JPEG图像。
            imageData = UIImageJPEGRepresentation(self.chooseImage, 1.0);
            NSLog(@"no");
        }
        NSMutableData *data=[NSMutableData dataWithData:imageData];
        [request setDelegate:self];
        //            [request setPostValue:self.givenUser.userid forKey:@"userid"];
        
        [request setRequestMethod:@"POST"];
        [request addData:data withFileName:[NSString stringWithFormat:@"%@.png",self.givenUser.userid] andContentType:@"image/png" forKey:@"file"];
        //            [request setPostBody:data];
        [request startAsynchronous];
        if (request.error!=nil) {
                    }
        else{
            
        }
        }
    
}

-(void)requestFailed:(ASIHTTPRequest *)request{
    UIAlertView *elert1=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络环境差" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [elert1 show];

}

//自适应键盘高度
-(void)textViewDidBeginEditing:(UITextView *)textView{
    CGRect frame = textView.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0-38);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger number = [textView.text length];
    if (number > 50) {
        textView.text = [textView.text substringToIndex:30];
        number = 50;
    }
}
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0-38);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}


//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}
//4个textfield允许输入长度只能为18
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *textString = textField.text ;
    NSUInteger length = [textString length]+1;
    BOOL bChange =YES;
    if (length >= 18)
        bChange = NO;
    if (range.length == 1) {
        bChange = YES;
    }
    return bChange;
}

@end
