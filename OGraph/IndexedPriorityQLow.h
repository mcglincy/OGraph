//
//  IndexedPriorityQLow.h
//  GraphLib
//
//  Created by Matthew McGlincy on 5/3/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


//  Priority queue based on an index into a set of keys. The queue is
//  maintained as a 2-way heap.
//
//  The priority in this implementation is the lowest valued key
@interface IndexedPriorityQLow : NSObject {
    double *keys;
    NSUInteger *heap;
    NSUInteger *invHeap;
    NSUInteger size;
    NSUInteger maxSize;
}

@property (nonatomic, readonly) NSUInteger size;

- (id)initWithKeys:(double *)aKeys maxSize:(NSUInteger)aMaxSize;
- (BOOL)empty;
- (void)insert:(NSUInteger)idx;
- (NSUInteger)pop;
- (void)changePriority:(NSUInteger)idx;

@end
