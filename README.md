# CarouselView


## Display Visual Example 

----
![Visual1](http://g.recordit.co/gfRjQrfLdV.gif)


Installation
--------------

To use the PLCarouselView class in an app, just drag the PLCarouselView class files (demo files and assets are not needed) into your project and add the QuartzCore framework.


Properties
--------------

The PLCarouselView has the following properties (note: for iOS, UIView when using properties):

    @property (nonatomic, weak) IBOutlet id<PLCarouselViewDataSource> dataSource;

An object that supports the PLCarouselViewDataSource protocol and can provide views to populate the scroll.

    @property (nonatomic, weak) IBOutlet id<PLCarouselViewDelegate> delegate;

An object that supports the PLCarouselViewDelegate protocol and can respond to scroll events and layout requests.

    @property (nonatomic, assign) BOOL vertical;

This property toggles whether the carousel is displayed horizontally or vertically on screen. All the built-in carousel types work in both orientations. Switching to vertical changes both the layout of the carousel and also the direction of swipe detection on screen. Note that custom carousel transforms are not affected by this property, however the swipe gesture direction will still be affected. Defaulth value is NO.

    @property (nonatomic, assign) BOOL scrollEnabled;

Enables and disables user scrolling of the carousel. The carousel can still be scrolled programmatically if this property is set to NO.

    @property (nonatomic, assign, readonly) NSUInteger currentPageIndex;

The index of the currently centered item in the carousel. Setting this property is equivalent to calling `scrollToItemAtIndex:animated:` with the animated argument set to NO. 


Methods
--------------

The PLCarouselView class has the following methods (note: for iOS, UIView in method arguments):

    + (instancetype)init;

Custom initialize method.

    + (instancetype)initWithFrame:(CGRect)frame;

Custom initialize method.

    - (UIView*)visibleItemWithType:(PLCarouselViewVisibleItem)type;

Returns the visible item view with the specified PLCarouselViewVisibleItem (PLCarouselViewVisibleItemCurrent, PLCarouselViewVisibleItemNext or PLCarouselViewVisibleItemPrevious).

    - (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated;

This will center the carousel on the specified item, either immediately or with a smooth animation. For wrapped carousels, the carousel will automatically determine the shortest (direct or wraparound) distance to scroll. If you need to control the scroll direction, or want to scroll by more than one revolution, use the scrollByNumberOfItems method instead.

    - (void)reloadData;

This reloads all carousel views from the dataSource and refreshes the carousel display.


Protocols
---------------

The PLCarouselView follows the Apple convention for data-driven views by providing two protocol interfaces, PLCarouselViewDataSource and PLCarouselViewDelegate. The PLCarouselViewDataSource protocol has the following required methods (note: for iOS, UIView in method arguments):

    -(NSUInteger)numberOfItemsInCarousel:(PLCarouselView *)carouselView;

Return the number of items (views) in the carousel.

    -(UIView*)carouselView:(PLCarouselView *)carouselView viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view;

Return a view to be displayed at the specified index in the carousel. The `reusingView` argument works like a UIPickerView, where views that have previously been displayed in the carousel are passed back to the method to be recycled. If this argument is not nil, you can set its properties and return it instead of creating a new view instance, which will slightly improve performance. Unlike UITableView, there is no reuseIdentifier for distinguishing between different carousel view types, so if your carousel contains multiple different view types then you should just ignore this parameter and return a new view each time the method is called. You should ensure that each time the `carouselView:viewForItemAtIndex:reusingView:` method is called, it either returns the reusingView or a brand new view instance rather than maintaining your own pool of recyclable views, as returning multiple copies of the same view for different carousel item indexes may cause display issues with the carousel.

The PLCarouselViewDelegate protocol has the following optional methods:

    -(void)carouselCurrentItemIndexDidChange:(PLCarouselView *)carouselView currentIndex:(NSUInteger)currentIndex previousIndex:(NSUInteger)previousIndex;

This method is called whenever the carousel scrolls far enough for the currentPageIndex property to change. It is called regardless of whether the item index was updated programatically or through user interaction.

    -(void)carouselView:(PLCarouselView*)carouselView didSelectItemAtIndex:(NSUInteger)index;

This method will fire if the user taps any carousel item view, including the currently selected view. This method will not fire if the user taps a control within the currently selected view (i.e. any view that is a subclass of UIControl).

-(void)carouselView:(PLCarouselView*)carouselView didScrollDiffrenceRate:(CGFloat)diffRate;

This method is called whenever the carousel scrolls far enough for the contentOffset property to change. It is called regardless of whether the item contentOffset was updated programatically or through user interaction.

-(void)carouselView:(PLCarouselView*)carouselView didMoveToView:(UIView*)view;

This method is called whenever the carousel scrolls far enough for the currentPageIndex property to change and the item move into carousel view. It is called regardless of whether the item view was updated programatically or through user interaction.

-(void)carouselView:(PLCarouselView*)carouselView changedScrollDirection:(PLCarouselViewDirection)direction;

This method is called whenever the carousel scrolls far enough for the contentOffset property to change. It is called regardless of whether the carousel contentOffset was updated programatically or through user interaction. (PLCarouselViewDirectionStatic, PLCarouselViewDirectionUp, PLCarouselViewDirectionDown, PLCarouselViewDirectionLeft or PLCarouselViewDirectionRight)


How to use ?
----------

```Objective-C
#import "PLCarouselView.h"

@interface ViewController () <PLCarouselViewDataSource,PLCarouselViewDelegate>

...

- (void)loadView
{
[super loadView];

PLCarouselView *_carousel = [PLCarouselView init];

[_carousel setFrame:[UIScreen mainScreen].bounds];

_carousel.delegate = self;

_carousel.dataSource = self;

_carousel.vertical = YES:

[self.view addSubview:_carousel];

[_carousel reloadData];

}

...

#pragma mark - PLCarouselView delegates & datasources

-(UIView *)carouselView:(PLCarouselView *)carouselView viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if(view)
    {
        return view;
    }
    else
    {
        return [UIView new];
    {
}

-(NSUInteger)numberOfItemsInCarousel:(PLCarouselView *)carouselView
{
    return 10;
}

-(void)carouselView:(PLCarouselView *)carouselView didMoveToView:(PLExpandScrollView *)view
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


```

Build and run the project files. Enjoy more examples!