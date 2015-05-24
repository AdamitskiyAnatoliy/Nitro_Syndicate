//
//  SKParralaxScrolling.m
//  
//
//  Created by Anatoliy Adamitskiy on 5/13/15.
//
//

#import "SKParralaxScrolling.h"

static inline CGFloat roundFloatTwoPlace(CGFloat num)
{
    return floorf(num * 100 + 0.5) /100;
}

@interface  SKParralaxScrolling()

@property (strong) NSArray* backgrounds;
@property (strong) NSArray* clonedBackgrounds;
@property (strong) NSArray* speeds;

@property NSUInteger numberOfBackgrounds;
@property CGSize bgSize;

@end

@implementation SKParralaxScrolling

-(id) initWithBackgrounds: (NSArray*) backgrounds
                     size: (CGSize) size
             fastestSpeed: (CGFloat) speed
            speedDecrease: (CGFloat) difference
{
    self = [super init];
    if (self) {
        self.numberOfBackgrounds = 0;
        self.position = CGPointMake(size.width/2, size.height/2);
        self.zPosition = -1;
        
        CGFloat zPosition = 1.0f/backgrounds.count;
        NSUInteger bgNumber = 0;
        NSMutableArray* bgs = [NSMutableArray array];
        NSMutableArray* cbgs = [NSMutableArray array];
        NSMutableArray* speeds = [NSMutableArray array];
        CGFloat currentSpeed = roundFloatTwoPlace(speed);
        
        for (id obj in backgrounds) {
            SKSpriteNode* node = nil;
            if ([obj isKindOfClass: [NSString class]]) {
                node = [[SKSpriteNode alloc]initWithImageNamed: (NSString*)obj];
            } else continue;
        
            node.zPosition = self.zPosition - (zPosition + (zPosition * bgNumber));
            node.position = CGPointMake(0, self.size.height);
            
            SKSpriteNode* clonedNode = [node copy];
            clonedNode.position = CGPointMake(-node.size.width, node.position.y);
            
            [bgs addObject:node];
            [cbgs addObject: clonedNode];
            [speeds addObject: [NSNumber numberWithFloat:currentSpeed]];
                
            currentSpeed = roundFloatTwoPlace(currentSpeed / (1 + difference));
        
            [self addChild:node];
            [self addChild:clonedNode];
            bgNumber ++;
        }// End loop of BG array
        
        if (bgNumber > 0) {
            self.numberOfBackgrounds = bgNumber;
            self.backgrounds = [bgs copy];
            self.clonedBackgrounds = [cbgs copy];
            self.speeds = [speeds copy];
        }
        
    }// End if self check
    return self;
}

-(void) update
{
    for (int i = 0; i < self.numberOfBackgrounds; i++)
    {
        CGFloat speed = [[self.speeds objectAtIndex:i] floatValue];
        SKSpriteNode* background = [self.backgrounds objectAtIndex:i];
        SKSpriteNode* clonedBackground = [self.clonedBackgrounds objectAtIndex:i];
        
        CGFloat newBGX = background.position.x;
        CGFloat newCBGX = clonedBackground.position.x;
        
        newBGX += speed;
        newCBGX += speed;
        
        if (newBGX >= background.size.width) {
            newBGX = newCBGX - clonedBackground.size.width + 0.05f;
        }
        if (newCBGX >= background.size.width) {
            newCBGX = newBGX - background.size.width + 0.05f;
        }
        
        background.position = CGPointMake(newBGX, background.position.y);
        clonedBackground.position = CGPointMake(newCBGX, clonedBackground.position.y);
    }
}

@end
