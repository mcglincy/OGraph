//
//  Heuristic.h
//  GraphLib
//
//  Created by Matthew McGlincy on 5/3/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SparseGraph.h"

@protocol Heuristic <NSObject>
- (double)calculateWithGraph:(SparseGraph *)graph node1Index:(NSUInteger)node1Index node2Index:(NSUInteger)node2Index;
@end
