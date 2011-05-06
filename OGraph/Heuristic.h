//
//  Heuristic.h
//  GraphLib
//
//  Created by Matthew McGlincy on 5/3/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GraphNode.h"

@protocol Heuristic <NSObject>
- (double)calculateWithNodeA:(GraphNode *)a b:(GraphNode *)b;
@end
