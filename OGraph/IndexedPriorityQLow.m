//
//  IndexedPriorityQLow.m
//  GraphLib
//
//  Created by Matthew McGlincy on 5/3/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "IndexedPriorityQLow.h"

@interface IndexedPriorityQLow()
- (void)swap:(NSUInteger)a with:(NSUInteger)b;
- (void)reorderUpwards:(NSUInteger)nd;
- (void)reorderDownwards:(NSUInteger)nd heapSize:(NSUInteger)heapSize;
- (double)keyWithHeapIndex:(NSUInteger)heapIndex;
@end

@implementation IndexedPriorityQLow

@synthesize size;

- (id)initWithKeys:(double *)aKeys maxSize:(NSUInteger)aMaxSize {
    self = [super init];
    if (self) {
        keys = aKeys;
        maxSize = aMaxSize;
        size = 0;
        int capacity = maxSize + 1;
        // we use calloc to zero out the array
        heap = (NSUInteger *)calloc(capacity, sizeof(NSUInteger));
        invHeap = (NSUInteger *)calloc(capacity, sizeof(NSUInteger));
    }
    return self;
}

- (void)dealloc {
    free(heap);
    free(invHeap);
    [super dealloc];
}

- (BOOL)empty {
    return (size == 0);
}

// to insert an item into the queue it gets added to the end of the heap
// and then the heap is reordered from the bottom up.
- (void)insert:(NSUInteger)idx {
    NSAssert(size + 1 <= maxSize, @"IndexedPriorityQLow insert: illegal size");
    NSAssert(idx < maxSize + 1, @"IndexedPriorityQLow insert: illegal idx");
    ++size;
    heap[size] = idx;
    invHeap[idx] = size;
    [self reorderUpwards:size];
}

- (NSUInteger)pop {
    [self swap:1 with:size];
    [self reorderDownwards:1 heapSize:(size - 1)];
    NSUInteger num = heap[size];
    size--;
    return num;
}

- (void)changePriority:(NSUInteger)idx {
    [self reorderUpwards:invHeap[idx]];
}

- (void)swap:(NSUInteger)a with:(NSUInteger)b {
    // TODO: use NSMutableArray exchangeObjectAtIndex ?
    NSUInteger tempA = heap[a];
    NSUInteger tempB = heap[b];
    heap[a] = tempB;
    heap[b] = tempA;
    // change the handles too
    invHeap[tempA] = a;
    invHeap[tempB] = b;
}

// Convenience method to get the key at the position given by the given heap index.
// i.e., returns keys[heap[idx]]
- (double)keyWithHeapIndex:(NSUInteger)heapIndex {
    return keys[heap[heapIndex]];
}

- (void)reorderUpwards:(NSUInteger)nd {
    // move up the heap swapping the elements until the heap is ordered
    while (nd > 1 && 
           [self keyWithHeapIndex:(nd / 2)] > [self keyWithHeapIndex:nd]) {
        [self swap:(nd / 2) with:nd];
        nd /= 2;
    }
}

- (void)reorderDownwards:(NSUInteger)nd heapSize:(NSUInteger)heapSize {
    // move down the heap from node nd swapping the elements until
    // the heap is reordered
    while (2 * nd <= heapSize) {
        NSUInteger child = 2 * nd;
        
        // set child to smaller of nd's two children
        if (child < heapSize &&
            [self keyWithHeapIndex:child] > [self keyWithHeapIndex:child + 1]) {
            ++child;
        }
        
        //if this nd is larger than its child, swap
        if ([self keyWithHeapIndex:nd] > [self keyWithHeapIndex:child]) {
            [self swap:child with:nd];
            //move the current node down the tree
            nd = child;
        } else {
            break;
        }
    }
}

@end
