#import "StatusItemView.h"
#include <stdlib.h>

@implementation StatusItemView

@synthesize statusItem = _statusItem;
@synthesize image = _image;
@synthesize action = _action;
@synthesize target = _target;

#pragma mark -

- (id)initWithStatusItem:(NSStatusItem *)statusItem
{
    CGFloat itemWidth = [statusItem length];
    CGFloat itemHeight = [[NSStatusBar systemStatusBar] thickness];
    NSRect itemRect = NSMakeRect(0.0, 0.0, itemWidth, itemHeight);
    self = [super initWithFrame:itemRect];
    
    if (self != nil) {
        _statusItem = statusItem;
        _statusItem.view = self;
    }

    NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(pollService)
                                                   object:nil];
    [myThread start];  // Actually create the thread

    return self;
}

- (void)pollService
{
    while (true) {
        [self updateLevel];
        [NSThread sleepForTimeInterval:30];
    }
}

#pragma mark -

- (void)updateLevel
{
    [self setLevel:4];
}

- (void)drawRect:(NSRect)dirtyRect
{
	[self.statusItem drawStatusBarBackgroundInRect:dirtyRect withHighlight:false];
    
    NSImage *icon = self.image;
    NSSize iconSize = [icon size];
    NSRect bounds = self.bounds;
    CGFloat iconX = roundf((NSWidth(bounds) - iconSize.width) / 2);
    CGFloat iconY = roundf((NSHeight(bounds) - iconSize.height) / 2);
    NSPoint iconPoint = NSMakePoint(iconX, iconY);
    [icon compositeToPoint:iconPoint operation:NSCompositeSourceOver];
}

#pragma mark -
#pragma mark Mouse tracking

- (void)mouseDown:(NSEvent *)theEvent
{
    [NSApp sendAction:self.action to:self.target from:self];
}

#pragma mark -
#pragma mark Accessors

#pragma mark -
-(void)setLevel:(int)level
{
    if (level >= 1 && level <= 5) {
        NSString *imageName = [NSString stringWithFormat:@"devcon%d", level];
        NSImage *newImage = [NSImage imageNamed:imageName];
        if (_image != newImage) {
            _image = newImage;
            [self setNeedsDisplay:YES];
        }
    }
}


#pragma mark -

- (NSRect)globalRect
{
    NSRect frame = [self frame];
    frame.origin = [self.window convertBaseToScreen:frame.origin];
    return frame;
}

@end
