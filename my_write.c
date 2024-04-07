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

