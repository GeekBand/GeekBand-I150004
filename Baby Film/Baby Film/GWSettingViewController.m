//
//  GWSettingViewController.m
//  Baby Film
//
//  Created by Will Ge on 8/15/15.
//  Copyright (c) 2015 gewill.org. All rights reserved.
//

#import "GWSettingViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface GWSettingViewController ()

@end

@implementation GWSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.fd_prefersNavigationBarHidden = YES;
//    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
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
