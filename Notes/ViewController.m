//
//  ViewController.m
//  Notes
//
//  Created by Marius Horga on 1/9/15.
//  Copyright (c) 2015 Marius Horga. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Note.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.entry != nil) {
        self.textView.text = self.entry.text;
        self.titleTextField.text = self.entry.title;
    }
}

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)createNote {
    AppDelegate *coreDataStack = [AppDelegate defaultStack];
    Note *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:coreDataStack.managedObjectContext];
    entry.text = self.textView.text;
    entry.title = self.titleTextField.text;
    entry.lastModified = [NSDate date];
    [coreDataStack saveContext];
}

- (void)editNote {
    self.entry.text = self.textView.text;
    self.entry.title = self.titleTextField.text;
    AppDelegate *coreDataStack = [AppDelegate defaultStack];
    [coreDataStack saveContext];
}

- (IBAction)savePressed:(id)sender {
    if (self.textView.editable == YES) {
        if (self.entry != nil) {
            [self editNote];
        } else {
            [self createNote];
        }
        self.textView.dataDetectorTypes = UIDataDetectorTypeAll;
        self.textView.editable = NO;
        self.saveButton.title = @"Done";
        [self.textView resignFirstResponder];
    } else {
        self.textView.dataDetectorTypes = UIDataDetectorTypeNone;
        self.textView.editable = YES;
        self.saveButton.title = @"Save";
        [self dismissSelf];
    }
}

- (IBAction)cancelPressed:(id)sender {
    [self dismissSelf];
}

@end
