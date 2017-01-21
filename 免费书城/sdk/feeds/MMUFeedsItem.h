//
//  MMUFeedsViewManager.h
//  MMULibrary
//
//  Created by liuyu on 1/20/16.
//  Copyright © 2016 alimama. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMUMamaResponse;
@class MMUMamaPromoter;
@class MMUFeeds;
@protocol MMUFeedsViewManagerDelegate;

@interface MMUFeedsItem : NSObject

@property (nonatomic, weak) UIViewController *mViewController;
@property (nonatomic, assign) UIEdgeInsets mContentInsetForPromoterCell;

- (instancetype)initWithFeeds:(MMUFeeds *)feeds  promoterIndex:(NSInteger)pId;

/**
 
 This method return recommend height for promoter cell
 
 @return height
 
 */

- (CGFloat)heightForPromoterCell;

/**
 
 This method return a promoter cell according to the loaded promoters info
 
 @param  tableView tableView to show promoter cell
 @param  indexPath indexPath of the cell to show promoter
 
 */

- (UITableViewCell *)cellWithTableView:(UITableView *)tableView;

/**
 
 Used to check whether you can render the relevant template
 
 @param  templateType
 @return YES / NO

 */

+ (BOOL)canRenderTemplate:(NSInteger)templateType;


/*
 * willDisplayCell
 */
- (void)willDisplayCell:(UITableViewCell *)cell;

/*
 * didEndDisplayingCell
 */
- (void) didEndDisplayingCell:(UITableViewCell *)cell;

@end

@protocol MMUFeedsViewManagerDelegate <NSObject>

@required

- (void)viewManager:(MMUFeedsItem *)manager
       viewDidShown:(NSArray<MMUMamaPromoter *> *)shownPromoters
           response:(MMUMamaResponse *)response;

- (void)viewManager:(MMUFeedsItem *)manager
     viewDidClicked:(MMUMamaPromoter *)clickedPromoter
           response:(MMUMamaResponse *)response;

@optional

- (void)viewManager:(MMUFeedsItem *)manager
  renderViewCreated:(UIView *)renderView;

@end
