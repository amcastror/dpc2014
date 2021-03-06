//
//  DejarComentarioViewController.h
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 19-04-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "PuntoCultural.h"

@protocol ComentarDelegate <NSObject>
-(void)comentarioEnviado;
@end

@interface DejarComentarioViewController : GAITrackedViewController <UITextFieldDelegate, UITextViewDelegate>{
    IBOutlet UITextField *nombre_field;
    IBOutlet UITextView *comentario_view;
    
    IBOutlet UIButton *botonEnviar;
    IBOutlet UIButton *botonCancelar;
    
    NSString *nombre;
    NSString *titulo;
    NSString *comentario;
    
    PuntoCultural *puntoCultural;
    id<ComentarDelegate> delegate;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndPuntoCultural:(PuntoCultural *)punto AndDelegate:(id)_delegate;

@end
