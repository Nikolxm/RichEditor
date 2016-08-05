//
//  RichEditorView.h
//  RichEditor
//
//  Created by Xuemin on 16/8/4.
//  Copyright © 2016年 Xuemin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RichEditorView : UIView
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *scrollContentView;

@property (strong, nonatomic) UITextView *titleView;
@property (strong, nonatomic) UITextView *contentView;

@property (strong, nonatomic) UITextView *lastEditTextView;
//lastEditTextView 的光标位置
@property (assign, nonatomic) NSInteger lastEditTextViewSelectedStartingPoint;

/**
 *  @author Xuemin
 *
 *  添加单张图片
 *
 *  @param image 图片
 *
 *  @since 1.0
 */
- (void)addImage:(id)image;

/**
 *  @author Xuemin
 *
 *  添加多张图片
 *
 *  @param images     图片
 *  @param textFollow 跟随文字，如果不为nil 在会在图片添加完成后紧跟后面添加
 *
 *  @since 1.0
 */
- (void)addImages:(NSArray *)images textFollow:(NSString *)textFollow;
@end
