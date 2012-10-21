//
//  DatabaseHelper.m
//  InstaCC
//
//  Created by Fang Andy on 12/4/2.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import "DatabaseHelper.h"

static DatabaseHelper *_sharedHelper = nil;

@implementation DatabaseHelper
+ (DatabaseHelper *)sharedHelper
{
    if (_sharedHelper == nil) {
        _sharedHelper = [[DatabaseHelper alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:_sharedHelper
                                                 selector:@selector(managedObjectContextDidSaveNotification:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:_sharedHelper.managedDocument.managedObjectContext];
    }
    
    return _sharedHelper;
}

#pragma mark - Public Properties
@synthesize managedDocument = _managedDocument;

#pragma mark - Setters and Getters
- (void)openSharedManagedDocumentUsingBlock:(completion_block_document)completionBlock
{
    NSURL *databaseURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    databaseURL = [databaseURL URLByAppendingPathComponent:@"YahooOpenHack2012 Database"];
    
    UIManagedDocument *managedDocument = [[UIManagedDocument alloc] initWithFileURL:databaseURL];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    managedDocument.persistentStoreOptions = options;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[managedDocument.fileURL path]]) {
        // does not exist on disk, so create it
        DLog(@"[%@ %@ %d] database does not exist, create it. %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, managedDocument);
        [managedDocument saveToURL:managedDocument.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            self.managedDocument = managedDocument;
            completionBlock(managedDocument);
        }];
    } else if (managedDocument.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        DLog(@"[%@ %@ %d] database exists, need to open it. %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, managedDocument);
        [managedDocument openWithCompletionHandler:^(BOOL success) {
            self.managedDocument = managedDocument;
            completionBlock(managedDocument);
        }];
    } else if (managedDocument.documentState == UIDocumentStateNormal) {
        // already open and ready to use
        DLog(@"[%@ %@ %d] database already open and ready to use.", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__);
        self.managedDocument = managedDocument;
        completionBlock(managedDocument);
    }
}

- (void)saveDocument
{
    [self.managedDocument saveToURL:self.managedDocument.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
    }];
}

#pragma mark - Notification
- (void)managedObjectContextDidSaveNotification:(NSNotification *)notification
{
    DLog(@"[%@ %@ %d] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), __LINE__, notification.name);
}
@end