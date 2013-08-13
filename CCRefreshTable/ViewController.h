//
//  ViewController.h
//  TableViewPull
//
//  Created by Robin on 13-8-13.
//
//

#import <UIKit/UIKit.h>
#import "CCRefreshTableViewController.h"
@interface ViewController : UIViewController<CCRefreshTableViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    CCRefreshTableViewController *_refreshView;
    BOOL _reloading;
}
@property (retain, nonatomic)  UITableView *table;

@end
