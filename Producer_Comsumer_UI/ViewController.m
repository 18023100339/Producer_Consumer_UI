//
//  ViewController.m
//  Producer_Comsumer_UI
//
//  Created by Liu_zc on 2021/1/6.
//  Copyright © 2021 Liu_zc. All rights reserved.
//

#import "ViewController.h"
#define N 25  //缓存池大小
//NSTimer *timer;

bool com = false; //是否要结束消费者进程
bool pro = false; //是否要结束生产者进程
int buffer[N] = {0}; //缓存池
int inWhere = 0; //生产在哪
int outWhere = 0; //消费在哪
int proCount = 0; //产品号，递增
int mutex = 1; //互斥使用信号量
int empty = N; //消费者信号量
int full = 0; //生产者信号量
int proCmutex = 1; //互斥
 
@interface ViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *cv;
@end

@implementation ViewController
-(void)producer{
    while(true){
        
        //互斥增加产品计数
        while(proCmutex <= 0);
        proCmutex--;
        proCount++;
        proCmutex++;
        
        //缓存区满，阻塞
        while(empty <= 0){
            printf("缓冲区已满,生产者线程被阻塞\n");
            [NSThread sleepForTimeInterval:3];
        }
        empty--;
 
        //互斥使用缓存池
        while(mutex <= 0);
        mutex--;
        buffer[inWhere] = proCount;
        inWhere = (inWhere + 1) % (N);
        mutex++;
        full++;
        printf("生产一个产品ID%d, 缓冲区位置为%d\n",proCount,inWhere);
        
        
        //渲染UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cv reloadData];
        });

        //延迟3秒
        [NSThread sleepForTimeInterval:3];

        //判断是否取消线程
        if (pro == false) {
            return;
        }
        
    }
}
 
-(void)consumer{
    while(true){
        while(full <= 0){
            printf("\t\t\t\t\t\t\t\t缓冲区为空，消费者线程被阻塞\n");
            [NSThread sleepForTimeInterval:3];
        }
        full--;
        
        //互斥使用缓存池
        while(mutex <= 0);
        mutex--;
 
        int nextc = buffer[outWhere];
        buffer[outWhere] = 0;//消费完将缓冲区设置为0
 
        outWhere = (outWhere + 1) % (N);
 
        mutex++;
        empty++;
        
        printf("\t\t\t\t\t\t\t\t消费一个产品ID%d,缓冲区位置为%d\n", nextc,outWhere);

        dispatch_async(dispatch_get_main_queue(), ^{   //  异步执行+主队列
            [self.cv reloadData];
        });
        
        [NSThread sleepForTimeInterval:3.0];
        
        if (com == false) {
            return;
        }
    }
}

- (IBAction)clickProducer:(id)sender {
    pro = true;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self producer];
    });
    
}

- (IBAction)clickConsumer:(id)sender {
    com = true;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self consumer];;
    });
    
    
}
- (IBAction)clickCancelPro:(id)sender {
    if (pro == false) {
        printf("\t\t不存在生产者进程\n");
    } else {
        printf("\t\t\t\t\t取消所有未阻塞的生产者进程\n");
    }
    
    pro = false;
}
- (IBAction)clickCancelCom:(id)sender {
    if (com == false) {
        printf("\t\t不存在消费者进程\n");
    } else {
        printf("\t\t\t\t\t取消所有未阻塞的消费者进程\n");
    }    com = false;
}
- (IBAction)clickCancelAll:(id)sender {
    NSLog(@"删除所有资源");
    full = 0;
    empty = N;
    inWhere = 0;
    outWhere = 0;
    memset(buffer, 0, sizeof(buffer)); 
    [self.cv reloadData]; 
}

- (void)viewDidLoad {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 2;
    self.cv = [[UICollectionView alloc]
    initWithFrame:CGRectMake(78, 120, 258, 258) collectionViewLayout:layout];

    self.cv.delegate = self;
    self.cv.dataSource = self;
    [self.cv registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:@"ReusableView"];
    
    [self.view addSubview:self.cv];
    [super viewDidLoad];
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString *cvCell = @"ReusableView";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cvCell forIndexPath:indexPath];
    
    [cell sizeToFit];

    if (buffer[indexPath.row] == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        cell.backgroundColor = [UIColor redColor];
    }
        return cell;
    
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return N;
}

@end
