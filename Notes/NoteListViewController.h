//
//  NoteListViewController.h
//  Notes
//
//  Created by Marius Horga on 1/9/15.
//  Copyright (c) 2015 Marius Horga. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoteListViewController;

@protocol NoteListViewControllerDelegate <NSObject>

- (void) cell:(NoteListViewController *)cell didTapImageView:(UIImageView *)imageView;

@end


@interface NoteListViewController : UITableViewController <UISearchDisplayDelegate>

@property (nonatomic, weak) id <NoteListViewControllerDelegate> delegate;

@end
