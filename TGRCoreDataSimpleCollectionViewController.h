//
//  TGRCoreDataSimpleCollectionViewController.h
//  CoreDataTest
//
//  Created by José Miguel Galván on 17/1/15.
//  Copyright (c) 2015 Tagorito. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TGRCoreDataSimpleCollectionViewController : UICollectionViewController

@property (strong, nonatomic) NSManagedObjectContext *context;

+(instancetype)coreDataCollectionViewControllerWithFetchRequest:(NSFetchRequest *)request
                                         inManagedObjectContext:(NSManagedObjectContext *) context;

+(instancetype)coreDataCollectionViewControllerWithFetchRequest:(NSFetchRequest *)request
                                           collectionViewLayout:(UICollectionViewLayout *) layout
                                         inManagedObjectContext:(NSManagedObjectContext *) context;

// designated
-(id) initWithFetchRequest:(NSFetchRequest *)request
      collectionViewLayout:(UICollectionViewLayout *) layout
    inManagedObjectContext:(NSManagedObjectContext *) context;

-(id) initWithFetchRequest:(NSFetchRequest *)request
    inManagedObjectContext:(NSManagedObjectContext *) context;


-(id) objectAtIndexPath:(NSIndexPath*)indexPath;

@end
