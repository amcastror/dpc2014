//
//  DejarComentarioViewController.m
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 19-04-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "DejarComentarioViewController.h"
#import "FacebookController.h"
#import <QuartzCore/QuartzCore.h>
#import "GAI.h"
#import "GAITracker.h"

@interface DejarComentarioViewController ()

@end

@implementation DejarComentarioViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndPuntoCultural:(PuntoCultural *)punto AndDelegate:(id)_delegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        puntoCultural = punto;
        delegate = _delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"dejar_comentario";
    
    if ([[FacebookController instance] tengoSession]) {
        nombre_field.text = [[FacebookController instance] nombre_usuario];
        nombre = [[FacebookController instance] nombre_usuario];
    }
    
    UIImageView *fondo_blanco = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 45)];
    fondo_blanco.image = [[UIImage imageNamed:@"fondo-blanco"] resizableImageWithCapInsets:UIEdgeInsetsMake(40.0, 40.0, 40.0, 40.0)];
    [self.view addSubview:fondo_blanco];
    [self.view sendSubviewToBack:fondo_blanco];
    
    UIImageView *fondo_gris = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, 300, 300)];
    fondo_gris.image = [[UIImage imageNamed:@"fondo-gris"] resizableImageWithCapInsets:UIEdgeInsetsMake(40.0, 40.0, 40.0, 40.0)];
    [self.view addSubview:fondo_gris];
    [self.view sendSubviewToBack:fondo_gris];

    comentario_view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    comentario_view.layer.borderWidth = 0.5;
    comentario_view.layer.cornerRadius = 5;
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) { // if iOS 7
        self.edgesForExtendedLayout = UIRectEdgeNone; //layout adjustements
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([nombre_field isFirstResponder] && [touch view] != nombre_field) {
        [nombre_field resignFirstResponder];
    }
    if ([titulo_field isFirstResponder] && [touch view] != titulo_field) {
        [titulo_field resignFirstResponder];
    }
    if ([comentario_view isFirstResponder] && [touch view] != comentario_view) {
        [comentario_view resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - text field delegate methods

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == nombre_field) {
        nombre = textField.text;
    }else if(textField == titulo_field){
        titulo = textField.text;
    }
}

#pragma mark - text view delegate methods

-(void)textViewDidEndEditing:(UITextView *)textView{
    comentario = textView.text;
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = frame.origin.y + 130;
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        //
    }];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = frame.origin.y - 130;
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        //
    }];
}

#pragma mark - acciones

-(IBAction)enviarComentario:(id)sender{
    if (!titulo || [titulo isEqualToString:@""]) {
        titulo = @"sin titulo";
    }
    if(
        !nombre || !titulo || !comentario ||
       [nombre isEqualToString:@""] ||
       [titulo isEqualToString:@""] ||
       [comentario isEqualToString:@""]
        ){
        [[[UIAlertView alloc] initWithTitle:@"Alerta" message:@"Debes completar toda la información primero" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Enviando..."];
    [puntoCultural requestDejarComentarioConAutor:nombre Titulo:titulo YComentario:comentario WithSuccess:^{
        [DejalBezelActivityView removeViewAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:^{
            [[[UIAlertView alloc] initWithTitle:@"Gracias!" message:@"Gracias por dejarnos tu comentario" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            [delegate comentarioEnviado];
        }];
    } AndFail:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
        NSLog(@"err: %@", error);
        [self dismissViewControllerAnimated:YES completion:^{
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Ha ocurrido un error, por favor intenta más tarde" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }];
    }];
    
}

-(IBAction)cancelarPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

@end
