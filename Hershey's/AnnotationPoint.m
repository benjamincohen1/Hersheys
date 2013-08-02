//
//  AnnotationPoint.m
//  Hershey's
//
//  Created by Development Account on 8/2/13.
//  Copyright (c) 2013 Vijay Sridhar. All rights reserved.
//

#import "AnnotationPoint.h"

@implementation AnnotationPoint;
@synthesize coordinate;

- (NSString *)subtitle{
	return nil;
}

- (NSString *)title{
	return nil;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	return self;
}

@end