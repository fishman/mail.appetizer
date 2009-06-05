#import "BBResizeView.h"

@implementation BBResizeView
- (id)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    _resizeIndicator = [NSImage imageNamed:@"resize"];
  }
  return self;
}

- (void)drawRect:(NSRect)frame
{
  [_resizeIndicator compositeToPoint:NSMakePoint(0, 6.0)
                           operation:NSCompositeSourceOver];
}


#if 0
/----------------\        /-------------\
|                |        |             |
|                |        |             |
|                |        |             |
|                |        |             |
|            .   |        |            .| 
|                |        \-------------/ y2 = 3
|               o|                       x2 = 13
\----------------/ y1 = 1
                  x1 = 16                                  
#endif

- (void)mouseDown:(NSEvent*)anEvent
{
  NSRect frame;
  NSPoint mouseLoc, newLoc;
  NSEvent *event;
  NSUInteger type;
  NSWindow * window;
  NSSize minsize,diff,newsize;
  
  
  window   = [self window];
  frame    = [window frame];
  minsize  = [window minSize];
  mouseLoc = [NSEvent mouseLocation];
  
  do {
    event  = [window nextEventMatchingMask:0x44];
    newLoc = [NSEvent mouseLocation];
    type   = [event type];
    
    if (type == NSLeftMouseDragged )
    {
      // Get drag difference
      diff.width = mouseLoc.x - newLoc.x;
      diff.height = newLoc.y - mouseLoc.y;
      
      // Calc the new size of the window
      newsize.width = frame.size.width - diff.width;
      newsize.height = frame.size.height - diff.height;
      
      if(newsize.width >= minsize.width && newsize.height >= minsize.height)
      {
        if(newsize.width >= minsize.width)
          frame.size.height = newsize.height;
        if(newsize.height >= minsize.height)
        {
          frame.size.width = newsize.width;
          frame.origin.y = frame.origin.y + diff.height;
        }
      }
      else{
        if(newsize.width < minsize.width)
          frame.size.width = minsize.width;
        if(newsize.height < minsize.height)
        {
          frame.size.height = minsize.height;
          // frame.origin.y = frame.origin.y + (frame.size.height - minsize.height);
        }
      }
      
      [window setFrame:frame display:YES];
      // save last mouse location
      mouseLoc = newLoc;
    }
  } while(type != NSLeftMouseUp);
}


- (void)mouseUp:(NSEvent*)anEvent
{
}

- (BOOL)mouseDownCanMoveWindow
{
  return NO;
}
@end