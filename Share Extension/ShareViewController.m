//
//  ShareViewController.m
//  Share Extension
//
//  Created by Marius Horga on 2/3/15.
//  Copyright (c) 2015 Marius Horga. All rights reserved.
//

#import "ShareViewController.h"
#import "CoreDataStack.h"
#import "Note.h"

@interface ShareViewController ()

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;

@end

@implementation ShareViewController

- (void)createNote {
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    Note *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:coreDataStack.managedObjectContext];
    entry.text = self.textView.text;
    entry.title = self.titleTextField.text;
    entry.lastModified = [NSDate date];
    [coreDataStack saveContext];
}

- (IBAction)savePressed:(id)sender {
    [self createNote];
    [self.textView resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
    }];
}

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height);
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

- (IBAction)dismiss:(id)sender {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        [self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
    }];
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
