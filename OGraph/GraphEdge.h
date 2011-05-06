//
//  GraphEdge.h
//  GraphLib
//
//  Created by Matthew McGlincy on 5/2/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphEdge : NSObject {
    NSUInteger from;
    NSUInteger to;
    double cost;
}

@property (nonatomic) NSUInteger from;
@property (nonatomic) NSUInteger to;
@property (nonatomic) double cost;

- (id)initWithFrom:(NSUInteger)aFrom to:(NSUInteger)aTo cost:(double)aCost;
- (id)initWithFrom:(NSUInteger)aFrom to:(NSUInteger)aTo;

@end
