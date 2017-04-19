//
//  ViewController.m
//  MyAnimation
//
//  Created by Clarision Tech on 4/17/17.
//  Copyright © 2017 Clarision Tech. All rights reserved.
//

#import "ViewController.h"

#define EXPAND_HEIGHT   150
#define NO_OF_BUTTONS   3
#define BUTTON_Y_ORIGIN   12

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIView *expandView;
@property (strong, nonatomic) IBOutlet UIView *horizontalView;
@property (strong, nonatomic) IBOutlet UIView *verticalView;
@property (strong, nonatomic) IBOutlet UIView *upperView;

@end

@implementation ViewController
{
    BOOL isExpanded;
    BOOL isAnimating;
    CGFloat heightHrizontal;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Common Init

-(void)commonInit{
    heightHrizontal=self.horizontalView.frame.size.height;
    isAnimating=NO;
    
    UITapGestureRecognizer *recognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnStartAnimation:)];
    [self.upperView addGestureRecognizer:recognizer];
}

#pragma mark - Expand/Hide View

- (IBAction)btnStartAnimation:(id)sender {
    if (!isAnimating) {
        if (!isExpanded) {
            [UIView animateWithDuration:0.4 animations:^{
                self.expandView.frame=CGRectMake(0, self.view.frame.size.height-EXPAND_HEIGHT, self.expandView.frame.size.width, EXPAND_HEIGHT);
                _upperView.frame=CGRectMake(0, self.horizontalView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-self.expandView.frame.size.height);
                _horizontalView.frame=CGRectMake(self.horizontalView.frame.origin.x, self.horizontalView.frame.origin.y, 2, 80);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.4 animations:^{
                    self.horizontalView.frame=CGRectMake(10, self.horizontalView.frame.origin.y, self.expandView.frame.size.width-20, self.horizontalView.frame.size.height);
                    [self hideButtons:self.expandView];
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.3 animations:^{
                        [self addSubviewsToExpandedView];
                    }];
                }];
            }];
            isExpanded=YES;
        }else{
            [UIView animateWithDuration:0.4 animations:^{
                [self hideButtons:self.expandView];
                [self hideSubviewsButton];
                self.horizontalView.frame=CGRectMake(self.expandView.frame.size.width/2, _horizontalView.frame.origin.y, 2, _horizontalView.frame.size.height);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.expandView.frame=CGRectMake(self.expandView.frame.origin.x, self.view.frame.size.height-60, self.expandView.frame.size.width, 60);
                    self.horizontalView.frame=CGRectMake(self.horizontalView.frame.origin.x, self.horizontalView.frame.origin.y, 2, heightHrizontal);
                    self.upperView.frame=CGRectMake(0, self.upperView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-self.expandView.frame.size.height);
                }];
            }];
            isExpanded=NO;
        }
    }
}

#pragma mark - ADD UIButtons to Expanded UIView

-(void)addSubviewsToExpandedView{
    CGFloat btnHeight=self.horizontalView.frame.size.width/NO_OF_BUTTONS;
    if (btnHeight >self.horizontalView.frame.size.height-BUTTON_Y_ORIGIN*2) {
        btnHeight=self.horizontalView.frame.size.height-BUTTON_Y_ORIGIN*2;
    }
    CGFloat btnYOrigin=(self.horizontalView.frame.size.width-btnHeight*NO_OF_BUTTONS)/(NO_OF_BUTTONS+1);
    UIButton *prevBtn;
    for (int i=0; i<NO_OF_BUTTONS; i++) {
        UIButton *btn;
        if (prevBtn) {
            btn=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(prevBtn.frame)+btnYOrigin, BUTTON_Y_ORIGIN  , btnHeight, btnHeight)];
        }else{
            btn=[[UIButton alloc]initWithFrame:CGRectMake(btnYOrigin, BUTTON_Y_ORIGIN  , btnHeight, btnHeight)];
        }
        prevBtn=btn;
        prevBtn.backgroundColor=[UIColor whiteColor];
        [self.horizontalView addSubview:prevBtn];
    }
}

#pragma mark - Hide Bottom View UIButtons

-(void)hideButtons:(UIView *)view{
    [view.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if ([btn isHidden]) {
                btn.hidden=NO;
            }else{
                btn.hidden=YES;
            }
        }
    }];
}

#pragma mark - Remove Expanded View Buttons

-(void)hideSubviewsButton{
    [self.horizontalView.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn removeFromSuperview];
        }
    }];
}
@end
