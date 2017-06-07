//
//  FETableViewCell.m
//  Pet
//
//  Created by liyy on 15/4/10.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "FETableViewCell.h"

#define LEFT_PADDING 15
#define RIGHT_PADDING 20
#define PADDING 5

//分割线
#define SEPERATE_LINE_HEIGHT       (1.0f/[[UIScreen mainScreen]scale])                //分割线
#define UIImageWithName(A)     [UIImage imageNamed:A]

@implementation FETableViewCell
{
    UIView          *_selectedBGView;
    
    UIView          *_topLineview;
    UIView          *_lineView;
    UIImageView     *_rightArrowView;
    UIImageView     *_selectedFlagView;
    
    UITableViewCellSelectionStyle            _highlightedStyle;
}

+ (CGFloat)cellHeightWithData:(id)data
{
    return 0;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _highlightedStyle = UITableViewCellSelectionStyleGray;
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];

        _selectedBGView = [[UIView alloc] initWithFrame:CGRectZero];
        _selectedBGView.backgroundColor =[UIColor whiteColor];
        [self.contentView addSubview:_selectedBGView];
        _selectedBGView.hidden = YES;
        
        self.showSeperateLine = YES;

        [self initSelf];
    }
    
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)initSelf
{
  
}

- (void)refresh
{
    [self setNeedsLayout];
}

- (void)setSelectionStyle:(UITableViewCellSelectionStyle)selectionStyle
{
    [super setSelectionStyle:UITableViewCellSelectionStyleGray];
    _highlightedStyle = selectionStyle;
}

- (UITableViewCellSelectionStyle)selectionStyle
{
    return _highlightedStyle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    _selectedFlagView.hidden = !selected;

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (_highlightedStyle == UITableViewCellSelectionStyleNone) {
        _selectedBGView.hidden = YES;
    } else {
        _selectedBGView.hidden = !highlighted;
    }
}

- (void)setShowRightArrowView:(BOOL)showRightArrowView
{
    _showRightArrowView = showRightArrowView;
    if (_showRightArrowView)
    {
        if (_rightArrowView == nil)
        {
            _rightArrowView = [[UIImageView alloc] initWithImage: UIImageWithName(@"common_arrow_right.png")];
        }
        
        if (_rightArrowView.superview == nil)
        {
            [self.contentView addSubview:_rightArrowView];
        }
    }
    else
    {
        [_rightArrowView removeFromSuperview];
    }
}

- (void)setShowSelectedFlagView:(BOOL)showSelectedFlagView
{
    _showSelectedFlagView = showSelectedFlagView;
    if (_showSelectedFlagView)
    {
        if (!_selectedFlagView) {
            _selectedFlagView = [[UIImageView alloc] initWithImage: UIImageWithName(@"common_cell_selected_flag.png")];
            [_selectedFlagView sizeToFit];
        }
        
        if (_selectedFlagView.superview == nil) {
            [self.contentView addSubview:_selectedFlagView];
        }
      
    }
    else
    {
        if (_selectedFlagView.superview != nil) {
            [_selectedFlagView removeFromSuperview];
        }
    }
}

- (void)setShowTopSeperateLine:(BOOL)showTopSeperateLine
{
    _showTopSeperateLine = showTopSeperateLine;
    if (_showTopSeperateLine)
    {
        if (_topLineview == nil)
        {
            _topLineview = [[UIView alloc] initWithFrame:CGRectZero];
            _topLineview.backgroundColor = Dividingline_COLOR;
        }
        
        if (_topLineview.superview == nil)
        {
            [self addSubview:_topLineview];
        }
    }
    else
    {
        [_topLineview removeFromSuperview];
    }
}

- (void)setShowSeperateLine:(BOOL)showSeperateLine
{
    _showSeperateLine = showSeperateLine;
    if (_showSeperateLine)
    {
        if (_lineView == nil)
        {
            _lineView = [[UIView alloc] initWithFrame:CGRectZero];
            _lineView.backgroundColor = Dividingline_COLOR;
        }
        
        if (_lineView.superview == nil)
        {
            [self addSubview:_lineView];
        }
    }
    else
    {
        [_lineView removeFromSuperview];
    }
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];

    _selectedBGView.frame = self.contentView.bounds;
    
    //如果显示选择标识 则不现实右箭头
    if (_showSelectedFlagView)
    {
        _rightArrowView.hidden = YES;
        if (_selectedFlagView)
        {
            _selectedFlagView.frame = CGRectMake(self.contentView.width - RIGHT_PADDING - _selectedFlagView.width
                                               , (self.contentView.height - _selectedFlagView.height)*0.5
                                               , _selectedFlagView.width
                                               , _selectedFlagView.height);
        }
    }
    else
    {
        if (_rightArrowView)
        {
            _rightArrowView.hidden = NO;
            _rightArrowView.frame = CGRectMake(self.contentView.width - RIGHT_PADDING - _rightArrowView.width
                                               , (self.contentView.height - _rightArrowView.height)*0.5
                                               , _rightArrowView.width
                                               , _rightArrowView.height);
        }
    }
    
    if (_showSeperateLine)
    {
        CGFloat indentationWidth = [self seperateLineIndentationWidth];
        _lineView.frame = CGRectMake(indentationWidth, self.height - SEPERATE_LINE_HEIGHT, self.width-indentationWidth, SEPERATE_LINE_HEIGHT);
    }
    
    if (_showTopSeperateLine)
    {
        _topLineview.frame = CGRectMake(0, 0, self.width, SEPERATE_LINE_HEIGHT);
    }
}

- (CGFloat)seperateLineIndentationWidth
{
    return 0;
}

@end
