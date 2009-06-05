#import "BBHoverButton.h"

@implementation BBHoverButton
- (id)init
{
  self = [super init];
  
  if(self)
  {
    _hoverImage = nil;
    _alternateImage = nil;
    _image = nil;
    _mouseInside = NO;
    _mouseDown = NO;
    _action = nil;
    _target = nil;
    //FIXME: what's the -1 in the init function for?
    _trackingRectTag = [super tag];
  }
  
  return self;
}

- (SEL)action
{
 return _action;
}

- (id)target
{
 return _target;
}

- (void)setAction:(SEL)action
{
  _action = action;
}

- (void)setTarget:(id)target
{
  _target = target;
}

- (void)dealloc
{
  [self removeTrackingRect:_trackingRectTag];
  [super dealloc];
}

- (void)sizeToFit
{
  [super setFrameSize:[_image size]];
}

- (void)mouseEntered:(NSEvent*)theEvent
{
  [self display];
}

- (void)mouseExited:(NSEvent*)theEvent
{
  [self display];
}

- (void)mouseDown:(NSEvent*)theEvent
{
  _mouseDown = YES;
  [self display];
}

- (BOOL)mouseDownCanMoveWindow
{
 return NO;
}

- (void)setAlternateImage:(NSImage*)alternateImage
{
  [_alternateImage release];
  _alternateImage = alternateImage;
  [_alternateImage retain];
}

- (void)setImage:(NSImage*)image
{
  [_image release];
  _image = image;
  [_image retain];
}

- (void)setHoverImage:(NSImage*)hoverImage
{
  [_hoverImage release];
  _hoverImage = hoverImage;
  [_hoverImage retain];
}

- (void)viewDidMoveToWindow
{
  if ([super window])
    [self calculateTrackingRect];
}

- (void)mouseUp:(NSEvent*)theEvent
{
  _mouseDown = NO;
  if (_mouseInside)
  {
    [self tryToPerform:@selector(click:) with:self];
    if ([self action])
      [[self target] performSelector:[self action]];
  }
  
  [self display];
}

- (void)drawRect:(NSRect)aRect
{
  [self calculateTrackingRect];
  id image;
  
  if(_mouseInside)
  {
    if(_mouseDown)
      image = _alternateImage;
    else
      image = _hoverImage;
  }
  else
    image = _image;
    
  [image compositeToPoint:aRect.origin operation:NSCompositeSourceOver];
}


- (void)calculateTrackingRect
{ 
  NSRect rect;
  if(_trackingRectTag != -1)
    [self removeTrackingRect:_trackingRectTag];
  
  //FIXME: this needs a +1 somewhere see 000068c5
  rect = [self convertRect:[self bounds] toView:nil];
  rect.origin.y = rect.origin.x + 1;
  _mouseInside = NSPointInRect([[self window] mouseLocationOutsideOfEventStream],rect);
  _trackingRectTag = [self addTrackingRect:[self frame] owner:self userData:nil assumeInside:_mouseInside];
}

- (void)mouseDragged:(NSEvent*)theEvent
{
  NSRect rect;
  
  rect = [self convertRect:[self bounds] toView:nil];
  // rect.origin.y += 1;
  if (NSPointInRect([[self window] mouseLocationOutsideOfEventStream], rect))
    [self display];
}


@end