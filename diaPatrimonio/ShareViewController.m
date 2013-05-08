//
//  ShareViewController.m
//  DiaDelPatrimonio
//
//  Created by Matias Castro on 04-04-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "GAI.h"
#import "GAITracker.h"
#import "ShareViewController.h"
#import "FacebookController.h"
#import "TwitterController.h"
#import <QuartzCore/QuartzCore.h>

@interface ShareViewController (){
    UIImage *imagenSeleccionada;
    int catacteresImg;
}

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
    self.trackedViewName = @"share";
    
    [facebook addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    [twitter addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    [self actualizarBotonCompartir];
    
    UIImageView *fondo_blanco = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 45)];
    fondo_blanco.image = [[UIImage imageNamed:@"fondo-blanco"] resizableImageWithCapInsets:UIEdgeInsetsMake(40.0, 40.0, 40.0, 40.0)];
    [self.view addSubview:fondo_blanco];
    [self.view sendSubviewToBack:fondo_blanco];
    
    UIImageView *fondo_gris = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, 300, 210)];
    fondo_gris.image = [[UIImage imageNamed:@"fondo-gris"] resizableImageWithCapInsets:UIEdgeInsetsMake(40.0, 40.0, 40.0, 40.0)];
    [self.view addSubview:fondo_gris];
    [self.view sendSubviewToBack:fondo_gris];
    
    UIImageView *segundo_blanco = [[UIImageView alloc] initWithFrame:CGRectMake(10, 245, 300, 37)];
    segundo_blanco.image = [[UIImage imageNamed:@"fondo-blanco"] resizableImageWithCapInsets:UIEdgeInsetsMake(40.0, 40.0, 40.0, 40.0)];
    [self.view addSubview:segundo_blanco];
    [self.view sendSubviewToBack:segundo_blanco];
    
    UIImageView *segundo_gris = [[UIImageView alloc] initWithFrame:CGRectMake(10, 272, 300, 80)];
    segundo_gris.image = [[UIImage imageNamed:@"fondo-gris"] resizableImageWithCapInsets:UIEdgeInsetsMake(40.0, 40.0, 40.0, 40.0)];
    [self.view addSubview:segundo_gris];
    [self.view sendSubviewToBack:segundo_gris];
    comentario.layer.borderColor = [UIColor lightGrayColor].CGColor;
    comentario.layer.borderWidth = 0.5;
    comentario.layer.cornerRadius = 5;
    
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
    
    if ([[TwitterController instance] twitterOn]) {
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
            
        }else{
            int caracteresImg = 0;
            if (imagenSeleccionada) {
                caracteresImg = 23;
            }
            if ([comentario.text length] + caracteresImg <= 140) {
                if (![[TwitterController instance] twitterOn]) {
                    [[TwitterController instance] loginWithSender:self AndHandler:^(NSError *error) {
                        if (!error) {
                            [twitter setOn:YES];
                        }else{
                            [twitter setOn:NO];
                        }
                    }];
                }
            }else{
                twitter.on = NO;
            }
        }
    }
    [self actualizarBotonCompartir];
}

- (IBAction)compartirPressed:(id)sender{
    //Tengo que hacer la lógica de comartir
    int imagen = 0;
    if (imagenSeleccionada) {
        imagen = 1;
    }
    
    if (facebook.on) {
        
        NSDictionary *parametros = [[NSDictionary alloc] initWithObjectsAndKeys:
                                           //linkURL, @"link",
                                           //@"http://www.paonde.com/web/img/logo/logo_paonde.png", @"picture",
                                           //imageURL, @"picture",
                                           //name, @"name",
                                           comentario.text, @"message",
                                           //caption,@"caption",
                                           //description, @"description",
                                           nil];
        [[FacebookController instance] publishStoryOnWallWithParams:parametros AndImage:imagenSeleccionada AndAttemps:1 AndCompletitionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"err: %@", error);
            }
            
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            [tracker trackEventWithCategory:@"UI" withAction:@"share" withLabel:@"FB" withValue:[NSNumber numberWithInt:imagen]];

        }];
    }
    if (twitter.on) {
        [[TwitterController instance] enviarTweet:comentario.text ConImagen:imagenSeleccionada YHandler:^(NSError *error) {
            if (error) {
                NSLog(@"err: %@", error);
            }
            
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            [tracker trackEventWithCategory:@"UI" withAction:@"share" withLabel:@"TW" withValue:[NSNumber numberWithInt:imagen]];
        }];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@"Listo!" message:@"Gracias por compartir!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (IBAction)tomarFotoPressed:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Obtener imagen desde:"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Cámara", @"Biblioteca", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
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
    [self actualizarBotonCompartir];
}

- (void)textViewDidChange:(UITextView *)textView{
    if([comentario.text isEqualToString:@"Escribe un comentario"]){
        comentario.text = @"";
        contadorCaracteres.text = @"0 caracteres";
    }else{
        int caracteresImg = 0;
        NSString *img = @"";
        if (imagenSeleccionada) {
            caracteresImg = 23;
            img = @" (incluída la imagen)";
        }
        contadorCaracteres.text = [NSString stringWithFormat:@"%i caracteres%@", [comentario.text length] + caracteresImg, img];
        
        if ([comentario.text length] + caracteresImg > 140) {
            twitter.on = NO;
        }
    }
    [self actualizarBotonCompartir];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([comentario isFirstResponder] && [touch view] != comentario) {
        [comentario resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (void) actualizarBotonCompartir{
    if (!facebook.on && !twitter.on) {
        compartir.enabled = NO;
    }else{
        if([comentario.text isEqualToString:@"Escribe un comentario"]){
            compartir.enabled = NO;
        }else{
            compartir.enabled = YES;
        }
    }
}

#pragma mark - uiactionsheet delegate methods

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //From Camera
        [self imagenDesdeCamara];
    }
    else if (buttonIndex == 1) {
        //From Video Library
        [self imagenDesdeBiblioteca];
    }
    else if (buttonIndex == 2) {
        //Cancel
    }
}

- (void)imagenDesdeCamara
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([mediaTypes containsObject:(NSString *)kUTTypeImage])
        {
            UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
            cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
            cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
            cameraUI.allowsEditing = YES;
            cameraUI.delegate = self;
            
            [self presentModalViewController:cameraUI animated:YES];
        }
        else {
            UIAlertView *alertB = [[UIAlertView alloc] initWithTitle:@"Lo sentimos" message:@"No es posible tomar una foto" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertB show];
        }
    }
    else {
        UIAlertView *alertA = [[UIAlertView alloc] initWithTitle:@"Lo sentimos" message:@"No detectamos una cámara" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertA show];
    }
}

- (void) imagenDesdeBiblioteca
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        if ([mediaTypes containsObject:(NSString *)kUTTypeImage]) {
            UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
            cameraUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
            cameraUI.allowsEditing = YES;
            cameraUI.delegate = self;
            
            [self presentModalViewController:cameraUI animated:YES];
        }
        else {
            UIAlertView *alertB = [[UIAlertView alloc] initWithTitle:@"Lo sentimos" message:@"La biblioteca de fotos no está disponible" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertB show];
        }
    }
    else {
        UIAlertView *alertA = [[UIAlertView alloc] initWithTitle:@"Lo sentimos" message:@"No encontramos imágenes para usar" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertA show];
    }
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) imagePickerController:(UIImagePickerController *) picker
 didFinishPickingMediaWithInfo:(NSDictionary *) info {
    [self dismissModalViewControllerAnimated: YES];
    
    imagenSeleccionada = [info objectForKey:UIImagePickerControllerEditedImage];
    [self textViewDidChange:comentario];
    
}

@end
