//
//  ZQAlbumNavC.m
//  PhotoAlbum
//
//  Created by ZhouQian on 16/5/28.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "ZQAlbumNavVC.h"
#import "ZQAlbumListVC.h"
#import "ZQPhotoFetcher.h"
#import "ZQAlbumVC.h"
#import "ProgressHUD.h"

#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)

@implementation ZQAlbumNavVC


- (instancetype)initWithType:(ZQAlbumType)type {
    return [self initWithMaxImagesCount:1 type:type bSingleSelect:YES];
}

- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount type:(ZQAlbumType)type bSingleSelect:(BOOL)bSingleSelect {

    if ([ZQPhotoFetcher authorizationStatusAuthorized]) {
        ZQAlbumListVC *lvc = [[ZQAlbumListVC alloc] init];
        lvc.type = type;
        lvc.bSingleSelection = bSingleSelect;
        
        self = [super initWithRootViewController:lvc];
        _maxImagesCount = maxImagesCount;
        
        ______WX(lvc, wlvc);
        ______WS();
        [ProgressHUD show];
        lvc.dataLoaded = ^(NSArray<ZQAlbumModel*>*Albums) {
            [ProgressHUD hide];
            
            if (wlvc.albums.count > 0) {
                ZQAlbumVC *vc = [[ZQAlbumVC alloc] init];
                vc.type = type;
                vc.maxImagesCount = maxImagesCount;
                vc.mAlbum = wlvc.albums[0];
                vc.bSingleSelection = bSingleSelect;
                [wSelf pushViewController:vc animated:NO];
            }
            else {
                //一个相册也没有。。。ZQAlbumListVC显示无照片；相册获取的时候，无照片的相册被跳过
            }
            
        };
        return self;
        
    }
    else {
        ______WS();
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:_LocalizedString(@"OPERATE_PRIVACY") preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:_LocalizedString(@"OPERATION_OK") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [wSelf.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [[ZQTools rootViewController] presentViewController:alert animated:YES completion:NULL];
        return nil;
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = YES;
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//    UIBarButtonItem *barItem;
//    if (iOS9Later) {
//        barItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[ZQAlbumListVC class]]];
//    } else {
//        barItem = [UIBarButtonItem appearanceWhenContainedIn:[ZQAlbumListVC class], nil];
//    }
//#pragma clang diagnostic pop
//    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
//    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
//    [barItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.automaticallyAdjustsScrollViewInsets = NO;
    [super pushViewController:viewController animated:animated];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


@end