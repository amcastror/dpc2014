//
//  MisPuntosCulturalesViewController.m
//  diaPatrimonio
//
//  Created by Matias Castro on 08-03-13.
//  Copyright (c) 2013 Matias Castro. All rights reserved.
//

#import "MisPuntosCulturalesViewController.h"
#import "MisPuntosCulturales.h"
#import "PuntoCultural.h"
#import "PuntoCulturalViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GAI.h"
#import "GAITracker.h"

#define fuenteNombre [UIFont fontWithName:@"HelveticaNeue-Light" size:16]

@interface MisPuntosCulturalesViewController (){
    BOOL editando;
}

@end

@implementation MisPuntosCulturalesViewController

@synthesize tablaPuntosCulturales, filaPuntoCultural;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.title = NSLocalizedString(@"Mis puntos culturales", @"Mis puntos culturales");
        [[MisPuntosCulturales instance] requestMisPuntosCulturalesWithSuccess:^() {
           
        } AndFail:^(NSError *error) {
            
        }];
        editando = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.trackedViewName = @"mis_puntos";
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Editar" style:UIBarButtonItemStylePlain target:self action:@selector(editarPressed:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor darkTextColor]];
    vistaSinPuntos.layer.borderColor = [UIColor darkGrayColor].CGColor;
    vistaSinPuntos.layer.borderWidth = 1;
    vistaSinPuntos.layer.cornerRadius = 8;
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) { // if iOS 7
        self.edgesForExtendedLayout = UIRectEdgeNone; //layout adjustements
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [tablaPuntosCulturales reloadData];
    [self revisaVistaSinPuntos];
}

- (void) editarPressed:(id)sender{
    if (editando) {
        editando = NO;
        [sender setTitle:@"Editar"];
        [sender setTintColor:[UIColor darkTextColor]];
		[super setEditing:NO animated:YES];
		[self.tablaPuntosCulturales setEditing:NO animated:YES];
    }else{
        editando = YES;
        [sender setTitle:@"Listo"];
        [sender setTintColor:[UIColor redColor]];
		[super setEditing:YES animated:YES];
		[self.tablaPuntosCulturales setEditing:YES animated:YES];
    }
}

#pragma mark table delegate functions

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[MisPuntosCulturales instance] misPuntosCulturales] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"filaPuntoCultural" owner:self options:nil];
        cell = self.filaPuntoCultural;
        self.filaPuntoCultural = nil;
    }
    /*
    int alto_primera_fila = 0;
    if (indexPath.row == 0) {
        alto_primera_fila = 10;
    }
    */
    PuntoCultural *puntoCultural = [[[MisPuntosCulturales instance] misPuntosCulturales] objectAtIndex:indexPath.row];
    
    CGRect frame;
    
    /*
     1 - Label, nombre
     */
    
    UILabel *label;
    
    label = (UILabel *)[cell viewWithTag:1];
    
    CGSize size_nombre = [puntoCultural.nombre sizeWithFont:fuenteNombre
                                          constrainedToSize:CGSizeMake(170, 100000)
                                              lineBreakMode:NSLineBreakByTruncatingTail];
    frame = label.frame;
    frame.size.height = size_nombre.height;
    label.frame = frame;
    label.font = fuenteNombre;
    //label.backgroundColor = [UIColor greenColor];
    label.text = puntoCultural.nombre;
    
    /*
     4 - Label, categoria
     */
    
    int fin_nombre = frame.origin.y + frame.size.height;
    
    label = (UILabel *)[cell viewWithTag:4];
    switch (puntoCultural.id_tipo.intValue) {
        case TIPO_APERTURA:
            label.text = @"Apertura";
            break;
        case TIPO_ACTIVIDAD:
            label.text = @"Actividad";
            break;
        case TIPO_RECORRIDO_GUIADO:
            label.text = @"Recorrido guiado";
            break;
        case TIPO_RUTA_TEMATICA:
            label.text = @"Ruta temática";
            break;
        default:
            break;
    }
    
    frame = label.frame;
    frame.origin.y = fin_nombre + 5;
    label.frame = frame;
    //label.backgroundColor = [UIColor yellowColor];
    
    /*
     2 - imageview, visitado
     */
    
    UIImageView *imagenNoVisitado = (UIImageView *)[cell viewWithTag:20];
    UIImageView *imagenVisitado = (UIImageView *)[cell viewWithTag:21];
    imagenVisitado.hidden = YES;
    imagenNoVisitado.hidden = YES;
    
    if (puntoCultural.visitado) {
        imagenVisitado.hidden = NO;
    }else{
        imagenNoVisitado.hidden = NO;
    }
    /*
    frame = imagenVisitado.frame;
    frame.origin.y = frame.origin.y + alto_primera_fila;
    frame.origin.y = [self tableView:tableView heightForRowAtIndexPath:indexPath]/2 - frame.size.height/2 + alto_primera_fila;
    imagenVisitado.frame = frame;
    */
    /*
     3 - imageview, tipo
     */
    
    UIImageView *imagenTipo = (UIImageView *)[cell viewWithTag:3];
    switch (puntoCultural.id_tipo.intValue) {
        case TIPO_APERTURA:
            imagenTipo.image = [UIImage imageNamed:@"icono-categoria-apertura-02"];
            break;
        case TIPO_ACTIVIDAD:
            imagenTipo.image = [UIImage imageNamed:@"icono-categoria-actividad-02"];
            break;
        case TIPO_RECORRIDO_GUIADO:
            imagenTipo.image = [UIImage imageNamed:@"icono-categoria-recorrido-02"];
            break;
        case TIPO_RUTA_TEMATICA:
            imagenTipo.image = [UIImage imageNamed:@"icono-categoria-rutas-02"];
            break;
        default:
            break;
    }
    
    frame = imagenTipo.frame;
    frame.origin.y = [self tableView:tableView heightForRowAtIndexPath:indexPath]/2 - frame.size.height/2;
    imagenTipo.frame = frame;
    
    //icono-categoria-actividad-02
    /*
    UIImage *fondo;
    if (indexPath.row == 0) {
        fondo = [UIImage imageNamed:@"ficha-img-fondo-fila-arriba"];
    }else{
        fondo = [UIImage imageNamed:@"ficha-img-fondo-fila"];
    }
    
    UIImage *fondo_resizable = [fondo resizableImageWithCapInsets:UIEdgeInsetsMake(40.0, 40.0, 40.0, 40.0)];
    UIImageView *background = [[UIImageView alloc] initWithImage:fondo_resizable];
    cell.backgroundView = background;
     */
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PuntoCultural *puntoCultural = [[[MisPuntosCulturales instance] misPuntosCulturales] objectAtIndex:indexPath.row];
    
    PuntoCulturalViewController *puntoCulturalViewController = [[PuntoCulturalViewController alloc] initWithNibName:@"PuntoCulturalViewController" bundle:[NSBundle mainBundle] AndPuntoCultural:puntoCultural];
    puntoCulturalViewController.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dpc-nav-bar-logos"]];
    [[self navigationController] pushViewController:puntoCulturalViewController animated:YES];
    
    UIBarButtonItem *atras = [[UIBarButtonItem alloc] initWithTitle:@"Mi ruta" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    if([[UIBarButtonItem class] instancesRespondToSelector:@selector(setTintColor:)]){
        atras.tintColor = [UIColor darkGrayColor];
    }
    
    [self.navigationItem setBackBarButtonItem:atras];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        PuntoCultural *puntoCultural = [[[MisPuntosCulturales instance] misPuntosCulturales] objectAtIndex:indexPath.row];
        
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"Eliminando..."];
        [[MisPuntosCulturales instance] eliminarPuntoCultural:puntoCultural DeMisPuntosWithSuccess:^{
            [DejalBezelActivityView removeViewAnimated:YES];
            [self.tablaPuntosCulturales reloadData];
            [self revisaVistaSinPuntos];
        } AndFail:^(NSError *error) {
            [DejalBezelActivityView removeViewAnimated:YES];
            [self revisaVistaSinPuntos];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PuntoCultural *puntoCultural = [[[MisPuntosCulturales instance] misPuntosCulturales] objectAtIndex:indexPath.row];
    CGSize size_nombre = [puntoCultural.nombre sizeWithFont:fuenteNombre
                                  constrainedToSize:CGSizeMake(170, 100000)
                                      lineBreakMode:NSLineBreakByTruncatingTail];
    
    if (indexPath.row == 0) {
        return MAX((size_nombre.height + 10 + 25), 50);
    }else{
        return MAX((size_nombre.height + 10 + 25), 40);
    }
}

- (void) revisaVistaSinPuntos{
    if ([[[MisPuntosCulturales instance] misPuntosCulturales] count] == 0) {
        vistaSinPuntos.hidden = NO;
        tablaPuntosCulturales.hidden = YES;
    }else{
        vistaSinPuntos.hidden = YES;
        tablaPuntosCulturales.hidden = NO;
    }
}

@end
