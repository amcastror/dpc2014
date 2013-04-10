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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Editar" style:UIBarButtonItemStylePlain target:self action:@selector(editarPressed:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor lightGrayColor]];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"mis puntos: %@", [[MisPuntosCulturales instance] misPuntosCulturales]);
    [tablaPuntosCulturales reloadData];
}

- (void) editarPressed:(id)sender{
    if (editando) {
        editando = NO;
        [sender setTitle:@"Editar"];
        [sender setTintColor:[UIColor lightGrayColor]];
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
    
    PuntoCultural *puntoCultural = [[[MisPuntosCulturales instance] misPuntosCulturales] objectAtIndex:indexPath.row];
    
    /*
     1 - Label, nombre
     */
   
    UILabel *label;
    
    label = (UILabel *)[cell viewWithTag:1];
    label.text = puntoCultural.nombre;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PuntoCultural *puntoCultural = [[[MisPuntosCulturales instance] misPuntosCulturales] objectAtIndex:indexPath.row];
    
    PuntoCulturalViewController *puntoCulturalViewController = [[PuntoCulturalViewController alloc] initWithNibName:@"PuntoCulturalViewController" bundle:[NSBundle mainBundle] AndPuntoCultural:puntoCultural];
    [[self navigationController] pushViewController:puntoCulturalViewController animated:YES];
    
    UIBarButtonItem *atras = [[UIBarButtonItem alloc] initWithTitle:@"Mis puntos" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
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
        } AndFail:^(NSError *error) {
            [DejalBezelActivityView removeViewAnimated:YES];
        }];
    }
}

@end
