//
//  PerfilViewController.h
//  diaPatrimonio
//
//  Created by Matias Castro on 03-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "FacebookController.h"
#import "TwitterController.h"

@interface PerfilViewController : GAITrackedViewController <UIActionSheetDelegate, twitter> {
    IBOutlet UILabel *estadoSesionFacebook;
    IBOutlet UILabel *estadoSesionTwitter;
    IBOutlet UIButton *publish;
    IBOutlet UISwitch *facebookSwitch;
    IBOutlet UISwitch *twitterSwitch;
    IBOutlet UIButton *cuentaPorDefecto;
    IBOutlet UILabel *nombreCuenta;
}

@property (nonatomic, strong) IBOutlet UILabel *estadoSesionFacebook;
@property (nonatomic, strong) IBOutlet UILabel *estadoSesionTwitter;
@property (nonatomic, strong) IBOutlet UIButton *publish;
@property (nonatomic, strong) IBOutlet UISwitch *facebookSwitch;
@property (nonatomic, strong) IBOutlet UISwitch *twitterSwitch;


@end
