//
//  OOAppDelegate.h
//  BreakpadTest
//
//  Created by Edward Rudd on 5/24/13.
//  Copyright (c) 2013 OutOfOrder.cc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Breakpad/Breakpad.h>

@interface OOAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *_window;
    BreakpadRef breakpad;
    IBOutlet NSTextField *_fileLog;
    IBOutlet NSTextField *_breakpadURL;
    IBOutlet NSTextField *_breakpadEnabledLabel;
}

@property (assign) IBOutlet NSWindow *window;
- (IBAction)testCrash:(id)sender;
- (IBAction)chooseLogFile:(id)sender;

@end
