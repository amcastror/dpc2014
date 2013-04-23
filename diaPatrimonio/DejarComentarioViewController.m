//
//  DejarComentarioViewController.m
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 19-04-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "DejarComentarioViewController.h"

@interface DejarComentarioViewController ()

@end

@implementation DejarComentarioViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndPuntoCultural:(PuntoCultural *)punto
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        puntoCultural = punto;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
        frame.origin.y = frame.origin.y + 150;
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        //
    }];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = frame.origin.y - 150;
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
