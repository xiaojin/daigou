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
#import <UIAlertView-Blocks/RIButtonItem.h>
#import <UIAlertView-Blocks/UIActionSheet+Blocks.h>
#import "ErrorHelper.h"

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
@property(nonatomic, strong)JVFloatLabeledTextField *address1Field;
@property(nonatomic, strong)JVFloatLabeledTextField *address2Field;
@property(nonatomic, strong)JVFloatLabeledTextField *address3Field;

@property(nonatomic, strong)UIButton *agencyButton;
@property(nonatomic, assign)BOOL isAgency;
@property(nonatomic, strong)CustomInfo *customInfo;
@property(nonatomic, strong)UIImagePickerController *imagePicker;
@property(nonatomic, strong)UICollectionView *imageCollection;
@property(nonatomic, strong)NSMutableArray *selectPhotos;
@property(nonatomic ,assign)BOOL isFrontPhoto;
@end

@implementation MEditCustomInfoViewController

NSString *const mEditCustomDetailCellIdentify = @"MEditCustomDetailCell";

- (instancetype)initWithCustom:(CustomInfo*)custom {
    if (self = [super init]) {
       _customInfo = custom;
       _isAgency = _customInfo.agent;
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
    _imageCollection.backgroundColor = [UIColor clearColor];
    _imageCollection.dataSource = self;
    _imageCollection.delegate = self;
    _imageCollection.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _selectPhotos = [[NSMutableArray alloc] init];
    if (_customInfo.photoback != nil && ![_customInfo.photoback isEqualToString:@""]) {
        Photo *backPhoto = [[Photo alloc]initWithPath:_customInfo.photoback];
        [_selectPhotos addObject:backPhoto];
    }
    if (_customInfo.photofront != nil && ![_customInfo.photofront isEqualToString:@""]) {
        Photo *frontPhoto = [[Photo alloc]initWithPath:_customInfo.photofront];
        [_selectPhotos addObject:frontPhoto];
    }
    
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
    _nameField.text = _customInfo.name;
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
    [_addressField setText:_customInfo.address];
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
    _phoneField.keyboardType = UIKeyboardTypeDecimalPad;
    [_phoneField setText:_customInfo.phonenum];
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
    _idNumberField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [_idNumberField setText:_customInfo.idnum];
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
    _emailField.keyboardType = UIKeyboardTypeURL;
    [_emailField setText:_customInfo.email];
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
    _postCodeField.keyboardType = UIKeyboardTypeNumberPad;
    [_postCodeField setText:_customInfo.postcode];
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
    idPhotoField.text = @"身份证信息";
    [_contentView addSubview:idPhotoField];
    [idPhotoField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_postCodeField.mas_bottom).with.offset(10);
        make.left.equalTo(self.view).with.offset(MARGINLEFT);
        make.width.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@30);
    }];
    
    
    UIImage *cameraImage = [IonIcons imageWithIcon:ion_image size:kTabICONSIZE color:[UIColor whiteColor]];
    UIButton *cameraButton = [[UIButton alloc]init];
    [cameraButton setBackgroundColor:THEMECOLOR];
    [cameraButton setTitle:@"身份证正面" forState:UIControlStateNormal];
    [cameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cameraButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10.0f)];
    [cameraButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0.0f)];
    [cameraButton setImage:cameraImage forState:UIControlStateNormal];
    [_contentView addSubview:cameraButton];
    [cameraButton addTarget:self action:@selector(takFrontPhotoForID) forControlEvents:UIControlEventTouchUpInside];
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
    
    [picutreButton setTitle:@"身份证反面" forState:UIControlStateNormal];
    [picutreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [picutreButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10.0f)];
    [picutreButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0.0f)];
    [picutreButton setImage:pictureImage forState:UIControlStateNormal];
    [picutreButton addTarget:self action:@selector(takBackPhotoFromID)forControlEvents:UIControlEventTouchUpInside];
    
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
    
    _address1Field = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _address1Field.delegate = self;
    _address1Field.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _address1Field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"备用地址1"
                                                                           attributes:@{NSForegroundColorAttributeName: fontColor}];
    _address1Field.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _address1Field.floatingLabelTextColor = floatingLabelColor;
    [_address1Field setText:_customInfo.address1];
    [_contentView addSubview:_address1Field];
    [_address1Field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageCollection.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(self.view).with.offset(MARGINLEFT);
        make.width.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@44);
    }];
    _address1Field.keepBaseline = YES;
    
    UIView *div7 = [UIView new];
    div7.backgroundColor = LINECOLOR;
    [_contentView addSubview:div7];
    [div7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_address1Field.mas_bottom);
        make.left.equalTo(_address1Field.mas_left);
        make.right.equalTo(_address1Field.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _address2Field = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _address2Field.delegate = self;
    _address2Field.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _address2Field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"备用地址2"
                                                                           attributes:@{NSForegroundColorAttributeName: fontColor}];
    _address2Field.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _address2Field.floatingLabelTextColor = floatingLabelColor;
    [_address2Field setText:_customInfo.address2];
    [_contentView addSubview:_address2Field];
    [_address2Field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_address1Field.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(self.view).with.offset(MARGINLEFT);
        make.width.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@44);
    }];
    _address2Field.keepBaseline = YES;
    
    UIView *div8 = [UIView new];
    div8.backgroundColor = LINECOLOR;
    [_contentView addSubview:div8];
    [div8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_address2Field.mas_bottom);
        make.left.equalTo(_address2Field.mas_left);
        make.right.equalTo(_address2Field.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    _address3Field = [[JVFloatLabeledTextField alloc]initHasAccessory];
    _address3Field.delegate = self;
    _address3Field.font = [UIFont systemFontOfSize:kJVFieldFontSize];
    _address3Field.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"备用地址2"
                                                                           attributes:@{NSForegroundColorAttributeName: fontColor}];
    _address3Field.floatingLabelFont = [UIFont boldSystemFontOfSize:kJVFieldFloatingLabelFontSize];
    _address3Field.floatingLabelTextColor = floatingLabelColor;
    [_address3Field setText:_customInfo.address3];
    [_contentView addSubview:_address3Field];
    [_address3Field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_address2Field.mas_bottom).with.offset(kJVFieldMarginTop);
        make.left.equalTo(self.view).with.offset(MARGINLEFT);
        make.width.equalTo(self.view).with.offset(-20);
        make.height.equalTo(@44);
    }];
    _address3Field.keepBaseline = YES;
    
    UIView *div9 = [UIView new];
    div9.backgroundColor = LINECOLOR;
    [_contentView addSubview:div9];
    [div9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_address3Field.mas_bottom);
        make.left.equalTo(_address3Field.mas_left);
        make.right.equalTo(_address3Field.mas_right);
        make.height.equalTo(@(kLINEHEIGHT));
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(div9.mas_bottom).with.offset(10);
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

- (void)takFrontPhotoForID {
    _isFrontPhoto = YES;
    [self showActionSheet];
    
}

- (void)takBackPhotoFromID {
    _isFrontPhoto = NO;
    [self showActionSheet];
}

-(void)presentImagePicker:(BOOL)forCamera{
    if (_selectPhotos.count < 2) {
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
     dispatch_async(dispatch_get_main_queue(), ^{
    [_imageCollection reloadData];
    });
    if (_isFrontPhoto) {
        _customInfo.photofront = photo.imageUrl;
    } else {
        _customInfo.photoback = photo.imageUrl;
    }
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

#pragma mark CameraPhotoSelect
- (void)showActionSheet {
    
    if (IOS8_OR_ABOVE) {
        [self menuCameraPhotoiOS8AndAbove];
    } else {
        [self menuCameraPhotoBelowiOS8];
    }
}

- (void)menuCameraPhotoiOS8AndAbove {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* destructiveBtn = [UIAlertAction actionWithTitle:@"相机获取" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               [self presentImagePicker:YES];
                                                           }];
    UIAlertAction* viewPhotoBtn = [UIAlertAction actionWithTitle:@"相册获取" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             [self presentImagePicker:NO];
                                                         }];
    UIAlertAction* cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * action) {
                                                            
                                                         }];
    __weak id weakSelf = self;
    [alert addAction:viewPhotoBtn];
    [alert addAction:destructiveBtn];
    [alert addAction:cancelBtn];
    alert.popoverPresentationController.sourceRect = self.view.frame;
    alert.popoverPresentationController.sourceView = weakSelf;
    
    [[[[[[[UIApplication sharedApplication] keyWindow] rootViewController] childViewControllers] lastObject] visibleViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)menuCameraPhotoBelowiOS8 {
    RIButtonItem *destructiveBtn = [RIButtonItem itemWithLabel:@"相机获取" action:^{
        [self presentImagePicker:YES];
    }];
    RIButtonItem *viewImageBtn = [RIButtonItem itemWithLabel:@"相册获取" action:^{
        [self presentImagePicker:NO];
    }];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                     cancelButtonItem:[RIButtonItem itemWithLabel:@"取消"]
                                                destructiveButtonItem: nil
                                                     otherButtonItems:viewImageBtn, destructiveBtn,nil];
    
    [actionSheet showFromRect:self.view.frame inView:self.view animated:YES];
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


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

#pragma mark - SaveCustomInfo
- (void)saveCustomInfo {
    //dismiss keyboard.
    [self.view endEditing:YES];
    if ([_customInfo.name isEqualToString:@""] || _customInfo.name == nil) {
        [ErrorHelper showErrorAlertWithTitle:@"客户信息" message:@"客户姓名不能为空"];
        return;
    }
    CustomInfoManagement *customManager = [CustomInfoManagement shareInstance];
    _customInfo.name = _nameField.text;
    _customInfo.email = _emailField.text;
    _customInfo.phonenum = _phoneField.text;
    _customInfo.idnum = _idNumberField.text;
    _customInfo.postcode = _postCodeField.text;
    _customInfo.address1 = _address1Field.text;
    _customInfo.address2 = _address2Field.text;
    _customInfo.address3 = _address3Field.text;
    _customInfo.agent = !_isAgency;
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

@end