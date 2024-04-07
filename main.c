#include "head.h"

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

    char dict[13][20] = {
            "mkdir", "rmdir", "ls", "cd", "create",
            "rm", "open", "close", "write", "read",
            "exit", "help", "format"
    };
    char command[30], *sp;
    int cmd_idx, i;
    printf("**************** file system start ***************\n");
	my_startsys();
    printf("文件系统提供的各项功能及命令调用格式:\n");
    printf("命令名  \t 命令参数            \t 命令说明 \t 调用格式\n");
    printf("format \t\t 无                 \t 磁盘格式化 \t format\n");
    printf("mkdir  \t\t 目录名              \t 创建子目录 \t mkdir dirname\n");
    printf("rmdir  \t\t 目录名              \t 删除子目录 \t rmdir dirname\n");
    printf("ls     \t\t 无                 \t 显示目录 \t my_ls\n");
    printf("cd     \t\t 目录名(路径名)       \t 更改当前目录 \t cd dirname\n");
    printf("create \t\t 文件名              \t 创建文件 \t create filename\n");
    printf("rm     \t\t 文件名              \t 删除文件 \t rm filename\n");
    printf("open   \t\t 文件名              \t 打开文件 \t open filename\n");
    printf("close  \t\t 文件描述符           \t 关闭文件 \t close fd\n");
    printf("write  \t\t 文件描述符           \t 写文件 \t write fd\n");
    printf("read   \t\t 文件的描述符、字节数    读文件 \t read fd size\n");
    printf("exit   \t\t 无                  \t 退出文件系统 \t exit\n");
    

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
            if (strcmp(sp, dict[i]) == 0) {
                cmd_idx = i;
                break;
            }
        }
        switch (cmd_idx) {
            case 0: // mkdir
                sp = strtok(NULL, " ");
                if (sp != NULL)
                    my_mkdir(sp);
                else
                    printf("mkdir error\n");
                 sp = strtok(NULL, " ");
                if (sp != NULL)
                    printf("\nwarning:you only need to INPUT my_mkdir  dir_name\n");
                break;
            case 1: // rmdir
                sp = strtok(NULL, " ");
                if (sp != NULL)
                    my_rmdir(sp);
                else
                    printf("rmdir error\n");
                sp = strtok(NULL, " ");
                if (sp != NULL)
                    printf("\nwarning:you only need to INPUT my_rmdir dir_name\n");
                break;
            case 2: // ls
                my_ls();
                sp = strtok(NULL, " ");
                if (sp != NULL)
                    printf("\nwarning:you only need to INPUT my_ls\n");
                break;
            case 3: // cd
                sp = strtok(NULL, " ");
                if (sp != NULL)
                    my_cd(sp);
                else
                    printf("cd error\n");
                sp = strtok(NULL, " ");
                if (sp != NULL)
                    printf("\nwarning:you only need to INPUT my_cd dir_name\n");
                break;
            case 4: // create
                sp = strtok(NULL, " ");
                if (sp != NULL)
                    my_create(sp);
                else
                    printf("create error\n");
                sp = strtok(NULL, " ");
                if (sp != NULL)
                    printf("\nwarning:you only need to INPUT my_create file_name\n");
                break;
            case 5: // rm
                sp = strtok(NULL, " ");
                if (sp != NULL)
                    my_rm(sp);
                else
                    printf("rm error\n");
                sp = strtok(NULL, " ");
                if (sp != NULL)
                    printf("\nwarning:you only need to INPUT my_rm file_name\n");
                break;
            case 6: // open
                sp = strtok(NULL, " ");
                if (sp != NULL)
                    my_open(sp);
                else
                    printf("open error\n");
                sp = strtok(NULL, " ");
                if (sp != NULL)
                    printf("\nwarning:you only need to INPUT my_open file_name\n");
                break;
            case 7: // close
                if (openfilelist[currfd].attribute == 1)
                    my_close(currfd);
                else
                    printf("there is not openning file\n");
                sp = strtok(NULL, " ");
                if (sp != NULL)
                    printf("\nwarning:you only need to INPUT my_close fd\n");
                break;
            case 8: // write
                if (openfilelist[currfd].attribute == 1)
                    my_write(currfd);
                else
                    printf("please open file first, then write\n");
                break;
            case 9: // read
                if (openfilelist[currfd].attribute == 1)
                    my_read(currfd);
                else
                    printf("please open file first, then read\n");
                break;
            case 10: // exit
                my_exitsys();
                return 0;
                break;
            case 11: // help

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
                break;
        }
    }
    return 0;
}
