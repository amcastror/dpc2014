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
#import "GAI.h"
#import "GAITracker.h"

@interface BuscadorPuntosCulturalesViewController ()

@end

@implementation BuscadorPuntosCulturalesViewController

@synthesize botonCancelar, botonZonas, botonBuscar, botonSubZonas, textoABuscar, botonCategorias;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [picker setShowsSelectionIndicator:YES];
        tipoBusqueda = BUSQUEDA_NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"busqueda";
    if ([[Filtros instance] zona_seleccionada]) {
        //[botonZonas setTitle:[[[Filtros instance] zona_seleccionada] nombre] forState:UIControlStateNormal];
    }
    if ([[Filtros instance] sub_zona_seleccionada]) {
        //[botonSubZonas setTitle:[[[Filtros instance] sub_zona_seleccionada] nombre] forState:UIControlStateNormal];
    }
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([[Filtros instance] zona_seleccionada]) {
        [botonZonas setTitle:[[[Filtros instance] zona_seleccionada] nombre] forState:UIControlStateNormal];
    }
    if ([[Filtros instance] sub_zona_seleccionada]) {
        [botonSubZonas setTitle:[[[Filtros instance] sub_zona_seleccionada] nombre] forState:UIControlStateNormal];
    }
    if ([[Filtros instance] categoria_seleccionada]) {
        [botonCategorias setTitle:[[[[Filtros instance] categorias] objectAtIndex:[[[Filtros instance] categoria_seleccionada] intValue] -1] objectForKey:@"n"] forState:UIControlStateNormal];
    }
    if ([[Filtros instance] texto_ingresado]) {
        textoABuscar.text = [[Filtros instance] texto_ingresado];
    }
    
    [self actualizaBusqueda];
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
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker trackEventWithCategory:@"UI" withAction:@"buscar" withLabel:@"filtros" withValue:nil];
    } AndFail:^(NSError *error) {
        [DejalBezelActivityView removeViewAnimated:YES];
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"No se pudo realizar la búsqueda, intenta de nuevo más tarde" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (IBAction)botonZonas:(id)sender{
    [botonSubZonas setSelected:NO];
    [botonCategorias setSelected:NO];
    
    tipoBusqueda = BUSQUEDA_ZONAS;
    
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
    [botonCategorias setSelected:NO];
    
    tipoBusqueda = BUSQUEDA_SUB_ZONAS;
    
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

- (IBAction)botonCategorias:(id)sender{
    [botonSubZonas setSelected:NO];
    [botonZonas setSelected:NO];
    
    tipoBusqueda = BUSQUEDA_CATEGORIAS;
    
    if ([sender isSelected]) {
        [self esconderPicker:self];
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
        [self esconderPicker:self];
        [picker reloadAllComponents];
        [self mostrarPicker:self];
        if ([[Filtros instance] categoria_seleccionada]) {
            [picker selectRow:[[[Filtros instance] categorias] indexOfObject:[[Filtros instance] categoria_seleccionada]]+1
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
        [botonCategorias setSelected:NO];
    }
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent
                     animations: ^{
                         CGRect myRect = pickerView.frame;
                         
                         int origen_b_aqui = self.view.frame.size.height;
                         
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
                         
                         int origen_b_aqui = self.view.frame.size.height - pickerView.frame.size.height;
                         
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
    
    if ([[Filtros instance] categoria_seleccionada]) {
        
        stringBusqueda = [stringBusqueda stringByAppendingFormat:@" en %@", [[[[Filtros instance] categorias] objectAtIndex:[[[Filtros instance] categoria_seleccionada] intValue] -1] objectForKey:@"n"]];
    }else{
        stringBusqueda = [stringBusqueda stringByAppendingString:@" en todas las categorías"];
    }
    
    if ([[Filtros instance] zona_seleccionada]) {
        stringBusqueda = [stringBusqueda stringByAppendingFormat:@", en la zona %@", [[[Filtros instance] zona_seleccionada] nombre]];
        
        if ([[Filtros instance] sub_zona_seleccionada]) {
            stringBusqueda = [stringBusqueda stringByAppendingFormat:@", específicamente en %@", [[[Filtros instance] sub_zona_seleccionada] nombre]];
        }
    }else{
        stringBusqueda = [stringBusqueda stringByAppendingString:@", en todas las zonas"];
    }
    
    busqueda.text = stringBusqueda;
}

#pragma mark - picker delegate methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    if (tipoBusqueda == BUSQUEDA_ZONAS) {
        return [[[Filtros instance] zonas] count] + 1; //el +1 es por todas las zonas
    }else if(tipoBusqueda == BUSQUEDA_SUB_ZONAS){
        Zona *zona_seleccionada = [[Filtros instance] zona_seleccionada]; 
        return [[zona_seleccionada sub_zonas] count] + 1;//el +1 es por todas las zonas
    }else{
        return [[[Filtros instance] categorias] count] + 1;
    }
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (tipoBusqueda == BUSQUEDA_ZONAS) {
        if (row == 0) {
            return @"Toda las zonas...";
        }else{
            return [[[[Filtros instance] zonas] objectAtIndex:row-1] nombre];
        }
    }else if(tipoBusqueda == BUSQUEDA_SUB_ZONAS){
        if (row == 0) {
            return @"Toda las sub zonas...";
        }else{
            return [[[[[Filtros instance] zona_seleccionada] sub_zonas] objectAtIndex:row-1] nombre];
        }
    }else{
        if (row == 0) {
            return @"Todas las categorías...";
        }else{
            return [[[[Filtros instance] categorias] objectAtIndex:row-1] objectForKey:@"n"];
        }
    }
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (tipoBusqueda == BUSQUEDA_ZONAS) {
        if (row == 0) {
            [[Filtros instance] setZona_seleccionada:nil];
            [botonZonas setTitle:@"Todas las zonas..." forState:UIControlStateNormal];
            
            [[Filtros instance] setSub_zona_seleccionada:nil];
            [botonSubZonas setTitle:@"Todas las sub zonas..." forState:UIControlStateNormal];
        }else{
            NSArray *zonas = [[Filtros instance] zonas];
            
            [[Filtros instance] setZona_seleccionada:[zonas objectAtIndex:row-1]];
            [botonZonas setTitle:[[zonas objectAtIndex:row-1] nombre] forState:UIControlStateNormal];
            
            [[Filtros instance] setSub_zona_seleccionada:nil];
            [botonSubZonas setTitle:@"Todas las sub zonas..." forState:UIControlStateNormal];
        }
    }else if(tipoBusqueda == BUSQUEDA_SUB_ZONAS){
        if (row == 0) {
            [[Filtros instance] setSub_zona_seleccionada:nil];
            [botonSubZonas setTitle:@"Todas las sub zonas..." forState:UIControlStateNormal];
        }else{
            NSArray *zonas = [[[Filtros instance] zona_seleccionada] sub_zonas];
            
            [[Filtros instance] setSub_zona_seleccionada:[zonas objectAtIndex:row-1]];
            [botonSubZonas setTitle:[[zonas objectAtIndex:row-1] nombre] forState:UIControlStateNormal];
        }
    }else{
        if (row == 0) {
            [[Filtros instance] setCategoria_seleccionada:nil];
            [botonCategorias setTitle:@"Todas las categorías" forState:UIControlStateNormal];
        }else{
            NSArray *categorias = [[Filtros instance] categorias];

            [[Filtros instance] setCategoria_seleccionada:[[categorias objectAtIndex:row-1] objectForKey:@"id"]];
            [botonCategorias setTitle:[[categorias objectAtIndex:row-1] objectForKey:@"n"] forState:UIControlStateNormal];
        }
    }
    [self actualizaBusqueda];
}

#pragma mark - text field delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = frame.origin.y - 150;
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        //
    }];

    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    tipoBusqueda = BUSQUEDA_NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = frame.origin.y + 150;
        self.view.frame = frame;
    } completion:^(BOOL finished) {
        //
    }];
    
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
