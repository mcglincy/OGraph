//
//  NavGraphNode.h
//  GraphLib
//
//  Created by Matthew McGlincy on 5/3/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "GraphNode.h"

@interface NavGraphNode : GraphNode <NSCoding> {
    CGPoint position;
}

@property (nonatomic) CGPoint position;

- (id)initWithIndex:(NSUInteger)anIndex position:(CGPoint)aPosition;
- (id)initWithIndex:(NSUInteger)anIndex x:(CGFloat)x y:(CGFloat)y;

@end
