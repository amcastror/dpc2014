//
//  PerfilViewController.h
//  diaPatrimonio
//
//  Created by Matias Castro on 03-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerfilViewController : UIViewController{
    IBOutlet UILabel *estadoSesionFacebook;
    IBOutlet UIButton *publish;
    IBOutlet UISwitch *facebookSwitch;
}

@property (nonatomic, strong) IBOutlet UILabel *estadoSesionFacebook;
@property (nonatomic, strong) IBOutlet UIButton *publish;
@property (nonatomic, strong) IBOutlet UISwitch *facebookSwitch;


@end
