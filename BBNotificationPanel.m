#import "BBNotificationPanel.h"

@implementation BBNotificationPanel
- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)windowStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)deferCreation
{ 
  id panel;
  
  panel = [super initWithContentRect:contentRect
                           styleMask:0x80
                             backing:0x02
                               defer:0];
  
  [panel setBackgroundColor:[NSColor clearColor]];
  [panel setAlphaValue:1.0];
  [panel setOpaque:NO];
  [panel setHidesOnDeactivate:NO];
  [panel setLevel:CGWindowLevelForKey(kCGPopUpMenuWindowLevelKey)];
  [panel setMovableByWindowBackground:YES];
  [panel setShowsResizeIndicator:YES];
  
  return panel;
}
- (void)show
{
  id delegate = [self delegate];
  
  _fading = FALSE;
  if ([delegate respondsToSelector:@selector(windowWillShow:)])
  {
    [delegate performSelector:@selector(windowWillShow:) withObject:self];
  }
  [self orderBack:nil];
  [self setAlphaValue:1.0];
}

- (void)_performFade
{
  id pool;
  float val;
  id delegate;
  
  pool = [[NSAutoreleasePool alloc] init];
  do {
    val = [self alphaValue];
    val-=0.05;
  
    if(val <= 0.01)
    {
      _fading = NO;
      val = 0.0;
    }
  
    [self setAlphaValue:val];
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
  } while(_fading == YES);
  
  if(val > 0){
    delegate = [self delegate];
    if ([delegate respondsToSelector:@selector(windowWillFade:)])
      [delegate performSelector:@selector(windowWillFade:) withObject:self];
  }
  
  [self orderOut:self];
  [pool release];
}

- (void)becomeKeyWindow
{
  [super becomeKeyWindow];
}

- (void)becomeMainWindow
{
  [super becomeMainWindow];
}

- (void)_faded
{
  [self orderOut:nil];
}

- (void)fade
{
  _fading = 1;
  
  [NSThread detachNewThreadSelector:@selector(_performFade) toTarget:self withObject:nil];
}

- (BOOL)isOpaque
{
  return FALSE;
}
    
- (BOOL)acceptsFirstMouse:(id)anArgument
{
  return TRUE;
}

- (BOOL)canBecomeKeyWindow
{
 return FALSE;
}
- (BOOL)canBecomeMainWindow
{
 return FALSE;
}

- (void)display
{
  [super display];
  [self invalidateShadow];
}

- (void)mouseExited:(id)anArgument
{
  [[self delegate] mouseExited:anArgument];
}

- (void)mouseEntered:(id)anArgument
{
  [[self delegate] mouseEntered:anArgument];
}

@end
