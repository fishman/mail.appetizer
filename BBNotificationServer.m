#import "BBNotificationServer.h"

@implementation BBNotificationServer

+ (void)initialize
{
  NSString *path;
  NSDictionary *dict;
  path = [[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"];
  dict = [NSDictionary dictionaryWithContentsOfFile:path];
  [[NSUserDefaults standardUserDefaults] registerDefaults:dict];
}

- (void)setCallbackTarget:(id)target
{
  [_target release];
  _target = target;
  [_target retain];
}

- (void)updateCounter
{
  NSUInteger msgCount;
  NSString * string;
  
  msgCount = [_messages count];
  _currentMessage++;
  string = [NSString stringWithFormat:@"%d/%d",_currentMessage, msgCount];
  [_windowController setCounter:string];
}

- (void)showNextMessage
{
  NSUInteger msgCount;
  id message;
  
  msgCount = [_messages count];
  // FIXME: is this really < or >= ?
  if(msgCount >= _currentMessage)
    [_windowController fade];
  else
  {
    _currentMessage++;
    [self updateCounter];
    message = [_messages objectAtIndex:_currentMessage];
    [_windowController showMessage:message];
  }
}

- (void)notificationPanelAction:(int)anArgument
{
  id message;
  id emlx;
  
  if(anArgument != 1)
  {
    message = [_messages objectAtIndex:_currentMessage];
    emlx = [message emlxFile];
    [_target performAction:anArgument forEmlxFile:emlx];
  }
  else
    [_windowController fade];
}

- (void)notificationPanelDidFade
{
  _idle = 1;
  [_messages removeAllObjects];
  _currentMessage = -1;
}

- (void)notificationPanelNextMessage
{
  [self showNextMessage];
}

- (void)setPreferencesMode:(BOOL)anArgument
{
  [_windowController setPreferencesMode:anArgument];
}

- (void)showNotificationForMessage:(BBMessage*)message
{
  [_messages addObject:message];
  // FIXME: right order?
  if(_idle)
    [self showNextMessage];
  else
    [self updateCounter];
}

- (void)setLocalizedHeaders:(id)anArgument
{
}

- (void)setLocalizedNoSubject:(id)anArgument
{
}

- (void)setEnabled:(BOOL)enable
{
  [[NSUserDefaults standardUserDefaults] setBool:enable forKey:@"Enabled"];
}

- (void)setTransparency:(float)transparency
{
  [[NSUserDefaults standardUserDefaults] setFloat:transparency forKey:@"Transparency"];
  [_windowController setTransparency:transparency];
}

- (void)setQuotationLevels:(int)level
{
  [[NSUserDefaults standardUserDefaults] setInteger:level forKey:@"QuotationLevels"];
  [_windowController setQuotationLevels:level];
}

- (void)setDismissAfter:(int)dismiss
{
  [[NSUserDefaults standardUserDefaults] setInteger:dismiss forKey:@"DismissAfter"];
  [_windowController setDismissAfter:dismiss];
}
- (void)setCustomHeaders:(id)headers
{
  [[NSUserDefaults standardUserDefaults] setObject:headers forKey:@"CustomHeaders"];
}

- (void)setHeaderDetail:(int)detail
{
  NSArray * detailArray;
  
  [[NSUserDefaults standardUserDefaults] setInteger:detail forKey:@"HeaderDetail"];
  
  if (detail == 1)
    detailArray = [NSArray arrayWithObjects:@"Subject", @"From", @"To", nil];
  else if (detail == 2)
    detailArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"CustomHeaders"];
  else 
    detailArray = [NSArray array];
    
  [_windowController setHeaders:detailArray];    
}

- (void)setExcludedMailboxes:(id)mailboxes
{
  [[NSUserDefaults standardUserDefaults] setObject:mailboxes forKey:@"ExcludedMailboxes"];
}
- (void)setMailboxDetail:(int)mboxdetail
{
  [[NSUserDefaults standardUserDefaults] setInteger:mboxdetail forKey:@"MailboxDetail"];
}

- (void)setShowHeaderTitles:(BOOL)show
{
  [[NSUserDefaults standardUserDefaults] setBool:show forKey:@"ShowHeaderTitles"];
  [_windowController setShowHeaderTitles:show];
}
- (void)setShowMailbox:(BOOL)show
{
  [[NSUserDefaults standardUserDefaults] setBool:show forKey:@"ShowMailbox"];
  [_windowController setShowMailbox:show];
}

- (void)setHideInMail:(BOOL)hide
{
  [[NSUserDefaults standardUserDefaults] setBool:hide forKey:@"HideInMail"];
}

- (void)setFontFamily:(NSString*)aFont size:(float)fontSize
{
  [[NSUserDefaults standardUserDefaults] setObject:aFont forKey:@"FontFamily"];
  [[NSUserDefaults standardUserDefaults] setFloat:fontSize forKey:@"FontSize"];
  [_windowController setFontFamily:aFont size:fontSize];
}

- (void)setOpenInSeparateWindow:(BOOL)enable
{
  [[NSUserDefaults standardUserDefaults] setBool:enable forKey:@"OpenInSeparateWindow"];
}

- (BOOL)openInSeparateWindow
{
  return [[NSUserDefaults standardUserDefaults] boolForKey:@"OpenInSeparateWindow"];
}

- (id)customHeaders
{
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"CustomHeaders"];
}

- (id)excludedMailboxes
{
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"ExcludedMailboxes"];
}

- (float)transparency
{
  return [[NSUserDefaults standardUserDefaults] floatForKey:@"Transparency"];
}

- (int)quotationLevels
{
  return [[NSUserDefaults standardUserDefaults] integerForKey:@"QuotationLevels"];
}

- (int)headerDetail
{
  return [[NSUserDefaults standardUserDefaults] integerForKey:@"HeaderDetail"];
}

- (int)mailboxDetail
{
 return [[NSUserDefaults standardUserDefaults] integerForKey:@"MailboxDetail"];
}

- (NSString*)fontFamily
{
 return [[NSUserDefaults standardUserDefaults] objectForKey:@"FontFamily"];
}

- (float)fontSize
{
  return [[NSUserDefaults standardUserDefaults] floatForKey:@"FontSize"];
}

- (BOOL)enabled
{
  return [[NSUserDefaults standardUserDefaults] boolForKey:@"Enabled"];
}

- (int)dismissAfter
{
  return [[NSUserDefaults standardUserDefaults] integerForKey:@"DismissAfter"];
}

- (BOOL)showHeaderTitles
{
  return [[NSUserDefaults standardUserDefaults] boolForKey:@"ShowHeaderTitles"];
}

- (BOOL)showMailbox
{
  return [[NSUserDefaults standardUserDefaults] boolForKey:@"ShowMailbox"];
}

- (BOOL)hideInMail
{
 return [[NSUserDefaults standardUserDefaults] boolForKey:@"HideInMail"];
}

- (void)readDefaults
{
  int headerDetail;
  NSArray * array;
  
  [_windowController setTransparency:[self transparency]];
  [_windowController setQuotationLevels:[self quotationLevels]];
  [_windowController setFontFamily:[self fontFamily] size:[self fontSize]];
  [_windowController setShowMailbox:[self showMailbox]];
  [_windowController setShowHeaderTitles:[self showHeaderTitles]];
  
  headerDetail = [self headerDetail];
  if (headerDetail == 1)
    array = [NSArray arrayWithObjects:@"Subject",@"From",@"To",nil];
  else if (headerDetail == 2)
    array = [[NSUserDefaults standardUserDefaults] objectForKey:@"CustomHeaders"];
  else
    array = [NSArray array];
    
  [_windowController setHeaders:array];
  [_windowController setDismissAfter:[self dismissAfter]];
  [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.bronsonbeta.MailAppetizer" object:nil];
}

- (void)connectionDidDie:(id)anArgument
{
  [NSApp terminate:self];
}

- (void)workspaceDidTerminateApplication:(NSNotification *)notif
{
  id bundle;
  
  bundle = [[notif userInfo] objectForKey:@"NSApplicationBundleIdentifier"];
  if ([bundle isEqual:@"com.apple.mail"])
    [NSApp terminate:self];
}

- (id)init
{
  self = [super init];
  
  if(self)
  {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectionDidDie:)
                                                 name:NSConnectionDidDieNotification
                                               object:nil];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(workspaceDidTerminateApplication:)
                                                               name:NSWorkspaceDidTerminateApplicationNotification
                                                             object:nil];
    [[NSConnection defaultConnection] setRootObject:self];
    [[NSConnection defaultConnection] registerName:@"BBNotificationServer"];
    [[NSRunLoop currentRunLoop] configureAsServer];
    _messages = [[NSMutableArray alloc] init];
    _currentMessage = -1;
    _idle = YES;
  }
  
  return self;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
  return NSTerminateNow;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [_messages release];
  [self setCallbackTarget:nil];
  [super dealloc];
}


@end
