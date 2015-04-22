//
//  TGRCoreDataSimpleCollectionViewController.m
//  CoreDataTest
//
//  Created by José Miguel Galván on 12/2/15.
//  Copyright (c) 2015 Tagorito. All rights reserved.
//

#import "TGRCoreDataSimpleCollectionViewController.h"
#import "TGREntityObserver.h"

#import "NSObject+GNUstepBase.h"

@interface TGRCoreDataSimpleCollectionViewController ()<TGREntityObserverDelegate>
@property (strong, nonatomic) TGREntityObserver *observer;
@property (strong, nonatomic) NSFetchRequest *request;
@property (strong, nonatomic, readonly) NSArray *results;
@end

@implementation TGRCoreDataSimpleCollectionViewController
#pragma mark - Properties
@synthesize results=_results;

// Resultados cargados de forma perezosa, por rendimiento y memoria
-(NSArray *) results{
    
    if (_results == nil ) {
        NSError *error;
        _results = [self.context executeFetchRequest:self.request
                                               error:&error];
        if (_results == nil) {
            NSLog(@"Error executing fetch request in TGRCoreDataCollectionViewController:\n%@", error.localizedDescription);
        }
    }
    return _results;
}

// Refresca los datos
-(void) reloadData{
    _results = 0;
    [self.collectionView reloadData];
}

#pragma mark - Class Methods
+(instancetype)coreDataCollectionViewControllerWithFetchRequest:(NSFetchRequest *)request
                                         inManagedObjectContext:(NSManagedObjectContext *) context{
    
    return [[self alloc] initWithFetchRequest:request
                       inManagedObjectContext:context];
}

+(instancetype)coreDataCollectionViewControllerWithFetchRequest:(NSFetchRequest *)request
                                           collectionViewLayout:(UICollectionViewLayout *) layout
                                         inManagedObjectContext:(NSManagedObjectContext *) context{
    
    return [[self alloc] initWithFetchRequest:request
                         collectionViewLayout:layout
                       inManagedObjectContext:context];
    
}


#pragma mark - Init
// designated
-(id) initWithFetchRequest:(NSFetchRequest *)request
      collectionViewLayout:(UICollectionViewLayout *) layout
    inManagedObjectContext:(NSManagedObjectContext *) context{
    
    if (self = [super initWithCollectionViewLayout:layout]) {
        _request = request;
        _context = context;
        
        
        NSEntityDescription *desc = [NSEntityDescription entityForName:request.entityName
                                                inManagedObjectContext:context];
        
        _observer = [TGREntityObserver entityObserverWithEntityDescription:desc
                                                    inManagedObjectContext:context];
        
        _observer.delegate = self;
        
    }
    return self;
}

-(id) initWithFetchRequest:(NSFetchRequest *)request
    inManagedObjectContext:(NSManagedObjectContext *) context{
    
    return [self initWithFetchRequest:request
                 collectionViewLayout:[[UICollectionViewFlowLayout alloc] init] inManagedObjectContext:context];
}


#pragma mark - View Lifecycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    // Set default title
    if ([self.title length] == 0) {
        self.title = [NSString stringWithFormat:@"%@s", self.request.entityName];
    }
    
    
    // start observing
    [self.observer startObserving];
    
    // Refrescamos los datos
    [self reloadData];
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Stop observing
    [self.observer stopObserving];
}

#pragma mark - Memory
-(void) didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    _results = nil;
}

#pragma mark - Undo management
-(void) motionEnded:(UIEventSubtype)motion
          withEvent:(UIEvent *)event{
    
    if (motion == UIEventSubtypeMotionShake) {
        // Se ha producido una sacudida
        [self.context.undoManager undo];
    }
    
    
}

#pragma mark - CollectionView Data Source
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1; // Más adelante habría que flexibilizar esto, como hace NSFetchedResultsController
}

-(NSInteger) collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    // De momento solo hay una sección
    return [self.results count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self subclassResponsibility:_cmd];
}

#pragma mark - TGREntityObserverDelegate
-(void) entityObserver:(TGREntityObserver *)observer
      didDeleteObjects:(NSSet *)objects{
    
    // refresco los datos
    [self reloadData];
    
}

-(void) entityObserver:(TGREntityObserver *)observer
      didInsertObjects:(NSSet *)objects{
    
    // refresco los datos
    [self reloadData];

}

-(void) entityObserver:(TGREntityObserver *)observer
      didUpdateObjects:(NSSet *)objects{
    
    // refresco los datos
    [self reloadData];

}

#pragma mark - Model
-(id) objectAtIndexPath:(NSIndexPath*)indexPath{
    
    // So far, there's only one section...
    return [self.results objectAtIndex:indexPath.item];
}


@end
