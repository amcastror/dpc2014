//
//  ShareViewController.h
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 04-04-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UIViewController <UITextViewDelegate>{
    IBOutlet UISwitch *facebook;
    IBOutlet UISwitch *twitter;
    IBOutlet UITextView *comentario;
    IBOutlet UILabel *contadorCaracteres;
    IBOutlet UIButton *compartir;
}

@end
