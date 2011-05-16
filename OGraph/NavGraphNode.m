//
//  NavGraphNode.m
//  GraphLib
//
//  Created by Matthew McGlincy on 5/3/11.
//  Copyright 2011 n/a. All rights reserved.
//

// UIKit is needed for NSValue CGPoint additions
#import <UIKit/UIKit.h>
#import "NavGraphNode.h"

@implementation NavGraphNode

@synthesize position;

- (id)initWithIndex:(NSUInteger)anIndex position:(CGPoint)aPosition {
    self = [super initWithIndex:anIndex];
    if (self) {
        position = aPosition;
    }
    return self;
}

- (id)initWithIndex:(NSUInteger)anIndex x:(CGFloat)x y:(CGFloat)y {
    return [self initWithIndex:anIndex position:CGPointMake(x, y)];
}

# pragma mark NSCoding methods

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        index = (NSUInteger)[coder decodeIntegerForKey:@"NGNIndex"];
        NSValue *val = (NSValue *)[coder decodeObjectForKey:@"NGNPosition"];
        position = [val CGPointValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:(NSInteger)index forKey:@"NGNIndex"];
    [coder encodeObject:[NSValue valueWithCGPoint:position] forKey:@"NGNPosition"];
}

@end
