//
//  ViewController.m
//  InterrutibleTapGestureDemo
//
//  Created by HeYilei on 3/12/2015.
//  Copyright © 2015 lionhylra. All rights reserved.
//

#import "ViewController.h"
#import "InterruptibleTapGestureDemo-swift.h"

@interface ViewController ()
@property(nonatomic, weak) IBOutlet UILabel *label;
@end

@interface ViewController(InterruptibleTap)<InterruptibleTapDelegate>

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.label addInterruptibleTapGestureRecognizerWithDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation ViewController(InterruptibleTap)
-(void)viewNotPressed:(UIView *)view{
    view.backgroundColor = [UIColor clearColor];
}
-(void)viewPressed:(UIView *)view{
    view.backgroundColor = [UIColor lightGrayColor];
}
-(void)action:(UIView *)view{
    NSLog(@"Button Tapped!!!");
}

@end