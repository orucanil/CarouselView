//
//  ViewController.m
//  CarouselViewDemo
//
//  Created by Anil Oruc on 3/10/16.
//  Copyright © 2016 Anil Oruc. All rights reserved.
//

#import "ViewController.h"
#import "PLCarouselView.h"

@interface ViewController () <PLCarouselViewDataSource,PLCarouselViewDelegate>

@property (nonatomic,strong) NSArray *colors;

@property (nonatomic,strong) PLCarouselView *carousel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _colors = @[@[[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor]],@[[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor]],@[[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor]],@[[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor]],@[[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor],[self randomColor]]];
    
    _carousel = [PLCarouselView init];
    
    [_carousel setFrame:[UIScreen mainScreen].bounds];
    
    _carousel.delegate = self;
    
    _carousel.dataSource = self;
    
    [self.view addSubview:_carousel];
    
    [_carousel reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIColor*)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

#pragma mark - PLCarouselView delegates & datasources

-(UIView *)carouselView:(PLCarouselView *)carouselView viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if (carouselView == _carousel) {
        
        PLCarouselView *carouselCategory = (PLCarouselView*)view;
        
        if (!view) {
            carouselCategory = [PLCarouselView init];
            
            carouselCategory.delegate = self;
            
            carouselCategory.dataSource = self;
            
            [carouselCategory setFrame:[UIScreen mainScreen].bounds];
            
            carouselCategory.vertical = YES;
        }
        
        carouselCategory.tag = index;
        
        [carouselCategory reloadData];
        
        return carouselCategory;
    }
    else {
        
        UIView *viewTemp = view;
        if(!viewTemp)
        {
            viewTemp = [UIView new];
        }
        viewTemp.layer.masksToBounds = NO;
        viewTemp.layer.shadowColor = [[UIColor blackColor] CGColor];
        viewTemp.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
        viewTemp.layer.shadowRadius = 3.0f;
        viewTemp.layer.shadowOpacity = 1.0f;
        
        [viewTemp setFrame:[UIScreen mainScreen].bounds];
        
        viewTemp.backgroundColor = _colors[carouselView.tag][index];
        
        return viewTemp;
    }
}

-(NSUInteger)numberOfItemsInCarousel:(PLCarouselView *)carouselView
{
    if (carouselView == _carousel) {
        return _colors.count;
    }
    
    return [_colors[carouselView.tag] count];
}

-(void)carouselView:(PLCarouselView *)carouselView didMoveToView:(UIView *)view
{
    
}

-(void)carouselCurrentItemIndexDidChange:(PLCarouselView *)carouselView currentIndex:(NSUInteger)currentIndex previousIndex:(NSUInteger)previousIndex
{
    
}

-(void)carouselView:(PLCarouselView *)carouselView didSelectItemAtIndex:(NSUInteger)index
{
    
}

-(void)carouselView:(PLCarouselView *)carouselView changedScrollDirection:(PLCarouselViewDirection)direction
{
    switch (direction) {
        case PLCarouselViewDirectionDown:
        {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
            break;
        case PLCarouselViewDirectionUp:
        {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
            break;
        case PLCarouselViewDirectionLeft:
        {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
            break;
        case PLCarouselViewDirectionRight:
        {
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
            break;
        case PLCarouselViewDirectionStatic:
        {
            
        }
            break;
        default:
            break;
    }
}

-(void)carouselView:(PLCarouselView *)carouselView didScrollDiffrenceRate:(CGFloat)diffRate
{
    
}

@end
