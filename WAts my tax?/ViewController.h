//
//  ViewController.h
//  WAts my tax?
//
//  Created by Travis spangle on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFPickerView.h"
#import "InfoPageViewController.h"

@interface ViewController : UIViewController<UITextFieldDelegate, AFPickerViewDataSource, AFPickerViewDelegate> {
    NSArray *possibleBottleSizes;
    AFPickerView *dollarPickerView;
    AFPickerView *changePickerView;
    NSMutableArray *dollarData;  
    NSMutableArray *changeData;
    
    __strong IBOutlet UITextField *salesPriceForLiquor;
    __strong IBOutlet UILabel *finalPriceOfLiquor;
    __strong IBOutlet UISlider *bottleSize;
    __strong IBOutlet UILabel *shownBottleSize;
    __strong IBOutlet UILabel *changeDecimal;
}
@property (nonatomic, retain) UISlider * bottleSize;
@property (nonatomic, retain) UITextField *salesPriceForLiquor;
@property (nonatomic, retain) UILabel *finalPriceOfLiquor;
@property (nonatomic, retain) UILabel *shownBottleSize;
@property (nonatomic, retain) UILabel *changeDecimal;
@property (nonatomic, retain) NSMutableArray *dollarData;
@property (nonatomic, retain) NSMutableArray *changeData;

- (IBAction)changeBottleSize:(UISlider *)sender;
- (IBAction)sliderIsMoving:(id)sender;
- (IBAction)showInfo:(id)sender;
- (void)moveSlider:(int)index;
- (void)calculatePrice;

@end
