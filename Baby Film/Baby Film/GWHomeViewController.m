//
//  GWHomeViewController.m
//  Baby Film
//
//  Created by Will Ge on 8/14/15.
//  Copyright (c) 2015 gewill.org. All rights reserved.
//

#import "GWHomeViewController.h"
#import "SZCalendarPicker.h"
#import <MediaPlayer/MediaPlayer.h>
#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayerDefines.h>
#import <UIKit/UIViewController.h>


@interface GWHomeViewController ()

@end

@implementation GWHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//MARK: - show calendar
- (IBAction)showCalendar:(id)sender {
    
    SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(0, 100, self.view.frame.size.width, 352);
    calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        
        NSLog(@"%li-%li-%li", (long)year,(long)month,(long)day);
    };
    
}




@end
