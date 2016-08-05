//
//  ViewController.m
//  RichEditor
//
//  Created by Xuemin on 16/8/3.
//  Copyright © 2016年 Xuemin. All rights reserved.
//

#import "ViewController.h"
#import "RichEditorView.h"
#import <Masonry/Masonry.h>
#import <TZImagePickerController/TZImagePickerController.h>

@interface ViewController ()
@property (strong, nonatomic) RichEditorView *editorView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.editorView];
    
    [self.editorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    NSLog(@"\nfirstObject: %@", self.view.subviews.firstObject);
    NSLog(@"\nlastObject : %@", self.view.subviews.lastObject);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RichEditorView *)editorView {
    if (_editorView == nil) {
        _editorView = [[RichEditorView alloc] init];
    }
    
    return _editorView;
}
- (IBAction)sortView:(id)sender {
}

- (IBAction)insertPhoto:(id)sender {
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    
    [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        UITextView *textView = [self.editorView lastEditTextView];
        if (textView) {
            NSString *text = textView.text;
            
            textView.text = [text substringToIndex:self.editorView.lastEditTextViewSelectedStartingPoint];
            NSString *textFollow = [text substringFromIndex:self.editorView.lastEditTextViewSelectedStartingPoint];
            
            [self.editorView addImages:photos textFollow:textFollow];
        }
        else {
            [self.editorView addImages:photos textFollow:nil];
        }
    }];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}
@end
