//
//  DesktopWindow.m
//  Desktopify
//
//  Created by Andrew Mellen on 2/25/16.
//  Copyright © 2016 theawesomecoder61. All rights reserved.
//

#import "DesktopWindow.h"

@implementation DesktopWindow

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)windowStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)deferCreation {
   self = [super initWithContentRect:contentRect styleMask:windowStyle backing:bufferingType defer:deferCreation];
   if(self) {
      [self setLevel:kCGDesktopWindowLevel-1]; // kCGDesktopIconWindowLevel for showing over desktop icons
      [self setCollectionBehavior:(NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorStationary | NSWindowCollectionBehaviorIgnoresCycle)];
   }
   return self;
}

- (BOOL)canBecomeMainWindow {
   return NO;
}

- (BOOL)canBecomeKeyWindow {
   return NO;
}

@end