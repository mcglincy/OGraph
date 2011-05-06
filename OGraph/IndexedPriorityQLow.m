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
- (NSUInteger)keyWithHeapIndex:(NSUInteger)heapIndex;
@end

@implementation IndexedPriorityQLow

@synthesize keys, size;

- (id)initWithKeys:(NSArray *)aKeys maxSize:(NSUInteger)aMaxSize {
    self = [super init];
    if (self) {
        self.keys = aKeys;
        maxSize = aMaxSize;
        size = 0;
        int capacity = maxSize + 1;
        heap = [[NSMutableArray alloc] initWithCapacity:capacity];
        invHeap = [[NSMutableArray alloc] initWithCapacity:capacity];
        NSNumber *zero = [NSNumber numberWithInt:0];
        for (int i = 0; i < capacity; i++) {
            [heap addObject:zero];
            [invHeap addObject:zero];
        }
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (BOOL)empty {
    return (size == 0);
}

// to insert an item into the queue it gets added to the end of the heap
// and then the heap is reordered from the bottom up.
- (void)insert:(NSUInteger)idx {
    NSAssert(size + 1 <= maxSize, @"IndexedPriorityQLow insert: illegal size");
    ++size;
    [heap replaceObjectAtIndex:size withObject:[NSNumber numberWithUnsignedInteger:idx]];
    [invHeap replaceObjectAtIndex:idx withObject:[NSNumber numberWithUnsignedInteger:size]];
    [self reorderUpwards:size];
}

- (NSUInteger)pop {
    [self swap:1 with:size];
    [self reorderDownwards:1 heapSize:(size - 1)];
    NSNumber *num = [heap objectAtIndex:size];
    size--;
    return [num unsignedIntegerValue];
}

- (void)changePriority:(NSUInteger)idx {
    [self reorderUpwards:[[invHeap objectAtIndex:idx] unsignedIntegerValue]];
}

- (void)swap:(NSUInteger)a with:(NSUInteger)b {
    // TODO: use NSMutableArray exchangeObjectAtIndex ?
    NSNumber *tempA = [heap objectAtIndex:a];
    NSNumber *tempB = [heap objectAtIndex:b];
    [heap replaceObjectAtIndex:a withObject:tempB];
    [heap replaceObjectAtIndex:b withObject:tempA];
    // change the handles too
    [invHeap replaceObjectAtIndex:[tempA unsignedIntegerValue] withObject:[NSNumber numberWithUnsignedInteger:a]];
    [invHeap replaceObjectAtIndex:[tempB unsignedIntegerValue] withObject:[NSNumber numberWithUnsignedInteger:b]];    
}

// Convenience method to get the key at the position given by the given heap index.
// i.e., returns keys[heap[idx]]
- (NSUInteger)keyWithHeapIndex:(NSUInteger)heapIndex {
    // handle all the NSArray / NSNumber crud under the hood.
    NSUInteger keyIdx = [[heap objectAtIndex:heapIndex] unsignedIntegerValue];
    return [[keys objectAtIndex:keyIdx] unsignedIntegerValue];
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
