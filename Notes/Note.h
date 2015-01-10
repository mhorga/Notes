//
//  Note.h
//  Notes
//
//  Created by Marius Horga on 1/9/15.
//  Copyright (c) 2015 Marius Horga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * lastModified;

@end
