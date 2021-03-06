/*
 *     Generated by class-dump 3.1.2.
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2007 by Steve Nygard.
 */

#import <Cocoa/Cocoa.h>
#import "BBResizeView.h"
#import "BBHoverButton.h"
#import "NSParagraphStyle-StyleAdditions.h"
// #import "BBTextField.h"

//FIXME: BBTextField
// @class BBTextField;

@interface BBBezelView : NSView
{
    NSColor *_hoverBackgroundColor;
    NSColor *_normalBackgroundColor;
    //FIXME: BBTextField *_counterTextField;
    NSTextField *_counterTextField;
    NSString *_counterString;
    NSAttributedString *_contentString;
    NSView *_buttonView;
    int _trackingRectTag;
    NSImage *_image;
    BOOL _showHeaderTitles;
    BOOL _showMailbox;
    BOOL _mouseInside;
    BBResizeView *_resizeView;
    NSArray *_headers;
    NSDictionary *_values;
    NSString *_mailbox;
    double _timeoutInterval;
    SEL _callback;
    id _target;
    NSTimer *_timer;
    NSArray *_localizedHeaders;
    NSFont *_font;
    int _quotationLevels;
}

- (id)initWithFrame:(struct _NSRect)fp8;
- (void)dealloc;
- (BOOL)isOpaque;
- (void)drawRect:(struct _NSRect)fp8;
- (void)viewDidMoveToWindow;
- (void)setFrame:(struct _NSRect)fp8;
- (void)mouseEntered:(NSEvent*)fp8;
- (void)mouseExited:(NSEvent*)fp8;
- (void)setMailbox:(NSString*)fp8;
- (void)setShowMailbox:(BOOL)fp8;
- (void)setShowHeaderTitles:(BOOL)fp8;
- (void)setTimeoutInterval:(double)fp8;
- (void)setQuotationLevels:(int)fp8;
- (void)setCallback:(SEL)fp8 target:(id)fp12;
- (void)_timeout:(id)fp8;
- (void)_stopTimer;
- (void)_resetTimer;
- (void)_addButtons;
- (NSArray*)headers;
- (void)setHeaders:(NSArray*)fp8;
- (void)setValues:(NSDictionary*)fp8;
- (id)textAttributes:(int)fp8;
- (void)_removeTrackingRect;
- (void)_setTrackingRect:(struct _NSRect)fp8;
- (void)_setTrackingRect;
- (id)_keysAttributedString;
- (id)_valuesAttributedString;
- (void)setImage:(NSImage*)fp8;
- (void)setContent:(NSAttributedString*)fp8;
- (void)setCounter:(NSString*)fp8;
- (void)setNormalBackgroundColor:(NSColor*)fp8;
- (void)setHoverBackgroundColor:(NSColor*)fp8;
- (void)setFont:(NSFont*)fp8;

@end

