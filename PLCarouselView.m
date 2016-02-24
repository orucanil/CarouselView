//
//  PLCarouselView.m
//  platinum
//
//  Created by Anil Oruc on 5/4/15.
//  Copyright (c) 2015 Turkcell. All rights reserved.
//

#import "PLCarouselView.h"

#import <QuartzCore/CALayer.h>
#import <math.h>

@interface PLCarouselView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) PLCarouselViewDirection direction;

@property (nonatomic,strong) UIView *viewPrevious;
@property (nonatomic,strong) UIView *viewCurrent;
@property (nonatomic,strong) UIView *viewNext;

@property (nonatomic, assign) NSUInteger currentPageIndex;
@property (nonatomic, assign) NSUInteger numberOfItems;

@property (nonatomic, assign) BOOL isScrolling;

@end

@implementation PLCarouselView

+(instancetype)init
{
    PLCarouselView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    if (self) {
        view.vertical = NO;
        [view loadView];
    }
    return view;
}

+ (instancetype)initWithFrame:(CGRect)frame
{
    PLCarouselView *view = [self init];
    if (view)
    {
        [view setFrame:frame];
        
    }
    return view;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self reloadFrame];
}

-(void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled = scrollEnabled;
    
    _scrollView.scrollEnabled = scrollEnabled;
}

- (void)resetInset
{
    _scrollView.contentInset = UIEdgeInsetsZero;
}

-(void)cloneBaseView:(UIView*)viewBase view:(UIView*)cloneView
{
    for (UIView *view in viewBase.subviews)
    {
        [view removeFromSuperview];
    }
    if (cloneView) {
        
        cloneView.center = self.center;
        
        //[cloneView addShadow];
        
        [viewBase addSubview:cloneView];
    }
}

-(void)setCurrentPageIndex:(NSUInteger)currentPageIndex
{
    if (_currentPageIndex - 1 == currentPageIndex)
    {
        [self cloneBaseView:_viewNext view:_viewCurrent.subviews.firstObject];
        [self cloneBaseView:_viewCurrent view:_viewPrevious.subviews.firstObject];
        
        UIView *view = [self viewForItemAtIndex:currentPageIndex - 1 reusingView:_viewPrevious.subviews.firstObject];
        [self cloneBaseView:_viewPrevious view:view];
        
        if ([_delegate respondsToSelector:@selector(carouselView:didMoveToView:)]) {
            [_delegate carouselView:self didMoveToView:view];
        }
    }
    else if (_currentPageIndex == currentPageIndex - 1)
    {
        [self cloneBaseView:_viewPrevious view:_viewCurrent.subviews.firstObject];
        [self cloneBaseView:_viewCurrent view:_viewNext.subviews.firstObject];
        
        UIView *view = [self viewForItemAtIndex:currentPageIndex + 1 reusingView:_viewNext.subviews.firstObject];
        [self cloneBaseView:_viewNext view:view];
        
        if ([_delegate respondsToSelector:@selector(carouselView:didMoveToView:)]) {
            [_delegate carouselView:self didMoveToView:view];
        }
    }
    else {
        UIView *viewNext = [self viewForItemAtIndex:currentPageIndex + 1 reusingView:_viewNext.subviews.firstObject];
        UIView *viewCurrent = [self viewForItemAtIndex:currentPageIndex reusingView:_viewCurrent.subviews.firstObject];
        UIView *viewPrevious = [self viewForItemAtIndex:currentPageIndex - 1 reusingView:_viewPrevious.subviews.firstObject];
        
        [self cloneBaseView:_viewNext view:viewNext];
        [self cloneBaseView:_viewCurrent view:viewCurrent];
        [self cloneBaseView:_viewPrevious view:viewPrevious];
        
        
        if ([_delegate respondsToSelector:@selector(carouselView:didMoveToView:)]) {
            [_delegate carouselView:self didMoveToView:viewPrevious];
            [_delegate carouselView:self didMoveToView:viewCurrent];
            [_delegate carouselView:self didMoveToView:viewNext];
        }
    }
    
    if (_currentPageIndex != currentPageIndex) {
        
        if ([_delegate respondsToSelector:@selector(carouselCurrentItemIndexDidChange:currentIndex:previousIndex:)]) {
            [_delegate carouselCurrentItemIndexDidChange:self currentIndex:currentPageIndex previousIndex:_currentPageIndex];
        }
    }
    
    _currentPageIndex = currentPageIndex;
}

-(UIView*)viewForItemAtIndex:(NSUInteger)index reusingView:(UIView*)reusingView
{
    if (_numberOfItems > index) {
        return [_dataSource carouselView:self viewForItemAtIndex:index reusingView:reusingView];
    }
    return nil;
    
}

-(void)setVertical:(BOOL)vertical
{
    _vertical = vertical;
    
    [self reloadFrame];
}

-(void)reloadFrame
{
    _scrollView.contentInset = UIEdgeInsetsZero;
    
    [_scrollView setFrame:self.bounds];
    
    [_viewNext setFrame:self.bounds];
    
    [_viewCurrent setFrame:self.bounds];
    
    [_viewPrevious setFrame:CGRectMake((_vertical ? 0.0f : - self.bounds.size.width), (_vertical ? - self.bounds.size.height : 0.0f ), self.bounds.size.width, self.bounds.size.height)];
    
    [_scrollView setContentSize:CGSizeMake((_vertical ? 1 : _numberOfItems) * self.frame.size.width, (_vertical ? _numberOfItems : 1) * self.frame.size.height)];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)setDirection:(PLCarouselViewDirection)direction
{
    if (_direction != direction) {
        _direction = direction;
        
        _viewNext.hidden = (_direction == PLCarouselViewDirectionStatic);
        _viewPrevious.hidden = (_direction == PLCarouselViewDirectionStatic);
        _viewCurrent.hidden = NO;
        /*
        if (_direction == PLCarouselViewDirectionStatic) {
            _viewNext.hidden = YES;
            _viewPrevious.hidden = YES;
        }
        else {
            _viewNext.hidden = _vertical ? !(_direction == PLCarouselViewDirectionDown) : !(_direction == PLCarouselViewDirectionRight);
            _viewPrevious.hidden = _vertical ? (_direction == PLCarouselViewDirectionDown) : (_direction == PLCarouselViewDirectionRight);
        }
        */
        if ([_delegate respondsToSelector:@selector(carouselView:changedScrollDirection:)]) {
            [_delegate carouselView:self changedScrollDirection:_direction];
        }
    }
}

-(UIView *)visibleItemWithType:(PLCarouselViewVisibleItem)type
{
    switch (type) {
        case PLCarouselViewVisibleItemCurrent:
        {
            return _viewCurrent.subviews.firstObject;
        }
            break;
            
        case PLCarouselViewVisibleItemNext:
        {
            return _viewNext.subviews.firstObject;
        }
            break;
        case PLCarouselViewVisibleItemPrevious:
        {
            return _viewPrevious.subviews.firstObject;
        }
            break;
        default:
            break;
    }
    return nil;
}

-(void)loadView
{
    _currentPageIndex = 0;
    _scrollEnabled = YES;
    
    for (UIView *view in _scrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    _scrollView.autoresizesSubviews = YES;
    
    _scrollView.contentInset = UIEdgeInsetsZero;
    
    [_scrollView setFrame:self.bounds];
    
    _viewNext = [[UIView alloc]initWithFrame:self.bounds];
    [_scrollView addSubview:_viewNext];
    
    _viewCurrent = [[UIView alloc]initWithFrame:self.bounds];
    [_scrollView addSubview:_viewCurrent];
    
    _viewPrevious = [[UIView alloc]initWithFrame:CGRectMake((_vertical ? 0.0f : - self.bounds.size.width), (_vertical ? - self.bounds.size.height : 0.0f ), self.bounds.size.width, self.bounds.size.height)];
    [_scrollView addSubview:_viewPrevious];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    singleTap.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:singleTap];
    
    _viewNext.hidden = YES;
    _viewPrevious.hidden = YES;
    _direction = PLCarouselViewDirectionStatic;
}

-(void)reloadData
{
    if (!_dataSource)
    {
        return;
    }
    NSUInteger newNumberOfItems = [_dataSource numberOfItemsInCarousel:self];
    if (_numberOfItems != newNumberOfItems) {
        _numberOfItems = newNumberOfItems;
        
        [_scrollView setContentSize:CGSizeMake((_vertical ? 1 : _numberOfItems) * self.frame.size.width, (_vertical ? _numberOfItems : 1) * self.frame.size.height)];
        
        NSInteger previousPageIndex = _currentPageIndex;
        if (previousPageIndex < 0) {
            previousPageIndex = 0;
            
        }
        
        _currentPageIndex = previousPageIndex;
    }
    
    self.currentPageIndex = _currentPageIndex;
    if ([_delegate respondsToSelector:@selector(carouselCurrentItemIndexDidChange:currentIndex:previousIndex:)]) {
        [_delegate carouselCurrentItemIndexDidChange:self currentIndex:_currentPageIndex previousIndex:_currentPageIndex];
    }
    [self scrollToItemAtIndex:_currentPageIndex animated:NO];
}

- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated
{
    if (_numberOfItems > 0 && index < _numberOfItems)
    {
        [_scrollView setContentOffset:CGPointMake((_vertical ? 0 : index) * self.frame.size.width, (_vertical ? index : 0) * self.frame.size.height) animated:animated];
    }
}

#pragma mark - UIScrollViewDelegates

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat nowContentOffset = (_vertical ? scrollView.contentOffset.y : scrollView.contentOffset.x);
    
    CGFloat pageSize = (_vertical ? scrollView.frame.size.height : scrollView.frame.size.width);
    
    CGFloat fractionalPage = nowContentOffset / pageSize;
    
    NSInteger page = floorf(fractionalPage);
        
    if (_lastContentOffset > nowContentOffset)
    {
        self.direction = _vertical ? PLCarouselViewDirectionUp : PLCarouselViewDirectionLeft;
    }
    else if (_lastContentOffset < nowContentOffset)
    {
        self.direction = _vertical ? PLCarouselViewDirectionDown : PLCarouselViewDirectionRight;
    }
    
    if (_currentPageIndex * pageSize > nowContentOffset)
    {
        page = ceilf(fractionalPage);
        _viewCurrent.frame = CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.y, self.bounds.size.width, self.bounds.size.height);
    }
    
    _viewNext.frame = CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.y, self.bounds.size.width, self.bounds.size.height);
    
    _lastContentOffset = nowContentOffset;
    
    if (_currentPageIndex != page && page >= 0) {
        
        _viewPrevious.frame = CGRectMake((_vertical ? 0.0f : (page - 1) * self.bounds.size.width),(_vertical ? (page - 1) * self.bounds.size.height : 0.0f), self.bounds.size.width, self.bounds.size.height);
        _viewNext.frame = CGRectMake((_vertical ? 0.0f : page) * self.bounds.size.width, (_vertical ? page : 0.0f) * self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
        _viewCurrent.frame = _viewNext.frame;
        
        self.currentPageIndex = page;
        
    }
    
    if ([_delegate respondsToSelector:@selector(carouselView:didScrollDiffrenceRate:)]) {
        [_delegate carouselView:self didScrollDiffrenceRate:fractionalPage];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.direction = PLCarouselViewDirectionStatic;
}

#pragma mark - UIGestureRecognizerDelegates

-(void)handleTap:(UITapGestureRecognizer*)gesture
{
    CGPoint point = [gesture locationInView:_scrollView];
    
    CGFloat nowContentOffset = (_vertical ? point.y : point.x);
    
    float fractionalPage = nowContentOffset / (_vertical ? self.bounds.size.height : self.bounds.size.width);
    
    NSInteger didSelectIndex = floorf(fractionalPage);
    
    if ([_delegate respondsToSelector:@selector(carouselView:didSelectItemAtIndex:)] && didSelectIndex > -1 && didSelectIndex < _numberOfItems) {
        [_delegate carouselView:self didSelectItemAtIndex:didSelectIndex];
    }
}

@end
