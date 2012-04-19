@interface StatusItemView : NSView {
@private
    NSImage *_image;
    NSStatusItem *_statusItem;
    SEL _action;
    __unsafe_unretained id _target;
}

- (void)setLevel:(int)level;
- (id)initWithStatusItem:(NSStatusItem *)statusItem;
- (void)pollService;
- (void)updateLevel;

@property (nonatomic, strong, readonly) NSStatusItem *statusItem;
@property (nonatomic, strong) NSImage *image;
@property (nonatomic, readonly) NSRect globalRect;
@property (nonatomic) SEL action;
@property (nonatomic, unsafe_unretained) id target;

@end
