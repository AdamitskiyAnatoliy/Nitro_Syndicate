//
//  SKParralaxScrolling.h
//  
//
//  Created by Anatoliy Adamitskiy on 5/13/15.
//
//

#import <SpriteKit/SpriteKit.h>

@interface SKParralaxScrolling : SKSpriteNode

-(void) update;
-(id) initWithBackgrounds: (NSArray*) backgrounds
                     size: (CGSize) size
             fastestSpeed: (CGFloat) speed
            speedDecrease: (CGFloat) difference;

@end
