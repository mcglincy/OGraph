//
//  GraphNode.h
//  GraphLib
//
//  Created by Matthew McGlincy on 5/2/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphNode : NSObject <NSCoding> {
    NSUInteger index;
}

@property (nonatomic) NSUInteger index;

- (id)initWithIndex:(NSUInteger)anIndex;

@end
