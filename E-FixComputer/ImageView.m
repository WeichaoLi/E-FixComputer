//
//  ImageView.m
//  易修电脑
//
//  Created by administrator on 13-12-9.
//  Copyright (c) 2013年 administrator. All rights reserved.
//

#import "ImageView.h"

@implementation ImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//重写placeholderImage的Setter方法
-(void)setPlaceholderImage:(UIImage *)placeholderImage
{
    if(placeholderImage != _placeholderImage)
    {
        _placeholderImage = placeholderImage;
        self.image = _placeholderImage;    //指定默认图片
    }
}
//重写imageURL的Setter方法
-(void)setImageURL:(NSString *)imageURL
{
    if(imageURL != _imageURL)
    {
        self.image = _placeholderImage;    //指定默认图片
    }
    
    if(self.imageURL)
    {
        //确定图片的缓存地址
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
        NSString *docDir = [path objectAtIndex:0];
        NSString *tmpPath = [docDir stringByAppendingPathComponent:@"LocalImage"];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        if(![fm fileExistsAtPath:tmpPath])
        {
            [fm createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        //从图片URL中取出图片的名字并作为文件的路径名字
        NSArray *lineArray = [self.imageURL componentsSeparatedByString:@"/"];
        self.fileName = [NSString stringWithFormat:@"%@/%@", tmpPath, [lineArray objectAtIndex:[lineArray count] - 1]];
        
        //判断图片是否已经下载过，如果已经下载到本地缓存，则不用重新下载。如果没有，请求网络进行下载。
        if(![[NSFileManager defaultManager] fileExistsAtPath:_fileName])
        {
            //下载图片，保存到本地缓存中
            [self loadImage];
        }
        else
        {
            //本地缓存中已经存在，直接指定请求的网络图片
            self.image = [UIImage imageWithContentsOfFile:_fileName];
        }
    }
}

//网络请求图片，缓存到本地沙河中
-(void)loadImage
{
    //对路径进行编码
    @try {
        //请求图片的下载路径
        //定义一个缓存cache
        NSURLCache *urlCache = [NSURLCache sharedURLCache];
        /*设置缓存大小为1M*/
        [urlCache setMemoryCapacity:15*124*1024];
        
        //设子请求超时时间为30s
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.imageURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
        //        NSLog(@"%@",request);
        
        //从请求中获取缓存输出
        NSCachedURLResponse *response = [urlCache cachedResponseForRequest:request];
        NSLog(@"%@",response);
        if(response != nil)
        {
            NSLog(@"如果有缓存输出，从缓存中获取数据");
            [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
        }else{
            NSLog(@"失败");
        }
        
        /*创建NSURLConnection*/
        if(!connection)
            connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        //开启一个runloop，使它始终处于运行状态
        
        UIApplication *app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];        
    }
    @catch (NSException *exception) {
        //        NSLog(@"没有相关资源或者网络异常");
    }
    @finally {
        ;//.....
    }
}

#pragma mark - NSURLConnection Delegate Methods
//请求成功，且接收数据(每接收一次调用一次函数)
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(loadData==nil)
    {
        loadData=[[NSMutableData alloc]initWithCapacity:2048];
    }
    [loadData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return cachedResponse;
    //    NSLog(@"将缓存输出");
}

-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    //    NSLog(@"即将发送请求");
    return request;
}

//下载完成，将文件保存到沙河里面
-(void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    
    //图片已经成功下载到本地缓存，指定图片----已改当图片没有成功读取时，显示一张默认图片。
    //此方法可能存入无用文件，一次没读取不会2次读取，。需配合TABLEVIEW的CELL使用
    //    if([loadData writeToFile:_fileName atomically:YES])
    //    {
    ////        self.image = [UIImage imageWithContentsOfFile:_fileName];
    //        if ([UIImage imageWithContentsOfFile:_fileName] == nil) {
    //            self.image = [UIImage imageNamed:@"notFound.jpg"];
    //        }else{
    //            self.image = [UIImage imageWithContentsOfFile:_fileName];
    //        }
    //
    //    }
    //次方法不会存入无用文件，对tableView可2次读取，会重新载入该图片，运行时  若数据因某些原因回复正常，可读取成功。
    if ([UIImage imageWithData:loadData] != nil) {
        if ([loadData writeToFile:_fileName atomically:YES]) {
            self.image = [UIImage imageWithContentsOfFile:_fileName];
        }
    }else{
        self.image = [UIImage imageNamed:@"notFound.jpg"];
    }
    
    connection = nil;
    loadData = nil;
    
    
}

//网络连接错误或者请求成功但是加载数据异常
-(void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    
    //如果发生错误，则重新加载
    connection = nil;
    loadData = nil;
    [self loadImage];
}


@end
