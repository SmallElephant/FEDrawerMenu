//
//  MasterViewController.m
//  FEDrawerMenu
//
//  Created by keso on 16/2/1.
//  Copyright © 2016年 FlyElephant. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#define SCREENWIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREENHEIGHT [[UIScreen mainScreen] bounds].size.height
#define MAXYOFFSET   200
#define ENDRIGHTX    200
#define ENDLEFTX    -200

@interface MasterViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSMutableArray *dataSource;
@property (strong,nonatomic) UITableView  *tableView;

@property (strong,nonatomic) UIView *leftDrawer;
@property (strong,nonatomic) UIView *rightDrawer;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //    [self configData];
    [self configData];
    NSLog(@"%d---%f",-10,fabs(-10.2));
    //        [self.tableView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    //    [self.tableView removeObserver:self forKeyPath:@"frame"];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString * cellIdentifier=@"CELLFLAG";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell.textLabel setText:self.dataSource[indexPath.row]];
    return cell;
}

#pragma mark touch method

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.tableView];
    CGPoint prePoint = [touch previousLocationInView:self.tableView];
}


#pragma mark - UIPanGesture method

-(void)panGestureRecognizer:(UIPanGestureRecognizer *)panGesture{
    CGPoint transition = [panGesture translationInView:self.tableView];
    self.tableView.frame=[self panGestureOffset:transition.x];
    [panGesture setTranslation:CGPointZero inView:self.tableView];
    //拖动手势结束
    if (panGesture.state==UIGestureRecognizerStateEnded) {
        CGFloat originX =self.tableView.frame.origin.x;
        CGFloat offsetX=0;
        //大于屏幕的一半进入新的位置
        if (originX > SCREENWIDTH*0.5) {
            offsetX=ENDRIGHTX-originX;
        }else if(originX < SCREENWIDTH*0.5 && originX > -SCREENWIDTH*0.5){
            //小于屏幕的一半，大于屏幕负一半的时候，则恢复到初始状态
            offsetX=offsetX-originX;
        }else if (originX<-SCREENWIDTH*0.5){
            offsetX=ENDLEFTX-originX;
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.frame=[self panGestureOffset:offsetX];
        }];
    }
}

-(CGRect)panGestureOffset:(CGFloat)offsetX{
    offsetX=self.tableView.frame.origin.x+offsetX;
    CGFloat offsetY = offsetX/SCREENWIDTH * MAXYOFFSET;
    //如果需要设置右边的抽屉，参数为负数，需要取绝对值
    CGFloat scale = (SCREENHEIGHT-fabs(2*offsetY))/SCREENHEIGHT;
    CGFloat height = SCREENHEIGHT*scale;
    CGFloat width  = SCREENWIDTH;
    CGFloat x = offsetX;
    CGFloat y = (SCREENHEIGHT- height)* 0.5;
    
    return CGRectMake(x, y, width, height);
}

#pragma mark getter and setter
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]init];
    }
    return _dataSource;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

-(UIView *)leftDrawer{
    if (!_leftDrawer) {
        _leftDrawer=[[UIView alloc]initWithFrame:self.view.bounds];
        [_leftDrawer setBackgroundColor:[UIColor redColor]];
    }
    return _leftDrawer;
}

#pragma mark config method

-(void)configData{
    //http://www.jianshu.com/users/24da48b2ddb3/latest_articles
    for (NSInteger i=0;i<5; i++) {
        [self.dataSource addObject:[NSString stringWithFormat:@"FlyElephant-%ld",i]];
    }
    
    [self.view addSubview:self.leftDrawer];
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self.tableView addGestureRecognizer:panGesture];
    [self.view addSubview:self.tableView];
}



@end
