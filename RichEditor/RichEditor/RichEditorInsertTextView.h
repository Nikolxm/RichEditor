//
//  RichEditorInsertTextView.h
//  RichEditor
//
//  Created by Xuemin on 16/8/5.
//  Copyright © 2016年 Xuemin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RichEditorInsertTextView;

@protocol RichEditorInsertTextViewDelegate <NSObject>

@optional
- (void)richEditorInsertTextView:(RichEditorInsertTextView *)textView
                    insertButton:(UIButton *)insertButton;

@end

@interface RichEditorInsertTextView : UIView
@property (weak, nonatomic) id <RichEditorInsertTextViewDelegate> delegate;
@property (strong, nonatomic) UIButton *insertButton;
@end
