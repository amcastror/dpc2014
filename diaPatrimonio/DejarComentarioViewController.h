//
//  DejarComentarioViewController.h
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 19-04-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuntoCultural.h"

@interface DejarComentarioViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>{
    IBOutlet UITextField *nombre_field;
    IBOutlet UITextField *titulo_field;
    IBOutlet UITextView *comentario_view;
    
    NSString *nombre;
    NSString *titulo;
    NSString *comentario;
    
    PuntoCultural *puntoCultural;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndPuntoCultural:(PuntoCultural *)punto;

@end
