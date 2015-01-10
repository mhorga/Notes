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

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.entry != nil) {
        self.textView.text = self.entry.text;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)createNote {
    AppDelegate *coreDataStack = [AppDelegate defaultStack];
    Note *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:coreDataStack.managedObjectContext];
    entry.text = self.textView.text;
    entry.lastModified = [NSDate date];
    [coreDataStack saveContext];
}

- (void)editNote {
    self.entry.text = self.textView.text;
    AppDelegate *coreDataStack = [AppDelegate defaultStack];
    [coreDataStack saveContext];
}

- (IBAction)savePressed:(id)sender {
    if (self.entry != nil) {
        [self editNote];
    } else {
        [self createNote];
    }
    [self dismissSelf];
}

- (IBAction)cancelPressed:(id)sender {
    [self dismissSelf];
}

@end
