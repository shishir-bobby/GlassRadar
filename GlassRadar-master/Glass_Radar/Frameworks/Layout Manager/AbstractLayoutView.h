


@interface AbstractLayoutView : UIScrollView
{
    int spacing;
    int leftMargin, rightMargin;
    int topMargin, bottomMargin;
    UIControlContentHorizontalAlignment hAlignment;
    UIControlContentVerticalAlignment vAlignment;
    BOOL fullScreen;
    int max_height;
}
@property BOOL fullScreen;
@property int spacing;
@property int leftMargin, rightMargin;
@property int topMargin, bottomMargin;
@property UIControlContentHorizontalAlignment hAlignment;
@property UIControlContentVerticalAlignment vAlignment;


- (id)init;
- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame spacing:(int)s;
- (id)initWithFrame:(CGRect)frame spacing:(int)s leftMargin:(int)lm
    rightMargin:(int)rm topMargin:(int)tm bottomMargin:(int)bm;
- (id)initWithFrame:(CGRect)frame spacing:(int)s leftMargin:(int)lm
        rightMargin:(int)rm topMargin:(int)tm bottomMargin:(int)bm
         hAlignment:(UIControlContentHorizontalAlignment)ha
         vAlignment:(UIControlContentVerticalAlignment)va fullScreen:(BOOL) flagScreen;

// UIControlContentHorizontalAlignmentFill and
// UIControlContentVerticalAlignmentFill are not supported, since layout
// managers do not manage subviews sizes.
- (id)initWithFrame:(CGRect)frame spacing:(int)s leftMargin:(int)lm
    rightMargin:(int)rm topMargin:(int)tm bottomMargin:(int)bm
    hAlignment:(UIControlContentHorizontalAlignment)ha
    vAlignment:(UIControlContentVerticalAlignment)va;

// These functions set the layout view's size to sizeThatFits: (without resizing
// the subviews). The caller can override one of the dimensions.
- (void)setSize;
- (void)setSizeWithWidth:(int)w;
- (void)setSizeWithHeight:(int)h;

// Returns frame width / height minus margins.
- (int)availableWidth;
- (int)availableHeight;

- (void)scrollToShow:(UIView *)subview animated:(BOOL)animated;

- (CGSize)layoutSubviewsEffectively:(BOOL)effectively;

@end
