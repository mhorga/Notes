//
//  CoreDataStack.h
//  Notes
//
//  Created by Marius Horga on 2/4/15.
//  Copyright (c) 2015 Marius Horga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataStack : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)defaultStack;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
