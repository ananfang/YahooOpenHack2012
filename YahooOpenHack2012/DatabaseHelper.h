//
//  DatabaseHelper.h
//  InstaCC
//
//  Created by Fang Andy on 12/4/2.
//  Copyright (c) 2012年 Openmouse Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void (^completion_block_document) (UIManagedDocument *managedDocument);

@interface DatabaseHelper : NSObject
+ (DatabaseHelper *)sharedHelper;
#pragma mark - UIManagedDocument
@property (nonatomic, strong) UIManagedDocument *managedDocument;
- (void)openSharedManagedDocumentUsingBlock:(completion_block_document)completionBlock;
- (void)saveDocument;
@end