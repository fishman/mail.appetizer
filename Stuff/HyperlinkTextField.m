@implementation HyperlinkTextField

-(id)initWithFrame:(NSRect)theFrame;
{
	self = [super initWithFrame:theFrame];
	{
		[self additionalInitialization];
	}
	return self;
}

- (void)additionalInitialization;
{
	[self setBordered:NO];
	[self setBezeled:NO];
	[self setEditable:NO];
	[self setSelectable:NO];
	[self setEnabled:YES];
	[self setTextColor:[NSColor blueColor]];
	[self sizeToFit];
	NSLog (@"Height %f",NSHeight([self frame]));
	NSRect theFrame = [self frame];
	theFrame.size.height += 10;
	[self setFrameSize:theFrame.size];
	
	
	NSLog (@"Opaque: %d",[self isOpaque]);
}




 -(BOOL)isOpaque { return NO; }

- (void)mouseDown:(NSEvent *)event
{
	BOOL mouseInside = YES;
	
	beingClicked = YES;
	[self setTextColor:[NSColor trackingClickableTextColor]];
	
	while (beingClicked && (event = [[self window] nextEventMatchingMask:(NSLeftMouseUpMask | NSLeftMouseDraggedMask)]))
	{
		NSEventType type = [event type];
		NSPoint location = [event locationInWindow];
		
		location = [self convertPoint:location fromView:nil];
		mouseInside = NSPointInRect(location, [self bounds]);
		
		if (mouseInside)
			[self setTextColor:[NSColor trackingClickableTextColor]];
		else if (beenClicked)
			[self setTextColor:[NSColor visitedClickableTextColor]];
		else
			[self setTextColor:[NSColor basicClickableTextColor]];
		
		if (type == NSLeftMouseUp)
			beingClicked = NO;
	}
	
	if (mouseInside)
	{
		beenClicked = YES;
		[self setTextColor:[NSColor visitedClickableTextColor]];
		[self sendAction:[self action] to:[self target]];
	}
}

- (void)resetTrackingRect
{
	if (trackingRectTag) {
		[self removeTrackingRect:trackingRectTag];
	}
	NSRect trackingRect = NSInsetRect([self frame],1.0f,1.0f);
	trackingRect.origin = NSMakePoint(1.0f,1.0f);
	trackingRectTag = [self addTrackingRect:trackingRect owner:self userData:nil assumeInside:NO];
}

//---------------------------------------------------------- 
// frameChanged:
//---------------------------------------------------------- 
-(void)setFrame:(NSRect)theRect;
{
	[super setFrame:theRect];
	[self resetTrackingRect];
}


//---------------------------------------------------------- 
// viewDidMoveToWindow
//---------------------------------------------------------- 
- (void)viewDidMoveToWindow;
{
	[[self window] setAcceptsMouseMovedEvents:YES];
	[self resetTrackingRect];
	
	[super viewDidMoveToWindow];
}

//---------------------------------------------------------- 
// viewDidMoveToWindow
//---------------------------------------------------------- 
- (void)viewWillMoveToWindow:(NSWindow *)newWindow;
{
	if (!newWindow && trackingRectTag)
		[self removeTrackingRect:trackingRectTag];
	
	[super viewWillMoveToWindow:newWindow];
}

//---------------------------------------------------------- 
// mouseEntered:
//---------------------------------------------------------- 
- (void)mouseEntered:(NSEvent *)theEvent
{
	if (NSPointInRect([[self window] mouseLocationOutsideOfEventStream],[self convertRect:[self bounds] toView:nil]))
		[self setTextColor:[NSColor redColor]];
}

//---------------------------------------------------------- 
// mouseExited:
//---------------------------------------------------------- 
- (void)mouseExited:(NSEvent *)theEvent
{
	if (! [[self textColor] isEqual:[NSColor blueColor]])
		[self setTextColor:[NSColor blueColor]];
}

@end
