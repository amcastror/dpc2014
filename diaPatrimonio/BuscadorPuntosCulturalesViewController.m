//
//  BuscadorPuntosCulturalesViewController.m
//  diaPatrimonio
//
//  Created by Matias Castro on 23-02-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "BuscadorPuntosCulturalesViewController.h"
#import "PuntosCulturales.h"
#import "Filtros.h"

@interface BuscadorPuntosCulturalesViewController ()

@end

@implementation BuscadorPuntosCulturalesViewController

@synthesize botonCancelar, botonZonas, botonBuscar, botonSubZonas, textoABuscar;

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
    if ([[Filtros instance] zona_seleccionada]) {
        //[botonZonas setTitle:[[[Filtros instance] zona_seleccionada] nombre] forState:UIControlStateNormal];
    }
    if ([[Filtros instance] sub_zona_seleccionada]) {
        //[botonSubZonas setTitle:[[[Filtros instance] sub_zona_seleccionada] nombre] forState:UIControlStateNormal];
    }
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self actualizaBusqueda];
    
    if ([[Filtros instance] zona_seleccionada]) {
        [botonZonas setTitle:[[[Filtros instance] zona_seleccionada] nombre] forState:UIControlStateNormal];
    }
    if ([[Filtros instance] sub_zona_seleccionada]) {
        [botonSubZonas setTitle:[[[Filtros instance] sub_zona_seleccionada] nombre] forState:UIControlStateNormal];
    }
    if ([[Filtros instance] texto_ingresado]) {
        textoABuscar.text = [[Filtros instance] texto_ingresado];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - acciones botones

- (IBAction)botonCancelarPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)botonBuscarPressed:(id)sender{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Buscando..."];
    [[PuntosCulturales instance] buscarPuntosCulturalesConFiltrosActivosWithSuccess:^{
        [DejalBezelActivityView removeViewAnimated:YES];
        [self dismissModalViewControllerAnimated:YES];
    } AndFail:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
    }];
}

- (IBAction)botonZonas:(id)sender{
    [botonSubZonas setSelected:NO];
    if ([sender isSelected]) {
        [self esconderPicker:self];
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
        [self esconderPicker:self];
        [picker reloadAllComponents];
        [self mostrarPicker:self];
        if ([[Filtros instance] zona_seleccionada]) {
            [picker selectRow:[[[Filtros instance] zonas] indexOfObject:[[Filtros instance] zona_seleccionada]]+1
                      inComponent:0
                         animated:YES];
        }else{
            [picker selectRow:0 inComponent:0 animated:YES];
        }
    
    }
}

- (IBAction)botonSubZonas:(id)sender{
    [botonZonas setSelected:NO];
    if ([sender isSelected]) {
        [self esconderPicker:self];
        [sender setSelected:NO];
    }else{
        if (![[Filtros instance] zona_seleccionada]) {
            [[[UIAlertView alloc] initWithTitle:@"Alerta" message:@"Debes seleccionar una zona primero" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
        
        [sender setSelected:YES];
        [self esconderPicker:self];
        [picker reloadAllComponents];
        [self mostrarPicker:self];
        if ([[Filtros instance] sub_zona_seleccionada]) {
            Zona *zona_seleccionada = [[Filtros instance] zona_seleccionada];
            [picker selectRow:[[zona_seleccionada sub_zonas] indexOfObject:[[Filtros instance] sub_zona_seleccionada]]+1
                      inComponent:0
                         animated:YES];
        }else{
            [picker selectRow:0 inComponent:0 animated:YES];
        }
    }
}

- (IBAction)esconderPicker:(id)sender{
    if ([sender class] == [UIBarButtonItem class]) {
        [botonZonas setSelected:NO];
        [botonSubZonas setSelected:NO];
    }
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent
                     animations: ^{
                         CGRect myRect = pickerView.frame;
                         
                         //Soporte en el mapa para iPhone 5
                         CGRect screenBounds = [[UIScreen mainScreen] bounds];
                         int origen_b_aqui = 460;
                         if (screenBounds.size.height == 568) {
                             origen_b_aqui = 548;
                         }
                         
                         myRect.origin.y = origen_b_aqui;
                         pickerView.frame = myRect;
                     }
                     completion:nil];
}

- (IBAction)mostrarPicker:(id)sender{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent
                     animations: ^{
                         CGRect myRect = pickerView.frame;
                         
                         //Soporte en el mapa para iPhone 5
                         CGRect screenBounds = [[UIScreen mainScreen] bounds];
                         int origen_b_aqui = 200;
                         if (screenBounds.size.height == 568) {
                             origen_b_aqui = 288;
                         }
                         
                         myRect.origin.y = origen_b_aqui;
                         pickerView.frame = myRect;
                     }
                     completion:nil];
}

- (void) actualizaBusqueda{
    NSString *stringBusqueda = @"Buscar";
    
    if ([textoABuscar.text isEqualToString:@""]) {
        stringBusqueda = [stringBusqueda stringByAppendingString:@" todo"];
    }else{
        stringBusqueda = [stringBusqueda stringByAppendingFormat:@" %@", textoABuscar.text];
    }
    
    if ([[Filtros instance] zona_seleccionada]) {
        stringBusqueda = [stringBusqueda stringByAppendingFormat:@" en la zona %@", [[[Filtros instance] zona_seleccionada] nombre]];
        
        if ([[Filtros instance] sub_zona_seleccionada]) {
            stringBusqueda = [stringBusqueda stringByAppendingFormat:@", específicamente en la sub zona %@", [[[Filtros instance] sub_zona_seleccionada] nombre]];
        }
    }else{
        stringBusqueda = [stringBusqueda stringByAppendingString:@" en todas las zonas"];
    }
    
    busqueda.text = stringBusqueda;
}

#pragma mark - picker delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    if ([botonZonas isSelected]) {
        return [[[Filtros instance] zonas] count] + 1; //el +1 es por todas las zonas
    }else{
        Zona *zona_seleccionada = [[Filtros instance] zona_seleccionada]; 
        return [[zona_seleccionada sub_zonas] count] + 1;//el +1 es por todas las zonas
    }
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *zonas;
    NSString *titulo;
    if ([botonZonas isSelected]) {
        titulo = @"Toda las zonas...";
        zonas = [[Filtros instance] zonas];
    }else{
        titulo = @"Todas las sub zonas...";
        zonas = [[[Filtros instance] zona_seleccionada] sub_zonas];
    }
    if (row == 0) {
        return titulo;
    }else{
        return [[zonas objectAtIndex:row-1] nombre];
    }
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSArray *zonas;
    NSString *titulo;
    if ([botonZonas isSelected]) {
        titulo = @"Toda las zonas...";
        zonas = [[Filtros instance] zonas];
    }else{
        titulo = @"Todas las sub zonas...";
        zonas = [[[Filtros instance] zona_seleccionada] sub_zonas];
    }
    
    if (row == 0) {
        //Borro el filtro...
        if ([botonZonas isSelected]) {
            [[Filtros instance] setZona_seleccionada:nil];
            [botonZonas setTitle:titulo forState:UIControlStateNormal];
            
            [[Filtros instance] setSub_zona_seleccionada:nil];
            [botonSubZonas setTitle:@"Todas las sub zonas..." forState:UIControlStateNormal];
        }else{
            [[Filtros instance] setSub_zona_seleccionada:nil];
            [botonSubZonas setTitle:titulo forState:UIControlStateNormal];
        }
    }else{
        //agrego el filtro...
        if ([botonZonas isSelected]) {
            [[Filtros instance] setZona_seleccionada:[zonas objectAtIndex:row-1]];
            [botonZonas setTitle:[[zonas objectAtIndex:row-1] nombre] forState:UIControlStateNormal];
            
            [[Filtros instance] setSub_zona_seleccionada:nil];
            [botonSubZonas setTitle:@"Todas las sub zonas..." forState:UIControlStateNormal];
        }else{
            [[Filtros instance] setSub_zona_seleccionada:[zonas objectAtIndex:row-1]];
            [botonSubZonas setTitle:[[zonas objectAtIndex:row-1] nombre] forState:UIControlStateNormal];
        }
    }
    [self actualizaBusqueda];
}

#pragma mark - text field delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{

    textField.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self actualizaBusqueda];
    [[Filtros instance] setTexto_ingresado:textoABuscar.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [self esconderPicker:self];
    [super touchesBegan:touches withEvent:event];
}

@end
