#import "BBWindowController.h"

@implementation BBWindowController

- (void)awakeFromNib
{
  id frameSave;
  NSWindow *window;
  NSRect visibleFrame,windowFrame;
  NSAttributedString *string;
  
  window = [self window];
  [window setFrameAutosaveName:@"BBNotificationPanel"];
  frameSave = [[NSUserDefaults standardUserDefaults] objectForKey:@"NSWindow Frame BBNotificationPanel"];
  
  if(frameSave)
  {
    [window setFrameUsingName:@"BBNotificationPanel" force:YES];
  }
  else
  {
    visibleFrame = [[window screen] visibleFrame];
    windowFrame  = [window frame];
    
    //FIXME: these could be swapped substractions 
    windowFrame.origin.x = visibleFrame.size.width - windowFrame.size.width - 10;
    windowFrame.origin.y = visibleFrame.size.height - windowFrame.size.height - 10;
    [window setFrameOrigin:windowFrame.origin];
  }
  
  _imageTag = -1;
  _cancelFade = NO;
  [_mainView setCallback:@selector(timeout) target:self];
  //FIXME: string = [[NSAttributedString alloc] initWithString:CFConstantStringClassReference];
  string = [[NSAttributedString alloc] initWithString:@""];
  [_mainView setContent:string];
  [string release];
  [delegate readDefaults];
}

//FIXME: preferencesMode true and false may be wrong
- (void)consumeImageData:(NSData *)data forTag:(NSInteger)tag
{
  NSImage *image;
  
  if(data)
  {
    if(tag == 0x40)
    {
      image = [[NSImage alloc] initWithData:data];
      [_mainView setImage:image];
      [image release];
      _imageTag = -1;
    }
  }
}

- (void)setBackgroundColor:(NSColor *)aColor
{
}

- (void)setCounter:(id)anArgument
{
  [_mainView setCounter:anArgument];
}

- (void)setPreferencesMode:(BOOL)enable
{
  //FIXME: could have some typos in here
  ABPerson *me;
  ABMultiValue *emails;
  NSString *email;
  NSDictionary *mailDict;
  NSMutableAttributedString *mutableString;
  NSAttributedString *string;
  
  _preferencesMode = enable;
  if(!enable)
  {
    [self fade];
    return;
  }
  
  me = [[ABAddressBook sharedAddressBook] me];
  emails = [me valueForProperty:kABEmailProperty];
  email = [emails valueAtIndex:0];
  
  mailDict = [NSDictionary dictionaryWithObjectsAndKeys:@"John Doe <john.doe@apple.com>",
                                            @"From",
                                            email,
                                            @"To",
                                            @"Sample Window",
                                            @"Subject",
                                            @"noreply@apple.com",
                                            @"Return-Path",
                                            @"Apple Mail (2.733)",
                                            @"X-Mailer",
                                            @"***",
                                            @"X-Spam-Level",
                                            @"1.0 (Apple Message framework v733)",
                                            @"Mime-Version",
                                            @"text/plain; charset=ISO-8859-1; format=flowed",
                                            @"Content-Type",
                                            nil];
                                            
  [_mainView setValues:mailDict];
  [_mainView setMailbox:@"Apple"];
  [_mainView setImage:[NSImage imageNamed:@"sender"]];
  
  mutableString = [[NSMutableAttributedString alloc] init];

  string        = [[[NSAttributedString alloc] initWithString:@"This is a sample window.\nUse the preference panel to make adjustments.\n\n"] autorelease];
  [mutableString appendAttributedString:string];
 
  string = [[[NSAttributedString alloc] initWithString:@"Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\n"
                                            attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1], 
                                                                                            @"MessageQuoteLevelAttributeName",nil]] autorelease];
  [mutableString appendAttributedString:string];
  
  string = [[[NSAttributedString alloc] initWithString:@"Donec massa. Duis molestie, urna at lacinia iaculis, libero dui ultricies est, nec condimentum ligula urna semper arcu. Donec elementum nulla nec arcu.\n"
                                            attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2], 
                                                                                            @"MessageQuoteLevelAttributeName",nil]] autorelease];
  [mutableString appendAttributedString:string];
  
  string = [[[NSAttributedString alloc] initWithString:@"Sed libero diam, dapibus non, dapibus at, fringilla vel, elit. Sed ut est a orci aliquam malesuada. Nulla wisi quam, ultricies quis, porta sed, cursus vel, tortor.\n"
                                            attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:3], 
                                                                                            @"MessageQuoteLevelAttributeName",nil]] autorelease];
  [mutableString appendAttributedString:string];
  
  string = [[[NSAttributedString alloc] initWithString:@"Fusce orci risus, ullamcorper scelerisque, vehicula sed, pellentesque quis, justo. Suspendisse ut mauris.\n"
                                            attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:4], 
                                                                                            @"MessageQuoteLevelAttributeName",nil]] autorelease];
  [mutableString appendAttributedString:string];
  
  string = [[[NSAttributedString alloc] initWithString:@"Nulla facilisi. Aenean rutrum purus condimentum lectus. Praesent wisi est, ornare ut, pharetra a, gravida vel, quam. Maecenas lorem mauris, tempus sed, porta vitae, lobortis et, libero. Sed at ipsum ut lacus facilisis placerat. Suspendisse quis diam.\n"
                                            attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:3], 
                                                                                            @"MessageQuoteLevelAttributeName",nil]] autorelease];
  [mutableString appendAttributedString:string];


  string = [[[NSAttributedString alloc] initWithString:@"Aliquam tincidunt, dui sit amet viverra pretium, nibh libero rutrum metus, sit amet tristique urna nunc sit amet sapien.\n"
                                            attributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1], 
                                                                                            @"MessageQuoteLevelAttributeName",nil]] autorelease];
  [mutableString appendAttributedString:string];
  
  
  [_mainView setContent:mutableString];
  [mutableString release];
  [[self window] show];
}

- (void)setShowMailbox:(BOOL)show
{
  [_mainView setShowMailbox:show];
}

- (void)setTransparency:(float)transparency
{
  [_mainView setNormalBackgroundColor:[NSColor colorWithDeviceWhite:0 alpha:transparency]];
  transparency = (1-transparency)*0.5+transparency;
  [_mainView setHoverBackgroundColor:[NSColor colorWithDeviceWhite:0 alpha:transparency]];
}
- (void)setQuotationLevels:(int)levels
{
  if(levels == -1)
    levels = 1000;
  [_mainView setQuotationLevels:levels];
}

- (void)setDismissAfter:(int)delay
{
  [_mainView setTimeoutInterval:delay];
}

- (void)setHeaders:(NSArray*)headers
{
  [_mainView setHeaders:headers];
}

- (void)setShowHeaderTitles:(BOOL)show
{
  [_mainView setShowHeaderTitles:show];
}

- (void)setFontFamily:(NSString*)font size:(float)size
{
  [_mainView setFont:[NSFont fontWithName:font
                                     size:size]];
}

- (void)fade
{
  [[self window] fade];
  if ([delegate respondsToSelector:@selector(notificationPanelDidFade)])
    [delegate performSelector:@selector(notificationPanelDidFade)];
}

- (void)windowDidResize:(NSNotification*)notification
{
}

- (void)mouseDown:(NSEvent *)theEvent
{
  _lastMouseDownLocation = [NSEvent mouseLocation];
}

- (void)timeout
{
  if(_preferencesMode == NO)
  {
    if ([delegate respondsToSelector:@selector(notificationPanelNextMessage)])
      [delegate performSelector:@selector(notificationPanelNextMessage)];
  }
}
- (void)mouseUp:(NSEvent *)theEvent
{
  //FIXME: is this correct?
  if (NSEqualPoints([NSEvent mouseLocation], _lastMouseDownLocation))
  {
    if([theEvent clickCount])
    {
      if(_preferencesMode==NO)
      {
        if ([delegate respondsToSelector:@selector(notificationPanelNextMessage)])
          [delegate performSelector:@selector(notificationPanelNextMessage)];
      }
    }
  }
}

- (void)click:(id)anArgument
{
  if(_preferencesMode == NO)
  {
    if([delegate respondsToSelector:@selector(notificationPanelAction:)])
      [delegate notificationPanelAction:[anArgument tag]];
  }
}

- (void)showMessage:(BBMessage*)message
{
  ABAddressBook *addressBook;
  ABSearchElement *searchElement;
  NSArray *records;
  NSString *uncommentedSender;
  NSData *imageData;
  NSImage *image;
  id temp;
  
  if(_preferencesMode == NO)
  {
    [ABAddressBook sharedAddressBook];
    uncommentedSender = [message uncommentedSender];
    temp = nil;
    if (uncommentedSender)
    {
      searchElement = [ABPerson searchElementForProperty:kABEmailProperty
                                                   label:nil
                                                     key:nil
                                                   value:uncommentedSender
                                              comparison:kABEqualCaseInsensitive];
      // test
      records = [addressBook recordsMatchingSearchElement:searchElement];
      if ([records count])
        temp = [[records objectAtIndex:0] retain];   
    }
    
    if(_imageTag != -1)
      [ABPerson cancelLoadingImageDataForTag:_imageTag];

    // FIXME: this looks wrong imagedata on a nil if no record found?
    imageData = [temp imageData];
    if(imageData)
    {
      image = [[NSImage alloc] initWithData:imageData];
      [_mainView setImage:image];
      [image release];
    }
    else
    {
      //FIXME: this in not done see 00007f33
      if(temp)
        _imageTag = [temp beginLoadingImageDataForClient:self];
        
      [_mainView setImage:nil];
    }
      
    [_mainView setContent:[message body]];
    [_mainView setValues:[message headers]];
    [_mainView setMailbox:[message mailbox]];
    [[self window] show];
  }
}

@end