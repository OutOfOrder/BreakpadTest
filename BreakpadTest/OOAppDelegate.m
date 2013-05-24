//
//  OOAppDelegate.m
//  BreakpadTest
//
//  Created by Edward Rudd on 5/24/13.
//  Copyright (c) 2013 OutOfOrder.cc. All rights reserved.
//

#import "OOAppDelegate.h"

static BreakpadRef InitBreakpad(void) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    BreakpadRef breakpad = 0;
    NSDictionary *plist = [[NSBundle mainBundle] infoDictionary];
    if (plist) {
        breakpad = BreakpadCreate(plist);
    }
    [pool drain];
    return breakpad;
}

@implementation OOAppDelegate

@synthesize window = _window;

- (void)awakeFromNib
{
    breakpad = InitBreakpad();
    if (!breakpad) {
        NSLog(@"Breakpad failed to initialize");
    }
    NSString *url = BreakpadKeyValue(breakpad, @BREAKPAD_URL);
    if (url) {
        [_breakpadURL setStringValue:url];
    } else {
        [_breakpadEnabledLabel setStringValue:@"Breakpad Disabled"];
    }
}

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    BreakpadRelease(breakpad);
    return NSTerminateNow;
}

#pragma mark - Actions

struct TestStruct {
    int num;
};

- (IBAction)testCrash:(id)sender
{
    /* Update the upload url */
    BreakpadSetKeyValue(breakpad, @BREAKPAD_URL, [_breakpadURL stringValue]);
    
    struct TestStruct *s = 0x0;
    NSLog(@"Testing Creash caused by dereference of %p", s);
    /* the next line will crash */
    s->num = 10;
}

- (IBAction)chooseLogFile:(id)sender
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:NO];
    
    if ([openDlg runModalForDirectory:nil file:nil] == NSOKButton)
    {
        NSArray *files = [openDlg filenames];
        for (NSString *filename in files) {
            BreakpadAddLogFile(breakpad, filename);
            NSString *newString = [[_fileLog stringValue] stringByAppendingFormat:@"%@\n", filename];
            [_fileLog setStringValue: newString];
        }
    }
}
@end
