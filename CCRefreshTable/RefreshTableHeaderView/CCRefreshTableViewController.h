//
//  CCRefreshTableViewController.h
//  TableViewPull
//
//  Created by Robin on 13-8-13.
//
//

#import "EGORefreshTableHeaderView.h"

//pull direction

typedef enum {
    CCRefreshTableViewDirectionUp,
    CCRefreshTableViewDirectionDown,
    CCRefreshTableViewDirectionAll
}CCRefreshTableViewDirection;
//pull type
typedef enum {
    CCRefreshTableViewPullTypeReload,           //从新加载
    CCRefreshTableViewPullTypeLoadMore,         //加载更多
}CCRefreshTableViewPullType;

@protocol CCRefreshTableViewControllerDelegate;

@interface CCRefreshTableViewController : NSObject<EGORefreshTableHeaderDelegate,UIScrollViewDelegate>
{
    BOOL _reloading;
    NSString *_logo;
    EGORefreshTableHeaderView  *_header;
    EGORefreshTableHeaderView  *_footer;
    CCRefreshTableViewDirection _direction;
}
@property (nonatomic, assign) UITableView  *pullTableView;
@property (nonatomic, assign) id<CCRefreshTableViewControllerDelegate> delegate;
//方向

- (id) initWithTableView:(UITableView *) tView
           pullDirection:(CCRefreshTableViewDirection) cwDirection;

- (id) initWithTableView:(UITableView *) tView
           pullDirection:(CCRefreshTableViewDirection) cwDirection
                withLogo:(NSString *)logo;

//加载完成调用
- (void) DataSourceDidFinishedLoading;
- (void)startLoadDataAutomaticly;//自动加载
@end

@protocol CCRefreshTableViewControllerDelegate <NSObject>

//从新加载

- (BOOL) CCRefreshTableViewControllerDataSource:(CCRefreshTableViewPullType) refreshType;

@end
