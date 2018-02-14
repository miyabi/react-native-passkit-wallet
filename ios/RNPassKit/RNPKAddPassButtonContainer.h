//
//  RNPKAddPassButtonContainer.h
//  RNPassKit
//
//  Created by Masayuki Iwai on 2018/02/13.
//  Copyright © 2018 Masayuki Iwai. All rights reserved.
//

#import <PassKit/PassKit.h>
#import <React/RCTComponent.h>

@interface RNPKAddPassButtonContainer : UIView

- (instancetype)initWithAddPassButtonStyle:(PKAddPassButtonStyle)style;

@property (nonatomic, retain) PKAddPassButton *addPassButton;
@property (nonatomic, assign) PKAddPassButtonStyle addPassButtonStyle;
@property (nonatomic, copy) RCTBubblingEventBlock onPress;

@end
