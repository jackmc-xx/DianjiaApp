//
//  ScanVC.m
//  YHB_Prj
//
//  Created by Johnny's on 15/9/9.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "ScanVC.h"
#import "DJScanViewController.h"
#import "LoginMode.h"
#import "SPGLSearchVC.h"
#import "SPGLManager.h"

@interface ScanVC ()<DJScanDelegate>
@property(nonatomic,strong) StoreMode *mode;
@property(nonatomic,strong) UIButton *scanBtn;
@property (strong, nonatomic) SPGLManager *manager;
@end

@implementation ScanVC

- (instancetype)initWithMode:(StoreMode *)aMode
{
    if (self = [super init])
    {
        _mode = aMode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _mode.strStoreName;
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat btnWidth = 250;
    _scanBtn = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth/2.0-btnWidth/2.0, 30, btnWidth, 30)];
    _scanBtn.backgroundColor = KColor;
    _scanBtn.titleLabel.font = kFont12;
    [_scanBtn setTitle:@"快速扫描" forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(touchScan) forControlEvents:UIControlEventTouchUpInside];
    _scanBtn.layer.cornerRadius = 3;
    [self.view addSubview:_scanBtn];
    
    self.manager = [[SPGLManager alloc] init];
}

- (void)touchScan
{
    DJScanViewController *vc=  [[DJScanViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scanController:(UIViewController *)vc didScanedAndTransToMessage:(NSString *)message
{
    MLOG(@"%@",message);
    SPGLSearchVC *ssvc = [[SPGLSearchVC alloc] initWithNibName:@"SPGLSearchVC" bundle:nil];
    [ssvc setMnagerAndCode:self.manager procode:message];
    NSMutableArray * viewControllers = [self.navigationController.viewControllers mutableCopy];
    if (viewControllers.count > 1) {
        [viewControllers removeLastObject];
    }
    [viewControllers addObject:ssvc];
    [self.navigationController setViewControllers:viewControllers animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
