//
//  GameScene.h
//  NitroSyndicate
//

//  Copyright (c) 2015 Anatoliy Adamitskiy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKParralaxScrolling.h"
#import "AVFoundation/AVFoundation.h"

@interface GameScene : SKScene <SKPhysicsContactDelegate>

@property (nonatomic) NSTimeInterval lastUpdateTime;
@property (nonatomic) NSTimeInterval lastSpawnTime;
@property SKAction* soundAction;
@property SKAction* explosionAction;
@property SKParralaxScrolling* myParrallax;
@property SKSpriteNode* mainCar;
@property SKLabelNode *scoreLabel;
@property SKSpriteNode* scoreboard;
@property SKSpriteNode* pauseButton;
@property SKSpriteNode* powerupButton;
@property SKSpriteNode* powerup;
@property SKSpriteNode* pauseMenu;
@property SKSpriteNode* pauseMenuNoButton;
@property SKSpriteNode* pauseMenuYesButton;
@property SKSpriteNode* powerupTimeLeftBoard;
@property SKLabelNode* powerActivated;
@property SKLabelNode* powerupLeft;
@property SKSpriteNode* titleBanner;
@property SKSpriteNode* playButton;
@property SKSpriteNode* rankingsButton;
@property SKSpriteNode* creditsButton;
@property SKSpriteNode* creditsScreen;
@property SKSpriteNode* closeButton;
@property SKSpriteNode* instructions;
@property AVAudioPlayer* audioPlayer;
@property int carType;
@property int score;
@property int countdown;
@property int numPowerups;
@property BOOL isPaused;
@property BOOL isPlaying;
@property BOOL onInstructions;

@end
