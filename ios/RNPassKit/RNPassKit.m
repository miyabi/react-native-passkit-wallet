//
//  RNPassKit.m
//  RNPassKit
//
//  Created by Masayuki Iwai on 2018/02/09.
//  Copyright © 2018 Masayuki Iwai. All rights reserved.
//

#import <PassKit/PassKit.h>
#import "RNPassKit.h"

@implementation RNPassKit

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(canAddPasses:(RCTPromiseResolveBlock)resolve
                  rejector:(RCTPromiseRejectBlock)reject) {
  resolve(@([PKAddPassesViewController canAddPasses]));
}

RCT_EXPORT_METHOD(addPass:(NSString *)base64Encoded
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejector:(RCTPromiseRejectBlock)reject) {
  NSData *data = [[NSData alloc] initWithBase64EncodedString:base64Encoded options:NSUTF8StringEncoding];
  NSError *error;
  PKPass *pass = [[PKPass alloc] initWithData:data error:&error];

  if (error) {
    reject(@"", @"Failed to create pass.", error);
    return;
  }

  dispatch_async(dispatch_get_main_queue(), ^{
    UIViewController *rootViewController = [self getPresenterViewController];
    if (rootViewController) {
        PKAddPassesViewController *addPassesViewController = [[PKAddPassesViewController alloc] initWithPass:pass];
        addPassesViewController.delegate = self;
        [rootViewController presentViewController:addPassesViewController animated:YES completion:^{
          // Succeeded
          resolve(nil);
        }];
        return;
    }

    reject(@"", @"Failed to present PKAddPassesViewController.", nil);
  });
}

RCT_EXPORT_METHOD(getUrlFromPass:(NSString *)withPassTypeIdentifier
                  serialNumber:(NSString *)serialNumber
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejector:(RCTPromiseRejectBlock)reject) {
  PKPassLibrary *passLibrary = [[PKPassLibrary alloc] init];
  PKPass *pass = [passLibrary passWithPassTypeIdentifier:withPassTypeIdentifier serialNumber:serialNumber];
  if (pass) {
    resolve(pass.passURL.absoluteString);
  } else {
    reject(@"", @"Pass not found.\nMake sure your app has the Wallet capability.", nil);
  }
}

RCT_EXPORT_METHOD(containsPass:(NSString *)base64Encoded
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejector:(RCTPromiseRejectBlock)reject) {
  NSData *data = [[NSData alloc] initWithBase64EncodedString:base64Encoded options:NSUTF8StringEncoding];
  NSError *error;
  PKPass *pass = [[PKPass alloc] initWithData:data error:&error];

  if (error) {
    reject(@"", @"Failed to create pass.", error);
    return;
  }

  BOOL passLibraryAvailable = [PKPassLibrary isPassLibraryAvailable];
  if (!passLibraryAvailable) {
    resolve(@(NO));
  }

  PKPassLibrary *passLib = [[PKPassLibrary alloc] init];

  resolve(@([passLib containsPass:pass]));
}

- (NSDictionary *)constantsToExport {
  PKAddPassButton *addPassButton = [[PKAddPassButton alloc] initWithAddPassButtonStyle:PKAddPassButtonStyleBlack];
  [addPassButton layoutIfNeeded];

  return @{
           @"AddPassButtonStyle": @{
               @"black": @(PKAddPassButtonStyleBlack),
               @"blackOutline": @(PKAddPassButtonStyleBlackOutline),
               },
           @"AddPassButtonWidth": @(CGRectGetWidth(addPassButton.frame)),
           @"AddPassButtonHeight": @(CGRectGetHeight(addPassButton.frame)),
           };
}

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

#pragma mark - PKAddPassesViewControllerDelegate

- (void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller {
  [controller dismissViewControllerAnimated:YES completion:^{
    [self sendEventWithName:@"addPassesViewControllerDidFinish" body:nil];
  }];
}

#pragma mark - RCTEventEmitter implementation

- (NSArray<NSString *> *)supportedEvents {
  return @[@"addPassesViewControllerDidFinish"];
}

#pragma mark - helper methods

-(UIViewController*)getPresenterViewController {
    UIApplication *sharedApplication = RCTSharedApplication();
    UIViewController *presentingViewcontroller = sharedApplication.delegate.window.rootViewController;
    if(presentingViewcontroller.presentedViewController != nil) {
        presentingViewcontroller = presentingViewcontroller.presentedViewController;
    }
    return presentingViewcontroller;
}

@end
