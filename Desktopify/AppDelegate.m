//
//  AppDelegate.m
//  Desktopify
//
//  Created by Andrew Mellen on 2/25/16.
//  Copyright © 2016 theawesomecoder61. All rights reserved.
//

#import "AppDelegate.h"
#import <WebKit/WebKit.h>

@interface AppDelegate () <WebFrameLoadDelegate, WebEditingDelegate, WebUIDelegate> {
   NSStatusItem *statusItem;
   NSUserDefaults *ud;
   WebPreferences *prefs;
}

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet WebView *wv;
@property (weak) IBOutlet NSMenu *mbMenu;

@property (weak) IBOutlet NSMenuItem *ppvMI;

@property (weak) IBOutlet NSMenuItem *opacityMI;
@property (weak) IBOutlet NSView *opacityView;
@property (weak) IBOutlet NSSlider *opacitySlider;

@property (weak) IBOutlet NSMenuItem *controlsMI;
@property (weak) IBOutlet NSView *controlsView;
@property (weak) IBOutlet NSButton *leftBtn;
@property (weak) IBOutlet NSButton *refreshBtn;
@property (weak) IBOutlet NSButton *rightBtn;


@property (weak) IBOutlet NSMenuItem *ejsMI;
@property (weak) IBOutlet NSMenuItem *ejaMI;
@property (weak) IBOutlet NSMenuItem *epMI;
@property (weak) IBOutlet NSMenuItem *eaiMI;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
   ud = [NSUserDefaults standardUserDefaults];
   prefs = [WebPreferences standardPreferences];
   
   // menu bar
   statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
   [statusItem setImage:[NSImage imageNamed:@"mi"]];
   [statusItem.image setTemplate:YES];
   [statusItem setMenu:self.mbMenu];
   
   // window
   [self.window setFrame:[[NSScreen mainScreen] frame] display:YES];
   
   // webview
   [self.wv setFrameLoadDelegate:self];
   [self.wv setEditingDelegate:self];
   [self.wv setUIDelegate:self];
   [self.wv setDrawsBackground:NO];
   [self.wv setCustomUserAgent:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/601.4.4 (KHTML, like Gecko) Version/9.0.3 Safari/601.4.4"];
   [[self.wv mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
   [prefs setPrivateBrowsingEnabled:YES];
   
   // load userdefaults
   [self.ejsMI setState:[ud boolForKey:@"JS"]];
   [self.ejaMI setState:[ud boolForKey:@"Java"]];
   [self.epMI setState:[ud boolForKey:@"Plugins"]];
   [self.eaiMI setState:[ud boolForKey:@"AutoImg"]];
   [prefs setJavaScriptEnabled:[ud boolForKey:@"JS"]];
   [prefs setJavaEnabled:[ud boolForKey:@"Java"]];
   [prefs setPlugInsEnabled:[ud boolForKey:@"Plugins"]];
   [prefs setLoadsImagesAutomatically:[ud boolForKey:@"AutoImg"]];
   [self.wv setPreferences:prefs];
   
   // menu items
   [self.controlsMI setView:self.controlsView];
   [self.opacityMI setView:self.opacityView];
   [self.leftBtn.image setTemplate:YES];
   [self.refreshBtn.image setTemplate:YES];
   [self.rightBtn.image setTemplate:YES];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
}

//
// WEBVIEW
//
- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame {
   [self.leftBtn setEnabled:[self.wv canGoBack]];
   [self.rightBtn setEnabled:[self.wv canGoForward]];
   if([[self.wv mainFrameURL] containsString:@"youtube."]) {
      [self.ppvMI setHidden:NO];
      [self.wv stringByEvaluatingJavaScriptFromString:@"document.querySelectorAll('.video-ads')[0].style.display='none';"];
      [self.ppvMI setTitle:@"Play/Pause YouTube video"];
   } else if([[self.wv mainFrameURL] containsString:@"vimeo."]) {
      [self.ppvMI setHidden:NO];
      [self.ppvMI setTitle:@"Play/Pause Vimeo video"];
   } else {
      [self.ppvMI setHidden:YES];
   }
}
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
}
- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element
    defaultMenuItems:(NSArray *)defaultMenuItems {
   return nil;
}
- (BOOL)webView:(WebView *)webView shouldChangeSelectedDOMRange:(DOMRange *)currentRange toDOMRange:(DOMRange *)proposedRange affinity:(NSSelectionAffinity)selectionAffinity stillSelecting:(BOOL)flag {
   return NO;
}
- (NSUInteger)webView:(WebView *)sender dragSourceActionMaskForPoint:(NSPoint)point {
   return WebDragSourceActionNone;
}
- (NSUInteger)webView:(WebView *)sender dragDestinationActionMaskForDraggingInfo:(id <NSDraggingInfo>)draggingInfo {
   return WebDragDestinationActionNone;
}

//
// MENU
//
- (IBAction)enableApp:(id)sender {
   [self.wv setShouldCloseWithWindow:YES];
   if([sender state] == 0) {
      [sender setState:1];
      [self.window orderFront:self];
   } else {
      [sender setState:0];
      [self.window orderOut:self];
   }
}
- (IBAction)leftBtn:(id)sender {
   [self.wv goBack];
}
- (IBAction)refreshBtn:(id)sender {
   [self.wv reload:self];
}
- (IBAction)rightBtn:(id)sender {
   [self.wv goForward];
}
- (IBAction)openURLIn:(id)sender {
   NSAlert *a = [[NSAlert alloc] init];
   [a setMessageText:@"Load a URL into Desktopify"];
   [a setInformativeText:@"If you do not want to change the current URL, click Cancel."];
   [a addButtonWithTitle:@"OK"];
   [a addButtonWithTitle:@"Cancel"];
   NSTextField *i = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 230, 24)];
   [i setStringValue:@"http://"];
   [i setUsesSingleLineMode:YES];
   [a setAccessoryView:i];
   NSInteger b = [a runModal];
   if(b == NSAlertFirstButtonReturn) {
      [i validateEditing];
      [[self.wv mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[i stringValue]]]];
   }
}
- (IBAction)updateOpacity:(id)sender {
   [self.window setAlphaValue:[self.opacitySlider doubleValue]];
}
- (IBAction)ppYT:(id)sender {
   if([[self.wv mainFrameURL] containsString:@"youtube."]) {
      [self.wv stringByEvaluatingJavaScriptFromString:@"if(!document.querySelectorAll('.video-stream')[0].paused) { document.querySelectorAll('.video-stream')[0].pause(); } else { document.querySelectorAll('.video-stream')[0].play(); }"];
   } else if([[self.wv mainFrameURL] containsString:@"vimeo."]) {
      [self.wv stringByEvaluatingJavaScriptFromString:@"if(!document.querySelector('.telecine:first-child video').paused) { document.querySelector('.telecine:first-child video').pause(); } else { document.querySelector('.telecine:first-child video').play(); }"];
   }
}
- (IBAction)enableJS:(id)sender {
   if([sender state] == 0) {
      [sender setState:1];
   } else {
      [sender setState:0];
   }
   [prefs setJavaScriptEnabled:[sender state]];
   [self.wv setPreferences:prefs];
   [ud setBool:[sender state] forKey:@"JS"];
   [ud synchronize];
}
- (IBAction)enableJava:(id)sender {
   if([sender state] == 0) {
      [sender setState:1];
   } else {
      [sender setState:0];
   }
   [prefs setJavaEnabled:[sender state]];
   [self.wv setPreferences:prefs];
   [ud setBool:[sender state] forKey:@"Java"];
   [ud synchronize];
}
- (IBAction)enablePlugins:(id)sender {
   if([sender state] == 0) {
      [sender setState:1];
   } else {
      [sender setState:0];
   }
   [prefs setPlugInsEnabled:[sender state]];
   [self.wv setPreferences:prefs];
   [ud setBool:[sender state] forKey:@"Plugins"];
   [ud synchronize];
}
- (IBAction)enableAutoImg:(id)sender {
   if([sender state] == 0) {
      [sender setState:1];
   } else {
      [sender setState:0];
   }
   [prefs setLoadsImagesAutomatically:[sender state]];
   [self.wv setPreferences:prefs];
   [ud setBool:[sender state] forKey:@"AutoImg"];
   [ud synchronize];
}
- (IBAction)aboutApp:(id)sender {
   [NSApp orderFrontStandardAboutPanel:nil];
}
- (IBAction)quitApp:(id)sender {
   [NSApp terminate:self];
}

@end