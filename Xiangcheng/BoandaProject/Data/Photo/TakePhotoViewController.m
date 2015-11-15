//
//  TakePhotoViewController.m
//  BoandaProject
//
//  Created by Alex Jean on 13-8-1.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "TakePhotoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PhotoManager.h"

@interface TakePhotoViewController ()

@property (nonatomic, strong) UIScrollView *photoScrollView;
@property (nonatomic, strong) NSMutableArray *photoList;
@property (nonatomic, strong) NSMutableArray *checkedPhotoList;
@property (nonatomic, strong) PhotoManager *photoManager;
@property (nonatomic, strong) UIPopoverController *photoPopoverController;

@end

@implementation TakePhotoViewController

@synthesize photoScrollView, photoList, checkedPhotoList, photoManager, photoPopoverController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"照片管理";
    
    //初始化数据
    self.photoList = [[NSMutableArray alloc] initWithCapacity:0];
    self.checkedPhotoList = [[NSMutableArray alloc] initWithCapacity:0];
    self.photoManager = [[PhotoManager alloc] init];
    
    //导航栏上传按钮
    UIBarButtonItem *uploadButton = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(uploadButtonClick:)];
    self.navigationItem.rightBarButtonItem = uploadButton;
    
    //ScrollView 用于展示图片
    self.photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(4, 50, 760, 850)];
    self.photoScrollView.delegate = self;
    [self.view addSubview:self.photoScrollView];
    
    //刷新界面
    [self makeView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)makeView
{
    for(id sub in self.photoScrollView.subviews)
    {
        [sub removeFromSuperview];
    }
    
    int count = self.photoList.count + 1;
    int row = count%3==0 ? count/3 : count/3+1;//每行显示3张图片,行数
    self.photoScrollView.contentSize = CGSizeMake(760, row*220+(row-1)*40+20);
    
    int x = 0, y = 0;
    for(int i = 0; i < count; i++)
    {
        if(x == 3)
        {
            x = 0;
            y++;
        }
        
        if(i != count-1)
        {
            //预览图显示区域，添加触摸手势
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10+x*260, 10+y*260, 220, 220)];
            image.image = [UIImage imageNamed:[self.photoList objectAtIndex:i]];
            UIImage *d = [[UIImage alloc] initWithContentsOfFile:[self.photoList objectAtIndex:i]];
            image.image = d;
            image.tag = 100+i;
            image.userInteractionEnabled = YES;
            UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageTap:)];
            [image addGestureRecognizer:tap];
            [self.photoScrollView addSubview:image];
            //图片名称修改
            UITextField *photoName = [[UITextField alloc] initWithFrame:CGRectMake(0, 220-44, 220, 44)];
            photoName.delegate = self;
            photoName.textAlignment = UITextAlignmentCenter;
            photoName.backgroundColor = [UIColor whiteColor];
            photoName.text = [[[self.photoList objectAtIndex:i] pathComponents] lastObject];
            [image addSubview:photoName];
        }
        else
        {
            //如果是最后一个位置，就是添加照片的选项
            UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(10+x*260, 10+y*260, 220, 220)];
            bg.userInteractionEnabled = YES;
            bg.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
            [self.photoScrollView addSubview:bg];
            //加号图片 92 × 89
            UIImageView *checked = [[UIImageView alloc] initWithFrame:CGRectMake((220-92)/2, (220-89)/2, 92, 89)];
            checked.image = [UIImage imageNamed:@"continue_add.png"];
            [bg addSubview:checked];
            //添加按钮
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, 220, 220);
            [button addTarget:self action:@selector(addPhotoClick:) forControlEvents:UIControlEventTouchUpInside];
            [bg addSubview:button];
            //添加边框
            CALayer *layer=[bg layer];
            [layer setMasksToBounds:YES];
            [layer setBorderWidth:5];
            [layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        }
        x++;
    }
}

#pragma mark - Control Event Handler

- (void)uploadButtonClick:(id)sender
{
    [photoManager uploadPhotos:self.photoList];
}

//添加照片按钮
- (void)addPhotoClick:(UIButton *)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
    else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        self.photoPopoverController = [[UIPopoverController alloc] initWithContentViewController:picker];
        self.photoPopoverController.delegate = self;
        self.photoPopoverController.popoverContentSize = CGSizeMake(320, 400);
        CGRect rect = CGRectMake(110, 220, 320, 400);
        [self.photoPopoverController presentPopoverFromRect:rect inView:sender.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

//图片上的触摸手势处理，如果是选中状态则取消
- (void)chooseImageTap:(UITapGestureRecognizer *)sender
{
    int index = sender.view.tag-100;
    if([self.checkedPhotoList containsObject:[NSNumber numberWithInt:index]])
    {
        //移除Check图片
        for(UIView *v in sender.view.subviews)
        {
            if([v isKindOfClass:[UIImageView class]])
            {
                [v removeFromSuperview];
            }
        }
        //取消边框
        CALayer *layer=[sender.view layer];
        [layer setMasksToBounds:NO];
        [layer setCornerRadius:0];
        [layer setBorderWidth:0];
        [layer setBorderColor:[[UIColor whiteColor] CGColor]];
        //将图片从待上传列表中移除
        [self.checkedPhotoList removeObject:[NSNumber numberWithInt:index]];
    }
    else
    {
        //添加Check图片
        UIImageView *checked = [[UIImageView alloc] initWithFrame:CGRectMake((220-64)/2, (220-64)/2, 64, 64)];
        checked.image = [UIImage imageNamed:@"check_photo.png"];
        [sender.view addSubview:checked];
        //添加红色边框
        CALayer *layer=[sender.view layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:0];
        [layer setBorderWidth:5];
        [layer setBorderColor:[[UIColor redColor] CGColor]];
        //添加到待上传列表
        [self.checkedPhotoList addObject:[NSNumber numberWithInt:index]];
    }
    
}

#pragma mark - Taking Photos

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(self.photoPopoverController)
    {
        [self.photoPopoverController dismissPopoverAnimated:YES];
    }
    //先判断是否从设备获取到了图片
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:@"public.image"] == NO)
    {
        [picker dismissModalViewControllerAnimated:YES];
        return;
    }
    //在iPad下面打开照相机和相册的方式不一样,如果是打开的照相机这里需要退出界面
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            [picker dismissModalViewControllerAnimated:YES];
        }
    }
    //将图片转换为二进制数据，耗时较长
    UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *data;
    if (UIImagePNGRepresentation(originImage) == nil)
    {
        data = UIImageJPEGRepresentation(originImage, 1);
    }
    else
    {
        data = UIImagePNGRepresentation(originImage);
    }
    //保存图片
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"photos"];
    [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMddHHmmss"];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[df stringFromDate:[NSDate date]]];
    BOOL ret = [fileManager createFileAtPath:[filePath stringByAppendingPathComponent:fileName] contents:data attributes:nil];
    if(ret)
    {
        [self.photoList addObject:[filePath stringByAppendingPathComponent:fileName]];
    }
    //在主线程中刷新界面
    [self makeView];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIPopoverController Delegate Method

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if(self.photoPopoverController)
    {
        [self.photoPopoverController dismissPopoverAnimated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    int index = textField.superview.tag-100;
    NSString *from = [self.photoList objectAtIndex:index];
    if([from rangeOfString:[[from pathComponents] lastObject]].location != NSNotFound)
    {
        NSString *t = [from substringToIndex:[from rangeOfString:[[from pathComponents] lastObject]].location];
        if(textField.text.length > 0)
        {
            NSString *to = [t stringByAppendingPathComponent:textField.text];
            [self.photoManager renamePhotoFromPath:from toPath:to];
            [self.photoList replaceObjectAtIndex:index withObject:to];
        }
    }
}

@end
