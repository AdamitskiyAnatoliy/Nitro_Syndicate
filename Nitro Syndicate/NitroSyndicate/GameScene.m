//
//  GameScene.m
//  NitroSyndicate
//
//  Created by Anatoliy Adamitskiy on 5/14/15.
//  Copyright (c) 2015 Anatoliy Adamitskiy. All rights reserved.
//

#import "GameScene.h"

static const uint32_t mainCarCategory = 0x1 << 0;
static const uint32_t spawnCarCategory = 0x1 << 1;
static NSString* mainCarCategoryName = @"mainCar";
static NSString* spawnCarCategoryName = @"spawnCar";

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.score = 0;
    self.carType = 1;
    self.numPowerups = 3;
    self.countdown = 30;
    self.isPaused = false;
    self.isPlaying = false;
    self.onInstructions = false;
    
    NSString* path = [NSString stringWithFormat: @"%@/backgroundMusic.mp3", [[NSBundle mainBundle]resourcePath]];
    
    NSURL* soundURL = [NSURL fileURLWithPath:path];
    NSError* error = nil;
    
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundURL error:&error];
    self.audioPlayer.numberOfLoops = -1;
    
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];

    
    NSArray* imageNames = @[@"road_land"];
    self.myParrallax = [[SKParralaxScrolling alloc] initWithBackgrounds:imageNames size:self.frame.size fastestSpeed:10.0f speedDecrease:1.5f];
    
    [self addChild: self.myParrallax];
    
    self.scoreboard = [[SKSpriteNode alloc] initWithImageNamed:@"scoreboard"];
    self.scoreboard.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 133);
    self.scoreboard.zPosition = 1;
    self.scoreboard.xScale = 1.5;
    self.scoreboard.yScale = 1.5;
    
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Palatino"];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.score];
    self.scoreLabel.fontSize = 30;
    self.scoreLabel.zPosition = 2;
    self.scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 145);
    
    self.mainCar = [[SKSpriteNode alloc]initWithImageNamed:@"mainCar"];
    self.mainCar.position = CGPointMake(CGRectGetMaxX(self.frame) - 100, CGRectGetMidY(self.frame));
    self.mainCar.zPosition = 1;
    self.mainCar.xScale = 1.15;
    self.mainCar.yScale = 1.15;
    self.mainCar.name = mainCarCategoryName;
    
    self.mainCar.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.mainCar.frame.size];
    self.mainCar.physicsBody.friction = 0.0f;
    self.mainCar.physicsBody.affectedByGravity = NO;
    self.mainCar.physicsBody.restitution = 1.0f;
    self.mainCar.physicsBody.linearDamping = 0.0f;
    self.mainCar.physicsBody.categoryBitMask = mainCarCategory;
    self.mainCar.physicsBody.contactTestBitMask = spawnCarCategory;
    self.mainCar.physicsBody.collisionBitMask = 0;
    [self.mainCar.physicsBody applyImpulse:CGVectorMake(10.0f, -10.0f)];
    
    self.pauseButton = [[SKSpriteNode alloc]initWithImageNamed:@"pauseButton"];
    self.pauseButton.position = CGPointMake(CGRectGetMinX(self.frame) + 42, CGRectGetMaxY(self.frame) - 126);
    self.pauseButton.zPosition = 1;
    self.pauseButton.xScale = 1.5;
    self.pauseButton.yScale = 1.5;
    
    self.powerupButton = [[SKSpriteNode alloc]initWithImageNamed:@"powerupButton"];
    self.powerupButton.position = CGPointMake(CGRectGetMaxX(self.frame) - 68, CGRectGetMaxY(self.frame) - 128);
    self.powerupButton.zPosition = 1;
    self.powerupButton.xScale = 1.5;
    self.powerupButton.yScale = 1.5;
    
    self.powerupLeft = [[SKLabelNode alloc] initWithFontNamed:@"Palatino"];
    self.powerupLeft.text = [NSString stringWithFormat:@"%d", self.numPowerups];
    self.powerupLeft.fontSize = 30;
    self.powerupLeft.zPosition = 2;
    self.powerupLeft.position = CGPointMake(CGRectGetMaxX(self.frame) - 51, CGRectGetMaxY(self.frame) - 140);
    
    self.powerActivated = [[SKLabelNode alloc] initWithFontNamed:@"Palatino"];
    self.powerActivated.text = [NSString stringWithFormat:@"30"];
    self.powerActivated.fontSize = 50;
    self.powerActivated.zPosition = 2;
    self.powerActivated.position = CGPointMake(CGRectGetMinX(self.frame) + 42, CGRectGetMinY(self.frame) + 128);
    
    self.powerupTimeLeftBoard = [[SKSpriteNode alloc]initWithImageNamed:@"powerupTimeLeftBoard"];
    self.powerupTimeLeftBoard.position = CGPointMake(CGRectGetMinX(self.frame) + 42, CGRectGetMinY(self.frame) + 138);
    self.powerupTimeLeftBoard.zPosition = 1;
    self.powerupTimeLeftBoard.xScale = 1.5;
    self.powerupTimeLeftBoard.yScale = 1.5;
    
    self.titleBanner = [[SKSpriteNode alloc] initWithImageNamed:@"titleBanner"];
    self.titleBanner.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 170);
    self.titleBanner.zPosition = 1;
    self.titleBanner.xScale = 0.20;
    self.titleBanner.yScale = 0.20;
    
    self.playButton = [[SKSpriteNode alloc] initWithImageNamed:@"playButton"];
    self.playButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 15);
    self.playButton.zPosition = 1;
    self.playButton.xScale = 2.5;
    self.playButton.yScale = 2.5;
    
    self.rankingsButton = [[SKSpriteNode alloc] initWithImageNamed:@"rankingsButton"];
    self.rankingsButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 115);
    self.rankingsButton.zPosition = 1;
    self.rankingsButton.xScale = 2.5;
    self.rankingsButton.yScale = 2.5;
    
    self.creditsButton = [[SKSpriteNode alloc] initWithImageNamed:@"creditsButton"];
    self.creditsButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 215);
    self.creditsButton.zPosition = 1;
    self.creditsButton.xScale = 2.5;
    self.creditsButton.yScale = 2.5;
    
    self.creditsScreen = [[SKSpriteNode alloc]initWithImageNamed:@"creditsScreen"];
    self.creditsScreen.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 20);
    self.creditsScreen.zPosition = 3;
    
    self.closeButton = [[SKSpriteNode alloc] initWithImageNamed:@"closeButton"];
    self.closeButton.position = CGPointMake(CGRectGetMaxX(self.frame) - 35, CGRectGetMinY(self.frame) + 125);
    self.closeButton.zPosition = 4;
    
    SKPhysicsBody* border = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody = border;
    
    [self addChild:self.mainCar];
    [self addChild:self.pauseButton];
    [self addChild:self.powerupButton];
    [self addChild:self.powerupTimeLeftBoard];
    [self addChild:self.powerupLeft];
    [self addChild:self.scoreboard];
    [self addChild:self.scoreLabel];
    [self addChild:self.titleBanner];
    [self addChild:self.playButton];
    [self addChild:self.rankingsButton];
    [self addChild:self.creditsButton];
    [self addChild:self.creditsScreen];
    [self addChild:self.closeButton];
    
    self.pauseButton.hidden = true;
    self.scoreboard.hidden = true;
    self.scoreLabel.hidden = true;
    self.powerupLeft.hidden = true;
    self.powerupButton.hidden = true;
    self.mainCar.hidden = true;
    self.powerupTimeLeftBoard.hidden = true;
    self.closeButton.hidden = true;
    self.creditsScreen.hidden = true;
    
    [self runAction:[SKAction playSoundFileNamed:@"tires_squealing.mp3" waitForCompletion:false]];
    
    NSArray* textures = @[[SKTexture textureWithImageNamed:@"explosion1"],
                          [SKTexture textureWithImageNamed:@"explosion2"],
                          [SKTexture textureWithImageNamed:@"explosion3"],
                          [SKTexture textureWithImageNamed:@"explosion4"],
                          [SKTexture textureWithImageNamed:@"explosion5"],
                          [SKTexture textureWithImageNamed:@"explosion6"],
                          [SKTexture textureWithImageNamed:@"explosion7"],
                          [SKTexture textureWithImageNamed:@"explosion8"],
                          [SKTexture textureWithImageNamed:@"explosion9"],
                          [SKTexture textureWithImageNamed:@"explosion10"]];
    self.explosionAction = [SKAction animateWithTextures:textures timePerFrame:0.01f];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint scenePosition = [touch locationInNode:self];
    SKNode* checkNode = [self nodeAtPoint:scenePosition];
    if (checkNode && [checkNode.name hasPrefix:@"mainCar"]) {
        self.mainCar = (SKSpriteNode*)checkNode;
    }
    
    for (touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        if ([self.pauseButton containsPoint:location]) {
            NSLog(@"Pause Button Touched");
            
            self.isPaused = true;
            self.pauseButton.hidden = true;
            self.powerupButton.hidden = true;
            self.powerupLeft.hidden = true;
            self.scoreboard.hidden = true;
            self.scoreLabel.hidden = true;
            self.powerActivated.hidden = true;
            self.powerupTimeLeftBoard.hidden = true;
            
            self.pauseMenu = [[SKSpriteNode alloc]initWithImageNamed:@"pauseMenu"];
            self.pauseMenu.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 50);
            self.pauseMenu.zPosition = 3;
            self.pauseMenu.xScale = 2.5;
            self.pauseMenu.yScale = 2.5;
            
            self.pauseMenuYesButton = [[SKSpriteNode alloc]initWithImageNamed:@"pauseMenuButtonYes"];
            self.pauseMenuYesButton.position = CGPointMake(CGRectGetMidX(self.frame) + 140, CGRectGetMidY(self.frame) - 65);
            self.pauseMenuYesButton.zPosition = 4;
            self.pauseMenuYesButton.xScale = 2.5;
            self.pauseMenuYesButton.yScale = 2.5;
            
            self.pauseMenuNoButton = [[SKSpriteNode alloc]initWithImageNamed:@"pauseMenuButtonNo"];
            self.pauseMenuNoButton.position = CGPointMake(CGRectGetMidX(self.frame) - 140, CGRectGetMidY(self.frame) - 65);
            self.pauseMenuNoButton.zPosition = 4;
            self.pauseMenuNoButton.xScale = 2.5;
            self.pauseMenuNoButton.yScale = 2.5;
            
            [self addChild:self.pauseMenu];
            [self addChild:self.pauseMenuYesButton];
            [self addChild:self.pauseMenuNoButton];
        
        }
        
        if ([self.pauseMenuYesButton containsPoint:location]) {
            
            NSLog(@"Resume Game");
            [self.pauseMenu removeFromParent];
            [self.pauseMenuYesButton removeFromParent];
            [self.pauseMenuNoButton removeFromParent];
            self.pauseButton.hidden = false;
            self.powerupButton.hidden = false;
            self.powerupLeft.hidden = false;
            self.scoreboard.hidden = false;
            self.scoreLabel.hidden = false;
            
            if (self.countdown < 30) {
                self.powerActivated.hidden = false;
                self.powerupTimeLeftBoard.hidden = false;
            } else if (self.countdown == 0 || self.countdown == 30) {
                self.powerActivated.hidden = true;
                self.powerupTimeLeftBoard.hidden = true;
            }
            self.isPaused = false;
            self.scene.view.paused = NO;
        }
        
        if ([self.pauseMenuNoButton containsPoint:location]) {
            
            NSLog(@"No button pressed");
            self.isPaused = false;
            self.onInstructions = true;
            self.scene.view.paused = NO;
            self.isPlaying = false;
            self.pauseMenu.hidden = true;
            self.pauseMenuNoButton.hidden = true;
            self.pauseMenuYesButton.hidden = true;
            self.mainCar.hidden = true;
            
        }
        
        if ([self.powerupButton containsPoint:location]) {
            
            [self.powerActivated removeFromParent];
            
            if (self.numPowerups > 0) {
            
                self.powerActivated.text = [NSString stringWithFormat:@"30"];
                self.powerupTimeLeftBoard.hidden = false;
                self.powerActivated.hidden = false;
                self.countdown = 30;
                self.numPowerups -= 1;
                self.powerupLeft.text = [NSString stringWithFormat:@"%d", self.numPowerups];
                
                [self addChild:self.powerActivated];
                
                [self runAction:[SKAction playSoundFileNamed:@"powerup.mp3" waitForCompletion:false]];
                
                SKAction* rotateText = [SKAction rotateByAngle:18.8495559 duration:0.75];
                SKAction* scaleDown = [SKAction scaleTo:0.6 duration:0.75];
                SKAction *scalePower = [SKAction group:@[rotateText, scaleDown]];
                
                SKAction* rotate = [SKAction rotateByAngle:18.8495559 duration:0.75];
                SKAction* scale = [SKAction scaleTo:0.6 duration:0.75];
                SKAction *rotateAndScale = [SKAction group:@[rotate, scale]];
                [self.mainCar runAction:rotateAndScale];
                [self.powerActivated runAction:scalePower];
                
                [self performSelector:@selector(powerupRun) withObject:nil afterDelay:30.0];
                
                [self performSelector:@selector(updatePowerupLabel) withObject:nil afterDelay:1.0];
                    
            } else if (self.numPowerups == 0) {
                // Play buzzer noise to indicate no powerups
                [self runAction:[SKAction playSoundFileNamed:@"buzzer.mp3" waitForCompletion:false]];
            }
            
        }
        
        if ([self.playButton containsPoint:location]) {
            
            self.onInstructions = true;
            self.isPlaying = true;
            self.mainCar.hidden = false;
            self.mainCar.position = CGPointMake(CGRectGetMaxX(self.frame) - 100, CGRectGetMidY(self.frame));
            
            SKAction* move = [SKAction moveTo:CGPointMake(CGRectGetMaxX(self.frame) + 450, CGRectGetMidY(self.frame) + 170) duration:1.0];
            SKAction* move2 = [SKAction moveTo:CGPointMake(CGRectGetMinX(self.frame) - 450, self.frame.origin.y) duration:1.0];
            [self.titleBanner runAction:move];
            [self.playButton runAction:move2];
            [self.rankingsButton runAction:move2];
            [self.creditsButton runAction:move2 completion:^{
                
                SKAction* scale = [SKAction scaleTo:1.15 duration:0.0];
                [self.mainCar runAction:scale];
                
                
                self.instructions = [[SKSpriteNode alloc]initWithImageNamed:@"instructions"];
                self.instructions.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
                self.instructions.xScale = 0.5;
                self.instructions.yScale = 0.5;
                self.instructions.zPosition = 3;
                
                [self addChild:self.instructions];
                
                self.onInstructions = true;
                self.pauseButton.hidden = false;
                self.scoreboard.hidden = false;
                self.scoreLabel.hidden = false;
                self.powerupLeft.hidden = false;
                self.powerupButton.hidden = false;
                self.score = 0;
                self.numPowerups = 3;
                self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.score];
                self.powerupLeft.text = [NSString stringWithFormat:@"%d", self.numPowerups];
                
            }];
            
        }
        
        if ([self.creditsButton containsPoint:location]) {
            self.closeButton.hidden = false;
            self.creditsScreen.hidden = false;
        }
        
        if ([self.closeButton containsPoint:location]) {
            self.closeButton.hidden = true;
            self.creditsScreen.hidden = true;
        }
        
        if ([self.instructions containsPoint:location]) {
            
            self.onInstructions = false;
            self.instructions.hidden = true;
        }
    }
}

-(void)updatePowerupLabel {
    
    if (self.countdown <= 30 && self.countdown > 0) {
        self.powerActivated.text = [NSString stringWithFormat:@"%d", self.countdown];
        self.countdown -= 1;
        [self performSelector:@selector(updatePowerupLabel) withObject:nil afterDelay:1.0];
    } else if (self.countdown == 0) {
        self.powerActivated.text = [NSString stringWithFormat:@"%d", self.countdown];
        self.countdown -= 1;
        [self.powerActivated removeFromParent];
        self.powerupTimeLeftBoard.hidden = true;
    }
}

-(void)powerupRun {
    
    [self runAction:[SKAction playSoundFileNamed:@"powerup.mp3" waitForCompletion:false]];
    SKAction* rotate = [SKAction rotateByAngle:18.8495559 duration:0.75];
    SKAction* scale = [SKAction scaleTo:1.15 duration:0.75];
    SKAction *rotateAndScale = [SKAction group:@[rotate, scale]];
    [self.mainCar runAction:rotateAndScale];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (self.mainCar == nil) return;
    UITouch *touch = [touches anyObject];
    CGPoint scenePosition = [touch locationInNode:self];
    CGPoint lastPosition = [touch previousLocationInNode:self];
    
    CGPoint newLoc = CGPointMake(self.mainCar.position.x + (scenePosition.x - lastPosition.x), self.mainCar.position.y + (scenePosition.y - lastPosition.y));
    
    self.mainCar.position = newLoc;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    if (!self.isPaused) {
        
        self.scene.view.paused = NO;
        
        CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTime;
        self.lastUpdateTime = currentTime;
        
        if (timeSinceLast > 1) {
            timeSinceLast = 1.0f/60.0f;
        }
        
        if (self.isPlaying) {
            if (!self.onInstructions) {
                [self updateWithTimeSinceLast: timeSinceLast];
            }
        } else {
            
            SKAction* move = [SKAction moveTo:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 170) duration:0.75];
            SKAction* move2 = [SKAction moveTo:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 15) duration:0.75];
            SKAction* move3 = [SKAction moveTo:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 115) duration:0.75];
            SKAction* move4 = [SKAction moveTo:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 215) duration:0.75];
            [self.titleBanner runAction:move];
            [self.playButton runAction:move2];
            [self.rankingsButton runAction:move3];
            [self.creditsButton runAction:move4];
            
        }
        
        [self.myParrallax update];
    } else {
        self.scene.view.paused = YES;
    }
}

-(void)updateWithTimeSinceLast:(CFTimeInterval)timeSinceLast {
    self.lastSpawnTime += timeSinceLast;
    if (self.lastSpawnTime > 1) {
        self.lastSpawnTime = 0;
        
        if (self.score < 150) {
            [self spawnCar];
        } else if (self.score >= 150 && self.score < 300) {
            [self spawnCar];
            [self spawnCar];
        } else if (self.score >= 300 && self.score < 500) {
            [self spawnCar];
            [self spawnCar];
            [self spawnCar];
        } else if (self.score >= 500 && self.score < 750) {
            [self spawnCar];
            [self spawnCar];
            [self spawnCar];
            [self spawnCar];
        } else if (self.score >= 750 && self.score < 1000) {
            [self spawnCar];
            [self spawnCar];
            [self spawnCar];
            [self spawnCar];
            [self spawnCar];
        } else if (self.score >= 1000) {
            [self spawnCar];
            [self spawnCar];
            [self spawnCar];
            [self spawnCar];
            [self spawnCar];
            [self spawnCar];
        }

    }
}

-(void) didBeginContact:(SKPhysicsContact *)contact
{
    if (self.isPlaying) {
    
        SKPhysicsBody* firstBody;
        SKPhysicsBody* secondBody;
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
        {
            firstBody = contact.bodyA;
            secondBody = contact.bodyB;
        }
        else
        {
            firstBody = contact.bodyB;
            secondBody = contact.bodyA;
        }
        
        if (firstBody.categoryBitMask == mainCarCategory &&
            secondBody.categoryBitMask == spawnCarCategory)
        {
            SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"explosion1"];
            sprite.position = firstBody.node.position;
            [sprite runAction:self.explosionAction completion:^{
                
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"KABOOM" message:@"Your car has been totaled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                
                sprite.hidden = true;
                self.mainCar.hidden = true;
                self.isPaused = false;
                self.scene.view.paused = NO;
                self.isPlaying = false;
                self.pauseButton.hidden = true;
                self.scoreboard.hidden = true;
                self.scoreLabel.hidden = true;
                self.powerupButton.hidden = true;
                self.powerupLeft.hidden = true;
                
            }];
            [self addChild:sprite];
            
            [self runAction:[SKAction playSoundFileNamed:@"explosion.mp3" waitForCompletion:false]];

            
        }
    }
}


-(void)spawnCar {
    SKSpriteNode *car = nil;
    
    switch (self.carType) {
        case 1:
            car = [SKSpriteNode spriteNodeWithImageNamed:@"car1"];
            break;
        case 2:
            car = [SKSpriteNode spriteNodeWithImageNamed:@"car2"];
            break;
        case 3:
            car = [SKSpriteNode spriteNodeWithImageNamed:@"car3"];
            break;
        case 4:
            car = [SKSpriteNode spriteNodeWithImageNamed:@"car4"];
            break;
        case 5:
            car = [SKSpriteNode spriteNodeWithImageNamed:@"car5"];
            break;
        case 6:
            car = [SKSpriteNode spriteNodeWithImageNamed:@"car6"];
            break;
    }
    
    self.carType++;
    
    if (self.carType < 7) {
    } else {
        self.carType = 1;
    }
    
    car.xScale = 1.25;
    car.yScale = 1.25;
    car.name = spawnCarCategoryName;
    
    car.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:car.frame.size];
    car.physicsBody.restitution = 0.1;
    car.physicsBody.friction = 0.4;
    car.physicsBody.dynamic = NO;
    car.physicsBody.categoryBitMask = spawnCarCategory;
    
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    
    int minY = car.size.height/2 + 100;
    int maxY = self.frame.size.height - minY;
    int rangeY = maxY - minY;
    int carY = (arc4random() % rangeY) + minY;
    
    car.position = CGPointMake(CGRectGetMinX(self.frame) - 75, carY);
    
    [self addChild:car];
    
    int minDuration = 2;
    int maxDuration = 4;
    int rangeD = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeD) + minDuration;
    
    SKAction *actionMove = [SKAction moveTo:CGPointMake(CGRectGetMaxX(self.frame) + 75, carY) duration:actualDuration];
    SKAction *done = [SKAction removeFromParent];
    
    [car runAction:[SKAction sequence:@[actionMove, done]] completion:^{
        self.score++;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.score];
    }];

}


@end
