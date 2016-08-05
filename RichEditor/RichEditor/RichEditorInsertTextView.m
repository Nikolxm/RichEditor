//
//  RichEditorInsertTextView.m
//  RichEditor
//
//  Created by Xuemin on 16/8/5.
//  Copyright © 2016年 Xuemin. All rights reserved.
//

#import "RichEditorInsertTextView.h"
#import <Masonry/Masonry.h>

@implementation RichEditorInsertTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.insertButton];
    
    [self.insertButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@15);
    }];
}

- (UIButton *)insertButton {
    if (_insertButton == nil) {
        _insertButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_insertButton setTitle:@"插入文字" forState:UIControlStateNormal];
        [_insertButton addTarget:self action:@selector(insertTextEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _insertButton;
}

- (void)insertTextEvent {
    if ([self.delegate respondsToSelector:@selector(richEditorInsertTextView:insertButton:)]) {
        [self.delegate richEditorInsertTextView:self insertButton:self.insertButton];
    }
}
@end
