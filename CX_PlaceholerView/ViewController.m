//
//  ViewController.m
//  CX_PlaceholerView
//
//  Created by Cyn X on 2018/6/8.
//  Copyright © 2018年 Cyn Van. All rights reserved.
//

#import "ViewController.h"

#import <ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import "UIView+PlaceholderView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(90, 90, 200, 30)];
    [self.view addSubview:button1];
    [button1 setTitle:@"无网络" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor redColor];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(90, 150, 200, 30)];
    [self.view addSubview:button2];
    [button2 setTitle:@"无商品" forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor redColor];
    
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake(90, 210, 200, 30)];
    [self.view addSubview:button3];
    [button3 setTitle:@"无评论" forState:UIControlStateNormal];
    button3.backgroundColor = [UIColor redColor];
    
    UIButton *button4 = [[UIButton alloc] initWithFrame:CGRectMake(90, 270, 200, 30)];
    [self.view addSubview:button4];
    [button4 setTitle:@"自定义" forState:UIControlStateNormal];
    button4.backgroundColor = [UIColor redColor];
    
    @weakify(self);
    [[button1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.view cx_showPlaceholderViewWithType:CQPlaceholderViewTypeNoNetwork reloadBlock:^{
            [self dismissView];
        }];
    }];
    
    [[button2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.view cx_showPlaceholderViewWithType:CQPlaceholderViewTypeNoGoods reloadBlock:^{
            [self dismissView];
        }];
    }];
    
    [[button3 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.view cx_showPlaceholderViewWithType:CQPlaceholderViewTypeNoComment reloadBlock:^{
            [self dismissView];
        }];
    }];
    
    [[button4 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.view cx_showPlaceholderViewWithType:CQPlaceholderViewTypeCustom customImg:[UIImage imageNamed:@"111.png"] showTitle:@"加载成功" buttonTitle:@"加载-加载" reloadBlock:^{
            [self dismissView];
        }];
    }];
    
    
}

- (void)dismissView {
    
    [self.view cx_removePlaceholderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
