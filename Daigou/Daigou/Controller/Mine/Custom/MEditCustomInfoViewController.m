//
//  MEditCustomInfoViewController.m
//  Daigou
//
//  Created by jin on 1/07/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "MEditCustomInfoViewController.h"
#import "MCustInfoViewController.h"
#import <Masonry/Masonry.h>
#import <ionicons/IonIcons.h>
#import <ionicons/ionicons-codes.h>
#import "CustomInfo.h"
#import "CustomInfoManagement.h"
#import "CommonDefines.h"
#import "JVFloatLabeledTextField.h"
#import "UITextField+UITextFieldAccessory.h"
#import "Photo.h"
#import "OrderPhotoViewCell.h"
#import "FSBasicImage.h"
#import "FSBasicImageSource.h"
#import "DirectoryUtil.h"

#define TEXTFIELDFONTSIZE 16.0f
#define kTabICONSIZE 26.0f
#define MARGINLEFT 10.0f
@interface MEditCustomInfoViewController()<UITextFieldDelegate,UIScrollViewDelegate,PhotoViewCellDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    CGSize keyboardSize;
}
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIView *contentView;
@property(nonatomic, strong)JVFloatLabeledTextField *nameField;
@property(nonatomic, strong)JVFloatLabeledTextField *addressField;
@property(nonatomic, strong)JVFloatLabeledTextField *phoneField;
@property(nonatomic, strong)JVFloatLabeledTextField *idNumberField;
@property(nonatomic, strong)JVFloatLabeledTextField *emailField;
@property(nonatomic, strong)JVFloatLabeledTextField *postCodeField;
@property(nonatomic, strong)UIButton *agencyButton;
@property(nonatomic, assign)BOOL isAgency;
@property(nonatomic, strong)CustomInfo *customInfo;
@property(nonatomic, strong)UIImagePickerController *imagePicker;
@property(nonatomic, strong)UICollectionView *imageCollection;
@property(nonatomic, strong)NSMutableArray *selectPhotos;
@end

@implementation MEditCustomInfoViewController

NSString *const mEditCustomDetailCellIdentify = @"MEditCustomDetailCell";

- (instancetype)initWithCustom:(CustomInfo*)custom {
    if (self = [super init]) {
       _customInfo = custom;
        [self initSubViews];
   }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setNavigationView];
    [self addContentView];
}
- (void)initSubViews {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(70, 70)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    _imageCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [_imageCollection registerClass:[OrderPhotoViewCell class] forCellWithReuseIdentifier:@"photos"];
    _imageCollection.backgroundColor = [UIColor lightGrayColor];
    _imageCollection.dataSource = self;
    _imageCollection.delegate = self;
    _imageCollection.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _selectPhotos = [[NSMutableArray alloc] init];
    
}


- (void)addContentView {
    _scrollView = [UIScrollView new];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _contentView = [[UIView alloc]init];
    [_scrollView addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    UIColor *floatingLabelColor = [UIColor lightGrayColor];
    UIColor *fontColor = FONTCOLOR;
    _nameField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _nameField.delegate = self;
    _nameField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"名称"
                                                                       attributes:@{NSForegroundColorAttributeName: fontColor}];
    _nameField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _nameField.floatingLabelTextColor = floatingLabelColor;
    [_contentView addSubview:_nameField];
    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView.mas_top).with.offset(kJVFieldMarginTop);
        make.left.equalTo(self.view).with.offset(MARGINLEFT);
        make.width.equalTo(self.view).with.offset(-90);
        make.height.equalTo(@44);
    }];
    _nameField.keepBaseline = YES;
    
    _agencyButton = [[UIButton alloc]init];
    [_agencyButton setTitle:@"代理" forState:UIControlStateNormal];
    [_agencyButton setTitleColor:fontColor forState:UIControlStateNormal];
    [_agencyButton.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [self handlerAgencyCheck];
    // [missProduct setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [_agencyButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0.0f)];
    [_agencyButton addTarget:self action:@selector(handlerAgencyCheck) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_agencyButton];
    [_agencyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameField.mas_right);
        make.bottom.equalTo(_nameField.mas_bottom).with.offset(2);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@30);
    }];
    
    UIView *div1 = [UIView new];
    div1.backgroundColor = LINECOLOR;
    [_contentView addSubview:div1];
    [div1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameField.mas_bottom);
        make.left.equalTo(_nameField.mas_left);
        make.right.equalTo(_nameField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    _addressField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _addressField.delegate = self;
    _addressField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _addressField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"地址"
                                                                        attributes:@{NSForegroundColorAttributeName: fontColor}];
    _addressField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _addressField.floatingLabelTextColor = floatingLabelColor;
    _addressField.keyboardType = UIKeyboardTypeDecimalPad;
    //[_receiverField setText:_product.name];
    [_contentView addSubview:_addressField];
    [_addressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameField.mas_bottom).with.offset(10);
        make.left.equalTo(_nameField.mas_left);
        make.width.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@44);
    }];
    _addressField.keepBaseline = YES;
    
    
    UIView *div2 = [UIView new];
    div2.backgroundColor = LINECOLOR;
    [_contentView addSubview:div2];
    [div2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressField.mas_bottom);
        make.left.equalTo(_addressField.mas_left);
        make.right.equalTo(_addressField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _phoneField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _phoneField.delegate = self;
    _phoneField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"联系电话"
                                                                          attributes:@{NSForegroundColorAttributeName: fontColor}];
    _phoneField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _phoneField.floatingLabelTextColor = floatingLabelColor;
    _phoneField.keyboardType = UIKeyboardTypeURL;
    [_contentView addSubview:_phoneField];
    [_phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addressField.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(self.view).with.offset(MARGINLEFT);
        make.width.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@44);
    }];
    _phoneField.keepBaseline = YES;
    
    UIView *div3 = [UIView new];
    div3.backgroundColor = LINECOLOR;
    [_contentView addSubview:div3];
    [div3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneField.mas_bottom);
        make.left.equalTo(_phoneField.mas_left);
        make.right.equalTo(_phoneField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _idNumberField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _idNumberField.delegate = self;
    _idNumberField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _idNumberField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"身份证号"
                                                                       attributes:@{NSForegroundColorAttributeName: fontColor}];
    _idNumberField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _idNumberField.floatingLabelTextColor = floatingLabelColor;
    [_contentView addSubview:_idNumberField];
    [_idNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneField.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(self.view).with.offset(MARGINLEFT);
        make.width.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@44);
    }];
    _idNumberField.keepBaseline = YES;
    
    UIView *div4 = [UIView new];
    div4.backgroundColor = LINECOLOR;
    [_contentView addSubview:div4];
    [div4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_idNumberField.mas_bottom);
        make.left.equalTo(_idNumberField.mas_left);
        make.right.equalTo(_idNumberField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _emailField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _emailField.delegate = self;
    _emailField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"电子邮箱"
                                                                           attributes:@{NSForegroundColorAttributeName: fontColor}];
    _emailField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _emailField.floatingLabelTextColor = floatingLabelColor;
    [_contentView addSubview:_emailField];
    [_emailField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_idNumberField.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(self.view).with.offset(MARGINLEFT);
        make.width.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@44);
    }];
    _idNumberField.keepBaseline = YES;
    
    UIView *div5 = [UIView new];
    div5.backgroundColor = LINECOLOR;
    [_contentView addSubview:div5];
    [div5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_emailField.mas_bottom);
        make.left.equalTo(_emailField.mas_left);
        make.right.equalTo(_emailField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _postCodeField = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _postCodeField.delegate = self;
    _postCodeField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _postCodeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"邮政编码"
                                                                        attributes:@{NSForegroundColorAttributeName: fontColor}];
    _postCodeField.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _postCodeField.floatingLabelTextColor = floatingLabelColor;
    [_contentView addSubview:_postCodeField];
    [_postCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_emailField.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(self.view).with.offset(MARGINLEFT);
        make.width.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@44);
    }];
    _postCodeField.keepBaseline = YES;
    
    UIView *div6 = [UIView new];
    div6.backgroundColor = LINECOLOR;
    [_contentView addSubview:div6];
    [div6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_postCodeField.mas_bottom);
        make.left.equalTo(_postCodeField.mas_left);
        make.right.equalTo(_postCodeField.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    
    UILabel *idPhotoField = [[UILabel alloc]init];
    idPhotoField.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    idPhotoField.textColor = fontColor;
    idPhotoField.text = @"身份证图片";
    [_contentView addSubview:idPhotoField];
    [idPhotoField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_postCodeField.mas_bottom).with.offset(10);
        make.left.equalTo(self.view).with.offset(MARGINLEFT);
        make.width.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@30);
    }];
    
    
    UIImage *cameraImage = [IonIcons imageWithIcon:ion_camera size:kTabICONSIZE color:[UIColor whiteColor]];
    UIButton *cameraButton = [[UIButton alloc]init];
    [cameraButton setBackgroundColor:THEMECOLOR];
    [cameraButton setTitle:@"拍照" forState:UIControlStateNormal];
    [cameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cameraButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40.0f)];
    [cameraButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0.0f)];
    [cameraButton setImage:cameraImage forState:UIControlStateNormal];
    [_contentView addSubview:cameraButton];
    [cameraButton addTarget:self action:@selector(takPhotoFromCamera) forControlEvents:UIControlEventTouchUpInside];
    [cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(idPhotoField.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(MARGINLEFT);
        make.width.equalTo(@((kWindowWidth-42)/2));
        make.height.equalTo(@44);
    }];
    
    UIView *buttonsLine = [[UIView alloc]init];
    [buttonsLine setBackgroundColor:[UIColor grayColor]];
    [_contentView addSubview:buttonsLine];
    [buttonsLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cameraButton.mas_top).with.offset(6);
        make.bottom.equalTo(cameraButton.mas_bottom).with.offset(-6);
        make.left.equalTo(cameraButton.mas_right).with.offset(10);
        make.width.equalTo(@2);
    }];
    
    UIImage *pictureImage = [IonIcons imageWithIcon:ion_image size:kTabICONSIZE color:[UIColor whiteColor]];
    UIButton *picutreButton = [[UIButton alloc]init];
    [picutreButton setBackgroundColor:THEMECOLOR];
    
    [picutreButton setTitle:@"相册" forState:UIControlStateNormal];
    [picutreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [picutreButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40.0f)];
    [picutreButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0.0f)];
    [picutreButton setImage:pictureImage forState:UIControlStateNormal];
    [picutreButton addTarget:self action:@selector(takPhotoFromAlbum)forControlEvents:UIControlEventTouchUpInside];
    
    [_contentView addSubview:picutreButton];
    [picutreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cameraButton.mas_top);
        make.left.equalTo(buttonsLine.mas_right).with.offset(10);
        make.bottom.equalTo(cameraButton.mas_bottom);
        make.right.equalTo(idPhotoField.mas_right);
    }];
    
    [_contentView addSubview:_imageCollection];
    [_imageCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@100);
        make.top.equalTo(cameraButton.mas_bottom).with.offset(10);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_imageCollection.mas_bottom).with.offset(15);
    }];

}

- (void)setNavigationView {
    self.title = @"客户详情";
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveCustomInfo)];
    self.navigationItem.rightBarButtonItem = saveBarButton;
}

- (void)handlerAgencyCheck {
    UIImage *checkedImage = [IonIcons imageWithIcon:ion_android_checkbox_outline iconColor:THEMECOLOR iconSize:22 imageSize:CGSizeMake(22, 22)];
    UIImage *uncheckedImage =[IonIcons imageWithIcon:ion_android_checkbox_outline_blank iconColor:FONTCOLOR iconSize:22 imageSize:CGSizeMake(22, 22)];
    if (_isAgency) {
        [_agencyButton setImage:checkedImage forState:UIControlStateNormal];
        _isAgency = false;
    } else {
        [_agencyButton setImage:uncheckedImage forState:UIControlStateNormal];
        _isAgency = true;
    }
}

- (void)takPhotoFromCamera {
    [self presentImagePicker:YES];
}

- (void)takPhotoFromAlbum {
    [self presentImagePicker:NO];
}

-(void)presentImagePicker:(BOOL)forCamera{
    if (_selectPhotos.count <=2) {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = NO;
        _imagePicker.sourceType = forCamera ? UIImagePickerControllerSourceTypeCamera :
        UIImagePickerControllerSourceTypePhotoLibrary;
        
        if (IOS8_OR_ABOVE) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self showViewController:_imagePicker];
            }];
        } else {
            [self showViewController:_imagePicker];
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"照片提示"
                                                            message:@"照片数量不能超过2张"
                                                           delegate:self
                                                  cancelButtonTitle:@"好的"
                                                  otherButtonTitles:nil, nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView show];
        });
    }
}
-(void)showViewController:(UIViewController*)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}
#pragma mark -- UIImagePickerControllerDelegate;
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil);
    }
    Photo *photo = [[Photo alloc] initWithImage:chosenImage];
    [_selectPhotos addObject:photo];
    // dispatch_async(dispatch_get_main_queue(), ^{
    [_imageCollection reloadData];
    //});
    
    [self imagePickerControllerDidCancel:picker];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [_imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OrderPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photos" forIndexPath:indexPath];
    [cell setPhoto:_selectPhotos[indexPath.row]];
    cell.readOnly = NO;
    cell.delegate = self;
    return cell;
}

#pragma mark PhotoCellViewDelegate
- (void)deletePhoto:(Photo*) selectedPhoto {
    [_selectPhotos removeObject:selectedPhoto];
    [_imageCollection reloadData];
}

-(void)showPhoto:(Photo*) photo {
    FSBasicImage *image = [[FSBasicImage alloc] initWithImage:photo.image];
    FSBasicImageSource *imageSource = [[FSBasicImageSource alloc] initWithImages:@[image]];
    FSImageViewerViewController *vc = [[FSImageViewerViewController alloc] initWithImageSource:imageSource];
    vc.sharingDisabled = YES;
    UINavigationController *uiNavigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    uiNavigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:uiNavigationController animated:YES completion:nil];
}



#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"%@",textView.text);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == 51002) {
        _customInfo.address = textView.text;
    } else if(textView.tag == 51005){
        _customInfo.note = textView.text;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 51000) {
        _customInfo.name = textField.text;
    } else if(textField.tag == 51001){
        _customInfo.email = textField.text;
    } else if(textField.tag == 51003){
        _customInfo.idnum = textField.text;
    }
}

#pragma mark - SaveCustomInfo
- (void)saveCustomInfo {
    //dismiss keyboard.
    [self.view endEditing:YES];
    if ([_customInfo.name isEqualToString:@""] || _customInfo.name == nil) {
        return;
    }
    CustomInfoManagement *customManager = [CustomInfoManagement shareInstance];
    BOOL result = [customManager updateCustomInfo:_customInfo];
    if (result) {
        NSArray *controllers = self.navigationController.childViewControllers;
        NSInteger length = [controllers count];
        if ([[controllers objectAtIndex:length-2] isKindOfClass:[MCustInfoViewController class]]) {
            MCustInfoViewController *showDetailView =  (MCustInfoViewController *)[controllers lastObject];
            //showDetailView.customInfo = _customInfo;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- Save Photo
- (NSString *)savePhotoToDB {
    __block NSString *photosURL = @"";
    [_selectPhotos enumerateObjectsUsingBlock:^(Photo *photo, NSUInteger idx, BOOL *stop) {
        if (idx < ([_selectPhotos count]-1)) {
            photosURL = [photosURL stringByAppendingFormat:@"%@,",[photo imageUrl]];
        } else {
            photosURL = [photosURL stringByAppendingFormat:@"%@",[photo imageUrl]];
        }
    }];
    return photosURL;
}

//- (void)getRelatedPhotosFromDB {
//    if (![_orderItem.noteImage isEqualToString:@""] && _orderItem.noteImage !=nil) {
//        NSArray *photos = [_orderItem.noteImage componentsSeparatedByString:@","];
//        if ([photos count]!= 0) {
//            [photos enumerateObjectsUsingBlock:^(NSString *imageURL, NSUInteger idx, BOOL *stop) {
//                Photo *photo = [[Photo alloc] initWithPath:imageURL];
//                [_selectPhotos addObject:photo];
//            }];
//        }
//    }
//    
//}

@end