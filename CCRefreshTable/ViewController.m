//
//  ViewController.m
//  TableViewPull
//
//  Created by Robin on 13-8-13.
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addTable];
    _refreshView = [[CCRefreshTableViewController alloc]
                    initWithTableView:self.table
                    pullDirection:CCRefreshTableViewDirectionAll
                    withLogo:@"logo.png"];
    _refreshView.delegate = self;
}
- (void)addTable
{
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource =self;
    [self.view addSubview:table];
    [self setTable:table];
    [table release];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_refreshView startLoadDataAutomaticly];
}
- (void)dealloc {
    [_table release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTable:nil];
    [super viewDidUnload];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    [cell.textLabel setText:[NSString stringWithFormat:@"%d",indexPath.row ]];
	// Configure the cell.
    
    return cell;
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    //访问网络数据
}

- (void)doneLoadingTableViewData{
	//数据访问结束
     [_refreshView DataSourceDidFinishedLoading];
	
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshView scrollViewDidScroll:scrollView];
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
	
}

- (BOOL)CCRefreshTableViewControllerDataSource:(CCRefreshTableViewPullType)refreshType
{
    switch (refreshType) {
        case CCRefreshTableViewPullTypeReload:
            [self reloadTableViewDataSource];
            break;
            
        case CCRefreshTableViewPullTypeLoadMore:
            [self reloadTableViewDataSource];
            break;
            
        default:
            break;
    }
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:4];
    return YES;
}

@end
