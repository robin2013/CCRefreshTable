//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"
#define RefreshViewHight  55.0f

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableHeaderView (Private)
{
}
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;
- (id) initWithFrame:(CGRect)frame withDirection:(EGOPullRefreshDirection) direc
{
    return [self initWithFrame:frame withDirection:direc withLogo:nil];
}
- (id) initWithFrame:(CGRect)frame withDirection:(EGOPullRefreshDirection) direc withLogo:(NSString *)logoStr
{
    if (self = [super initWithFrame:frame]) {
        [self setDirection:direc];
        _logo = [logoStr copy];
        
        [self creatControlWithFrame];
    }
    return self;
}
- (void)creatControlWithFrame {
    CGRect frame = self.bounds;
    float y_labUpdate = frame.size.height - 30.0f ;
    if (_direction == EGOOPullRefreshUp)
    {
        y_labUpdate = 30;
    }
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor =[UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    
    // add msg lable
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, y_labUpdate, self.frame.size.width, 20.0f)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textColor = TEXT_COLOR;
    label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    _lastUpdatedLabel=label;
    [label release];
    
    // add state lable
    label = [[UILabel alloc] initWithFrame:CGRectOffset(label.frame, 0, -20)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont boldSystemFontOfSize:13.0f];
    label.textColor = TEXT_COLOR;
    label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    _statusLabel=label;
    [label release];
    
    // add imgArrow
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(25.0f, y_labUpdate-30.0f, 30.0f, 55.0f);
    layer.contentsGravity = kCAGravityResizeAspect;
    layer.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        layer.contentsScale = [[UIScreen mainScreen] scale];
    }
#endif
    
    [[self layer] addSublayer:layer];
    _arrowImage=layer;
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    view.frame = CGRectMake(25.0f, y_labUpdate-8.0f, 20.0f, 20.0f);
    [self addSubview:view];
    _activityView = view;
    [view release];
    
    if (_logo) {//add company logo
        float y_imgLogo = label.frame.origin.y  - 72;
        if (_direction == EGOOPullRefreshUp) {
            y_imgLogo = label.frame.origin.y  +48;
        }
        CGRect rect = CGRectMake(0,
                                 y_imgLogo,
                                 self.frame.size.width,
                                 70);
        UIImageView *imgLogo = [[UIImageView alloc]
                                initWithFrame:rect];
        [imgLogo setImage:[UIImage imageNamed:_logo]];
        [imgLogo setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:imgLogo];
        [imgLogo release];
    }
    [self setState:EGOOPullRefreshNormal];
}


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"MM/dd/yyyy hh:mm:a"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"Last Updated: %@", [formatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[formatter release];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}
    
}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
			//_statusLabel.text = NSLocalizedString(@"Release to refresh...", @"Release to refresh status");
            switch (_direction) {
                    
                case EGOOPullRefreshUp:
                    _statusLabel.text = NSLocalizedString(@"释放加载更多...", @"释放加载更多...");
                    break;
                case EGOOPullRefreshDown:
                    _statusLabel.text = NSLocalizedString(@"释放刷新...", @"释放刷新...");
                    break;
                    
            }
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = NSLocalizedString(@"Pull down to refresh...", @"Pull down to refresh status");
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoading:
			
			_statusLabel.text = NSLocalizedString(@"Loading...", @"Loading Status");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (_state == EGOOPullRefreshLoading) {
		
		CGFloat offset = - scrollView.contentOffset.y ;
        if (_direction == EGOOPullRefreshUp) {
            offset = scrollView.contentOffset.y ;
        }
        switch (_direction) {
            case EGOOPullRefreshUp:
            {
                offset = MIN(offset, RefreshViewHight+20);
                scrollView.contentInset = UIEdgeInsetsMake(0, 0.0f, offset, 0.0f);
                break;
            }
            case EGOOPullRefreshDown:
            {
                offset = MIN(offset, RefreshViewHight);
                scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
                break;
            }
        }
		
	}
    else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
        switch (_direction) {
                
            case EGOOPullRefreshUp:
            {
                if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y + (scrollView.frame.size.height) < scrollView.contentSize.height + RefreshViewHight && scrollView.contentOffset.y > 0.0f && !_loading) {
                    
                    [self setState:EGOOPullRefreshNormal];
                    
                }
                else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + RefreshViewHight &&!_loading) {
                    
                    [self setState:EGOOPullRefreshPulling];
                    
                }
            }
                break;
                
            case EGOOPullRefreshDown:
                
                if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -RefreshViewHight && scrollView.contentOffset.y < 0.0f && !_loading) {
                    
                    [self setState:EGOOPullRefreshNormal];
                    
                } else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -RefreshViewHight && !_loading) {
                    
                    [self setState:EGOOPullRefreshPulling];
                    
                }
                
                break;
        }
        
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)])
    {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];//是否开始加载
	}
	switch (_direction)
    {
        case EGOOPullRefreshDown:
        {
            if (scrollView.contentOffset.y <= - RefreshViewHight && !_loading) {
                
                if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:direction:)]) {
                    [_delegate egoRefreshTableHeaderDidTriggerRefresh:self
                                                            direction:_direction
                     ];//启动加载
                }
                [self setState:EGOOPullRefreshLoading];
                [ UIView animateWithDuration:0.2 animations:^{
                    scrollView.contentInset = UIEdgeInsetsMake(RefreshViewHight, 0.0f, 0.0f, 0.0f);}
                                  completion:nil];
            }
        }
            break;
        default:
        {
            if (scrollView.contentOffset.y >= RefreshViewHight  && !_loading) {
                
                if ([_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:direction:)]) {
                    [_delegate egoRefreshTableHeaderDidTriggerRefresh:self
                                                            direction:_direction];//启动加载
                }
                [self setState:EGOOPullRefreshLoading];
                [ UIView animateWithDuration:0.2 animations:^{
                    scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, RefreshViewHight+20, 0.0f);}
                                  completion:nil];
            }
        }
            break;
    }
    
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [UIView commitAnimations];
    
    [self setState:EGOOPullRefreshNormal];
    
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    [_logo release];//logo
    _delegate=nil;
    _activityView = nil;
    _statusLabel = nil;
    _arrowImage = nil;
    _lastUpdatedLabel = nil;
    [super dealloc];
}


@end
