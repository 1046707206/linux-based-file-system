# linux-based-file-system
2.开发设计文档
2.1定义的常量
#define BLOCKSIZE 1024    // 一个块的大小
#define SIZE 1024000
#define END 65535
#define FREE 0
#define ROOTBLOCKNUM 2
#define MAXOPENFILE 10 	// 同时打开最大文件数（表项数目）
#define MAX_TEXT_SIZE 10000
对系统在磁盘中的一些使用数据先进行定义，方便后续使用，根据系统设计思路添加文件最大数加以控制。
2.2数据结构
开辟虚拟磁盘空间进行文件存储分区，我们仿造FAT16文件系统进行设计。
typedef struct FCB {
    char filename[8];  //文件名
    char exname[3];  //文件扩展名
    unsigned char attribute; // 0: dir file, 1: data file   文件属性字段（目录或文件）
    unsigned short time;  //创建时间
    unsigned short date;  //创建日期
    unsigned short first;  //起始盘块号
    unsigned short length;  //文件长度
    char free; // 0: 空 fcb   //表示目录项是否为空
} fcb;
对文件和目录的信息进行了上述设计。我们同样设计了用户打开文件表来对有关文件操作的动态信息进行记录。
typedef struct USEROPEN {
//内存FCB表的所有属性
    char filename[8]; //文件名
    char exname[3]; //文件扩展名
    unsigned char attribute; //文件属性：值为0时表示目录文件，值为1时表示数据文件
    unsigned short time; //文件创建时间
    unsigned short date; //文件创建日期
    unsigned short first; //文件起始盘块号
    unsigned short length; //文件长度（对数据文件是字节数，对目录文件可以是目录项个数）

    char free; //表示目录项是否为空，若值为0，表示空，值为1，表示已分配

    int dirno; // 父目录文件起始盘块号（父目录指针位置）
    int diroff; // 该文件对应的 fcb 在父目录中的逻辑序号（子目录在父目录中的指针位置）
    char dir[MAXOPENFILE][80]; // 全路径信息
    int count;
    char fcbstate; // 是否修改 1是 0否
    char topenfile; // 0: 空 openfile
} useropen;
文件分配表记录了FAT中的信息，包括是否空闲和块号，每个FAT占据两个磁盘块。
typedef struct FAT {
    unsigned short id;  //fat表的信息
} fat;
在结构的引导块存储磁盘的相关信息。
typedef struct BLOCK {
    char magic_number[8];  //文件魔数
    char information[200];  //磁盘块大小
    unsigned short root;   //根目录文件开始位置
    unsigned char* startblock;  ////数据区开始位置
} block0;
2.3全局变量定义
extern unsigned char* myvhard;  //指向虚拟磁盘的起始地点
extern useropen openfilelist[MAXOPENFILE];   //打开文件表数组
extern int currfd;            	//方便记录指针当前位置
extern unsigned char* startp;          //记录虚拟磁盘上数据区开始位置
extern unsigned char buffer[SIZE];    //当前目录名
2.4虚拟磁盘空间布局
系统申请内存作为虚拟磁盘，一共划分1000个磁盘块，每个块1024个字节，引导块占一个盘块，两张FAT各占两个盘块，剩余为数据区，并将数据区第一块分配给根目录。如图所示：
 
2.5系统主函数main()
2.5.1实现思路
系统主函数main()文件中首先定义函数void test()，这个函数是用来测试文件系统是否正确启动。Main()中定义数组dict用于存放定义的命令字符，然后调用startsys()来进入文件系统，创建识别函数同时对命令正确错误的情况进行定义，若正确则根据输入的命令查找函数中的指令调用相关的文件进行处理，如输入read后，主函数将调用my_read()函数来处理命令。若指令错误，则根据指令格式予以错误提醒。
首先在虚拟机中使用sudo apt install gcc命令下载gcc，然后输入命令安装cmake项目构建工具。安装成功后，进入项目文件的目录，新建一个CMakeLists.txt文件，在文件中设置包含目录型和指定编译的源文件。然后执行cmake .命令读取CMakeLists.txt并生成项目文件makefile，然后输入make命令进行编译。
2.5.2程序内容
#include "init.c"//定义了驱动的初始化和退出相关的函数

//debug func
void test()
{
    int openfile_num = 0;
    int i;
    printf("debug area ############\n");
    // print open file number
    for (i = 0; i < MAXOPENFILE; i++) {
        if (openfilelist[i].topenfile == 1) {
            openfile_num++;
        }
    }
    printf("  open file number: %d\n", openfile_num);
    printf("  curr file name: %s\n", openfilelist[currfd].filename);
    printf("  curr file length: %d\n", openfilelist[currfd].length);

    printf("debug end  ############\n");
}

int main(void)
{
    char cmd[13][10] = {
        "mkdir", "rmdir", "ls", "cd", "create",
        "rm", "open", "close", "write", "read",
        "exit", "help", "test"
    };
    char command[30], *sp;
    int cmd_idx, i;

    printf("************* file system ***************\n");
startsys();
//startsys()初始化.加载本地文件，如果文件不存在，则在内存中开辟出一块空间来，如果存在则将其读到内存中。获得该内存区域后，对其进行格式化操作，我们得到的空间是原始的，也就是我们常看到的一些存储设备上标记的大小，但是往往我们发现其实际大小是要小的，原因是我们的文件系统在读该块存储区域进行格式化的时候要占据一定的空间。得到这个空间之后，同时为我们的根目录分配了fat块，我们对其将根目录进行设置，添加上两个fcb，对于fcb中的每一项执行相应的初始化操作，同时我们还具有一个表示当前打开层级目录的结构体，openfile，将这个当前目录更新为我们当前的目录。
    while (1) {
        printf("%s> ", openfilelist[currfd].dir);
        gets(command);
        cmd_idx = -1;
        if (strcmp(command, "") == 0) {
            printf("\n");
            continue;
        }
        sp = strtok(command, " ");
        for (i = 0; i < 13; i++) {
            if (strcmp(sp, cmd[i]) == 0) {
                cmd_idx = i;
                break;
            }
        }
        switch (cmd_idx) {
        case 0: 
// mkdir创建目录。获取当前目录的信息，将其读到内存中，判断是否存在该目录。创建一个FCB，判断是否存在一个空的FCB区域，创建一项添加，从Fat表中找到空闲表块，在开辟的新数据区块中创建根目录和当前目录的FCB。
            sp = strtok(NULL, " ");
            if (sp != NULL)
                my_mkdir(sp);
            else
                printf("mkdir error\n");
            break;
        case 1: // rmdir
删除一个目录。找到当前目录，将其读入到内存中，从其中的fcb进行一个比对，确定是否存在，如果存在根据其first找到对应的fat表，然后判断fat的id找到该内存区域，将fat的id设置为free，fat2的表项也要进行更新。然后将当前目录中的该fcb项free设置为0，将当前目录的length--，写回到原来的数据区。
            sp = strtok(NULL, " ");
            if (sp != NULL)
                my_rmdir(sp);
            else
                printf("rmdir error\n");
            break;
        case 2: // ls
展示当前有哪些目录文件，得到当前目录执行。根据first指向，然后找到指定的块，根据这个块进行fcb的遍历。根据其长度进行遍历，同时结合其中的free属性进行检测。
            my_ls();
            break;
        case 3: // cd
打开一个目录。接收目录名，然后打开这个目录，进入目录下面，以后的当前目录就是这个目录了。调用open函数，判断是否是已经打开存在后将其加入到打开列表中，调用ls操作，产生当下目录的所有文件。根据文件名找到上层目录，将该层目录关闭。
            sp = strtok(NULL, " ");
            if (sp != NULL)
                my_cd(sp);
            else
                printf("cd error\n");
            break;
        case 4: // create
创建一个文件。相比于创建目录，其少了的操作是不需要在其下一块进行一个目录文件的创建。找到当前目录读入内存，对其中的fcb比对，确定是否存在，如果不存在则再去fat表中，添加一项。将fcb块中添加一项，同时将当前的根目录的length++，和外部表的length++。
            sp = strtok(NULL, " ");
            if (sp != NULL)
                my_create(sp);
            else
                printf("create error\n");
            break;
        case 5: // rm
删除一个文件。相比删除目录，少的部分是对于文件内容块的设置，将开的部分设置free属性，读出当前目录块的内容，然后在当前目录块中找到这个文件，通过比对fat表找到文件所占的块数，根据文件的块数将制定的区域释放掉，将上层目录的length--，当前目录的length--。
            sp = strtok(NULL, " ");
            if (sp != NULL)
                my_rm(sp);
            else
                printf("rm error\n");
            break;
        case 6: 
// open打开。装载父目录进来，根据名称从父目录的fcb中进行检测判断是否存在，在当前打开列表中进行检测，如果可以的话分配一个块出去。将fcb中的内容拷贝给打开列表中的一项，根据传递的FD找到制定的块区域，根据制定的长度进行读写操作。
            sp = strtok(NULL, " ");
            if (sp != NULL)
                my_open(sp);
            else
                printf("open error\n");
            break;
        case 7: // close关闭
            if (openfilelist[currfd].attribute == 1)
                my_close(currfd);
            else
                printf("there is not openning file\n");
            break;
        case 8: // write
写文件函数。根据fat号找到要写回的区域，将之前读入的部分中fcb进行调整，然后写覆盖。
					if (openfilelist[currfd].attribute == 1)
                    my_write(currfd);
                else
                    printf("please open file first, then write\n");
                break;
				case 9: // read
	读入当前目录信息。接收fat'块和缓存区大小，根据fat块号找到对应根目录位置，读入根目录下的fcb信息，写到缓冲区。
            if (openfilelist[currfd].attribute == 1)
                    my_read(currfd);
                else
                    printf("please open file first, then read\n");
                break;
            case 10: // exit
                my_exitsys();
                return 0;
                break;        case 11: // help
                sp = strtok(NULL, " ");
                if (sp != NULL)
                    help(sp);
                else
                    printf("rm error\n");
                sp = strtok(NULL, " ");
               if (sp != NULL)
                    printf("\nwarning:you only need to INPUT my_help function_name\n");
                break;
            case 12: // format
               my_format();
                break;
            default:
                printf("wrong command: %s\n", command);
                break;        }
    }
    return 0;
}
 
2.6进入文件系统函数startsys()
2.6.1实现思路
这个函数用于进入文件系统，如果文件系统存在则载入相关的root目录，如果不存在就调用my_format格式化磁盘来创建文件系统。主要判断手段是通过FILENAEM是否存在且开头是否为魔数，判断成功后定义fcb指针root来载入根目录初始信息，如文件名，拓展名，创建日期等等。
2.6.2程序实现
#include "init.h"
char* FILENAME = "zfilesys";
void startsys()
{
    /**
     * 如果存在文件系统（存在 FILENAME 这个文件 且 开头为魔数）则
	 * 将 root 目录载入打开文件表。
	 * 否则，调用 my_format 创建文件系统，再载入。
	 */
    myvhard = (unsigned char*)malloc(SIZE);
    FILE* file;
    if ((file = fopen(FILENAME, "r")) != NULL) {
        fread(buffer, SIZE, 1, file);
        fclose(file);
        if (memcmp(buffer, "10101010", 8) == 0) {
            memcpy(myvhard, buffer, SIZE);
            printf("myfsys file read successfully\n");
        } else {
            printf("invalid myfsys magic num, create file system\n");
            my_format();
            memcpy(buffer, myvhard, SIZE);
        }
    } else {
        printf("myfsys not find, create file system\n");
        my_format();
        memcpy(buffer, myvhard, SIZE);
    }

    fcb* root;
    root = (fcb*)(myvhard + 5 * BLOCKSIZE);
    strcpy(openfilelist[0].filename, root->filename);
    strcpy(openfilelist[0].exname, root->exname);
    openfilelist[0].attribute = root->attribute;
    openfilelist[0].time = root->time;
    openfilelist[0].date = root->date;
    openfilelist[0].first = root->first;
    openfilelist[0].length = root->length;
    openfilelist[0].free = root->free;

    openfilelist[0].dirno = 5;
    openfilelist[0].diroff = 0;
    strcpy(openfilelist[0].dir, "/root/");
    openfilelist[0].count = 0;
    openfilelist[0].fcbstate = 0;
    openfilelist[0].topenfile = 1;

    startp = ((block0*)myvhard)->startblock;
    currfd = 0;
    return;
}

void exitsys()
{
    /**
	 * 依次关闭 打开文件。 写入 FILENAME 文件
	 */
    while (currfd) {
        my_close(currfd);
    }
    FILE* fp = fopen(FILENAME, "w");
    fwrite(myvhard, SIZE, 1, fp);
    fclose(fp);
}
2.7磁盘格式化函数my_format()
2.7.1实现思路
创建引导块boot指针，创建文件系统FILENAME,赋予魔数10101010，然后写入到磁盘内存空间，初始化前五个磁盘块建立两个FAT表，将前五定为已用，后面定为空闲，然后将第六个磁盘块指定为根目录，创建根目录.和..。然后读取localtime改变格式定义为文件系统和根目录.及..的创立时间。
2.7.2程序实现
void my_format()
{
    /**
	 * 初始化前五个磁盘块
	 * 设定第六个磁盘块为根目录磁盘块
	 * 初始化 root 目录： 创建 . 和 .. 目录
	 * 写入 FILENAME 文件 （写入磁盘空间）
	 */
    block0* boot = (block0*)myvhard;
    strcpy(boot->magic_number, "10101010");
    strcpy(boot->information, "fat file system");
    boot->root = 5;
    boot->startblock = myvhard + BLOCKSIZE * 5;

    fat* fat1 = (fat*)(myvhard + BLOCKSIZE);
    fat* fat2 = (fat*)(myvhard + BLOCKSIZE * 3);
    int i;
    for (i = 0; i < 6; i++) {
        fat1[i].id = END;
        fat2[i].id = END;
    }
    for (i = 6; i < 1000; i++) {
        fat1[i].id = FREE;
        fat2[i].id = FREE;
    }

    // 5th block is root
    fcb* root = (fcb*)(myvhard + BLOCKSIZE * 5);
    strcpy(root->filename, ".");
    strcpy(root->exname, "di");
    root->attribute = 0; // dir file

    time_t rawTime = time(NULL);
    struct tm* time = localtime(&rawTime);
    // 5 6 5 bits
    root->time = time->tm_hour * 2048 + time->tm_min * 32 + time->tm_sec / 2;
    // 7 4 5 bits; year from 2000
    root->date = (time->tm_year - 100) * 512 + (time->tm_mon + 1) * 32 + (time->tm_mday);
    root->first = 5;
    root->free = 1;
    root->length = 2 * sizeof(fcb);

    fcb* root2 = root + 1;
    memcpy(root2, root, sizeof(fcb));
    strcpy(root2->filename, "..");
    for (i = 2; i < (int)(BLOCKSIZE / sizeof(fcb)); i++) {
        root2++;
        strcpy(root2->filename, "");
        root2->free = 0;
    }

    FILE* fp = fopen(FILENAME, "w");
    fwrite(myvhard, SIZE, 1, fp);
    fclose(fp);
}
 
2.8创建子目录函数my_mkdir()
2.8.1实现思路
my_mkdir函数用于创建子目录，通过调用读取do_read函数读取当前的父目录信息，输入信息中的新建目录名用来在父目录中进行重名检查，若文件名已经在父目录中存在，则错误信息并返回。若不存在则在父目录下申请新的目录表项，申请磁盘块，更新FAT表，将父目录中空的fcb分配给该目录，并初始化新目录的信息，读取时间作为创建时间，还会将目录路径上的所有目录信息进行更新修改，包括.和..目录等。
在 root 父目录下， 输入命令ls查看当前有哪些文件，再输入mkdir yyx和mkdir yangyuxuan，用ls查看后显示创建子目录yyx和yangyuxuan成功，若输入命令mkdir yang.txt则报you can not use extension。
2.8.2程序实现
void my_mkdir(char* dirname)  
{  
    int i = 0;  
    char text[MAX_TEXT_SIZE];  
  
   char* fname = strtok(dirname, ".");  
   char* exname = strtok(NULL, ".");  
    if (exname != NULL) {  
        printf("you can not use extension\n");  
        return;  
    }  
    // 读取父目录信息  
    openfilelist[currfd].count = 0;  
    int filelen = do_read(currfd, openfilelist[currfd].length, text);  
    fcb* fcbptr = (fcb*)text;  
  
    // 查找是否重名  
    for (i = 0; i < (int)(filelen / sizeof(fcb)); i++) {  
        if (strcmp(dirname, fcbptr[i].filename) == 0 && fcbptr->attribute == 0) {  
            printf("dir has existed\n");  
            return;  
        }  
    }  
  
    // 申请一个打开目录表项  
    int fd = get_free_openfilelist();  
    if (fd == -1) {  
        printf("openfilelist is full\n");  
        return;  
    }  
// 申请一个磁盘块  
unsigned short int block_num = get_free_block();  
    if (block_num == END) {  
        printf("blocks are full\n");  
        openfilelist[fd].topenfile = 0;  
        return;  
    }  
    // 更新 fat 表  
    fat* fat1 = (fat*)(myvhard + BLOCKSIZE);  
    fat* fat2 = (fat*)(myvhard + BLOCKSIZE * 3);  
    fat1[block_num].id = END;  
    fat2[block_num].id = END;  
  
    // 在父目录中找一个空的 fcb，分配给该目录  
    for (i = 0; i < (int)(filelen / sizeof(fcb)); i++) {  
        if (fcbptr[i].free == 0) {  
            break;  
        }  
    }  
    openfilelist[currfd].count = i * sizeof(fcb);  
    openfilelist[currfd].fcbstate = 1;  
    // 初始化该 fcb  
    fcb* fcbtmp = (fcb*)malloc(sizeof(fcb));  
    fcbtmp->attribute = 0;  
    time_t rawtime = time(NULL);  
    struct tm* time = localtime(&rawtime);  
    fcbtmp->date = (time->tm_year - 100) * 512 + (time->tm_mon + 1) * 32 + (time->tm_mday);  
    fcbtmp->time = (time->tm_hour) * 2048 + (time->tm_min) * 32 + (time->tm_sec) / 2;  
    strcpy(fcbtmp->filename, dirname);  
    strcpy(fcbtmp->exname, "di");  
    fcbtmp->first = block_num;  
    fcbtmp->length = 2 * sizeof(fcb);  
    fcbtmp->free = 1;  
    do_write(currfd, (char*)fcbtmp, sizeof(fcb), 2);  
  
    // 设置打开文件表项  
    openfilelist[fd].attribute = 0;  
    openfilelist[fd].count = 0;  
    openfilelist[fd].date = fcbtmp->date;  
    openfilelist[fd].time = fcbtmp->time;  
    openfilelist[fd].dirno = openfilelist[currfd].first;  
    openfilelist[fd].diroff = i;  
    strcpy(openfilelist[fd].exname, "di");  
    strcpy(openfilelist[fd].filename, dirname);  
    openfilelist[fd].fcbstate = 0;  
    openfilelist[fd].first = fcbtmp->first;  
    openfilelist[fd].free = fcbtmp->free;  
    openfilelist[fd].length = fcbtmp->length;  
    openfilelist[fd].topenfile = 1;  
    strcat(strcat(strcpy(openfilelist[fd].dir, (char*)(openfilelist[currfd].dir)), dirname), "/");  
  
    // 设置 . 和 .. 目录  
    fcbtmp->attribute = 0;  
    fcbtmp->date = fcbtmp->date;  
    fcbtmp->time = fcbtmp->time;  
    strcpy(fcbtmp->filename, ".");  
    strcpy(fcbtmp->exname, "di");  
    fcbtmp->first = block_num;  
    fcbtmp->length = 2 * sizeof(fcb);  
    do_write(fd, (char*)fcbtmp, sizeof(fcb), 2);  
  
    fcb* fcbtmp2 = (fcb*)malloc(sizeof(fcb));  
    memcpy(fcbtmp2, fcbtmp, sizeof(fcb));  
    strcpy(fcbtmp2->filename, "..");  
    fcbtmp2->first = openfilelist[currfd].first;  
    fcbtmp2->length = openfilelist[currfd].length;  
    fcbtmp2->date = openfilelist[currfd].date;  
    fcbtmp2->time = openfilelist[currfd].time;  
    do_write(fd, (char*)fcbtmp2, sizeof(fcb), 2);  
  
    // 关闭该目录的打开文件表项，close 会修改父目录中对应该目录的 fcb 信息  
    /** 
     * 这里注意，一个目录存在 2 个 fcb 信息，一个为该目录下的 . 目录文件，一个为父目录下的 fcb。 
     * 因此，这俩个fcb均需要修改，前一个 fcb 由各个函数自己完成，后一个 fcb 修改由 close 完成。 
     * 所以这里，需要打开文件表，再关闭文件表，实际上更新了后一个 fcb 信息。 
     */  
    my_close(fd);  
  
    free(fcbtmp);  
    free(fcbtmp2);  
  
    // 修改父目录 fcb  
    fcbptr = (fcb*)text;  
    fcbptr->length = openfilelist[currfd].length;  
    openfilelist[currfd].count = 0;  
    do_write(currfd, (char*)fcbptr, sizeof(fcb), 2);  
    openfilelist[currfd].fcbstate = 1;  
}  
 
2.9更改当前目录函数my_cd()
2.9.1实现思路
my_cd函数用于对当前目录进行更改，从而进入新的目录下。首先会对当前位置的dir进行判断，若不为dir类型则返回错误信息，否则调用do_read函数读取命令cd后的目录路径。然后根据路径读取相关的fcb信息直到进入目的目录，若未查找到相关的fcb信息，则输出路径错误并返回。
2.9.2程序实现
void my_cd(char* dirname)  
{  
    int i = 0;  
    int tag = -1;  
    int fd;  
    if (openfilelist[currfd].attribute == 1) {  
        // if not a dir  
        printf("you are in a data file, you could use 'my_close' to exit this file\n");  
        return;  
    }  
    char* buf = (char*)malloc(10000);  
    openfilelist[currfd].count = 0;  
    do_read(currfd, openfilelist[currfd].length, buf);  
  
    fcb* fcbptr = (fcb*)buf;  
    // 查找目标 fcb  
    for (i = 0; i < (int)(openfilelist[currfd].length / sizeof(fcb)); i++, fcbptr++) {  
        if (strcmp(fcbptr->filename, dirname) == 0 && fcbptr->attribute == 0) {  
            tag = 1;  
            break;  
        }  
    }  
    if (tag != 1) {  
        printf("my_cd: no such dir\n");  
        return;  
    } else {  
        // . 和 .. 检查  
        if (strcmp(fcbptr->filename, ".") == 0) {  
            return;  
        } else if (strcmp(fcbptr->filename, "..") == 0) {  
            if (currfd == 0) {  
                // root  
                return;  
            } else {  
                currfd = my_close(currfd);  
                return;  
            }  
        } else {  
            // 其他目录  
            fd = get_free_openfilelist();  
            if (fd == -1) {  
                return;  
            }  
            openfilelist[fd].attribute = fcbptr->attribute;  
            openfilelist[fd].count = 0;  
            openfilelist[fd].date = fcbptr->date;  
            openfilelist[fd].time = fcbptr->time;  
            strcpy(openfilelist[fd].filename, fcbptr->filename);  
            strcpy(openfilelist[fd].exname, fcbptr->exname);  
            openfilelist[fd].first = fcbptr->first;  
            openfilelist[fd].free = fcbptr->free;  
  
            openfilelist[fd].fcbstate = 0;  
            openfilelist[fd].length = fcbptr->length;  
            strcat(strcat(strcpy(openfilelist[fd].dir, (char*)(openfilelist[currfd].dir)), dirname), "/");  
            openfilelist[fd].topenfile = 1;  
            openfilelist[fd].dirno = openfilelist[currfd].first;  
            openfilelist[fd].diroff = i;  
            currfd = fd;  
        }  
    }  
}  

2.10删除子目录函数my_rmdir()
2.10.1实现思路
my_rmdir函数的主要功能是通过调用my_rmdir dirname命令来删除当前目录下名为dirname的子目录。
首先，通过do_read()命令读入当前目录文件到内存中，并检查该目录文件是否存在，若不存在则返回并显示错误信息；然后检查该目录文件是否为空，即是否除“.”和“..”外没有其他的子目录和文件，若不为空贼返回并显示错误信息；此外还需要检查该目录文件是否已经打开，若已打开则调用my_close()函数关闭。
以上信息判断完毕之后，回收该目录文件所占据的磁盘块，修改FAT，并从当前目录文件中清空该目录文件的目录项，调用do_write()函数以覆盖的方式将free字段置为0；最后修改当前目录文件的用户打开表项中的长度信息，将fcbstate置为1，然后返回。
2.10.2程序实现
#include "head.h"

void my_rmdir(char* dirname)
{
    int i, tag = 0;
    char buf[MAX_TEXT_SIZE];

    // 排除 . 和 .. 目录
    if (strcmp(dirname, ".") == 0 || strcmp(dirname, "..") == 0) 
    {
        printf("can not remove . and .. special dir\n");
        return;
    }
    openfilelist[currfd].count = 0;
    do_read(currfd, openfilelist[currfd].length, buf);

    // 查找要删除的目录
    fcb* fcbptr = (fcb*)buf;
    for (i = 0; i < (int)(openfilelist[currfd].length / sizeof(fcb)); i++, fcbptr++) 
    {
        if (fcbptr->free == 0)
            continue;
        if (strcmp(fcbptr->filename, dirname) == 0 && fcbptr->attribute == 0) 
        {
            tag = 1;
            break;
        }
    }
    if (tag != 1) 
    {
        printf("no such dir\n");
        return;
    }
    // 无法删除非空目录
    if (fcbptr->length > 2 * sizeof(fcb)) 
    {
        printf("can not remove a non empty dir\n");
        return;
    }

    // 更新 fat 表
    int block_num = fcbptr->first;
    fat* fat1 = (fat*)(myvhard + BLOCKSIZE);
    int nxt_num = 0;
    while (1) 
    {
        nxt_num = fat1[block_num].id;
        fat1[block_num].id = FREE;
        if (nxt_num != END) 
        {
            block_num = nxt_num;
        } 
        else 
        {
            break;
        }
    }
    fat1 = (fat*)(myvhard + BLOCKSIZE);
    fat* fat2 = (fat*)(myvhard + BLOCKSIZE * 3);
    memcpy(fat2, fat1, BLOCKSIZE * 2);

    // 更新 fcb
    fcbptr->date = 0;
    fcbptr->time = 0;
    fcbptr->exname[0] = '\0';
    fcbptr->filename[0] = '\0';
    fcbptr->first = 0;
    fcbptr->free = 0;
    fcbptr->length = 0;

    openfilelist[currfd].count = i * sizeof(fcb);
    do_write(currfd, (char*)fcbptr, sizeof(fcb), 2);

    // 删除目录需要相应考虑可能删除 fcb，也就是修改父目录 length
    // 这里需要注意：因为删除中间的 fcb，目录有效长度不变，即 length 不变
    // 因此需要考虑特殊情况，即删除最后一个 fcb 时，极有可能之前的 fcb 都是空的，这是需要
    // 循环删除 fcb (以下代码完成)，可能需要回收 block 修改 fat 表等过程(do_write 完成)
    int lognum = i;
    if ((lognum + 1) * sizeof(fcb) == openfilelist[currfd].length) 
    {
        openfilelist[currfd].length -= sizeof(fcb);
        lognum--;
        fcbptr = (fcb *)buf + lognum;
        while (fcbptr->free == 0) 
        {
            fcbptr--;
            openfilelist[currfd].length -= sizeof(fcb);
        }
    }

    // 更新父目录 fcb
    fcbptr = (fcb*)buf;
    fcbptr->length = openfilelist[currfd].length;
    openfilelist[currfd].count = 0;
    do_write(currfd, (char*)fcbptr, sizeof(fcb), 2);

    openfilelist[currfd].fcbstate = 1;
}
 
2.11显示目录函数my_ls()
2.11.1实现思路
my_ls()函数的主要功能是显示当前目录的内容，包含子目录和文件信息。
该函数主要是通过调用do_read()函数读出当前目录文件内容到内存中，然后通过遍历文件内容，将读出的目录文件信息按照一定的格式显示到屏幕上，完成之后返回。
2.11.2程序实现
#include "head.h"

void my_ls()
{
    // 判断是否是目录
    if (openfilelist[currfd].attribute == 1)
    {
        printf("data file\n");
        return;
    }
    
    char buf[MAX_TEXT_SIZE];
    int i;

    // 读取当前目录文件信息(一个个fcb), 载入内存
    openfilelist[currfd].count = 0;
    do_read(currfd, openfilelist[currfd].length, buf);

    // 遍历当前目录 fcb
    fcb* fcbptr = (fcb*)buf;
    for (i = 0; i < (int)(openfilelist[currfd].length / sizeof(fcb)); i++, fcbptr++) 
    {
        if (fcbptr->free == 1) 
        {
            if (fcbptr->attribute == 0) 
            {
                if (strcmp(fcbptr->filename,"..") &&strcmp(fcbptr->filename,"."))
                {      printf("<DIR> %-8s\t%d/%d/%d %d:%d\n",
                       fcbptr->filename,
                       (fcbptr->date >> 9) + 2000,
                       (fcbptr->date >> 5) & 0x000f,
                       (fcbptr->date) & 0x001f,
                       (fcbptr->time >> 11),
                       (fcbptr->time >> 5) & 0x003f);}
            } 
            else 
            {
                printf("<FILE> %-8s\t%d/%d/%d %d:%d\t%d\n",
                       fcbptr->filename,
                       (fcbptr->date >> 9) + 2000,
                       (fcbptr->date >> 5) & 0x000f,
                       (fcbptr->date) & 0x001f,
                       (fcbptr->time >> 11),
                       (fcbptr->time >> 5) & 0x003f,
                       fcbptr->length);
            }
        }
    }
}
 
2.12创建文件函数my_create()
2.12.1实现思路
my_create()函数的主要功能是通过调用my_create filename命令创建一个指定路径下的文件。
首先，为新文件分配一个新的文件列表，若有父目录文件，则调用my_open()函数打开，若没有空闲表或者打开父目录失败，则释放已获得的空间并显示错误信息；然后调用do_read()函数将父目录中文件读取到内存中，判断是否已存在一个同名的文件；接着判断FAT中是否有空闲的磁盘块，并在其中寻找或者增加一个新的目录项，修改该目录文件的长度信息并将对应用户打开文件表的fcbstate置为1。
修改文件的fcb内容，并调用do_write()函数填写进该文件分配到的目录项中，填写该文件分配到的空闲打开文件表，将fcbstate字段值和读写指针值修改为0。最后关闭父目录文件，将新文件的打开文件报表项序号返回。
2.12.2程序实现
#include "head.h"

int my_create(char* filename)
{
    // 非法判断
    if (strcmp(filename, "") == 0) 
    {
        printf("please input filename\n");
        return -1;
    }
    if (openfilelist[currfd].attribute == 1) 
    {
        printf("you are in data file now\n");
        return -1;
    }

    openfilelist[currfd].count = 0;
    char buf[MAX_TEXT_SIZE];
    do_read(currfd, openfilelist[currfd].length, buf);

    int i;
    fcb* fcbptr = (fcb*)buf;
    // 检查重名
    for (i = 0; i < (int)(openfilelist[currfd].length / sizeof(fcb)); i++, fcbptr++)
    {
        if (fcbptr->free == 0) 
        {
            continue;
        }
        if (strcmp(fcbptr->filename, filename) == 0 && fcbptr->attribute == 1) 
        {
            printf("the same filename error\n");
            return -1;
        }
    }

    // 申请空 fcb;
    fcbptr = (fcb*)buf;
    for (i = 0; i < (int)(openfilelist[currfd].length / sizeof(fcb)); i++, fcbptr++) 
    {
        if (fcbptr->free == 0)
            break;
    }
    // 申请磁盘块并更新 fat 表
    int block_num = get_free_block();
    if (block_num == -1) 
    {
        return -1;
    }
    fat* fat1 = (fat*)(myvhard + BLOCKSIZE);
    fat* fat2 = (fat*)(myvhard + BLOCKSIZE * 3);
    fat1[block_num].id = END;
    memcpy(fat2, fat1, BLOCKSIZE * 2);

    // 修改 fcb 信息
    strcpy(fcbptr->filename, filename);
    time_t rawtime = time(NULL);
    struct tm* time = localtime(&rawtime);
    fcbptr->date = (time->tm_year - 100) * 512 + (time->tm_mon + 1) * 32 + (time->tm_mday);
    fcbptr->time = (time->tm_hour) * 2048 + (time->tm_min) * 32 + (time->tm_sec) / 2;
    fcbptr->first = block_num;
    fcbptr->free = 1;
    fcbptr->attribute = 1;
    fcbptr->length = 0;

    openfilelist[currfd].count = i * sizeof(fcb);
    do_write(currfd, (char*)fcbptr, sizeof(fcb), 2);

    // 修改父目录 fcb
    fcbptr = (fcb*)buf;
    fcbptr->length = openfilelist[currfd].length;
    openfilelist[currfd].count = 0;
    do_write(currfd, (char*)fcbptr, sizeof(fcb), 2);

    openfilelist[currfd].fcbstate = 1;
}
 
2.13申请新的空闲磁盘块函数get_free_block()
2.13.1实现思路
get_free_block()函数的主要功能是申请空闲的磁盘块。该函数通过for循环，利用指针返回空闲磁盘块的位置并修改相应信息。
2.13.2实现思路
#include "head.h"


int get_free_openfilelist()
{
    int i;
    for (i = 0; i < MAXOPENFILE; i++) 
    {
        if (openfilelist[i].topenfile == 0) 
        {
            openfilelist[i].topenfile = 1;
            return i;
        }
    }
    return -1;
}
2.14申请新的打开文件列表函数get_free_openfilelist()
2.14.1实现思路
get_free_openfilelist()函数的主要功能是用来申请打开文件或者目录。toopenfile的值为文件打开的状态，为1表示已打开文件，为0则表示未打开。
2.14.2程序实现
#include "head.h"


int get_free_openfilelist()
{
    int i;
    for (i = 0; i < MAXOPENFILE; i++) 
    {
        if (openfilelist[i].topenfile == 0) 
        {
            openfilelist[i].topenfile = 1;
            return i;
        }
    }
    return -1;
}

2.15 删除文件函数my_rm()
2.15.1实现思路
my_rm函数的主要功能是删除文件，首先通过for循环判断父目录文件是否已经打开，若欲删除文件的目录还没有打开，则调用my_open()打开；若打开失败，则返回，并显示错误信息；调用do_read()独处该父目录文件内容到内存，检查该目录下欲删除文件是否存在，若不存在则返回，并输出no such file；用一个while语句检查该文件是否已经打开，若已打开则关闭掉；回收该文件所占据的磁盘块，修改fat，更新fat表；从文件的父目录文件中清空该文件的目录项，清空fcb，然后以覆盖写方式调用do_write函数来修改父目录文件的fcb,最后修改该父目录文件的用户打开文件表项中的长度信息，并将该表行中的fcbstate置为一。
2.15.2程序实现
#include "head.h"

void my_rm(char* filename)
{
    char buf[MAX_TEXT_SIZE];
    openfilelist[currfd].count = 0;
    do_read(currfd, openfilelist[currfd].length, buf);

    int i, flag = 0;
    fcb* fcbptr = (fcb*)buf;
    // 查询
    for (i = 0; i < (int)(openfilelist[currfd].length / sizeof(fcb)); i++, fcbptr++) {
        if (strcmp(fcbptr->filename, filename) == 0 && fcbptr->attribute == 1) {
            flag = 1;
            break;
        }
    }
    if (flag != 1) {
        printf("no such file\n");
        return;
    }

    // 更新 fat 表
    int block_num = fcbptr->first;
    fat* fat1 = (fat*)(myvhard + BLOCKSIZE);
    int nxt_num = 0;
    while (1) {
        nxt_num = fat1[block_num].id;
        fat1[block_num].id = FREE;
        if (nxt_num != END)
            block_num = nxt_num;
        else
            break;
    }
    fat1 = (fat*)(myvhard + BLOCKSIZE);
    fat* fat2 = (fat*)(myvhard + BLOCKSIZE * 3);
    memcpy(fat2, fat1, BLOCKSIZE * 2);

    // 清空 fcb
    fcbptr->date = 0;
    fcbptr->time = 0;
    fcbptr->exname[0] = '\0';
    fcbptr->filename[0] = '\0';
    fcbptr->first = 0;
    fcbptr->free = 0;
    fcbptr->length = 0;
    openfilelist[currfd].count = i * sizeof(fcb);
    do_write(currfd, (char*)fcbptr, sizeof(fcb), 2);
    //
    int lognum = i;
    if ((lognum + 1) * sizeof(fcb) == openfilelist[currfd].length) {
        openfilelist[currfd].length -= sizeof(fcb);
        lognum--;
        fcbptr = (fcb *)buf + lognum;
        while (fcbptr->free == 0) {
            fcbptr--;
            openfilelist[currfd].length -= sizeof(fcb);
        }
    }

    // 修改父目录 . 目录文件的 fcb
    fcbptr = (fcb*)buf;
    fcbptr->length = openfilelist[currfd].length;
    openfilelist[currfd].count = 0;
    do_write(currfd, (char*)fcbptr, sizeof(fcb), 2);

    openfilelist[currfd].fcbstate = 1;
}
 
2.16 打开文件函数my_open()
2.16.1实现思路
My_open函数的主要功能是打开文件，检查该文件是否已经打开，若已经打开则返回-1，并显示错误信息；调用do_read()读出父目录文件的内容到内存，用if语句判断该目录下欲打开文件是否存在，若不存在则返回-1，并输出no such file；申请新的打开目录项并初始化该目录项，检查用户打开文件表中是否有空表项，若有则为欲打开文件分配一个空表项，若没有则返回-1，并输入”my_open:full openfilelist”；为该文件填写空白用户打开文件表表项内容，读写指针置为0；将该文件所分配到的空白用户打开文件表表项序号（数组下标）作为文件描述符fd，返回1。
2.16.2程序代码
#include "head.h"

int my_open(char* filename)
{
    char buf[MAX_TEXT_SIZE];
    openfilelist[currfd].count = 0;
    do_read(currfd, openfilelist[currfd].length, buf);

    int i, flag = 0;
    fcb* fcbptr = (fcb*)buf;
    // 重名检查
    for (i = 0; i < (int)(openfilelist[currfd].length / sizeof(fcb)); i++, fcbptr++) {
        if (strcmp(fcbptr->filename, filename) == 0 && fcbptr->attribute == 1) {
            flag = 1;
            break;
        }
    }
    if (flag != 1) {
        printf("no such file\n");
        return -1;
    }

    // 申请新的打开目录项并初始化该目录项
    int fd = get_free_openfilelist();
    if (fd == -1) {
        printf("my_open: full openfilelist\n");
        return -1;
    }

    openfilelist[fd].attribute = 1;
    openfilelist[fd].count = 0;
    openfilelist[fd].date = fcbptr->date;
    openfilelist[fd].time = fcbptr->time;
    openfilelist[fd].length = fcbptr->length;
    openfilelist[fd].first = fcbptr->first;
    openfilelist[fd].free = 1;
    strcpy(openfilelist[fd].filename, fcbptr->filename);
    strcat(strcpy(openfilelist[fd].dir, (char*)(openfilelist[currfd].dir)), filename);
    openfilelist[fd].dirno = openfilelist[currfd].first;
    openfilelist[fd].diroff = i;
    openfilelist[fd].topenfile = 1;

    openfilelist[fd].fcbstate = 0;

    currfd = fd;
    return 1;
}
 
2.17 关闭文件函数my_close()
2.17.1实现思路
my_close函数的主要功能是关闭前面由my_open()打开的文件。首先使用if语句检查fd的有效性，如果fd超出用户打开文件表所在数组的最大下标或者小于0，则无效，返回-1，并输出my_close: fd error；然后检查用户打开文件表表项中的fcbstate字段的值，如果为1则打开该文件的父目录文件，以覆盖写方式调用do_write()将欲关闭文件的FCB写入父目录文件的相应盘块中；以此来将该文件的FCB的内容保存到虚拟磁盘上该文件的目录项中，最后释放打开文件表，回收该文件占据的用户打开文件表表项（进行清空操作），并将topenfile字段置为0，返回father_fd。
2.17.2程序代码
#include "head.h"

int my_close(int fd)
{
    if (fd > MAXOPENFILE || fd < 0) {
        printf("my_close: fd error\n");
        return -1;
    }

    int i;
    char buf[MAX_TEXT_SIZE];
    int father_fd = -1;
    fcb* fcbptr;
    for (i = 0; i < MAXOPENFILE; i++) {
        if (openfilelist[i].first == openfilelist[fd].dirno) {
            father_fd = i;
            break;
        }
    }
    if (father_fd == -1) {
        printf("my_close: no father dir\n");
        return -1;
    }
    if (openfilelist[fd].fcbstate == 1) {
        do_read(father_fd, openfilelist[father_fd].length, buf);
        // update fcb
        fcbptr = (fcb*)(buf + sizeof(fcb) * openfilelist[fd].diroff);
        strcpy(fcbptr->exname, openfilelist[fd].exname);
        strcpy(fcbptr->filename, openfilelist[fd].filename);
        fcbptr->first = openfilelist[fd].first;
        fcbptr->free = openfilelist[fd].free;
        fcbptr->length = openfilelist[fd].length;
        fcbptr->time = openfilelist[fd].time;
        fcbptr->date = openfilelist[fd].date;
        fcbptr->attribute = openfilelist[fd].attribute;
        openfilelist[father_fd].count = openfilelist[fd].diroff * sizeof(fcb);
        do_write(father_fd, (char*)fcbptr, sizeof(fcb), 2);
    }
    // 释放打开文件表
    memset(&openfilelist[fd], 0, sizeof(useropen));
    currfd = father_fd;
    return father_fd;
}

2.18 写文件函数my_write()
2.18.1实现思路
my_write函数的功能是将用户通过键盘输入的内容写到fd所指定的文件中。磁盘文件的读写操作都必须以完整的数据块为单位进行，在写操作时，先将数据写在缓冲区中，缓冲区的大小与磁盘块的大小相同，然后再将缓冲区中的数据一次性写到磁盘块中；读出时先将一个磁盘块中的内容读到缓冲区中，然后再传送到用户区。本实例为了简便起见，没有设置缓冲区管理，只是在读写文件时由用户使用malloc()申请一块空间作为缓冲区，读写操作结束后使用free()释放掉。写操作有三种方式：截断写、覆盖写和追加写。截断写是放弃原来文件的内容，重新写文件；覆盖写是修改文件在当前读写指针所指的位置开始的部分内容；追加写是在原文件的最后添加新的内容。在本实例中，输入写文件命令后，系统会出现提示让用户选择其中的一种写方式，并将随后键盘输入的内容按照所选的方式写到文件中。首先检查fd的有效性，如果fd超出用户打开文件表所在数组的最大下标或小于0，则返回-1，并输出my_write: no such file；有效则提示并等待用户输入写方式：（1：截断写；2：覆盖写；3：追加写）如果用户要求的写方式是截断写，则释放文件除第一块外的其他磁盘空间内容（查找并修改FAT表），将内存用户打开文件表项中文件长度修改为0，将读写指针置为0；如果用户要求的写方式是追加写，则修改文件的当前读写指针位置到文件的末尾；如果写方式是覆盖写，则从文件指针处开始写；用户可分多次输入写入内容，每次用回车结束；每次用户的输入内容保存到一临时变量text[]中，要每次输入以回车结束；my_write调用do_write()函数将通过键盘键入的内容写到文件中。如果do_write()函数的返回值为非负值，则将实际写入字节数增加do_write()函数返回值，否则显示出错信息；如果text[]中最后一个字符不是结束字符，则继续进行写操作；如果当前读写指针位置大于用户打开文件表项中的文件长度，则修改打开文件表项中的文件长度信息，并将fcbstate的值定为1。
2.18.2程序代码
#include "head.h"

int my_write(int fd)
{
    fat *fat1, *fat2, *fatptr1, *fatptr2;
    int wstyle, len, ll, tmp;
    char text[MAX_TEXT_SIZE];
    unsigned short blkno;
    fat1 = (fat *)(myvhard + BLOCKSIZE);
    fat2 = (fat *)(myvhard + 3 * BLOCKSIZE);
    if(fd < 0 || fd >= MAXOPENFILE)
    {
        printf("my_write: no such file\n");
        return -1;
    }
    while(1)
    {
        printf("1:Truncation  2:Coverage  3:Addition\n");
        scanf("%d", &wstyle);
        if(wstyle > 0 && wstyle < 4)
            break;
        printf("input error");
    }
    getchar();
     switch(wstyle)
    {
        case 1://截断写把原文件所占的虚拟磁盘空间重置为1
            blkno = openfilelist[fd].first;
            fatptr1 = fat1 + blkno;
            fatptr2 = fat2 + blkno;
            blkno = fatptr1->id;
            fatptr1->id = END;
            fatptr2->id = END;
            while(blkno != END)
            {
                fatptr1 = fat1 + blkno;
                fatptr2 = fat2 + blkno;
                blkno = fatptr1->id;
                fatptr1->id = FREE;
                fatptr2->id = FREE;
            }
            openfilelist[fd].count = 0;
            openfilelist[fd].length = 0;
            break;
        case 2:
            openfilelist[fd].count = 0;
            break;
        case 3:
            openfilelist[fd].count = openfilelist[fd].length;
            break;
        default:
            break;
    }
    ll = 0;
    printf("please input data, line feed + $end to end file\n");
    for(;;)
    {
    	fgets(text,MAX_TEXT_SIZE,stdin);
    	text[strlen(text) -1] = '\0';
    	if(!strcmp(text,"$end"))break;
    	if (wstyle==1)
    	    text[strlen(text)]='\n';
    	
    	if(do_write(fd, text, strlen(text), 2) > 0)
    	{
    		len +=strlen(text);
    		ll = strlen(text);
    		if (wstyle==1)
    		    ll -= 1;
    	}
    	else{
    	return -1;
    	}
    }
   
    return ll;//实际写的字节数
}
 
 
2.19 实际写文件函数do_write()
2.19.1实现思路
do_write是实际写文件函数，它会被写文件函数my_write()调用，它的功能是用来将键盘输入的内容写到相应的文件中。首先用malloc()申请1024B的内存空间作为读写磁盘的缓冲区buf，申请失败则返回-1，并显示出错信息；将读写指针转化为逻辑块块号和块内偏移off，并利用打开文件表表项中的首块号及FAT表的相关内容将逻辑块块号转换成对应的磁盘块块号blkno；如果找不到对应的磁盘块，则需要检索FAT为该逻辑块分配一新的磁盘块，并将对应的磁盘块块号blkno登记到FAT中，若分配失败，则返回-1，并显示出错信息；如果是覆盖写，或者如果当前读写指针所对应的块内偏移off不等于0，则将块号为blkno的虚拟磁盘块全部1024B的内容读到缓冲区buf中，否则便用清空buf；将text中未写入的内容暂存到缓冲区buff的第off字节开始的位置，直到缓冲区满，或者接收到结束字符为止，将本次写入字节数记录到tmplen中，buf中1024B的内容写入到块号为blkno的虚拟磁盘块中，然后将当前读写指针修改为原来的值加上tmplen；并将本次实际写入的字节数增加tmplen，如果tmplen小于len，则继续写入，否则返回本次实际写入的字节数。
2.19.2程序代码：
#include "head.h"

int do_write(int fd, char* text, int len, char wstyle)
{
    int block_num = openfilelist[fd].first;
    int i, tmp_num;
    int lentmp = 0;
    char* textptr = text;
    char buf[BLOCKSIZE];
    fat* fatptr = (fat*)(myvhard + BLOCKSIZE) + block_num;
    unsigned char* blockptr;

    if (wstyle == 1) {
        openfilelist[fd].count = 0;
        openfilelist[fd].length = 0;
    } 
    else if (wstyle == 3) {
        // 追加写，如果是一般文件，则需要先删除末尾 \0，即将指针移到末位减一个字节处
        openfilelist[fd].count = 0;}
        else if (wstyle == 3) {
        // 追加写，如果是一般文件，则需要先删除末尾 \0，即将指针移到末位减一个字节处
        openfilelist[fd].count = openfilelist[fd].length;
        if (openfilelist[fd].attribute == 1) {
            if (openfilelist[fd].length != 0) {
                // 非空文件
                openfilelist[fd].count = openfilelist[fd].length - 1;
            }
        }
    }

    int off = openfilelist[fd].count;

    // 定位磁盘块和块内偏移量
    while (off >= BLOCKSIZE) {
        block_num = fatptr->id;
        if (block_num == END) {
            printf("do_write: off error\n");
            return -1;
        }
        fatptr = (fat*)(myvhard + BLOCKSIZE) + block_num;
        off -= BLOCKSIZE;
    }

    blockptr = (unsigned char*)(myvhard + BLOCKSIZE * block_num);
    // 写入磁盘
    while (len > lentmp) {
        memcpy(buf, blockptr, BLOCKSIZE);
        for (; off < BLOCKSIZE; off++) {
            *(buf + off) = *textptr;
            textptr++;
            lentmp++;
            if (len == lentmp)
                break;
        }
        memcpy(blockptr, buf, BLOCKSIZE);

        // 写入的内容太多，需要写到下一个磁盘块，如果没有磁盘块，就申请一个
        if (off == BLOCKSIZE && len != lentmp) {
            off = 0;
            block_num = fatptr->id;
            if (block_num == END) {
                block_num = get_free_block();
                if (block_num == END) {
                    printf("do_write: block full\n");
                    return -1;
                }
                blockptr = (unsigned char*)(myvhard + BLOCKSIZE * block_num);
                fatptr->id = block_num;
                fatptr = (fat*)(myvhard + BLOCKSIZE) + block_num;
                fatptr->id = END;
            } else {
                blockptr = (unsigned char*)(myvhard + BLOCKSIZE * block_num);
                fatptr = (fat*)(myvhard + BLOCKSIZE) + block_num;
            }
        }
    }

    openfilelist[fd].count += len;
    if (openfilelist[fd].count > openfilelist[fd].length)
        openfilelist[fd].length = openfilelist[fd].count;

    // 删除多余的磁盘块
    if (wstyle == 1 || (wstyle == 2 && openfilelist[fd].attribute == 0)) {
        off = openfilelist[fd].length;
        fatptr = (fat *)(myvhard + BLOCKSIZE) + openfilelist[fd].first;
        while (off >= BLOCKSIZE) {
            block_num = fatptr->id;
            off -= BLOCKSIZE;
            fatptr = (fat *)(myvhard + BLOCKSIZE) + block_num;
        }
        while (1) {
            if (fatptr->id != END) {
                i = fatptr->id;
                fatptr->id = FREE;
                fatptr = (fat *)(myvhard + BLOCKSIZE) + i;
            } else {
                fatptr->id = FREE;
                break;
            }
        }
        fatptr = (fat *)(myvhard + BLOCKSIZE) + block_num;
        fatptr->id = END;
    }

    memcpy((fat*)(myvhard + BLOCKSIZE * 3), (fat*)(myvhard + BLOCKSIZE), BLOCKSIZE * 2);
    return len;
}
2.20读文件函数my_read()  
2.20.1实现思路
my_read() 函数的功能是读出指定文件中从读写指针开始的长度为len的内容到用户空间中。通过定义一个字符型数组text[MAX_TEXT_SIZE]，来接收用户从文件中读出的文件内容，如果返回值超出用户打开文件表所在数组的最大下标或者小于零，则返回为-1,并输出no such file，然后调用do_read()将指定文件中的内容读出到text中并输出。
2.20.2程序实现 
#include "head.h"

int my_read(int fd)
{
    if (fd < 0 || fd >= MAXOPENFILE) {
        printf("no such file\n");
        return -1;
    }

    openfilelist[fd].count = 0;
    char text[MAX_TEXT_SIZE] = "\0";
    do_read(fd, openfilelist[fd].length, text);
    printf("%s\n", text);
    return 1;
}

 
2.21实际读文件函数do_read()  
2.21.1实现思路
do_read函数是实际读文件函数，它会被my_read()调用，读出指定文件中从读写指针开始的长度为len的内容到用户空间的text中。首先使用malloc()函数申请一个1024B的空间作为缓冲区buf，申请失败则返回-1，并输出do_read reg mem error；然后将读写指针转化为逻辑块块号及块内偏移量off，利用打开文件表表项中的首块号查找FAT表，找到该逻辑块所在的磁盘块块号；将该磁盘块块号转化为虚拟磁盘上的内存位置；将该内存位置开始的一个磁盘块的内容读入buf中；比较buf中从偏移量off开始的剩余字节数是否大于等于应读写的字节数len，如果是，则将从off开始的buf中的len长度的内容读入到text中；否则，将从off开始的buf中的剩余内容读入到text中；使用free()释放开始申请的缓冲区。返回实际读出的字节数。
2.21.2程序实现
#include "head.h"

int do_read(int fd, int len, char* text)
{
    int len_tmp = len;
    char* textptr = text;
    unsigned char* buf = (unsigned char*)malloc(1024);
    if (buf == NULL) {
        printf("do_read reg mem error\n");
        return -1;
    }
    int off = openfilelist[fd].count;
    int block_num = openfilelist[fd].first;
    fat* fatptr = (fat*)(myvhard + BLOCKSIZE) + block_num;

    // 定位读取目标磁盘块和块内地址
    while (off >= BLOCKSIZE) {
        off -= BLOCKSIZE;
        block_num = fatptr->id;
        if (block_num == END) {
            printf("do_read: block not exist\n");
            return -1;
        }
        fatptr = (fat*)(myvhard + BLOCKSIZE) + block_num;
    }

    unsigned char* blockptr = myvhard + BLOCKSIZE * block_num;
    memcpy(buf, blockptr, BLOCKSIZE);

    // 读取内容
    while (len > 0) {
        if (BLOCKSIZE - off > len) {
            memcpy(textptr, buf + off, len);
            textptr += len;
            off += len;
            openfilelist[fd].count += len;
            len = 0;
        } else {
            memcpy(textptr, buf + off, BLOCKSIZE - off);
            textptr += BLOCKSIZE - off;
            len -= BLOCKSIZE - off;

            block_num = fatptr->id;
            if (block_num == END) {
                printf("do_read: len is lager then file\n");
                break;
            }
            fatptr = (fat*)(myvhard + BLOCKSIZE) + block_num;
            blockptr = myvhard + BLOCKSIZE * block_num;
            memcpy(buf, blockptr, BLOCKSIZE);
        }
    }
    free(buf);
    return len_tmp - len;
}
2.22退出文件系统函数my_exitsys()
2.22.1实现思路
my_exitsys()函数的主要功能是退出文件系统，通过调用库函数fopen()来打开myfsys文件，并将内容写入到FILENAME文件中，并且可以通过调用库函数fclose()关闭myfsys，从而释放虚拟磁盘空间，最后输出exit file system。
2.22.2程序实现
# include "head.h"

void my_exitsys()
{
    /**
	 * 依次关闭 打开文件。 写入 FILENAME 文件
	 */
    while (currfd) {
        my_close(currfd);
    }
    FILE* fp = fopen(FILENAME, "w");
    fwrite(myvhard, SIZE, 1, fp);
    fclose(fp);
    printf("**************** exit file system ****************\n");
}
 
