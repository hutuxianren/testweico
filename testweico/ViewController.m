
//  ViewController.m
//  testweico
//
//  Created by luluteam on 15/9/14.
//  Copyright (c) 2015年 luluteam. All rights reserved.
//

#import "ViewController.h"
//#import "WeiboSDK.h"
#import "Global.h"
#import "AppDelegate.h"
#import "WeiboModel.h"
#import "UserModel.h"
#import "WeiboCell.h"
#import "WeiboView.h"
#import "myWeiboCell.h"
#import "UIUtils.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *weiboTable;
@property(nonatomic,strong)NSMutableArray *data;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    _recordRequest=0;
    // Do any additional setup after loading the view, typically from a nib.
    [self setupRefresh];//下拉刷新
    [self setupDownRefresh];//上拉刷新
}
/**
* 集成下拉刷新
*/
-(void)setupRefresh
{
    //1.添加刷新控件
    UIRefreshControl *control=[[UIRefreshControl alloc]init];
    [control addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    [self.weiboTable addSubview:control];
    
    //2.马上进入刷新状态，并不会触发UIControlEventValueChanged事件
    [control beginRefreshing];
    
    // 3.加载数据
    [self refreshStateChange:control];
}
/**
 *  UIRefreshControl进入刷新状态：加载最新的数据
 */

-(void)refreshStateChange:(UIRefreshControl *)control
{
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if(self.topWeiboId.length==0)
    {
        NSLog(@"微博为空");
        [WBHttpRequest requestWithAccessToken:token url:@"https://api.weibo.com/2/statuses/friends_timeline.json" httpMethod:@"GET" params:nil delegate:self withTag:nil];
        [control endRefreshing];
        return;
    }
    NSMutableDictionary *param=[NSMutableDictionary dictionaryWithObject:self.topWeiboId forKey:@"since_id"];
    [WBHttpRequest requestWithAccessToken:token url:@"https://api.weibo.com/2/statuses/friends_timeline.json" httpMethod:@"GET" params:param delegate:self withTag:nil];
    _recordRequest=1;//1表示下拉取数据
    [control endRefreshing];
}



-(void)setupDownRefresh
{
    _weiboTable.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        // 结束刷新
        [self loadMoreData];
        [_weiboTable.footer endRefreshing];
        
    }];
}
//加载更多数据
-(void)loadMoreData
{
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if(self.lastWeiboId.length==0)
    {
        NSLog(@"微博为空");
        //[WBHttpRequest requestWithAccessToken:token url:@"https://api.weibo.com/2/statuses/friends_timeline.json" httpMethod:@"GET" params:nil delegate:self withTag:nil];
        return;
    }
    NSMutableDictionary *param=[NSMutableDictionary dictionaryWithObject:self.lastWeiboId forKey:@"max_id"];
    [WBHttpRequest requestWithAccessToken:token url:@"https://api.weibo.com/2/statuses/friends_timeline.json" httpMethod:@"GET" params:param delegate:self withTag:nil];
    _recordRequest=2;//2表示加载更多数据
}

//登录微博
- (IBAction)btnSummit:(id)sender {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
    
}
/**
* 请求微博数据
 */
- (IBAction)qingqiu:(id)sender {
    //AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    //NSMutableDictionary *param=[NSMutableDictionary dictionary];
    //[param setObject:@"5" forKey:@"count"];
    //NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    //NSDictionary *dic=[defaults objectForKey:@"SinaWeiboAuthData"];
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    [WBHttpRequest requestWithAccessToken:token url:@"https://api.weibo.com/2/statuses/friends_timeline.json" httpMethod:@"GET" params:nil delegate:self withTag:nil];
    
}
//网络加载失败
-(void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    title = NSLocalizedString(@"请求异常", nil);
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil];
        [alert show];
}
//网络加载完成
-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString*)result
{
    //取出完整的微博数据
    if(_recordRequest==0)
    {
        NSData *data=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        //NSArray *pics=[dic objectForKey:@"pic_ids"];
        //NSLog(@"json数据------->%@",dic);
        NSArray * statuses=[dic objectForKey:@"statuses"];
        NSMutableArray *weibos=[NSMutableArray arrayWithCapacity:1000];
        for(NSDictionary *dic in statuses)
        {
            WeiboModel *weibo=[[WeiboModel alloc]initWithDataDic:dic];
            //NSLog(@"-------%@",weibo);
            //NSLog(@"----%@pics----%@",weibo.user.screen_name,weibo.pic_urls);
            [weibos addObject:weibo];
        }
        if (weibos.count>0) {
            WeiboModel *lastWeibo=[weibos lastObject];
            self.lastWeiboId=[lastWeibo.id stringValue];
            WeiboModel *topWeibo=[weibos objectAtIndex:0];
            self.topWeiboId=[topWeibo.id stringValue];
        }
        self.data=weibos;
        self.fullWeibos=weibos;
        [self.weiboTable reloadData];
    }
    //取出下拉刷新后的数据
    if(_recordRequest==1)
    {
        NSData *data=[result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray * statuses=[dic objectForKey:@"statuses"];
        NSMutableArray *array=[NSMutableArray arrayWithCapacity:1000];
        for(NSDictionary *dic in statuses)
        {
            WeiboModel *weibo=[[WeiboModel alloc]initWithDataDic:dic];
            NSLog(@"-------%@",weibo);
            [array addObject:weibo];
        }
        //更新topid
        if(array.count>0)
        {
            WeiboModel *topWeibo=[array objectAtIndex:0];
            self.topWeiboId=[topWeibo.id stringValue];
        }
        [array addObjectsFromArray:self.fullWeibos];
        self.fullWeibos=array;
        self.data=array;
        [_weiboTable reloadData];
        _recordRequest=0;
        return;
    }
    //取出上拉加载后的数据
    if(_recordRequest==2)
    {
        NSData *data=[result dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray * statuses=[dic objectForKey:@"statuses"];
        NSMutableArray *array=[NSMutableArray arrayWithCapacity:1000];
        for(NSDictionary *dic in statuses)
        {
            WeiboModel *weibo=[[WeiboModel alloc]initWithDataDic:dic];
            if(![[weibo.id stringValue] isEqualToString:self.lastWeiboId]) {
                            [array addObject:weibo];
                            NSLog(@"-------%@",weibo);
            }


        }
        //更新topid
        if(array.count>0)
        {
            WeiboModel *lastWeibo=[array lastObject];
            self.lastWeiboId=[lastWeibo.id stringValue];
        }
        [self.fullWeibos addObjectsFromArray:array];
        self.data=self.fullWeibos;
        [_weiboTable reloadData];
        _recordRequest=0;
        return;
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"WeiboCell";
    WeiboCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell=[[WeiboCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];

    }
    WeiboModel *weibo=self.data[indexPath.row];
    cell.weiboModel=weibo;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        WeiboModel *weibo = [self.data objectAtIndex:indexPath.row];
        CGFloat height = [WeiboView getWeiboViewHeight:weibo isRepost:NO isDetail:NO];
    
        height += 70;
    
        return height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
