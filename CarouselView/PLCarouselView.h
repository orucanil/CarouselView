//
//  PLCarouselView.h
//  OmsaTech
//
//  Created by Anil Oruc on 5/4/15.
//  Copyright (c) 2015 OmsaTech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    PLCarouselViewVisibleItemCurrent = 0,
    PLCarouselViewVisibleItemNext,
    PLCarouselViewVisibleItemPrevious
    
}
PLCarouselViewVisibleItem;

typedef enum
{
    PLCarouselViewDirectionStatic = 0,
    PLCarouselViewDirectionUp,
    PLCarouselViewDirectionDown,
    PLCarouselViewDirectionLeft,
    PLCarouselViewDirectionRight
}
PLCarouselViewDirection;

@class PLCarouselView;

@protocol PLCarouselViewDelegate <NSObject>

@optional

-(void)carouselView:(PLCarouselView*)carouselView didSelectItemAtIndex:(NSUInteger)index;

-(void)carouselCurrentItemIndexDidChange:(PLCarouselView *)carouselView currentIndex:(NSUInteger)currentIndex previousIndex:(NSUInteger)previousIndex;

-(void)carouselView:(PLCarouselView*)carouselView didScrollDiffrenceRate:(CGFloat)diffRate;

-(void)carouselView:(PLCarouselView*)carouselView didMoveToView:(UIView*)view;

-(void)carouselView:(PLCarouselView*)carouselView changedScrollDirection:(PLCarouselViewDirection)direction;

@end

@protocol PLCarouselViewDataSource <NSObject>

@required

-(UIView*)carouselView:(PLCarouselView *)carouselView viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view;

-(NSUInteger)numberOfItemsInCarousel:(PLCarouselView *)carouselView;

@end

@interface PLCarouselView : UIView

+ (instancetype)init;

+ (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) IBOutlet id<PLCarouselViewDataSource> dataSource;

@property (nonatomic, weak) IBOutlet id<PLCarouselViewDelegate> delegate;

@property (nonatomic, assign) BOOL vertical;

@property (nonatomic, assign) BOOL scrollEnabled;

@property (nonatomic, assign, readonly) NSUInteger currentPageIndex;

- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated;

- (void)reloadData;

- (UIView*)visibleItemWithType:(PLCarouselViewVisibleItem)type;

- (void)resetInset;

@end
