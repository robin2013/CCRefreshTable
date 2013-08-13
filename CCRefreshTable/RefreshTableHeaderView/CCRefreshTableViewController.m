//
//  CCRefreshTableViewController.m
//  TableViewPull
//
//  Created by Robin on 13-8-13.
//
//

#import "CCRefreshTableViewController.h"
@interface CCRefreshTableViewController()
- (void) initControl;
- (void) initPullDownView;
- (void) initPullUpView;
- (void) initPullAllView;
@end
@implementation CCRefreshTableViewController
@synthesize delegate = _delegate;
@synthesize pullTableView = _pullTableView;
- (void)dealloc
{
    [_pullTableView release];
    _delegate = nil;
    [_logo release];
    [super dealloc];
}
- (id) initWithTableView:(UITableView *) tView
           pullDirection:(CCRefreshTableViewDirection) cDirection
{
    return [self initWithTableView:tView pullDirection:cDirection withLogo:nil];
    
}

- (id) initWithTableView:(UITableView *) tView
           pullDirection:(CCRefreshTableViewDirection) cDirection
                withLogo:(NSString *)logo
{
    if (self= [super init]) {
        _logo = [logo copy];
        _direction = cDirection;
        [self setPullTableView:tView];
        [self initControl];
    }
    return self;
}

- (void) initControl
{
    switch (_direction) {
        case CCRefreshTableViewDirectionDown:
            [self initPullDownView];
            break;
        case CCRefreshTableViewDirectionUp:
            [self initPullUpView];
            break;
        default:
            [self initPullAllView];
            break;
    }
}
- (void) initPullDownView
{
    CGRect rect = CGRectOffset(_pullTableView.frame, 0, -_pullTableView.frame.size.height);
    _header = [[EGORefreshTableHeaderView alloc] initWithFrame:rect
                                                 withDirection:EGOOPullRefreshDown
                                                      withLogo:_logo];
    _header.delegate = self;
    _header.autoresizingMask = _pullTableView.autoresizingMask;
    [_pullTableView addSubview:_header];
    [_header release];
    [_header refreshLastUpdatedDate];
}
- (void)initPullUpView
{
    CGRect rect = CGRectOffset(_pullTableView.frame, 0, _pullTableView.frame.size.height);
    _footer = [[EGORefreshTableHeaderView alloc] initWithFrame:rect
                                                 withDirection:EGOOPullRefreshUp
                                                      withLogo:nil];
    _footer.delegate = self;
    _footer.autoresizingMask = _pullTableView.autoresizingMask;
    [_pullTableView addSubview:_footer];
    [_footer release];
    [_footer refreshLastUpdatedDate];
}
- (void) initPullAllView
{
    [self initPullDownView];
    [self initPullUpView];
}
- (void) updatePullViewFrame

{
    
    
    if (_footer != nil) {
        
        CGFloat fWidth = _pullTableView.frame.size.width;
        
        CGFloat originY = _pullTableView.contentSize.height;
        
        CGFloat originX = _pullTableView.contentOffset.x;
        
        if (originY < _pullTableView.frame.size.height) {
            
            originY = _pullTableView.frame.size.height;
            
        }
        
        if (!CGRectEqualToRect(_footer.frame, CGRectMake(originX, originY, fWidth, 60))) {
            
            _footer.frame = CGRectMake(originX, originY, fWidth, 60);
            
        }
        
    }
    
}

- (void)startLoadDataAutomaticly
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ UIView animateWithDuration:1.2 animations:^{
            [self.pullTableView setContentOffset:CGPointMake(0, -55)];
        } completion:^(BOOL finished) {
            [_header egoRefreshScrollViewDidScroll:_pullTableView ];
            [_header egoRefreshScrollViewDidEndDragging:_pullTableView ];
        }];
    });
    
}

#pragma mark -

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y < -60.0f) {
        
        [_header egoRefreshScrollViewDidScroll:scrollView];
    }
    else if (scrollView.contentOffset.y >  60.0f)
    {
        [_footer egoRefreshScrollViewDidScroll:scrollView];
    }
[self updatePullViewFrame];
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y < -60.0f) {
        [_header egoRefreshScrollViewDidEndDragging:scrollView];
    }
    else if (scrollView.contentOffset.y > 60.0f)
    {
        [_footer  egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark -

#pragma mark Data Source Loading / Reloading Methods

- (void) DataSourceDidFinishedLoading
{
    _reloading = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_header egoRefreshScrollViewDataSourceDidFinishedLoading:_pullTableView];
        [_footer egoRefreshScrollViewDataSourceDidFinishedLoading:_pullTableView];
    });
}


#pragma mark -

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
                                     direction:(EGOPullRefreshDirection)direc
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(CCRefreshTableViewControllerDataSource:)]) {
        if (direc == EGOOPullRefreshUp) {
            _reloading = [_delegate CCRefreshTableViewControllerDataSource:CCRefreshTableViewPullTypeLoadMore];
        }
        else if (direc == EGOOPullRefreshDown)
        {
            _reloading = [_delegate CCRefreshTableViewControllerDataSource:CCRefreshTableViewPullTypeReload];
        }
    }
}



- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}
@end
