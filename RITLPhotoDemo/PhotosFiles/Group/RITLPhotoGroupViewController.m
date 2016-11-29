//
//  YPPhotoGroupController.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLPhotoGroupViewController.h"
#import "RITLPhotoGroupViewModel.h"
#import "RITLPhotoGroupCell.h"
#import "YPPhotosController.h"

#import "RITLPhotosViewController.h"


static NSString * cellIdentifier = @"RITLPhotoGroupCell";

@interface RITLPhotoGroupViewController ()<YPPhotosControllerDelegate>

@end

@implementation RITLPhotoGroupViewController

-(instancetype)initWithViewModel:(RITLPhotoGroupViewModel *)viewModel
{
    if (self = [super init])
    {
        _viewModel = viewModel;
    }
    
    return self;
}

+(instancetype)controllerWithViewModel:(RITLPhotoGroupViewModel *)viewModel
{
    return [[self alloc]initWithViewModel:viewModel];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self extensionTableView];
    [self extensionNavigation];
    [self bindViewModel];
    
    //开始获取相片
    [_viewModel fetchDefaultGroups];
}


/// 设置tableView的拓展属性
- (void)extensionTableView
{
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerClass:[RITLPhotoGroupCell class] forCellReuseIdentifier:cellIdentifier];
}


/// 设置导航栏属性
- (void)extensionNavigation
{
    self.navigationItem.title = @"相册";
    
    // 回归到viewModel
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancle" style:UIBarButtonItemStylePlain target:self.viewModel action:@selector(dismissGroupController)];
}


/// 绑定viewModel
- (void)bindViewModel
{
    __weak typeof(self) weakSelf = self;
    
    _viewModel.dismissGroupBlock = ^(){
      
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf dismissViewControllerAnimated:true completion:^{}];
        
    };
    
    
    _viewModel.fetchGroupsBlock = ^(NSArray * groups){
      
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.tableView reloadData];
    };
    
    
    _viewModel.selectedBlock = ^(PHAssetCollection * colletion,NSIndexPath * indexPath){
      
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        
#warning 待重写!
        
        YPPhotosController * collectionViewController = [[YPPhotosController alloc]init];
        
        //传递组对象
        [collectionViewController setValue:[strongSelf.viewModel fetchPhotos:indexPath] forKey:@"assets"];
        [collectionViewController setValue:NSLocalizedString(colletion.localizedTitle, @"") forKey:@"itemTitle"];
        [collectionViewController setValue:@(8) forKey:@"maxNumberOfSelectImages"];
        
        [strongSelf.navigationController pushViewController:[RITLPhotosViewController new] animated:true];
        
    };
    
#warning 待重写!
}




- (IBAction)cancleItemButtonDidTap:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc
{
//    self.groups = nil;
#ifdef YDEBUG
    NSLog(@"RITLPhotoGroupViewController Dealloc");
#endif
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.numberOfGroup;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel numberOfRowInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RITLPhotoGroupCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RITLPhotoGroupCell class]) forIndexPath:indexPath];
    
    //设置
    [self.viewModel loadGroupTitleImage:indexPath complete:^(id _Nonnull title, id _Nonnull image, id _Nonnull appendTitle, NSUInteger count) {
       
        cell.titleLabel.text = appendTitle;
        cell.imageView.image = image;
        
    }];
    
    return cell;
}



#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //消除选择痕迹
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    [self.viewModel didSelectRowAtIndexPath:indexPath];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return [self.viewModel heightForRowAtIndexPath:indexPath];
}



#pragma mark - 

-(RITLPhotoGroupViewModel *)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [RITLPhotoGroupViewModel new];
    }
    
    return _viewModel;
}


@end
