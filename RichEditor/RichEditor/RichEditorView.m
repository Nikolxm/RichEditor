//
//  RichEditorView.m
//  RichEditor
//
//  Created by Xuemin on 16/8/4.
//  Copyright © 2016年 Xuemin. All rights reserved.
//

#import "RichEditorView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "RichEditorInsertTextView.h"

@interface RichEditorView () <UIScrollViewDelegate, RichEditorInsertTextViewDelegate>
@property (strong, nonatomic) MASConstraint *scrollContentViewBottomConstraint;
@property (strong, nonatomic) NSMutableArray<MASConstraint *> * topConstraints;

@end

@implementation RichEditorView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self layoutAllSubViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollContentView];
    [self.scrollContentView addSubview:self.titleView];
    [self.scrollContentView addSubview:self.contentView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewBeginEdit:) name:UITextViewTextDidBeginEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEndEdit:) name:UITextViewTextDidEndEditingNotification object:nil];
}

- (void)layoutAllSubViews {
    
    __weak typeof(self) weakSelf = self;
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.right.equalTo(weakSelf);
        make.height.equalTo(weakSelf).priorityMedium();
        make.bottom.lessThanOrEqualTo(@0);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.right.equalTo(@0);
        make.height.equalTo(@44);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleView.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@64);
    }];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}

- (UIView *)scrollContentView {
    if (_scrollContentView == nil) {
        _scrollContentView = [[UIView alloc] init];
    }
    
    return _scrollContentView;
}

- (UITextView *)titleView {
    if (_titleView == nil) {
        _titleView = [[UITextView alloc] init];
        _titleView.backgroundColor = [UIColor purpleColor];
    }
    
    return _titleView;
}

- (UITextView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UITextView alloc] init];
        _contentView.backgroundColor = [UIColor orangeColor];
    }
    
    return _contentView;
}

- (NSMutableArray<MASConstraint *> *)topConstraints {
    if (_topConstraints == nil) {
        _topConstraints = [NSMutableArray array];
    }
    
    return _topConstraints;
}

#pragma mark - Notification

- (void)textViewBeginEdit:(NSNotification *)notification {
    UITextView *textView = notification.object;
    
    if (textView == self.titleView) {
        return;
    }
    
    self.lastEditTextView = textView;
}

- (void)textViewEndEdit:(NSNotification *)notification {
    UITextView *textView = notification.object;
    
    if (textView == self.titleView) {
        return;
    }
    
    self.lastEditTextViewSelectedStartingPoint = textView.selectedRange.location;
}


#pragma mark - Function


- (void)addImage:(id)image {
    [self addImages:@[image] textFollow:nil];
}

- (void)addImages:(NSArray *)images textFollow:(NSString *)textFollow {
    
    __block UIView *lastView = self.lastEditTextView ?: self.scrollContentView.subviews.lastObject;
    __weak typeof(self) weakSelf = self;
    
    
    NSInteger index = 0;
    
    if (self.lastEditTextView) {
        index = [self.scrollContentView.subviews indexOfObject:self.lastEditTextView];
    }
    
    [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        if ([obj isKindOfClass:[UIImage class]]) {
            imageView.image = obj;
        }
        else if ([obj isKindOfClass:[NSString class]]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:obj]];
        }
        else if ([obj isKindOfClass:[NSURL class]]) {
            [imageView sd_setImageWithURL:obj];
        }
        
        if (weakSelf.lastEditTextView) {
            [weakSelf.scrollContentView insertSubview:imageView aboveSubview:lastView];
        }
        else {
            [weakSelf.scrollContentView addSubview:imageView];
        }
        
        
//        //插入图片
//        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(lastView.mas_bottom).offset(0);
//            make.left.right.equalTo(@0);
//            make.height.equalTo(imageView.mas_width);
//        }];
        
        lastView = imageView;
        
        //如果没有跟随添加图片后的文字 或者 当前的索引不是最后一个
        if (textFollow == nil || textFollow.length == 0 || idx != images.count - 1) {
            //插入添加文字按钮
            RichEditorInsertTextView *insertTextView = [[RichEditorInsertTextView alloc] init];
            insertTextView.delegate = self;
            
            if (weakSelf.lastEditTextView) {
                [weakSelf.scrollContentView insertSubview:insertTextView aboveSubview:lastView];
            }
            else {
                 [weakSelf.scrollContentView addSubview:insertTextView];
            }
           
//            [insertTextView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(lastView.mas_bottom).offset(0);
//                make.left.right.equalTo(@0);
//                make.height.equalTo(@32);
//                [weakSelf resetScrollContentViewBottom:make];
//            }];
            
            lastView = insertTextView;
        }
    }];
    
    //是否是尾随的文字
    if (textFollow.length > 0) {
        UITextView *textView = [[UITextView alloc] init];
        textView.text = textFollow;
        
        if (self.lastEditTextView) {
            [self.scrollContentView insertSubview:textView aboveSubview:lastView];
        }
        else {
            [self.scrollContentView addSubview:textView];
        }
        
        
//        [textView becomeFirstResponder];
//        textView.selectedRange = NSMakeRange(0, 0);
        
//        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(lastView.mas_bottom).offset(0);
//            make.left.right.equalTo(@0);
//            make.height.equalTo(@64);
//            [weakSelf resetScrollContentViewBottom:make];
//        }];
        
//        [self.scrollView scrollRectToVisible:self.lastEditTextView.frame animated:YES];
    }
    
    [self resetSubViewLayout];
}


- (void)resetScrollContentViewBottom:(MASConstraintMaker *)make {
    if (self.scrollContentViewBottomConstraint != nil) {
        [self.scrollContentViewBottomConstraint uninstall];
        self.scrollContentViewBottomConstraint = nil;
    }
    self.scrollContentViewBottomConstraint = make.bottom.equalTo(@0);
}


- (void)resetSubViewLayout {
    
    __block UIView *lastView = self.contentView;
    __weak typeof(self) weakSelf = self;
    
    [self.scrollContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != weakSelf.titleView && obj != weakSelf.contentView) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = obj;
                [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastView.mas_bottom).offset(0);
                    make.left.right.equalTo(@0);
                    make.height.equalTo(imageView.mas_width);
                }];
            }
            else if ([obj isKindOfClass:[RichEditorInsertTextView class]]) {
                RichEditorInsertTextView *insertTextView = obj;
                
                [insertTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastView.mas_bottom).offset(0);
                    make.left.right.equalTo(@0);
                    make.height.equalTo(@32);
                    [weakSelf resetScrollContentViewBottom:make];
                }];
            }
            else if ([obj isKindOfClass:[UITextView class]]) {
                UITextView *textView = obj;
                
                [textView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastView.mas_bottom).offset(0);
                    make.left.right.equalTo(@0);
                    make.height.equalTo(@64);
                    [weakSelf resetScrollContentViewBottom:make];
                }];
            }
            
            lastView = obj;
        }
    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self endEditing:YES];
}


#pragma mark - RichEditorInsertTextViewDelegate

- (void)richEditorInsertTextView:(RichEditorInsertTextView *)textView
                    insertButton:(UIButton *)insertButton {
    
    NSInteger index = [self.scrollContentView.subviews indexOfObject:textView];
    
    [textView removeFromSuperview];
    
    UITextView *newTextView = [[UITextView alloc] init];
    [newTextView becomeFirstResponder];
    [self.scrollContentView insertSubview:newTextView atIndex:index];
    
    [self resetSubViewLayout];
}

@end
