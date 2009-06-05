#import "BBBezelView.h"

@implementation BBBezelView
- (id)initWithFrame:(NSRect)frame
{
  NSRect rect;
  
  self = [super initWithFrame:frame];
  
  if(self)
  {
    [self setNormalBackgroundColor:[NSColor colorWithDeviceWhite:0 alpha:0.3]];
    [self setHoverBackgroundColor:[NSColor colorWithDeviceWhite:0 alpha:0.6]];
    [self setCounter:@"999/999"];
    [self setContent:nil];
    _resizeView = [BBResizeView alloc];
    rect = [self frame];
    rect.origin.x = rect.size.width - 21;
    rect.origin.y = 0;
    rect.size.width = 21;
    rect.size.height = 21;
    
    [_resizeView initWithFrame:rect];
    [_resizeView setAutoresizingMask:NSViewMinXMargin];
    [_resizeView setHidden:YES];
    
    [self addSubview:_resizeView];
    [self setPostsFrameChangedNotifications:YES];
    
    // FIXME: +510  00003c2f  c7477800000000          movl        $0x00000000,0x78(%edi)
    // +517  00003c36  c7477c00000000          movl        $0x00000000,0x7c(%edi)
    // +246  00003b27  c74768ffffffff          movl        $0xffffffff,0x68(%edi)
    // +253  00003b2e  c7476c00000000          movl        $0x00000000,0x6c(%edi)
    // +260  00003b35  c7879400000000000000    movl        $0x00000000,0x00000094(%edi) 
  }
  
  return self;
}

- (BOOL)isOpaque
{
 return NO;
}

- (void)mouseEntered:(NSEvent*)anEvent
{
  _mouseInside = YES;
  [self _stopTimer];
  [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent*)anEvent
{
  _mouseInside = NO;
  [self _resetTimer];
  [self setNeedsDisplay:YES];
}

- (void)setMailbox:(NSString*)mailbox
{
  [_mailbox release];
  _mailbox = mailbox;
  [_mailbox retain];
}

- (void)setShowMailbox:(BOOL)show
{
  _showMailbox = show;
  [self setNeedsDisplay:YES];
}

- (void)setShowHeaderTitles:(BOOL)show
{
  _showHeaderTitles = show;
  [self setNeedsDisplay:YES];
}

- (void)setTimeoutInterval:(double)interval
{
  _timeoutInterval = interval;
  [self _resetTimer];
}

- (void)setQuotationLevels:(int)levels
{
  _quotationLevels = levels;
  [self setNeedsDisplay:YES];
}

- (void)dealloc
{
  [_counterString release];
  [_normalBackgroundColor release];
  [_hoverBackgroundColor release];
  [_resizeView release];
  [_headers release];
  [_values release];
  [super dealloc];
}

- (NSArray*)headers
{
 return _headers;
}

- (void)setHeaders:(NSArray*)headers
{
  [_headers release];
  _headers = headers;
  [_headers retain];
  [self setNeedsDisplay:YES];
}


- (void)setImage:(NSImage*)image
{
  [_image release];
  _image = image;
  [_image retain];
  [self setNeedsDisplay:YES];
}

- (void)setContent:(NSAttributedString*)content
{
  [self _resetTimer];
  [_contentString release];
  _contentString  = content;
  [_contentString retain];
  [self setNeedsDisplay:YES];
}

- (void)setFrame:(NSRect)frame
{
  [self _setTrackingRect:frame];
  [super setFrame:frame];
}

- (void)_timeout:(id)anArgument
{
  _timer = nil;
  [_target performSelector:@selector(_callback)];
}

- (void)_stopTimer
{
  [_timer invalidate];
  _timer = nil;
}

- (void)setValues:(NSDictionary*)values
{
  [_values release];
  _values = values;
  [_values retain];
}

- (void)setFont:(NSFont*)font
{
  [_font release];
  _font = font;
  [_font retain];
  [self setNeedsDisplay:YES];
}

- (void)viewDidMoveToWindow
{
  if ([self window])
  {
    [self _addButtons];
    [self _setTrackingRect];
    [self setNeedsDisplay:YES];
  }
  
  [super viewDidMoveToWindow];
}

- (void)setCallback:(SEL)callback target:(id)target
{
  _callback = callback;
  [_target release];
  _target = target;
  [_target retain];
}

- (void)_resetTimer
{
  [self _stopTimer];
  if(_timeoutInterval == 0)
  {
    if(_mouseInside == NO)
    {
      _timer = [NSTimer scheduledTimerWithTimeInterval:_timeoutInterval
                                                target:self
                                              selector:@selector(_timeout:)
                                              userInfo:nil
                                               repeats:NO];
    }
  }
}

- (void)_setTrackingRect:(NSRect)rect
{
  if (_trackingRectTag!=-1)
    [self _removeTrackingRect];

  _trackingRectTag = [self addTrackingRect:rect owner:self userData:@"NORMAL" assumeInside:_mouseInside];
}

- (void)setHoverBackgroundColor:(NSColor*)color
{
  [_hoverBackgroundColor release];
  _hoverBackgroundColor = color;
  [_hoverBackgroundColor retain];
  [self setNeedsDisplay:YES];
}

- (void)_removeTrackingRect
{
  [self removeTrackingRect:_trackingRectTag];
  _trackingRectTag = -1;
}

- (void)setNormalBackgroundColor:(NSColor*)color
{
  [_normalBackgroundColor release];
  _normalBackgroundColor = color;
  [_normalBackgroundColor retain];
  [self setNeedsDisplay:YES];
}

- (void)setCounter:(NSString*)counter
{
  [_counterString release];
  _counterString = counter;
  [_counterString retain];
  [self setNeedsDisplay:YES];
}

- (void)_addButtons
{ 
  BBHoverButton *closeButton, *deleteButton, *openButton, *readButton;
  
  _buttonView = [[NSView alloc] init];
  
  closeButton = [[BBHoverButton alloc] init];
  [closeButton setImage:[NSImage imageNamed:@"close"]];
  [closeButton setAlternateImage:[NSImage imageNamed:@"close_pressed"]];
  [closeButton setHoverImage:[NSImage imageNamed:@"close_hovered"]];
  [closeButton sizeToFit];
  [closeButton setToolTip:@"Close window"];
  [closeButton setTag:1];
  [_buttonView addSubview:closeButton];
  [closeButton release];
  

  deleteButton = [[BBHoverButton alloc] init];
  [deleteButton setImage:[NSImage imageNamed:@"delete"]];
  [deleteButton setAlternateImage:[NSImage imageNamed:@"delete_pressed"]];
  [deleteButton setHoverImage:[NSImage imageNamed:@"delete_hovered"]];
  [deleteButton sizeToFit];
  [deleteButton setToolTip:@"Delete message"];
  [deleteButton setTag:4];
  [deleteButton setFrameOrigin:NSMakePoint(20,0)];
  [_buttonView addSubview:deleteButton];
  [deleteButton release];

  openButton = [[BBHoverButton alloc] init];
  [openButton setImage:[NSImage imageNamed:@"open"]];
  [openButton setAlternateImage:[NSImage imageNamed:@"open_pressed"]];
  [openButton setHoverImage:[NSImage imageNamed:@"open_hovered"]];
  [openButton sizeToFit];
  [openButton setToolTip:@"Open message in Mail"];
  [openButton setTag:5];
  [openButton setFrameOrigin:NSMakePoint(40,0)];
  [_buttonView addSubview:openButton];
  [openButton release];
  
  readButton = [[BBHoverButton alloc] init];
  [readButton setImage:[NSImage imageNamed:@"read"]];
  [readButton setAlternateImage:[NSImage imageNamed:@"read_pressed"]];
  [readButton setHoverImage:[NSImage imageNamed:@"read_hovered"]];
  [readButton sizeToFit];
  [readButton setToolTip:@"Mark message as read"];
  [readButton setTag:2];
  [readButton setFrameOrigin:NSMakePoint(60, 0)];
  [_buttonView addSubview:readButton];
  [readButton release];
  //FIXME: rect is prolly wrong
  [_buttonView setFrame:NSMakeRect(4,4,80,19)];
  [self addSubview:_buttonView];
  [_buttonView release];
}

- (void)_setTrackingRect
{
  _mouseInside = NSPointInRect([[self window] mouseLocationOutsideOfEventStream],[self frame]);
  [self _setTrackingRect:[self frame]];  
}

- (id)textAttributes:(int)attributes
{
  NSFont * font;
  NSColor *color;
  NSParagraphStyle *paragraphStyle;
  int alignment; //0xe0(%ebp)
  int linebreak; //0xe4(%ebp)
  
  if(attributes == 4)
  {
    font = [NSFont fontWithName:@"Helvetica-Bold" size:12.0];
    color = [NSColor colorWithDeviceWhite:1.0 alpha:1.0];
    alignment = NSCenterTextAlignment;
    linebreak = NSLineBreakByClipping;
  }
  else if (attributes == 1)
  {
    font = [NSFont fontWithName:@"Helvetica-Bold" size:12.0];
    color = [NSColor colorWithDeviceWhite:1.0 alpha:0.6];
    alignment = NSRightTextAlignment;
    linebreak = NSLineBreakByClipping;
  }
  else if (attributes == 2)
  {
    font = [NSFont fontWithName:@"Helvetica-Bold" size:12.0];
    color = [NSColor colorWithDeviceWhite:1.0 alpha:1.0];    
    alignment = NSLeftTextAlignment;
    linebreak = NSLineBreakByTruncatingTail;
  }  
  else if (attributes == 3)
  {
    font = [NSFont fontWithName:@"Helvetica" size:12.0];
    color = [NSColor colorWithDeviceWhite:1.0 alpha:1.0];    
    alignment = NSLeftTextAlignment;
    linebreak = NSLineBreakByTruncatingTail;
  }
  else if (attributes == 5)
  {
    font = _font;
    if (!font)
      // _font not initialized
      font = [NSFont fontWithName:@"Helvetica" size:12.0];
      
    color = [NSColor colorWithDeviceWhite:1.0 alpha:1.0];
    alignment = NSLeftTextAlignment;
    linebreak = NSLineBreakByWordWrapping;
  }
  paragraphStyle = [NSParagraphStyle paragraphStyleWithAlignment:alignment lineBreakMode:linebreak];
  
  return [[[NSDictionary alloc] initWithObjectsAndKeys:font, NSFontAttributeName,
                                              color, NSForegroundColorAttributeName,
                                              paragraphStyle, NSParagraphStyleAttributeName, nil] autorelease];  
}

- (id)_keysAttributedString
{
  NSMutableAttributedString * mutableString;
  NSAttributedString *tempStr;
  NSEnumerator *enumerator;
  NSString  *header;
  NSString *mailbox;
  BOOL firstEntry;
  
  mutableString = [[NSMutableAttributedString alloc] init];
  enumerator = [_headers objectEnumerator];
  firstEntry = YES;
  
  while(header = [enumerator nextObject])
  {
    if (firstEntry == NO)
    {
      header = [NSString stringWithFormat:@"\n%@", header];
    }
    
    tempStr = [[NSAttributedString alloc] initWithString:header
                                              attributes:[self textAttributes:1]];
    [mutableString appendAttributedString:tempStr];
    [tempStr release];
    firstEntry = NO;
  }
  
  //FIXME: this showMailbox may be shown incorrectly. mailbox is a constant nsstring
  if (_showMailbox)
  {
    mailbox = @"Mailbox";
    if (firstEntry == NO)
    {
      mailbox = [NSString stringWithFormat:@"\n%@", mailbox];
    }
    
    tempStr = [[NSAttributedString alloc] initWithString:mailbox
                                              attributes:[self textAttributes:1]];
    [mutableString appendAttributedString:tempStr];
    [tempStr release];    
  }
  
  return [mutableString autorelease];
}

- (id)_valuesAttributedString
{
  NSEnumerator *enumerator;
  NSMutableAttributedString *mutableString;
  NSAttributedString *tmpStr;
  NSString *header, *value;
  BOOL firstEntry;
  int attributes;
  
  mutableString = [[NSMutableAttributedString alloc] init];
  enumerator = [_headers objectEnumerator];
  firstEntry = YES;
  
  while(header = [enumerator nextObject])
  {
    value = [_values objectForKey:header];
    if(!value)
      // if nil
      value = @"";
      
    if ([header isEqualToString:@"Subject"])
    {
      attributes = 2;
      if ([value isEqualToString:@""])
        value = [[NSBundle mainBundle] localizedStringForKey:@"NO_SUBJECT"
                                                       value:@"(No Subject)"
                                                       table:@"Compose"];
      
      if (!firstEntry)
        value = [NSString stringWithFormat:@"\n%@",value];
    }
    else
    {
      attributes = 3;
      if (!firstEntry)
        value = [NSString stringWithFormat:@"\n%@",header];
    }
    
    tmpStr = [[NSAttributedString alloc] initWithString:value
                                             attributes:[self textAttributes:attributes]];
                                             
    [mutableString appendAttributedString:tmpStr];
    [tmpStr release];
    firstEntry = NO;
  }
  
  if(_showMailbox)
  {
    value = _mailbox;
    
    // Check if mailbox is an empty str
    if (value == nil)
      value = @"";
    
    // Check if this is the first entry were writing
    if (!firstEntry)
      value = [NSString stringWithFormat:@"\n%@",value];
      
    tmpStr = [[NSAttributedString alloc] initWithString:value
                                             attributes:[self textAttributes:3]];
                                             
    [mutableString appendAttributedString:tmpStr];
    [tmpStr release];    
  }
  
  return [mutableString autorelease];
}

- (void)drawRect:(NSRect)rect
{
  NSRect frame, fontRect;
  CGContextRef contextRef;
  NSSize fontSize;
  float x, y;

  contextRef = [[NSGraphicsContext currentContext] graphicsPort];
  CGContextSaveGState(contextRef);
  CGContextSetShouldSmoothFonts(contextRef,NO);
  CGContextSetInterpolationQuality(contextRef, kCGInterpolationHigh);
  [[NSColor clearColor] set];
  frame = [self frame];
  NSRectFill(frame);
  if (_mouseInside)
  {
    [_resizeView setHidden:NO];
    [_buttonView setHidden:NO];
    [_hoverBackgroundColor set];
  }
  else
  {
    [_resizeView setHidden:YES];
    [_buttonView setHidden:YES];
    [_normalBackgroundColor set];    
    frame.origin.y = 23;
    frame.size.height -= 23;
  }
  // FIXME: tiger [[NSBezierPath bezierPathWithRoundedRect:frame
  //                                   radius:10.0] fill];
  NSBezierPath *path = [NSBezierPath bezierPath];
  [path appendBezierPathWithRoundedRect:frame
                                xRadius:10.0
                                yRadius:10.0];
  [path fill];

  fontSize = [_counterString sizeWithAttributes:[self textAttributes:4]];

  frame = [self frame];

  fontRect.origin.x = frame.size.width/2-fontSize.width/2;
  fontRect.origin.y = frame.origin.y+2;
  fontRect.size.height = fontSize.height+2;
  fontRect.size.width  = fontSize.width+14;
  // buttonFrame = 
  if(!_mouseInside){
    // FIXME: tiger [[NSBezierPath bezierPathWithRoundedRect:fontRect
    //                                   radius:1.0] fill];
    path = [NSBezierPath bezierPath];
    [path appendBezierPathWithRoundedRect:fontRect
                                  xRadius:10.0
                                  yRadius:10.0];
    [path fill];    
  }
    
  [_counterString drawInRect:fontRect
                withAttributes:[self textAttributes:4]];
  // 
  
  if(_showHeaderTitles)
  {
    // FIXME: header titles don't show up yet
		fontSize = [[self _keysAttributedString] size];
    fontRect.origin.x = 14;
    fontRect.origin.y = frame.size.height;
    fontRect.size.width = fontSize.width+4;
    fontRect.size.height = fontSize.height+4;
    [[self _keysAttributedString] drawInRect:fontRect];
  }
  
  
  NSShadow * shadow = [[NSShadow alloc] init];
  // [shadow setShadowOffset:NSMakeSize(-1, 0)];
  // [shadow setShadowBlurRadius:unknown];
  // [shadow setShadowColor:[NSColor colorWithDeviceWhite:unknown alpha:unknown]];
  // [shadow set];
  // end
  CGContextRestoreGState(contextRef);
}
@end