//
//  ShareViewController.m
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 04-04-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "ShareViewController.h"
#import "FacebookController.h"
#import "TwitterController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [facebook addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    [twitter addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    //veo si tengo sesion en FB, si no tengo, trato de abrir una silenciosamente. Al terminar esa acción reviso de nuevo.
    if ([[FacebookController instance] tengoSession]) {
        [facebook setOn:YES];
    }else{
        [[FacebookController instance] trataDeAbrirSesionWithUI:NO
                                                     AndHandler:^(NSError *error) {
                                                         if ([[FacebookController instance] tengoSession]) {
                                                             [facebook setOn:YES];
                                                         }
                                                     }];
    }
    
    if ([[TwitterController instance] tengoCuentas]) {
        [twitter setOn:YES];
    }else{
        [twitter setOn:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - acciones

- (void)switchValueChange:(id)sender{
    if (sender == facebook) {
        if (![facebook isOn]) {
            NSLog(@"apago facebook");
        }else{
            NSLog(@"prendo facebook");
            [[FacebookController instance] trataDeAbrirSesionWithUI:YES AndHandler:^(NSError *error) {
                if (![[FacebookController instance] tengoSession]) {
                    NSLog(@"No aceptó la sesión");
                    [facebook setOn:NO];
                }
                
            }];
        }
    }else if (sender == twitter){
        if (![twitter isOn]) {
            NSLog(@"apago twitter");
        }else{
            [[TwitterController instance] conectarseALasCuentasDelUsuarioWith:^(NSError *error) {
                if (!error) {
                    [twitter setOn:YES];
                }else{
                    [twitter setOn:NO];
                }
            }];
        }
    }
}

- (IBAction)compartirPressed:(id)sender{
    //Tengo que hacer la lógica de comartir
    NSLog(@"tengo que compartir el texto: %@", comentario.text);
    if (facebook.on) {
        NSLog(@"en facebook");
    }
    if (twitter.on) {
        [[TwitterController instance] enviarTweetWith:^(NSError *error) {
            //
        }];
    }
}

#pragma mark - text view delegate methods


- (void)textViewDidBeginEditing:(UITextView *)textView{
    if([comentario.text isEqualToString:@"Escribe un comentario"]){
        comentario.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{    
    if(comentario.text.length == 0){
        comentario.text = @"Escribe un comentario";
    }else {
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([comentario isFirstResponder] && [touch view] != comentario) {
        [comentario resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

@end
