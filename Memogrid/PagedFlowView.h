

#import <UIKit/UIKit.h>

@protocol PagedFlowViewDataSource;
@protocol PagedFlowViewDelegate;


typedef enum{
    PagedFlowViewOrientationHorizontal = 0,
    PagedFlowViewOrientationVertical
}PagedFlowViewOrientation;

@interface PagedFlowView : UIView<UIScrollViewDelegate>{
    
    PagedFlowViewOrientation orientation;
    
    UIScrollView        *_scrollView;
    BOOL                _needsReload;
    CGSize              _pageSize;
    NSInteger           _pageCount;
    
    NSMutableArray      *_cells;
    NSRange              _visibleRange;
    NSMutableArray      *_reusableCells;
    
    UIPageControl       *pageControl;
    
    CGFloat _minimumPageAlpha;
    CGFloat _minimumPageScale;
    
    
    id <PagedFlowViewDataSource> _dataSource;
    id <PagedFlowViewDelegate>   _delegate;
}

@property(nonatomic,assign)   id <PagedFlowViewDataSource> dataSource;
@property(nonatomic,assign)   id <PagedFlowViewDelegate>   delegate;
@property(nonatomic,retain)    UIPageControl       *pageControl;
@property (nonatomic, assign) CGFloat minimumPageAlpha;
@property (nonatomic, assign) CGFloat minimumPageScale;
@property (nonatomic, assign) PagedFlowViewOrientation orientation;
- (void)reloadData;

// Cell
- (UIView *)dequeueReusableCell;
- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;

@end


@protocol  PagedFlowViewDelegate<NSObject>

- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView;
- (void)didChangePageToIndex:(int)index forFlowView:(PagedFlowView *)flowView; // Added.

@end


@protocol PagedFlowViewDataSource <NSObject>


- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView;
- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index;

@end