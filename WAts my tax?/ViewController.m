//
//  ViewController.m
//  WAts my tax?
//
//  Created by Travis spangle on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
// 
/* Taxes are taken from http://liq.wa.gov/stores/liquor-pricing */
/* 
    possible sizes
    50, 200, 375, 750, 1000, 1750
*/

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize bottleSize, salesPriceForLiquor, finalPriceOfLiquor, shownBottleSize, dollarData, changeData, changeDecimal;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[bottleSize setEnabled:NO];
    possibleBottleSizes = [NSArray arrayWithObjects:[NSNumber numberWithInt:50],
                       [NSNumber numberWithInt:200],
                       [NSNumber numberWithInt:375],
                       [NSNumber numberWithInt:750],
                       [NSNumber numberWithInt:1000],
                       [NSNumber numberWithInt:1750],nil];
    

    [bottleSize setValue:3 animated:NO];
    [bottleSize setThumbImage:[UIImage imageNamed:@"thumb.png"] forState:UIControlStateNormal];
    [bottleSize setThumbImage:[UIImage imageNamed:@"thumb.png"] forState:UIControlStateHighlighted];    
    [finalPriceOfLiquor setText:@"Enter Sales Price"];
    
    dollarData = [NSMutableArray array];
    changeData = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 199; i++)
        [dollarData addObject:[NSString stringWithFormat:@"%d", i+1]];
    
    for (NSInteger i = 0; i < 99; i++)
        [changeData addObject:[NSString stringWithFormat:@"%d", i+1]];        
    
    [changeData addObject:@"00"];    
    
    
    dollarPickerView = [[AFPickerView alloc] initWithFrame:CGRectMake(89.0, 130.0,76.0, 197.0)];
    [dollarPickerView setRowIndent:21.0];
    [dollarPickerView setRowFont:[UIFont fontWithName:@"Copperplate" size:28.0]];
    dollarPickerView.dataSource = self;
    dollarPickerView.delegate = self;
    [dollarPickerView reloadData];
    [self.view addSubview:dollarPickerView];
    
    [dollarPickerView setSelectedRow:21];
    
    changePickerView = [[AFPickerView alloc] initWithFrame:CGRectMake(170.0, 130.0,66.0, 197.0)];
    [changePickerView setRowIndent:20.0];
    [changePickerView setRowFont:[UIFont fontWithName:@"Copperplate" size:24.0]];    
    changePickerView.dataSource = self;
    changePickerView.delegate = self;
    [changePickerView reloadData];
    [self.view addSubview:changePickerView]; 
    
    [changePickerView setSelectedRow:([changeData count]-1)];
    
    [self.view bringSubviewToFront:changeDecimal];
}

- (void)viewDidUnload
{
    salesPriceForLiquor = nil;
    finalPriceOfLiquor = nil;
    bottleSize = nil;
    shownBottleSize = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    float salesPrice = [[textField text] floatValue];
    
    float selectedSize = [[possibleBottleSizes objectAtIndex:[bottleSize value]] floatValue];
    selectedSize = selectedSize / 1000;
    
    float finalPrice = salesPrice+(salesPrice*.205)+(3.7708*selectedSize);
    
    [finalPriceOfLiquor setText:[NSString stringWithFormat:@"%f", finalPrice ]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {

	if (theTextField == salesPriceForLiquor) {
		[salesPriceForLiquor resignFirstResponder];
        [self calculatePrice];
	}
	return YES;
}

- (IBAction)changeBottleSize:(UISlider *)sender;
{
    int roundedUp = (int) ([sender value]+0.5f);
    [sender setValue:roundedUp animated:YES];
 
    [shownBottleSize setText:
        [NSString stringWithFormat:@"%@ ml", [possibleBottleSizes objectAtIndex:roundedUp]]];
    
    [self calculatePrice];
}

- (void)moveSlider:(int)index;
{
    [bottleSize setValue:index animated:YES];
    
    [shownBottleSize setText:
     [NSString stringWithFormat:@"%@ ml", [possibleBottleSizes objectAtIndex:index]]];    
}


- (IBAction)sliderIsMoving:(id)sender;
{
    int roundedUp = (int) ([(UISlider*)sender value]+0.5f);
    [shownBottleSize setText:
     [NSString stringWithFormat:@"%@ ml", [possibleBottleSizes objectAtIndex:roundedUp]]];        
}

- (void)calculatePrice;
{
    //float salesPrice = [[salesPriceForLiquor text] floatValue];
    float salesPrice = [[NSString stringWithFormat:@"%@.%@", 
                         [dollarData objectAtIndex:[dollarPickerView selectedRow]],
                         [changeData objectAtIndex:[changePickerView selectedRow]]]
                        floatValue];
    
    if( salesPrice <= 0){ return; }
    
    float selectedSize = [[possibleBottleSizes objectAtIndex:[bottleSize value]] floatValue];
    selectedSize = selectedSize / 1000;
    
    
    double finalPrice = (double) salesPrice+(salesPrice*.205)+(3.7708*selectedSize);
    
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberAsString = [currencyFormatter stringFromNumber:[NSNumber numberWithDouble:finalPrice]];
    
    [finalPriceOfLiquor setText:numberAsString];
}

#pragma mark - AFPickerViewDataSource

- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView
{
    if (pickerView == dollarPickerView)
        return [dollarData count];
    

    if (pickerView == changePickerView)
        return [changeData count];
    
    return 0;
}




- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row
{
    if (pickerView == dollarPickerView)
        return [dollarData objectAtIndex:row];
    
    if (pickerView == changePickerView)
        return [changeData objectAtIndex:row];        
    
    return @"";

}

#pragma mark - AFPickerViewDelegate

- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row
{
    [self calculatePrice];
}

- (IBAction)showInfo:(id)sender;
{
    InfoPageViewController *infoPage = [[InfoPageViewController alloc] init];
    infoPage.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:infoPage animated:YES completion: nil];
}

@end
